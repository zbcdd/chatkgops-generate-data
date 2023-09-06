import sys
from concurrent.futures.thread import ThreadPoolExecutor

from scenario_component import admin_operations, data_init
import time

from scenarios_large import *


class ScenarioAPI:
    scenarios = {
        "scenario_admin": admin_operations,
        "scenario_1": scenario_1,
        "scenario_2": scenario_2,
        "scenario_3": scenario_3,
        "scenario_4": scenario_4,
    }
    peak_start_time = ""
    peak_end_time = ""
    peak_qps = 0
    valley_start_time = ""
    valley_end_time = ""
    valley_qps = 0
    init_qps = 0
    endtime = ""
    pool = ThreadPoolExecutor(max_workers=100)

    def __init__(
            self,
            init_qps,
            endtime,
            peak_start_time = "",
            peak_end_time = "",
            peak_qps = 0,
            valley_start_time = "",
            valley_end_time = "",
            valley_qps = 0
    ) -> None:
        self.peak_start_time = peak_start_time
        self.peak_end_time = peak_end_time
        self.peak_qps = peak_qps
        self.valley_start_time = valley_start_time
        self.valley_end_time = valley_end_time
        self.valley_qps = valley_qps
        self.init_qps = init_qps
        self.endtime = endtime

    def time_divide(
            self,
            now_time,
    ):
        if self.peak_qps == 0 and self.valley_qps == 0:
            return "init"

        start_time_array = time.localtime(int(now_time))
        now_date = time.strftime("%Y-%m-%d", start_time_array)

        if self.peak_start_time != "":
            today_peak_start_date = now_date + " " + self.peak_start_time
            today_peak_end_date = now_date + " " + self.peak_end_time
            today_peak_start_time_tick = time.mktime(time.strptime(today_peak_start_date, "%Y-%m-%d %H:%M:%S"))
            today_peak_end_date_time_tick = time.mktime(time.strptime(today_peak_end_date, "%Y-%m-%d %H:%M:%S"))
            if now_time > today_peak_start_time_tick and now_time < today_peak_end_date_time_tick:
                return "peak"
        if self.valley_start_time != "":
            today_valley_start_date = now_date + " " + self.valley_start_time
            today_valley_end_date = now_date + " " + self.valley_end_time
            today_valley_start_date_time_tick = time.mktime(time.strptime(today_valley_start_date, "%Y-%m-%d %H:%M:%S"))
            today_valley_end_date_time_tick = time.mktime(time.strptime(today_valley_end_date, "%Y-%m-%d %H:%M:%S"))
            if now_time > today_valley_start_date_time_tick and now_time < today_valley_end_date_time_tick:
                return "valley"
        return "init"

    def run(
            self,
            scenario
    ):
        start = time.time()
        start_time_array = time.localtime(int(start))
        now_date = time.strftime("%Y-%m-%d %H:%M:%S", start_time_array)
        print(f"start time : {now_date}")
        func = self.scenarios[scenario]

        endtime_tick = time.mktime(time.strptime(self.endtime, "%Y-%m-%d %H:%M:%S"))
        while time.time() < endtime_tick:
            now_time = time.time()
            division = self.time_divide(now_time)
            if division == "peak":
                time.sleep(1 / self.peak_qps)
                self.pool.submit(func)
                # t = threading.Thread(target=func, args=())
                # t.start()
                continue
            if division == "valley":
                time.sleep(1 / self.valley_qps)
                self.pool.submit(func)
                # t = threading.Thread(target=func, args=())
                # t.start()
                continue
            time.sleep(1 / self.init_qps)
            self.pool.submit(func)
            # t = threading.Thread(target=func, args=())
            # t.start()
        self.pool.shutdown()


if __name__ == '__main__':
    try:
        scenario, type = sys.argv[1:3]
        # type
        # 0 表示没有peak和valley读入参数为 scenario type init_qps endtimeYMD endtimeHMS
        # 1 表示有peak没有valley读入参数为 scenario type init_qps endtimeYMD endtimeHMS peak_start_time peak_end_time peak_qps
        # 2 表示没有peak有valley读入参数为 scenario type init_qps endtimeYMD endtimeHMS valley_start_time valley_end_time valley_qps
        # 3 表示peak和valley均有 读入参数为 scenario type init_qps endtimeYMD endtimeHMS peak_start_time peak_end_time peak_qps valley_start_time valley_end_time valley_qps
        # 其中endtime为%Y-%m-%d %H:%M:%S格式 分成endtimeYMD和endtimeHMS两个参数
        # 各种end\start time为 %H:%M:%S格式
        # data_init()
        if type == '0':
            init_qps, endtimeYMD, endtimeHMS = sys.argv[3:6]
            init_qps = float(init_qps)
            endtime = endtimeYMD + " " +  endtimeHMS
            scenario_api = ScenarioAPI(init_qps, endtime)
            scenario_api.run(scenario)
        if type == '1':
            init_qps, endtimeYMD, endtimeHMS, peak_start_time, peak_end_time, peak_qps = sys.argv[3:9]
            init_qps = float(init_qps)
            peak_qps = float(peak_qps)
            endtime = endtimeYMD + " " +  endtimeHMS
            scenario_api = ScenarioAPI(init_qps, endtime, peak_start_time, peak_end_time, peak_qps)
            scenario_api.run(scenario)
        if type == '2':
            init_qps, endtimeYMD, endtimeHMS, valley_start_time, valley_end_time, valley_qps = sys.argv[3:9]
            init_qps = float(init_qps)
            valley_qps = float(valley_qps)
            endtime = endtimeYMD + " " +  endtimeHMS
            scenario_api = ScenarioAPI(init_qps, endtime, "", "", 0, valley_start_time, valley_end_time, valley_qps)
            scenario_api.run(scenario)
        init_qps, endtimeYMD, endtimeHMS, peak_start_time, peak_end_time, peak_qps, valley_start_time, valley_end_time, valley_qps = sys.argv[3:12]
        init_qps = float(init_qps)
        peak_qps = float(peak_qps)
        valley_qps = float(valley_qps)
        endtime = endtimeYMD + " " + endtimeHMS
        scenario_api = ScenarioAPI(init_qps, endtime, peak_start_time, peak_end_time, peak_qps, valley_start_time,
                                   valley_end_time, valley_qps)
        scenario_api.run(scenario)

    except Exception as e:
        print(sys.argv)
        print(e)
