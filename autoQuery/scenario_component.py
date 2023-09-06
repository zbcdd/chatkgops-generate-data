from adminQueries import AdminQuery
from constant import Constant, InitData, AdminData
from queries import Query
from utils import *
import time
import logging
import operator
import uuid


logger = logging.getLogger("data_init")
highspeed_weights = {True: 60, False: 40}
datestr = time.strftime("%Y-%m-%d", time.localtime())


# admin相关增删改查：post -> get -> update -> get -> delete
def data_init():
    # 初始化管理员
    admin_query = AdminQuery(Constant.ts_address)
    admin_query.login(Constant.admin_username, Constant.admin_pwd)
    # 初始化站点信息
    for station_data in InitData.init_stations_data:
        admin_query.stations_post(
            station_data[0],
            # station_data[1],
            station_data[2]
        )
    # 初始化路线信息
    for route_data in InitData.init_route_data:
        route_id = admin_query.admin_add_route(
            route_data[0],
            route_data[1],
            route_data[2],
            route_data[3]
        )["id"]
        # 增加车次
        for i in range(len(InitData.train_types)):
            admin_query.admin_add_travel(
                InitData.init_train_trips_id[i],
                InitData.train_types[i],
                route_id
                # InitData.travel_start_time_tick
            )

    # 初始化用户
    user_id = admin_query.admin_add_user(
        InitData.init_user["document_type"],
        InitData.init_user["document_num"],
        InitData.init_user["email"],
        InitData.init_user["password"],
        InitData.init_user["username"],
        InitData.init_user["gender"]
    )
    # 初始化用户联系人
    for contact in InitData.init_user_contacts:
        admin_query.contacts_post(
            "67df7d6b-773c-44c9-8442-e8823a792095",
            contact["contact_name"],
            contact["document_type"],
            contact["document_number"],
            contact["phone_number"]
        )


