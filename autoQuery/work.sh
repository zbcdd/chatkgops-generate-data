#!/bin/bash

ED_TIME="2023-02-23 20:10:00"

python3 scenarioApi.py scenario_admin 0 0.1 $ED_TIME &> ./log/scenario_admin &
python3 scenarioApi.py scenario_1 0 0.2 $ED_TIME &> ./log/scenario_1 &
python3 scenarioApi.py scenario_2 0 0.2 $ED_TIME &> ./log/scenario_2 &
python3 scenarioApi.py scenario_3 0 0.2 $ED_TIME &> ./log/scenario_3 &
python3 scenarioApi.py scenario_4 0 0.2 $ED_TIME &> ./log/scenario_4 &
