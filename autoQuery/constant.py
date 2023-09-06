

class Constant:
    # ts_address = 'http://139.196.228.58:32677'   # 阿里云
    ts_address = "http://10.176.122.154:32677"  # 学院云
    #ts_address = 'http://10.176.122.1:32677'  # HD学院云

    admin_username = "admin"
    admin_pwd = "222222"
    user_username = "fdse_microservice"
    user_pwd = "111111"


class InitData:

    init_stations_data = [
        ("fengtai", "Feng Tai", 7),
        ("zhengding", "Zheng Ding", 3),
        ("zhengzhoukonggang", "Zheng Zhou Kong Gang", 5),
        ("xiangyangdong", "Xiang Yang Dong", 3),
        ("wanzhou", "Wan Zhou", 2),
        ("chongqingbei", "Chong Qing Bei", 5),
        ("chengdudong", "Cheng Du Dong", 5),
    ]
    station_list = "fengtai,zhengding,zhengzhoukonggang,xiangyangdong,chongqingbei,chengdudong"
    distance_list = "0,150,360,500,1100,1400"
    init_route_data = [
        (station_list, distance_list, "fengtai", "chengdudong")
    ]
    train_types = [
        "GaoTieOne", "GaoTieTwo", "DongCheOne", "ZhiDa", "TeKuai", "KuaiSu"
    ]
    init_train_trips_id = [
        "G9001", "G9002", "D8003", "Z8004", "T8005", "K8006"
    ]
    travel_start_time_tick = "1367929200000"

    init_user = {
            "document_type": "1",
            "document_num": "5599488099312X",
            "email": "ts@fd1.edu.cn",
            "password": "111111",
            "username": "chair1",
            "gender": "1"
    }

    init_user_contacts = [
        {
            "contact_name": "Contacts_111",
            "document_type": 1,
            "document_number": "5135488099312X",
            "phone_number": "19921940977",
        },
        {
            "contact_name": "Contacts_222",
            "document_type": 1,
            "document_number": "5235488099312X",
            "phone_number": "18921940977",
        },
        {
            "contact_name": "Contacts_333",
            "document_type": 1,
            "document_number": "5335488099312X",
            "phone_number": "17921940977",
        }
    ]

    # 下面记录在新增的过程中产生的route travel等对应的标识(id等)
    init_stations_ids = []
    init_routes_ids = []


class AdminData:
    admin_stations_data = [
        ("taiyuannan", "Tai Yuan Nan", 3),
        # ("zhengzhoudong", "Zheng Zhou Dong", 5),
        # ("hankou", "Han Kou", 5),
        # ("changshanan", "Chang Sha Nan", 3),
        # ("guangzhounan", "Guang Zhou Nan", 5),
        # ("shenzhenbei", "Shen Zhen Bei", 5),
        # ("futian", "Fu Tian", 3),
        ("jiulong", "Jiu Long", 5)
    ]
    # station_list = "taiyuannan,zhengzhoudong,hankou,changshanan,guangzhounan,shenzhenbei,futian,jiulong"
    station_list = "taiyuannan,jiulong"
    distance_list = "0,1660"
    admin_route_data = [
        (station_list, distance_list, station_list[0], station_list[1])
    ]
    train_types = [
        # "GaoTieOne","DongCheOne","ZhiDa"
        "GaoTieOne"
    ]
    admin_train_trips_id = [
        # "G7001", "D7003", "Z7004"
        "G7001"
    ]
    admin_train_update_trip_id = [
        # "G7001", "D7003", "Z7004"
        "G7001"
    ]
    travel_start_time = "1367989200000"
    travel_update_start_time = "1367989800000"

    admin_data_user = {
            "document_type": "1",
            "document_num": "7799488099312X",
            "email": "ts@fd99.edu.cn",
            "password": "111111",
            "username": "adminTest3",
            "gender": "1"
    }

    admin_data_user_contacts = [
        {
            "contact_name": "adminContactTest1",
            "document_type": 1,
            "document_number": "7135488099312X",
            "phone_number": "19921940978",
        }
        # {
        #     "contact_name": "adminContactTest2",
        #     "document_type": 1,
        #     "document_number": "7235488099312X",
        #     "phone_number": "18921940979",
        # },
        # {
        #     "contact_name": "adminContactTest3",
        #     "document_type": 1,
        #     "document_number": "7335488099312X",
        #     "phone_number": "179219409780",
        # }
    ]

    random_train_type_reflection = {
        "GaoTieOne": "G10246",
        "GaoTieTwo": "G10247",
        "DongCheOne": "D10248",
        "ZhiDa": "Z10249",
        "TeKuai": "T10250",
        "KuaiSu": "K10251"
    }