def admin_operations():
    admin_query = AdminQuery(Constant.ts_address)
    admin_query.login(Constant.admin_username, Constant.admin_pwd)

    # 1. 添加新的站点、路线、车次、price、config
    # 2. 添加新的用户

    # 对于station，每次执行添加的station都是唯一的
    this_stations_data = []
    this_stations = []
    this_stations_str = ""
    for station in AdminData.admin_stations_data:  # station是一个tuple
        this_station_name = station[0] + "_" + uuid.uuid1().hex
        this_station = (this_station_name, station[1], station[2])
        this_stations_data.append(this_station)
        this_stations.append(this_station_name)
        this_stations_str += this_station_name + ","
    this_stations_str = this_stations_str[:len(this_stations_str)-1]
    this_route_data = [(this_stations_str, AdminData.distance_list, this_stations[0], this_stations[len(this_stations)-1])]
    # 同理，对于travel也是唯一的
    this_train_trips_id = []
    this_train_update_trip_id = []   # 这两者应该是一样的，update指update操作的目标travel
    for trip_id in AdminData.admin_train_trips_id:
        this_trip_id = trip_id + uuid.uuid1().hex
        this_train_trips_id.append(this_trip_id)
        this_train_update_trip_id.append(this_trip_id)
        print(this_trip_id)

    # 初始化站点信息
    for station_data in this_stations_data:
        admin_query.stations_post(
            station_data[0],
            # station_data[1],
            station_data[2]
        )
    # 初始化路线信息
    route_id_list = []
    for route_data in this_route_data:
        route_id = admin_query.admin_add_route(
            route_data[0],
            route_data[1],
            route_data[2],
            route_data[3]
        )["id"]
        route_id_list.append(route_id)
        # 增加车次
        for i in range(len(AdminData.train_types)):
            admin_query.admin_add_travel(
                this_train_trips_id[i],
                AdminData.train_types[i],
                route_id
                # AdminData.travel_start_time
            )
    print(str(route_id_list))

    # 添加price，对于上述route
    price_id_list = []
    for route_id in route_id_list:
        for i in range(len(AdminData.train_types)):
            price_id = admin_query.prices_post(route_id, AdminData.train_types[i], 0.5, 1)["id"]
            price_id_list.append(price_id)
    print(price_id_list)

    # 添加config
    config_name = "config_name_" + uuid.uuid1().hex    # config是用name来标识的
    admin_query.configs_post(config_name, "1", "description")

    # 初始化用户
    user_data = admin_query.admin_add_user(
        AdminData.admin_data_user["document_type"],
        AdminData.admin_data_user["document_num"],
        AdminData.admin_data_user["email"],
        AdminData.admin_data_user["password"],
        # AdminData.admin_data_user["username"],
        uuid.uuid1().hex,
        AdminData.admin_data_user["gender"]
    )
    user_id = user_data["userId"]
    # 初始化用户联系人 没有联系人id无法删除 因此暂不添加
    for contact in AdminData.admin_data_user_contacts:
        admin_query.contacts_post(
            user_id,
            contact["contact_name"],
            contact["document_type"],
            contact["document_number"],
            contact["phone_number"]
        )


    print("执行update操作")
    # 执行更新操作
    all_stations = admin_query.stations_get()
    for station_data in this_stations_data:
        # 利用name进行查找对应的id(在系统中，重复添加name会报错)
        for s in all_stations:
            s_name = s["name"]
            if s_name == station_data[0]:   # [0] [1]为name [2]为stay time
                admin_query.stations_put(  # 参数station id,station name,stay time
                    s["id"],
                    station_data[0],
                    station_data[2]
                )
    # 更新路线信息
    for route_id in route_id_list:
        # 更新车次
        for i in range(len(AdminData.train_types)):
            admin_query.admin_update_travel(
                this_train_update_trip_id[i],
                AdminData.train_types[i],
                route_id,
                AdminData.travel_update_start_time
            )
    # 更新price，对于上述route
    for price_id in price_id_list:
        for i in range(len(AdminData.train_types)):
            admin_query.prices_put(price_id, AdminData.train_types[i], route_id_list[i], 0.6, 1)

    # 更新config
    admin_query.configs_put(config_name, "1", "description_update")

    # 更新用户
    admin_query.admin_update_user(
        user_data["userId"],
        AdminData.admin_data_user["document_type"],
        AdminData.admin_data_user["document_num"],
        AdminData.admin_data_user["email"],
        AdminData.admin_data_user["password"],
        AdminData.admin_data_user["username"],
        AdminData.admin_data_user["gender"]
    )
    # 更新用户联系人
    contacts = admin_query.query_contacts(user_id)
    for contact in contacts:
        admin_query.contacts_put(
            contact.get("id"),
            user_id,
            contact.get("name"),
            contact.get("documentType"),
            contact.get("documentNumber"),
            contact.get("phoneNumber")
        )

    # 进行Get查询信息
    print("更新之后进行Get查询")
    admin_query.admin_get_all_routes()
    admin_query.configs_get()
    admin_query.trains_get()
    admin_query.stations_get()
    admin_query.contacts_get()
    admin_query.orders_get()
    admin_query.prices_get()
    admin_query.admin_get_all_travels()
    admin_query.admin_get_all_users()

    print("执行DELETE操作")
    # 删除添加的信息
    # 删除站点，同样需要寻找
    for station_data in this_stations_data:
        # 利用name进行查找对应的id(在系统中，重复添加name会报错)
        for s in all_stations:
            s_name = s["name"]
            if s_name == station_data[0]:  # [0]为name [2]为stay time
                admin_query.stations_delete(s["id"])

    # 删除车次和路线
    for route_id in route_id_list:
        for i in range(len(AdminData.train_types)):
            admin_query.admin_delete_travel(
                this_train_trips_id[i]
            )
        admin_query.admin_delete_route(
            route_id
        )

    # 删除price
    for price_id in price_id_list:
        admin_query.prices_delete(price_id)

    # 删除config
    admin_query.configs_delete(config_name)

    # 删除contact
    for contact in contacts:
        admin_query.contacts_delete(contact.get("id"))

    # 删除用户
    admin_query.admin_delete_user(
        user_id
    )


