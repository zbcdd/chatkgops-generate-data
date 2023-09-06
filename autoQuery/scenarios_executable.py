from scenario_component import *
from constant import *
from datetime import timedelta, datetime
import time

logger = logging.getLogger("auto-queries")


# 正常preserve流程
# login -> 查询余票成功 -> 正常预定&refresh
def preserve_successfully(query: Query = None,
                          date: str = time.strftime("%Y-%m-%d", time.localtime()),
                          seat_type: str = "") -> List[dict]:
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 新增parallel查询(仅仅查询，不考虑后续订票操作)
    query.query_high_speed_ticket_parallel()

    # 如何保证对应的查询方式均可以找到余票而不会存在no route的情形:需要使用init中的数据,将查询方式与起点、终点绑定
    # 选择查询的(起点，终点)对
    place_pairs = []
    for route_data in InitData.init_route_data:  # init_route_data内部的每个route都会与train绑定从而形成travel
        start = route_data[2]
        end = route_data[3]
        # 此处的是station对应的id，需要到init_station_data列表中查找对应的name信息
        for station_data in InitData.init_stations_data:
            if station_data[0] == start:  # route_data[2]是起始站
                start = station_data[1]  # id换成name
            if station_data[0] == end:  # route_data[2]是起始站
                end = station_data[1]  # id换成name
        place_pair = (start, end)
        place_pairs.append(place_pair)
    query_place_pair = random_from_list(place_pairs)
    logger.info(f"[start station & end station] : {query_place_pair} ")
    # print(f"[start station & end station] : {query_place_pair} ")
    # 选择查询的方式
    query_types = ["normal", "high_speed", "min_station", "cheapest", "quickest"]
    query_type = random_from_list(query_types)
    logger.info("[query_type] : " + query_type)
    # print("[query_type] : " + query_type)

    # 查询余票
    # date = time.strftime("%Y-%m-%d", time.localtime())   # 默认为选择当日日期，因为query函数无法找到过去日期的票
    trip_info = query_left_tickets_successfully(query, query_type, query_place_pair, date + " 00:00:00")
    # 订票并刷新订单
    all_orders_info = preserve_and_refresh(query, trip_info, date, seat_type, types=tuple([0]))  # 返回状态0的订单 not paid

    # 批量创建food order
    # query.create_food_order_batch()

    # 退出并删除用户（不需要在这个里面删除用户，在大场景的结束的时候删除用户）
    return all_orders_info


# 正常查票订票检票进站
def normal_routine(query: Query = None):

    init_query = query
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 成功预定(query查票 -> preserve -> refresh)，返回所有符合条件的订单（默认为0，1）
    all_orders_info = preserve_successfully(query)

    # 批量创建food order
    query.create_food_order_batch()

    # 异常判断，如果order_info是null，即preserve错误为null
    if all_orders_info is None:
        # print("no order available ! exit")
        logger.info("[normal_routine] no order available ! exit")
        return

    # 选择一个订单作为此次处理的对象，输入的order的状态已经是符合条件的了 preserve_and_refresh的参数types来确定
    order_info = random_from_list(all_orders_info)  # 可能是高铁动车也可能是普通列车
    logger.info(f"[order selected] : {order_info} ")
    # print('[order selected] '+str(order_info))
    # 支付
    query.pay_order(order_info.get("id"), order_info.get("trainNumber"))
    # 取票进站
    collect_and_enter(query, order_info.get("id"))
    logger.info(f"[pay, collect and enter successfully] : {order_info} ")

    admin = AdminQuery(Constant.ts_address)
    admin.login(Constant.admin_username, Constant.admin_pwd)
    # admin删除订单
    admin.orders_delete(order_info.get("id"), order_info.get("trainNumber"))
    if init_query is None:  # 如果是新建的用户才删除
        # admin删除用户
        admin.admin_delete_user(query.uid)


# rebook失败后成功(一套完整的流程)
# login -> preserve_successfully -> rebook失败(not paid) -> pay and rebook成功 -> 取票进站台
def rebook_routine(query: Query = None):

    init_query = query
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 成功预定(query查票 -> preserve -> refresh)
    # 注意：此处为了后续rebook一定可以找到车次成功，默认定明天的车
    tomorrow_date = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
    all_orders_info = preserve_successfully(query, tomorrow_date)  # 返回所有的order
    # 选择一个订单作为此次处理的对象，需要筛选时间为tomorrow_date的
    order_info = {}
    for order in all_orders_info:
        if order["travelDate"] == tomorrow_date:
            order_info = order
    print("被选择的order为：" + str(order_info))  # 后续的rebook依赖此处的选择的order

    # rebook失败(应该失败，此处失败是正常的，原因是没有支付)
    order_id = rebook(query, order_info)

    # pay and rebook成功 以及后续的取票进站
    order_id = pay_and_rebook_successfully(query, order_info)     # 这里的rebook不一定成功
    collect_and_enter(query, order_id)

    # 恢复数据库
    admin = AdminQuery(Constant.ts_address)
    admin.login(Constant.admin_username, Constant.admin_pwd)
    # admin删除订单
    admin.orders_delete(order_id, order_info.get("trainNumber"))
    if init_query is None:  # 如果是新建的用户才删除
        # admin删除用户
        admin.admin_delete_user(query.uid)


