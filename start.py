import datetime
import json
import logging
import os
import argparse
import requests
import subprocess
import time
from concurrent.futures import ThreadPoolExecutor
from kubernetes import client, config


WAIT_INTERVAL = 10
AUTO_QUERY_DURATION = 60
AUTO_QUERY_START = None  # set by auto_query, which is the start time to send query to trainticket.
NUM_THREADS = 3
WARM_QUERY_DURATION = 60

config.load_kube_config()
k8s_v1 = client.CoreV1Api()
k8s_apps_v1 = client.AppsV1Api()

if not os.path.exists('./log'):
    os.makedirs('./log')
logging.basicConfig(filename='./log/run.log',
                    level=logging.INFO,
                    format='%(asctime)s %(filename)s: %(levelname)s %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S')


def save_json(data, path):
    path_dir = os.path.dirname(path)
    if not os.path.exists(path_dir):
        logging.info(f'[save_json] create dir {path_dir}')
        os.makedirs(path_dir)
    with open(path, 'w') as json_file:
        json.dump(data, json_file)


def load_json(path):
    with open(path, 'r') as json_file:
        data = json.load(json_file)
    return data


def check_pods_status():
    logging.info('[check_pods_status] start.')
    get_all_pods_cmd = 'kubectl get pods --all-namespaces -o custom-columns="NAMESPACE:.metadata.namespace,POD:.metadata.name" | tail -n +2'
    get_all_pods_cmd_result = shell_exec(get_all_pods_cmd)
    if get_all_pods_cmd_result['code'] != 0:
        logging.error(f'[check_pods_status] exec get_all_pods_cmd fail: \
                      code: {get_all_pods_cmd_result["code"]} \
                      stdout: {get_all_pods_cmd_result["stdout"]} \
                      stderr: {get_all_pods_cmd_result["stderr"]}')
        return False
    all_pods = get_all_pods_cmd_result['stdout']
    for pod_info in all_pods.split('\n'):
        if not pod_info:
            continue
        namespace, pod_name = pod_info.split()
        pod_status = k8s_v1.read_namespaced_pod_status(pod_name, namespace) 
        if not pod_status.status.phase == "Running" or \
           not all(cond.status == "True" for cond in pod_status.status.conditions if cond.type == "Ready"):
           # not running or not ready
           logging.error(f'[check_pods_status] find {namespace}::{pod_name} in bad status.')
           return False 
    logging.info('[check_pods_status] finish: all pods ok.')
    return True


def shell_exec(cmd):
    exec_result = subprocess.run(cmd,
                                 shell=True,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE,
                                 text=True)
    return {
        'code': exec_result.returncode,
        'stdout': exec_result.stdout,
        'stderr': exec_result.stderr
        }


def shell_exec_op(cmds):
    exec_results = []
    op_success = True
    for cmd in cmds:
        result = shell_exec(cmd)
        exec_results.append(result)
        if result['code'] != 0:
            op_success = False
            break
    return {
        'success': op_success,
        'results': exec_results
    }


def tsdb_recover():
    logging.info('[tsdb_recover] start.')
    try_results = []
    for i in range(3):
        # tsdb-mysql-0 or tsdb-mysql-1 or tsdb-mysql-2
        cp_cmd = f'kubectl cp ./tsdb_recover/ts.sql tsdb-mysql-{i}:/home/ts.sql -c mysql'
        exec_cmd = f'kubectl exec tsdb-mysql-{i} -c mysql -- /bin/bash -c "mysql < /home/ts.sql"'
        exec_op_results = shell_exec_op([cp_cmd, exec_cmd])
        if exec_op_results['success']:
            logging.info(f'[tsdb_recover] {exec_op_results}')
            logging.info(f'[tsdb_recover] success -> tsdb-mysql-{i}')
            return True
        else:
            try_results.append(exec_op_results)
    
    # tsdb_recover fail
    logging.error(f'[tsdb_recover] {try_results}')
    logging.error(f'[tsdb_recover] fail.')
    return False 
    
        
def wait(duration):
    logging.info(f'[wait] {duration} seconds.')
    time.sleep(duration)
    logging.info(f'[wait] finish.')