# 新增用户并登陆
def new_user() -> Query:
    admin_query = AdminQuery(Constant.ts_address)
    admin_query.login(Constant.admin_username, Constant.admin_pwd)
    # 利用uuid新建一个用户的用户名，密码默认为111111
    new_username = uuid.uuid1().hex  # 转换成str
    res = admin_query.admin_add_user("1", "5599488099312X", "ts@fd1.edu.cn", "111111", new_username, "1")
    print(f"[new user] : userId : {res.get('userId')} , username : {res.get('userName')} , pwd : {res.get('password')}")
    # 登陆
    query = Query(Constant.ts_address)
    query.login(new_username, "111111")
    return query


# 用户登陆并成功查询到余票(普通查询):输入起始站and终点站，日期以及查询类型
# 查询类型： normal , high_speed , cheapest , min_station , quickest
def query_left_tickets_successfully(query: Query,
                                    query_type: str = "normal", place_pair: tuple = (),
                                    date: str = time.strftime("%Y-%m-%d", time.localtime()) + " 00:00:00") -> dict:
    # 查询余票(确定起始站、终点站以及列车类型)
    # 类型：普通票、高铁票、高级查询（最快、最少站、最便宜）
    all_trip_info = []  # 成功查询的结果
    if query_type == "normal":
        all_trip_info = query.query_normal_ticket(place_pair=place_pair, time=date)
    if query_type == "high_speed":
        all_trip_info = query.query_high_speed_ticket(place_pair=place_pair, time=date)
    if query_type == "cheapest":
        all_trip_info = query.query_cheapest(place_pair=place_pair, date=date)
    if query_type == "min_station":
        all_trip_info = query.query_min_station(place_pair=place_pair, date=date)
    if query_type == "quickest":
        all_trip_info = query.query_quickest(place_pair=place_pair, date=date)
    # 随机选择一个trip来返回，作为后续preserve的对象（输入）
    trip_info = random_from_list(all_trip_info)
    print(f"[query trip info] : {trip_info}")
    return trip_info


# 用户登陆并查询余票失败（没有station）
# 输入一个不存在的起始站点或终止站点(通过控制输入值来保证查不到travel)
def query_left_tickets_unsuccessfully(query: Query,
                                      query_type: str = "normal",
                                      place_pair: tuple = ("Chong Qing Bei", "Gui Yang Bei"),   # 此处是大写有空格的
                                      date: str = time.strftime("%Y-%m-%d", time.localtime()) + " 00:00:00"):
    # 查询余票(确定起始站、终点站以及列车类型)
    # 查票失败：系统中没有输入的起始站、终点站所以找不到对应trip，返回值为空
    all_trip_info = []
    if query_type == "normal":
        all_trip_info = query.query_normal_ticket(place_pair=place_pair, time=date)
    if query_type == "high_speed":
        all_trip_info = query.query_high_speed_ticket(place_pair=place_pair, time=date)
    if query_type == "cheapest":
        all_trip_info = query.query_cheapest(place_pair=place_pair, date=date)
    if query_type == "min_station":
        all_trip_info = query.query_min_station(place_pair=place_pair, date=date)
    if query_type == "quickest":
        all_trip_info = query.query_quickest(place_pair=place_pair, date=date)
    if all_trip_info is None or len(all_trip_info) == 0:   # 如不存在则返回值为null或[]
        logger.warning("query left tickets unsuccessfully : "
                       "no route found because of unknown start station or end station")
    else:
        logger.warning("error : query left tickets successfully , Unsatisfied query conditions")