# 正常订票并且取消
def cancel_routine(query: Query = None):

    init_query = query
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 订票
    tomorrow_date = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
    all_orders_info = preserve_successfully(query, tomorrow_date)
    # 选择一个订单作为此次处理的对象，状态为0(not paid)的
    order_info = {}
    for order in all_orders_info:
        if order["status"] == 0:
            order_info = order
    order_id = order_info.get("id")
    print("被选择的order为：" + str(order_info))

    # 支付（支付了则计算退款会显示金额，未支付计算退款为0）
    pay_or_not = random_boolean()
    if pay_or_not:
        query.pay_order(order_info.get("id"), order_info.get("trainNumber"))

    # 取消
    refund_and_cancel(query, order_id)

    # 恢复数据库
    admin = AdminQuery(Constant.ts_address)
    admin.login(Constant.admin_username, Constant.admin_pwd)
    # admin删除订单
    admin.orders_delete(order_id, order_info.get("trainNumber"))
    if init_query is None:  # 如果是新建的用户才删除
        # admin删除用户
        admin.admin_delete_user(query.uid)


# rebook两次后取消
# 同样前提也是改签成功
# login -> preserve_successfully -> rebook两次失败 -> cancel
def rebook_twice_and_cancel(query: Query = None):

    init_query = query
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 成功预定(query查票 -> preserve -> refresh)，返回所有符合条件的订单（默认为0，1）
    tomorrow_date = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
    all_orders_info = preserve_successfully(query, tomorrow_date)  # 返回所有的order
    # 选择一个订单作为此次处理的对象，需要筛选时间为tomorrow_date的
    order_info = {}
    for order in all_orders_info:
        if order["travelDate"] == tomorrow_date:
            order_info = order
    print("被选择的order为：" + str(order_info))  # 后续的rebook依赖此处的选择的order

    # rebook twice
    order_id = rebook_unsuccessfully_for_rebooking_twice(query, order_info)

    # 取消订单
    # query.cancel_order(order_id)
    refund_and_cancel(query, order_id)   # 改签过的订单是无法退款的 但是可以取消

    # 恢复数据库
    admin = AdminQuery(Constant.ts_address)
    admin.login(Constant.admin_username, Constant.admin_pwd)
    # admin删除订单
    admin.orders_delete(order_id, order_info.get("trainNumber"))
    if init_query is None:  # 如果是新建的用户才删除
        # admin删除用户
        admin.admin_delete_user(query.uid)


# 由于时间问题rebook失败：在发车时间后2h外改签
# today去改签预定的昨天/前天的车次(不可行，因为查询余票的时候输入过去的时间节点会没有返回值并导致preserve失败)
# 添加一班此刻的前2h的车次，搜索预定并且preserve，后失败  --> 每天的0-3点用不了因为preserve时会查票失败
# def rebook_exceeding_time_and_cancel():
#     # 在init route的基础上加上time形成travel
#     admin_query = AdminQuery(Constant.ts_address)
#     admin_query.login("admin", "222222")
#     # 获取所有route
#     all_routes_info = admin_query.admin_get_all_routes()
#     print(all_routes_info)
#     # 获取init中的route:
#     init_route = InitData.station_list.split(",")
#     init_route_id = ""
#     for route in all_routes_info:
#         if route["stations"] == init_route:
#             init_route_id = route["id"]
#             break   # route可以重复添加stations，会产生不同的id
#     # 添加travel:指定trip_id和train_type_id，输入route_id和时间
#     train_type_id = random_from_list(InitData.train_types)
#     trip_id = train_type_id[0] + "2022"  # 获取第一个char
#     start_time = (datetime.now() - timedelta(hours=3)).strftime("%Y-%m-%d %H:%M:%S")
#     print(trip_id)
#     print(start_time)
#     admin_query.admin_add_travel(trip_id, train_type_id, init_route_id, start_time)
#
#     query = new_user()
#     # 车票预定(query查票 -> preserve -> refresh),预定刚刚的车次
#     today_date = datetime.now().strftime("%Y-%m-%d")
#     all_orders_info = preserve_successfully(query, today_date)  # 返回所有的order
#     # 选择一个订单作为此次处理的对象，需要筛选时间为tomorrow_date的
#     order_info = {}
#     for order in all_orders_info:
#         if order["trainNumber"] == trip_id:
#             order_info = order
#     print("被选择的order为：" + str(order_info))  # 后续的rebook依赖此处的选择的order
#
#     # 支付并改签
#     # pay_and_rebook_successfully()
#     # 恢复数据库
#     # 删除travel
#     admin_query.admin_delete_travel(trip_id)