def query(query_type, formatted_st_time, formatted_ed_time):
    if not os.path.exists(f'./log/{query_type}'):
        os.makedirs(f'./log/{query_type}')
    cmds = [
        f'python3 ./autoQuery/scenarioApi.py scenario_admin 0 0.1 {formatted_ed_time} &> ./log/{query_type}/scenario_admin.log',
        f'python3 ./autoQuery/scenarioApi.py scenario_1 0 0.2 {formatted_ed_time} &> ./log/{query_type}/scenario_1.log',
        f'python3 ./autoQuery/scenarioApi.py scenario_2 0 0.2 {formatted_ed_time} &> ./log/{query_type}/scenario_2.log',
        f'python3 ./autoQuery/scenarioApi.py scenario_3 0 0.2 {formatted_ed_time} &> ./log/{query_type}/scenario_3.log',
        f'python3 ./autoQuery/scenarioApi.py scenario_4 0 0.2 {formatted_ed_time} &> ./log/{query_type}/scenario_4.log'
    ]

    query_processes = []
    for cmd in cmds:
        query_processes.append(subprocess.Popen(
            cmd,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        ))
    
    query_success = True
    for query_process in query_processes:
        return_code = query_process.wait()
        if return_code == 0:
            logging.info(f'[{query_type}] {query_process.pid} exit with {return_code}.')
        else:
            query_success = False
            logging.error(f'[{query_type}] {query_process.pid} exit with {return_code}.')
    
    logging.info(f'[{query_type}] finish, start: {formatted_st_time}, end: {formatted_ed_time}')
    return query_success


def warm_query(duration):
    logging.info(f'[warm_query] start, total {duration} seconds.')
    st_time = datetime.datetime.now() 
    formatted_st_time = st_time.strftime("%Y-%m-%d %H:%M:%S")
    ed_time = st_time + datetime.timedelta(seconds=duration)
    formatted_ed_time = ed_time.strftime("%Y-%m-%d %H:%M:%S")
    return query('warm_query', formatted_st_time, formatted_ed_time)


def auto_query(duration):
    global AUTO_QUERY_START
    logging.info(f'[auto_query] start, total {duration} seconds.')
    st_time = datetime.datetime.now() 
    AUTO_QUERY_START = st_time
    formatted_st_time = st_time.strftime("%Y-%m-%d %H:%M:%S")
    ed_time = st_time + datetime.timedelta(seconds=duration)
    formatted_ed_time = ed_time.strftime("%Y-%m-%d %H:%M:%S")
    return query('auto_query', formatted_st_time, formatted_ed_time)


def get_system_data(data_dir):
    logging.info(f'[get_system_data] data_dir: {data_dir}')
    get_log_data(data_dir)
    get_metrics_data(data_dir)
    get_metrics_metadata(data_dir)
    get_trace_data(data_dir)
    get_service_graph_data(data_dir)
    get_k8s_data(data_dir)


def get_log_data(data_dir):
    data_path = os.path.join(data_dir, 'log', 'label_value.json')
    logging.info('[get_log_data] start.')
    loki_api_url = 'http://10.176.122.154:30001' 

    labels_url = f'{loki_api_url}/loki/api/v1/labels'
    response = requests.get(labels_url)

    labels = []
    if response.status_code == 200:
        labels_data = response.json()
        labels = labels_data.get('data', [])
    else:
        logging.error(f'[get_log_data] can not fetch loki labels, HTTP response code: {response.status_code}')

    label_value_map = {}
    for label_name in labels:
        label_values_url = f'{loki_api_url}/loki/api/v1/label/{label_name}/values'
        response = requests.get(label_values_url)

        if response.status_code == 200:
            label_values_data = response.json()
            label_values = label_values_data.get('data', [])
            label_value_map[label_name] = label_values
        else:
            logging.info(f'can not fetch {label_name}\'s values: HTTP response code: {response.status_code}')

    save_json(label_value_map, data_path) 
    logging.info(f'[get_log_data] finish: data saved at {data_path}')


def get_metrics_data(data_dir):
    data_path = os.path.join(data_dir, 'metrics', 'series.json')
    logging.info(f'[get_metrics_data] start.')
    prom_api_url = 'http://10.176.122.154:30002/api/v1/series'
    params = {
        'match[]': '{__name__!=""}'
    }

    response = requests.get(prom_api_url, params)
    if response.status_code == 200:
        series_data = response.json().get('data', [])
    else:
        logging.error(f'[get_metrics_data] fail: can not fetch series.')

    save_json(series_data, data_path)
    logging.info(f'[get_metrics_data] finsh: data saved at {data_path}')