# 预定成功且刷新订单
# 输入 query对象，预定的trip信息，预定的日期，刷新所有订单后返回的状态(如果不输入默认返回order界面的订单即未付款/已付款未取票)
def preserve_and_refresh(query: Query, trip_info: dict,
                         date: str = time.strftime("%Y-%m-%d", time.localtime()),
                         seat_type: str = "",
                         types: tuple = tuple([0, 1])) -> List[dict]:
    # 订票(返回是否新建了联系人，因为要删掉)
    new_contact, contacts_id = query.preserve(trip_info=trip_info, date=date, seat_type=seat_type)
    if new_contact is True:
        print("[contact delete][new contact during preserve and delete successfully]")
        admin = AdminQuery(Constant.ts_address)
        admin.login(Constant.admin_username, Constant.admin_pwd)
        admin.contacts_delete(contact_id=contacts_id)

    # refresh刷新订单并返回所有特定状态的订单信息，注意需要分两次返回，因为高铁动车与其他车型是两个不同的接口
    # 注意此处调用query_orders_all_info接口来获取所有信息，而不是query_orders
    res_high_speed = query.query_orders_all_info(types=types)
    res_normal = query.query_orders_all_info(types=types, query_other=True)
    res = res_high_speed + res_normal
    print("[all orders queried] " + str(res))
    return res


# 查询新加的两个站之间是否有直接的线路
def search_route2staion(query, search_id_pair: list = ["chongqingbei", "guiyangbei"],):
    routes = query.admin_get_all_routes()
    for ele in routes:
        stations = ele["stations"]
        if operator.eq(stations, search_id_pair):
            return ele["id"]
    return ""


# 使用admin添加查询失败的线路站点车次，并重新查询返回trip相关信息
def admin_add_route_search(
        search_id_pair: tuple = ("chongqingbei", "guiyangbei"),
        search_name_pair: tuple = ("Chong Qing Bei", "Gui Yang Bei"),
        miss_station_name: str = "guiyangbei",
):
    query = AdminQuery(Constant.ts_address)
    query.login("admin", "222222")

    # 确保对于每一次查询均是唯一的，若系统中已经存在了此station则在删除之前再次添加均会返回id=None
    if miss_station_name == "guiyangbei":
        miss_station_name = miss_station_name + uuid.uuid1().hex
        search_id_pair = list(search_id_pair)
        search_id_pair[1] = miss_station_name
        search_id_pair = tuple(search_id_pair)
        # print(search_id_pair)

    # 添加缺失的站点
    miss_station_id = query.stations_post(
        miss_station_name,
        5
    )["id"]

    # 添加路线,获取route_id
    origin_route_id = search_route2staion(query, list(search_id_pair))
    route_id = query.admin_add_route(
        search_id_pair[0]+","+miss_station_name,
        "0,500",
        search_id_pair[0],
        miss_station_name
    )["id"]
    if origin_route_id != "":
        query.admin_delete_route(route_id)
        route_id = origin_route_id
    print("添加路线成功")

    # 添加车次
    train_type = random.choice(AdminData.train_types)  # 获取一种车的类型
    # travel ID需要是对于此次场景的运行是唯一的，利用uuid来生成
    travel_id_number = uuid.uuid1().hex  # 转换成str
    travel_id = train_type[0] + travel_id_number
    query.admin_add_travel(   # add a new travel是没有返回值的，每个travel用travel ID来标识
        travel_id,   # 根据车的类型获取车次对应Travel ID
        train_type,
        route_id
        # AdminData.travel_start_time    # 默认新增travel的开始时间为当下
    )
    print("添加车次成功" + str(travel_id))

    if train_type[0] == "D" or train_type[0] == "G":
        query_type = "high_speed"
    else:
        query_type = "normal"
    trip_info = query_left_tickets_successfully(query, query_type, search_id_pair)
    return trip_info, miss_station_id, route_id, travel_id