# rebook成功(更贵的车次 需要计算并支付差价differnece)
# 对于同一个route 价钱与起始站终点站之间的距离以及一等座二等座相关
def rebook_more_expensive_travel_successfully(query: Query = None):

    init_query = query
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 成功预定(query查票 -> preserve -> refresh)，返回所有符合条件的订单（默认为0，1）
    tomorrow_date = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
    all_orders_info = preserve_successfully(query, tomorrow_date, "3")  # 设定此时预定二等座
    # 选择一个订单作为此次处理的对象，需要筛选时间为tomorrow_date的(不然会出现时间报错)并且座位为二等座的
    order_info = {}
    for order in all_orders_info:
        if order["travelDate"] == tomorrow_date and order["seatClass"] == 3:
            order_info = order
    print("被选择的order为：" + str(order_info))  # 后续的rebook依赖此处的选择的order

    # 支付并且rebook更贵的车次成功
    order_id = pay_and_rebook_successfully_for_more_expensive_travel(query, order_info)

    # 取票进站，流程结束
    collect_and_enter(query, order_id)

    # 恢复数据库
    admin = AdminQuery(Constant.ts_address)
    admin.login(Constant.admin_username, Constant.admin_pwd)
    # admin删除订单
    admin.orders_delete(order_id, order_info.get("trainNumber"))
    if init_query is None:  # 如果是新建的用户才删除
        # admin删除用户
        admin.admin_delete_user(query.uid)


# 异常preserve流程(no route)，预定车票查询失败，admin添加并重新预定
# login -> search failed -> admin add -> preserve_successfully -> collect & enter
# login -> 查询余票(no route) -> admin添加相关信息 -> 查询余票成功 -> 正常预定&refresh -> 删除相关数据
def search_failed_and_preserve(query: Query = None):

    init_query = query
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 初始查询失败
    query_left_tickets_unsuccessfully(query)   # 默认查询的对就是 guiyangbei chongqingbei
    # admin添加相关站点并进行重新进行search
    search_trip_info, miss_station_id, route_id, travel_id = admin_add_route_search()
    # 订票并刷新订单
    all_orders_info = preserve_and_refresh(query, search_trip_info, types=tuple([0]))  # 返回状态0的订单 not paid
    # 选择一个订单作为此次处理的对象，输入的order的状态已经是符合条件的了 preserve_and_refresh的参数types来确定
    order_info = random_from_list(all_orders_info)  # 可能是高铁动车也可能是普通列车
    print(order_info)
    order_id = order_info.get("id")
    train_num = order_info.get("trainNumber")
    # 支付
    query.pay_order(order_id, train_num)
    # 取票进站
    collect_and_enter(query, order_id)

    # 恢复数据库
    admin = AdminQuery(Constant.ts_address)
    admin.login(Constant.admin_username, Constant.admin_pwd)
    # admin删除订单
    admin.orders_delete(order_id, train_num)
    # admin删除站点
    admin.stations_delete(miss_station_id)
    # admin删除route
    admin.admin_delete_route(route_id)
    # admin删除travel
    admin.admin_delete_travel(travel_id)
    if init_query is None:  # 如果是新建的用户才删除
        # admin删除用户
        admin.admin_delete_user(query.uid)


# consign加入preserve过程
def consign_and_preserve(query: Query = None):

    init_query = query
    if query is None:  # 如果没有外部输入用户
        # 新建用户并登陆or使用特定用户登陆
        query = new_user()

    # 成功预定(query查票 -> preserve -> refresh)，返回所有符合条件的订单（默认为0，1）
    all_orders_info = preserve_successfully(query)

    # 批量创建food order
    query.create_food_order_batch()

    # 选择一个订单作为此次处理的对象，输入的order的状态已经是符合条件的了 preserve_and_refresh的参数types来确定
    order_info = random_from_list(all_orders_info)  # 可能是高铁动车也可能是普通列车
    print(order_info)
    # consign
    extra_consign(query, order_info)

    # 可以consign完成之后在用户主页查找当前用户的所有consign
    query.query_consign_by_account_id(query.uid)

    # 支付
    query.pay_order(order_info.get("id"), order_info.get("trainNumber"))
    # 取票进站
    collect_and_enter(query, order_info.get("id"))

    # 恢复数据库
    admin = AdminQuery(Constant.ts_address)
    admin.login(Constant.admin_username, Constant.admin_pwd)
    # admin删除订单
    admin.orders_delete(order_info.get("id"), order_info.get("trainNumber"))
    if init_query is None:  # 如果是新建的用户才删除
        # admin删除用户
        admin.admin_delete_user(query.uid)