def get_metrics_metadata(data_dir):
    data_path = os.path.join(data_dir, 'metrics', 'metadata.json')
    logging.info(f'[get_metrics_metadata] start.')
    prom_api_url = 'http://10.176.122.154:30002/api/v1/metadata'

    response = requests.get(prom_api_url)
    if response.status_code == 200:
        metadata = response.json().get('data', {})
    else:
        logging.error(f'[get_metrics_metadata] fail: can not fetch metadata.')

    save_json(metadata, data_path)
    logging.info(f'[get_metrics_metadata] finsh: data saved at {data_path}')


def query_trace_detail(trace_id):
    tempo_query_url = f'http://10.176.122.154:30003/api/traces/{trace_id}'
    tempo_query_response = requests.get(tempo_query_url)
    if tempo_query_response.status_code == 200:
        return trace_id, tempo_query_response.json()
    else:
        logging.error(f'[query_trace_detail] fail: can not fecth trace detail, traceid = {trace_id}')
        return trace_id, None


def get_trace_data(data_dir):
    logging.info(f'[get_trace_data] start.')
    ed_time = datetime.datetime.now()
    st_time = AUTO_QUERY_START
    assert st_time is not None, '[get_trace_data] not execute auto_query before.'

    tempo_search_url = 'http://10.176.122.154:30003/api/search'
    tempo_search_params = {
        'limit': 100000,
        'start': int(st_time.timestamp()),
        'end': int(ed_time.timestamp())
    }
    logging.info(f'[get_trace_data] query_range: start: {st_time}, end: {ed_time}')
    tempo_search_response = requests.get(tempo_search_url, tempo_search_params)
    if tempo_search_response.status_code == 200:
        traceid_data = tempo_search_response.json().get('traces', [])
    else:
        logging.error(f'[get_trace_data] fail: can not fetch trace ids. {tempo_search_response.text}')
    traceid_data_path = os.path.join(data_dir, 'trace', 'traceids.json')
    save_json(traceid_data, traceid_data_path)

    trace_data = {}
    executor = ThreadPoolExecutor(max_workers=NUM_THREADS)
    for trace_id, trace in executor.map(query_trace_detail, [item['traceID'] for item in traceid_data]):
        if trace:
           trace_data[trace_id] = trace 
    trace_data_path = os.path.join(data_dir, 'trace', 'trace.json')
    save_json(trace_data, trace_data_path)


def get_service_graph_data(data_dir):
    logging.warning(f'[get_service_graph_data] not implemented yet.')


def get_pod_data(data_dir, namespace='default'):
    data_path = os.path.join(data_dir, 'k8s', 'pod_info.json')
    logging.info(f'[get_k8s_data] start.')
    pods = k8s_v1.list_namespaced_pod(namespace=namespace)
    pods_info = {}
    for pod in pods.items:    
        pod_info = {
            'namespace': pod.metadata.namespace,
            'pod_name': pod.metadata.name,
            'pod_ip': pod.status.pod_ip,
            'app': pod.metadata.labels.get('app', ''),
            'node_name': pod.spec.node_name,
            'node_ip': pod.status.host_ip,
            'containers': [{'container_id': i.container_id, 'container_name': i.name} for i in pod.status.container_statuses],
        }
        pods_info[pod.metadata.name] = pod_info
    save_json(pods_info, data_path)
    logging.info(f'[get_k8s_data pod_info] finish: data saved at {data_path}')


def get_svc_data(data_dir, namespace='default'):
    data_path = os.path.join(data_dir, 'k8s', 'svc_info.json')
    svc_info = {}
    svcs = k8s_v1.list_namespaced_service(namespace=namespace)
    for svc in svcs.items:
        selector = svc.spec.selector
        if not selector:
            continue
        info = {
            'name': svc.metadata.name,
            'namespace': svc.metadata.namespace,
            'pods': [pod.metadata.name for pod in k8s_v1.list_namespaced_pod(namespace, label_selector=','.join(f'{key}={value}' for key, value in selector.items())).items]
        }
        svc_info[svc.metadata.name] = info

    save_json(svc_info, data_path)
    logging.info(f'[get_k8s_data svc_info] finish: data saved at {data_path}')