# 改签
# 在预定成功并刷新订单来获取所有符合条件的订单的场景之后，搜索得到刚刚预定的订单并且改签(再次query)
# 输入为refresh查找得到的所有order信息(orderId，tripId)
def rebook(query: Query, order_info: dict) -> str:
    order_id = order_info.get("id")  # 获取id

    # 再次查找余票(此处只有normal和high_speed可选，默认选择同类型的列车进行改签，否则涉及补差价的问题)
    train_type = order_info.get("trainNumber")[0]
    if train_type == 'G' or train_type == 'D':
        query_type = "high_speed"
    else:
        query_type = "normal"
    place_pair = (order_info.get("from"), order_info.get("to"))
    new_date = order_info.get("travelDate")   # 默认改签同一天
    new_trip_info = query_left_tickets_successfully(query, query_type, place_pair, new_date)
    print(f"[rebook new trip info] : {new_trip_info}")

    # 需要更细致的区分时间问题
    # 获取发送请求的时间

    # 改签(默认改签当天)
    new_trip_id = new_trip_info.get("tripId").get("type")+new_trip_info.get("tripId").get("number")  # 返回值是dict
    res = query.rebook_ticket(order_info.get("id"), order_info.get("trainNumber"),
                              new_trip_id, new_date, order_info.get("coachNumber"))

    # 根据res区分不同情形
    if res.find("you order not suitable to rebook!") != -1:
        logger.warning("[rebook unsuccessfully]: not paid or rebook twice")
    if res.find("You can only change the ticket before the train start or within 2 hours after the train start.") != -1:
        logger.warning("[rebook unsuccessfully]: time invalid " +
                       "(You can only change the ticket before the train start " +
                       "or within 2 hours after the train start.)")
    if res.find("Success!") != -1:  # 改签成功
        # 如果改签成功则可能会产生新的orderId，则返回新的orderId
        res_dict = eval(res)  # 改签成功的data不为null，可以转换为字典处理
        order_id = res_dict.get("data").get("id")
        logger.warning(f"[rebook successfully]: Success!  orderId : {order_id}")
    return order_id


# rebook成功的场景（已支付, 第一次rebook, 当前时间在发车时间之前或发车时间2h后）
def rebook_successfully(query: Query, order_info: dict) -> str:
    order_id = order_info.get("id")  # 获取id

    # 再次查找余票(此处只有normal和high_speed可选，默认选择同类型的列车进行改签，否则涉及补差价的问题)
    train_type = order_info.get("trainNumber")[0]
    if train_type == 'G' or train_type == 'D':
        query_type = "high_speed"
    else:
        query_type = "normal"
    place_pair = (order_info.get("from"), order_info.get("to"))
    new_date = datestr  # 获取当天
    new_trip_info = query_left_tickets_successfully(query, query_type, place_pair, new_date)
    print(f"[rebook new trip info] : {new_trip_info}")

    # 需要更细致的区分时间问题

    # 改签(默认改签当天)
    new_trip_id = new_trip_info.get("tripId").get("type")+new_trip_info.get("tripId").get("number")  # 返回值是dict
    res = query.rebook_ticket(order_info.get("id"), order_info.get("trainNumber"),
                              new_trip_id, new_date, order_info.get("coachNumber"))

    # 根据res区分不同情形
    if res.find("you order not suitable to rebook!") != -1:
        logger.warning("[rebook unsuccessfully]: not paid or rebook twice")
    if res.find("You can only change the ticket before the train start or within 2 hours after the train start.") != -1:
        logger.warning("[rebook unsuccessfully]: time invalid " +
                       "(You can only change the ticket before the train start " +
                       "or within 2 hours after the train start.)")
    if res.find("Success!") != -1:  # 改签成功
        # 如果改签成功则可能会产生新的orderId，则返回新的orderId
        res_dict = eval(res)  # 改签成功的data不为null，可以转换为字典处理
        order_id = res_dict.get("data").get("id")
        logger.warning(f"[rebook successfully]: Success!  orderId : {order_id}")
    return order_id


# 改签失败(原因：改签两次)
# 在预定成功并刷新订单来获取所有符合条件的订单的场景之后，搜索得到刚刚预定的订单并且改签(再次query)
# 输入为refresh查找得到的所有order信息(orderId，tripId)
def rebook_unsuccessfully_for_rebooking_twice(query: Query, order_info: dict):
    # 调用paid and rebook successfully函数后再次rebook
    pay_and_rebook_successfully(query, order_info)

    # 再次查找余票(此处只有normal和high_speed可选，默认选择同类型的列车进行改签)
    order_id = rebook(query, order_info)
    logger.warning("[rebook unsuccessfully for rebook twice]")
    return order_id


