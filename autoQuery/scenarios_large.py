from scenarios_executable import *

# 更大的场景，将多个可执行场景合为同一个，用一个用户做更多的事情


# 1. normal_routine -> consign -> rebook_routine -> cancel_routine
def scenario_1():
    query = new_user()
    normal_routine(query)
    consign_and_preserve(query)
    rebook_routine(query)
    cancel_routine(query)


# 2. normal_routine -> consign -> rebook_more_expensive_travel_successfully -> cancel_routine
def scenario_2():
    query = new_user()
    normal_routine(query)
    consign_and_preserve(query)
    rebook_more_expensive_travel_successfully(query)
    cancel_routine(query)


# 3. normal_routine -> consign -> rebook_twice_and_cancel -> cancel_routine
def scenario_3():
    query = new_user()
    normal_routine(query)
    consign_and_preserve(query)
    rebook_twice_and_cancel(query)
    cancel_routine(query)


# 4. search_failed_and_preserve -> normal_routine -> consign -> cancel_routine
def scenario_4():
    query = new_user()
    search_failed_and_preserve(query)
    normal_routine(query)
    consign_and_preserve(query)
    cancel_routine(query)