def get_deploy_data(data_dir, namespace='default'):
    data_path = os.path.join(data_dir, 'k8s', 'deploy_info.json')
    deploy_info = {}
    deploys = k8s_apps_v1.list_namespaced_deployment(namespace=namespace)
    for deploy in deploys.items:
        replica_set_names = []
        selector = ",".join([f"{key}={value}" for key, value in deploy.spec.selector.match_labels.items()])
        replica_sets = k8s_apps_v1.list_namespaced_replica_set(namespace, label_selector=selector)
        for rs in replica_sets.items:
            replica_set_names.append(rs.metadata.name)
        info = {
            'name': deploy.metadata.name,
            'namespace': deploy.metadata.namespace,
            'replicaset': replica_set_names,
        }
        deploy_info[deploy.metadata.name] = info
    save_json(deploy_info, data_path)
    logging.info(f'[get_k8s_data deploy_info] finish: data saved at {data_path}')


def get_replicaset_data(data_dir, namespace='default'):
    data_path = os.path.join(data_dir, 'k8s', 'replicaset_info.json')
    replicaset_info = {}
    reps = k8s_apps_v1.list_namespaced_replica_set(namespace=namespace)
    for rep in reps.items:
        selector = ",".join([f"{key}={value}" for key, value in rep.spec.selector.match_labels.items()])
        info = {
            'name': rep.metadata.name,
            'namespace': rep.metadata.namespace,
            'pods': [i.metadata.name for i in k8s_v1.list_namespaced_pod(namespace, label_selector=selector).items]
        }
        replicaset_info[rep.metadata.name] = info 

    save_json(replicaset_info, data_path)
    logging.info(f'[get_k8s_data replicaset_info] finish: data saved at {data_path}')


def get_statefulset_data(data_dir, namespace='default'):
    data_path = os.path.join(data_dir, 'k8s', 'statefulset_info.json')
    statefulset_info = {}
    sfs = k8s_apps_v1.list_namespaced_stateful_set(namespace=namespace)
    for sf in sfs.items:
        selector = ",".join([f"{key}={value}" for key, value in sf.spec.selector.match_labels.items()])
        info = {
            'name': sf.metadata.name,
            'namespace': sf.metadata.namespace,
            'pods': [i.metadata.name for i in k8s_v1.list_namespaced_pod(namespace, label_selector=selector).items]
        }
        statefulset_info[sf.metadata.name] = info 
    
    save_json(statefulset_info, data_path)
    logging.info(f'[get_k8s_data statefulset_info] finish: data saved at {data_path}')


def get_k8s_data(data_dir):
    get_pod_data(data_dir)
    get_svc_data(data_dir)
    get_deploy_data(data_dir)
    get_replicaset_data(data_dir)
    get_statefulset_data(data_dir)
 

def main():
    if not os.path.exists('./log'):
        os.makedirs('./log')

    if not check_pods_status():
        logging.error('[main] exit after check_pods_status.')
        return

    # Warm trainticket
    if not tsdb_recover():
        logging.error('[main] exit after tsdb_recover.')
        return
    wait(WAIT_INTERVAL)
    if WARM_QUERY_DURATION != 0 and not warm_query(WARM_QUERY_DURATION):
        logging.error('[main] exit after warm_query.')
        return
    wait(WAIT_INTERVAL)
    if not tsdb_recover():
        logging.error('[main] exit after tsdb_recover.')
        return
    wait(WAIT_INTERVAL)

    # Auto query
    if not auto_query(AUTO_QUERY_DURATION):
        logging.error('[main] exit after auto_query.')
        return
    wait(WAIT_INTERVAL)

    # Get data
    get_system_data('./data')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate data to build KG.')
    
    parser.add_argument('--wait-interval', type=int, nargs='?', const=10, default=10, help='Interval between each steps.')
    parser.add_argument('--auto-query-duration', type=int, nargs='?', const=60, default=60, help='Duration of auto query trainticket.')
    parser.add_argument('--trace-collect-num-threads', type=int, nargs='?', const=3, default=3, help='Number of threads to collect trace data from tempo api.')
    parser.add_argument('--warm-query-duration', type=int, nargs='?', const=60, default=60, help='Duration of warmming trainticket.')
    
    args = parser.parse_args()
    
    WAIT_INTERVAL = args.wait_interval
    AUTO_QUERY_DURATION = args.auto_query_duration
    NUM_THREADS = args.trace_collect_num_threads
    WARM_QUERY_DURATION = args.warm_query_duration 
    
    logging.info(f'WAIT_INTERVAL = {WAIT_INTERVAL}s')
    logging.info(f'AUTO_QUERY_DURATION = {AUTO_QUERY_DURATION}s')
    logging.info(f'NUM_THREADS = {NUM_THREADS}')
    logging.info(f'WARM_QUERY_DURATION = {WARM_QUERY_DURATION}s')
    
    main()