# 支付并且改签更贵的车次成功
def pay_and_rebook_successfully_for_more_expensive_travel(query: Query, order_info: dict):
    # 支付
    query.pay_order(order_info.get("id"), order_info.get("trainNumber"))

    # 改签步骤：
    # 查余票 -> 选择一个trip -> rebook并将差价作为返回值并在前端展示 -> 提交并支付差价 -> 改签成功
    order_id = order_info.get("id")  # 获取id
    # 查找余票并随机选择一个trip(此处只有normal和high_speed可选，默认选择同类型的列车进行改签，差价利用seat_type来区分)
    train_type = order_info.get("trainNumber")[0]
    if train_type == 'G' or train_type == 'D':
        query_type = "high_speed"
    else:
        query_type = "normal"
    place_pair = (order_info.get("from"), order_info.get("to"))
    new_date = order_info.get("travelDate")   # 默认改签同一天
    new_trip_info = query_left_tickets_successfully(query, query_type, place_pair, new_date)
    print(f"[rebook new trip info] : {new_trip_info}")

    # 改签(默认改签同一天，并且调整座位类型来制造差价，在完整的场景中调用此方法座位类型的一定是3)
    new_trip_id = new_trip_info.get("tripId").get("type")+new_trip_info.get("tripId").get("number")  # 返回值是dict
    res = query.rebook_ticket(order_info.get("id"), order_info.get("trainNumber"),
                              new_trip_id, new_date, "2")
    print(res)    # 此处的res的内容为需要补的差价金额，并在前端提示

    # 补差价后改签成功
    print("补差价后改签成功")
    res_difference = query.calculate_difference_and_submit(order_info.get("id"), order_info.get("trainNumber"),
                                                           new_trip_id, new_date, "2")
    # 返回改签后订单的order Id
    if res.find("Success!") != -1:  # 改签成功
        # 如果改签成功则可能会产生新的orderId，则返回新的orderId
        res_dict = eval(res)  # 改签成功的data不为null，可以转换为字典处理
        order_id = res_dict.get("data").get("id")
        logger.warning(f"[rebook more expensive travel successfully]: Success!  orderId : {order_id}")

    return order_id


# 支付并且改签成功
def pay_and_rebook_successfully(query: Query, order_info: dict):
    # 支付
    query.pay_order(order_info.get("id"), order_info.get("trainNumber"))

    # 改签
    order_id = rebook(query, order_info)
    return order_id


# 检票进站
def collect_and_enter(query: Query, order_id):
    query.collect_order(order_id)
    query.enter_station(order_id)
    logger.info("collect and enter station")


# 取消订单
def refund_and_cancel(query: Query, order_id):
    query.cancel_refund_calculate(order_id=order_id)
    query.cancel_order(order_id)


# 查询order的consign并进行新增
def extra_consign(query: Query, order_info: dict):
    # 查询当前order的consign
    consign_data = query.query_consign_by_order_id(order_info.get("id"))   # 如果已经有consign信息了则返回信息不然为None
    if consign_data is None:  # 表示没有在preserve中指定consign
        consign_id = ""
    else:
        consign_id = consign_data["id"]
    # 新建consign
    consign_data = {
        "accountId": query.uid,
        "targetDate": time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())),
        "from": order_info.get("from"),
        "to": order_info.get("to"),
        "orderId": order_info.get("id"),
        "consignee": "consign_test_again",
        "phone": "19921940999",
        "weight": random.randint(1, 10),
        "handleDate": datestr,   # 2022-10-10
        "isWithin": False,
        "id": consign_id   # consign id
    }
    query.put_consign(consign_data)
    # 再次查询
    query.query_consign_by_order_id(order_info.get("id"))   # 根据order查询
    query.query_consign_by_consignee(consign_data["consignee"])   # 根据consignee查询


# 删除多余的没有删掉的user()
def delete_extra_users():
    admin_query = AdminQuery(ts_address=Constant.ts_address)
    admin_query.login("admin","222222")

    # 获取所有的users
    all_users = admin_query.admin_get_all_users()
    print(all_users)

    # 保留初始用户 fd
    for user in all_users:
        if user["userName"] != "fdse_microservice":
            # 删掉剩余的user
            admin_query.admin_delete_user(user["userId"])
            print(user["userId"] + " 删除成功")
