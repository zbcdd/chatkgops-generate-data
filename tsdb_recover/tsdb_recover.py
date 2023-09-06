import time
import logging
import subprocess
from apscheduler.schedulers.background import BackgroundScheduler


def recover_tsdb():
    logging.basicConfig(filename='./run_info.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logging.getLogger('apscheduler').setLevel(logging.WARNING)
    success_cnt = 0
    for i in range(3):
        cp_cmd = f'kubectl cp ./ts.sql tsdb-mysql-{i}:/home/ts.sql -c mysql'
        exec_cmd = f'kubectl exec tsdb-mysql-{i} -c mysql -- /bin/bash -c "mysql < /home/ts.sql"'
        cp_status, cp_output = subprocess.getstatusoutput(cp_cmd)
        if cp_status != 0:
            logging.error(f'copy error: status: {cp_status}, output: {cp_output}')
        exec_status, exec_output = subprocess.getstatusoutput(exec_cmd)
        if exec_status == 0:
            logging.info(f'Recover success: tsdb-mysql-{i}, status: {exec_status}, output: {exec_output}')
            success_cnt += 1
    if success_cnt != 1:
        logging.error(f'recover tsdb error: success cnt = {success_cnt}')


if __name__ == '__main__':
    scheduler = BackgroundScheduler(timezone='Asia/Shanghai')
    scheduler.add_job(recover_tsdb, 'cron', minute='10,14,25,29,40,44,55,59', second=25)
    scheduler.start()
    try:
        while True:
            time.sleep(10)
    except(KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
