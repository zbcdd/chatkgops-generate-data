use ts;
-- MySQL dump 10.13  Distrib 5.7.34-37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ts
-- ------------------------------------------------------
-- Server version	5.7.34-37-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*!50717 SELECT COUNT(*) INTO @rocksdb_has_p_s_session_variables FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'performance_schema' AND TABLE_NAME = 'session_variables' */;
/*!50717 SET @rocksdb_get_is_supported = IF (@rocksdb_has_p_s_session_variables, 'SELECT COUNT(*) INTO @rocksdb_is_supported FROM performance_schema.session_variables WHERE VARIABLE_NAME=\'rocksdb_bulk_load\'', 'SELECT 0') */;
/*!50717 PREPARE s FROM @rocksdb_get_is_supported */;
/*!50717 EXECUTE s */;
/*!50717 DEALLOCATE PREPARE s */;
/*!50717 SET @rocksdb_enable_bulk_load = IF (@rocksdb_is_supported, 'SET SESSION rocksdb_bulk_load = 1', 'SET @rocksdb_dummy_bulk_load = 0') */;
/*!50717 PREPARE s FROM @rocksdb_enable_bulk_load */;
/*!50717 EXECUTE s */;
/*!50717 DEALLOCATE PREPARE s */;

--
-- Table structure for table `assurance`
--

DROP TABLE IF EXISTS `assurance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assurance` (
  `assurance_id` varchar(255) NOT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  `assurance_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`assurance_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assurance`
--

LOCK TABLES `assurance` WRITE;
/*!40000 ALTER TABLE `assurance` DISABLE KEYS */;
/*!40000 ALTER TABLE `assurance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `user_id` varchar(36) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `user_name` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES ('4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','$2a$10$gjnfTQBYtr90k5vXn3rbBuqSGjn9eoeqHPsCX.f1qORHuEPgyUiFm','fdse_microservice'),('b4f140aa-e4d0-42fc-91e4-d4fd4d482057','$2a$10$luh62CvPMSwhn9D1K.mRMuM6yVrw.1SpVjDe20/nXq8UqxOPsE8mS','admin'),('f80faabd-a593-461e-a70d-08761a4d0e31','$2a$10$AoRHIFT6kLHeY1bCW5lqgOI/U8UEMU54uUfxs/226EFJ.gpcdbrRO','chair1');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES ('DirectTicketAllocationProportion','Allocation Proportion Of The Direct Ticket - From Start To End','0.5');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consign_price`
--

DROP TABLE IF EXISTS `consign_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consign_price` (
  `id` varchar(36) NOT NULL,
  `beyond_price` double DEFAULT NULL,
  `idx` int(11) DEFAULT NULL,
  `initial_price` double DEFAULT NULL,
  `initial_weight` double DEFAULT NULL,
  `within_price` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_lgier9psog5spnqru5luet1sv` (`idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consign_price`
--

LOCK TABLES `consign_price` WRITE;
/*!40000 ALTER TABLE `consign_price` DISABLE KEYS */;
INSERT INTO `consign_price` VALUES ('38a5385c-2eda-404c-8321-4645d19877e6',4,0,8,1,2);
/*!40000 ALTER TABLE `consign_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consign_record`
--

DROP TABLE IF EXISTS `consign_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consign_record` (
  `consign_record_id` varchar(255) NOT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `consignee` varchar(255) DEFAULT NULL,
  `from_place` varchar(255) DEFAULT NULL,
  `handle_date` varchar(255) DEFAULT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  `consign_record_phone` varchar(255) DEFAULT NULL,
  `consign_record_price` double DEFAULT NULL,
  `target_date` varchar(255) DEFAULT NULL,
  `to_place` varchar(255) DEFAULT NULL,
  `weight` double NOT NULL,
  PRIMARY KEY (`consign_record_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consign_record`
--

LOCK TABLES `consign_record` WRITE;
/*!40000 ALTER TABLE `consign_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `consign_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
  `id` varchar(36) NOT NULL,
  `account_id` varchar(255) DEFAULT NULL,
  `document_number` varchar(255) DEFAULT NULL,
  `document_type` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_document_idx` (`account_id`,`document_number`,`document_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES ('0fc49fb2-9751-4f9b-b5c3-56a439362752','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','DocumentNumber_One',1,'Contacts_One','ContactsPhoneNum_One'),('e5b4b29c-2041-4c18-b87b-36d12ac4df32','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','DocumentNumber_Two',1,'Contacts_Two','ContactsPhoneNum_Two'),('7fcf5f75-8670-443f-91b1-f9efdad9f383','67df7d6b-773c-44c9-8442-e8823a792095','5135488099312X',1,'Contacts_111','19921940977'),('d4bdeeb0-fcee-4238-a427-0e051aa55ff6','67df7d6b-773c-44c9-8442-e8823a792095','5235488099312X',1,'Contacts_222','18921940977'),('ec943ab9-2f2c-4894-aecc-e8c46fd72c65','67df7d6b-773c-44c9-8442-e8823a792095','5335488099312X',1,'Contacts_333','17921940977');
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delivery` (
  `id` varchar(36) NOT NULL,
  `food_name` varchar(255) DEFAULT NULL,
  `order_id` binary(255) DEFAULT NULL,
  `station_name` varchar(255) DEFAULT NULL,
  `store_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_delivery_order`
--

DROP TABLE IF EXISTS `food_delivery_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `food_delivery_order` (
  `id` varchar(36) NOT NULL,
  `created_time` varchar(255) DEFAULT NULL,
  `delivery_fee` double NOT NULL,
  `delivery_time` varchar(255) DEFAULT NULL,
  `seat_no` int(11) NOT NULL,
  `station_food_store_id` varchar(255) DEFAULT NULL,
  `trip_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_delivery_order`
--

LOCK TABLES `food_delivery_order` WRITE;
/*!40000 ALTER TABLE `food_delivery_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_delivery_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_delivery_order_food_list`
--

DROP TABLE IF EXISTS `food_delivery_order_food_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `food_delivery_order_food_list` (
  `food_delivery_order_id` varchar(36) NOT NULL,
  `food_name` varchar(255) DEFAULT NULL,
  `price` double NOT NULL,
  KEY `FK7qff03pst9g4hm7fieqeqf8ta` (`food_delivery_order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_delivery_order_food_list`
--

LOCK TABLES `food_delivery_order_food_list` WRITE;
/*!40000 ALTER TABLE `food_delivery_order_food_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_delivery_order_food_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order`
--

DROP TABLE IF EXISTS `food_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `food_order` (
  `id` varchar(36) NOT NULL,
  `food_name` varchar(255) DEFAULT NULL,
  `food_type` int(11) NOT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  `price` double NOT NULL,
  `station_name` varchar(255) DEFAULT NULL,
  `store_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order`
--

LOCK TABLES `food_order` WRITE;
/*!40000 ALTER TABLE `food_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `food_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inside_money`
--

DROP TABLE IF EXISTS `inside_money`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inside_money` (
  `id` varchar(36) NOT NULL,
  `money` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `user_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inside_money`
--

LOCK TABLES `inside_money` WRITE;
/*!40000 ALTER TABLE `inside_money` DISABLE KEYS */;
INSERT INTO `inside_money` VALUES ('b38b26eb-d041-4dfa-813b-563026ecf7b7','10000','A','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f');
/*!40000 ALTER TABLE `inside_money` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inside_payment`
--

DROP TABLE IF EXISTS `inside_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inside_payment` (
  `id` varchar(36) NOT NULL,
  `order_id` varchar(36) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `user_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inside_payment`
--

LOCK TABLES `inside_payment` WRITE;
/*!40000 ALTER TABLE `inside_payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `inside_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `money`
--

DROP TABLE IF EXISTS `money`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `money` (
  `id` varchar(36) NOT NULL,
  `money` varchar(255) DEFAULT NULL,
  `user_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `money`
--

LOCK TABLES `money` WRITE;
/*!40000 ALTER TABLE `money` DISABLE KEYS */;
/*!40000 ALTER TABLE `money` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_info`
--

DROP TABLE IF EXISTS `notify_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_info` (
  `id` varchar(36) NOT NULL,
  `date` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `end_place` varchar(255) DEFAULT NULL,
  `order_number` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `seat_class` varchar(255) DEFAULT NULL,
  `seat_number` varchar(255) DEFAULT NULL,
  `send_status` bit(1) DEFAULT NULL,
  `start_place` varchar(255) DEFAULT NULL,
  `start_time` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_info`
--

LOCK TABLES `notify_info` WRITE;
/*!40000 ALTER TABLE `notify_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `notify_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `office`
--

DROP TABLE IF EXISTS `office`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `office` (
  `name` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `workTime` varchar(32) DEFAULT NULL,
  `windowNum` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `office`
--

LOCK TABLES `office` WRITE;
/*!40000 ALTER TABLE `office` DISABLE KEYS */;
INSERT INTO `office` VALUES ('Jinqiao Road ticket sales outlets','Shanghai','Shanghai','Pudong New Area','Jinqiao Road 1320, Shanghai, Pudong New Area','08:00-18:00',1),('Jinqiao Road ticket sales outlets','Shanghai','Shanghai','Pudong New Area','Jinqiao Road 1320, Shanghai, Pudong New Area','08:00-18:00',1);
/*!40000 ALTER TABLE `office` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` varchar(36) NOT NULL,
  `account_id` varchar(36) DEFAULT NULL,
  `bought_date` varchar(255) DEFAULT NULL,
  `coach_number` int(11) NOT NULL,
  `contacts_document_number` varchar(255) DEFAULT NULL,
  `contacts_name` varchar(255) DEFAULT NULL,
  `document_type` int(11) NOT NULL,
  `from_station` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `seat_class` int(11) NOT NULL,
  `seat_number` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `to_station` varchar(255) DEFAULT NULL,
  `train_number` varchar(255) DEFAULT NULL,
  `travel_date` varchar(255) DEFAULT NULL,
  `travel_time` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('98857edf-f6f8-44d6-9918-8c106642277d','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:20',5,'DocumentNumber_One','Contacts_One',1,'nanjing','100.0',2,'FirstClass-30',0,'shanghaihongqiao','G1237','2022-10-01 00:00:00','2022-10-01 00:00:00'),('e500077e-9d60-43a9-8c9e-fd9899c6c200','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:21',5,'DocumentNumber_One','Contacts_One',1,'shanghai','100.0',2,'FirstClass-30',0,'beijing','G1234','2022-10-01 00:00:00','2022-10-01 00:00:00'),('375935a1-f67d-4048-92f3-0ab50da15c77','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:21',5,'DocumentNumber_One','Contacts_One',1,'shanghai','100.0',2,'FirstClass-30',0,'beijing','G1235','2022-10-01 00:00:00','2022-10-01 00:00:00'),('52c73dc4-3e12-4148-be98-b27b0a5050a8','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:35',5,'DocumentNumber_One','Contacts_One',1,'nanjing','100.0',2,'FirstClass-30',0,'shanghaihongqiao','G1237','2022-10-01 00:00:00','2022-10-01 00:00:00'),('52e8ae27-c90f-49f6-8ff7-d12300434a91','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:37',5,'DocumentNumber_One','Contacts_One',1,'shanghai','100.0',2,'FirstClass-30',0,'beijing','G1234','2022-10-01 00:00:00','2022-10-01 00:00:00'),('50604ae9-2e3e-43cc-b19b-8b2bf386b9ba','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:37',5,'DocumentNumber_One','Contacts_One',1,'shanghai','100.0',2,'FirstClass-30',0,'beijing','G1235','2022-10-01 00:00:00','2022-10-01 00:00:00');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_other`
--

DROP TABLE IF EXISTS `orders_other`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders_other` (
  `id` varchar(36) NOT NULL,
  `account_id` varchar(36) DEFAULT NULL,
  `bought_date` varchar(255) DEFAULT NULL,
  `coach_number` int(11) NOT NULL,
  `contacts_document_number` varchar(255) DEFAULT NULL,
  `contacts_name` varchar(255) DEFAULT NULL,
  `document_type` int(11) NOT NULL,
  `from_station` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `seat_class` int(11) NOT NULL,
  `seat_number` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `to_station` varchar(255) DEFAULT NULL,
  `train_number` varchar(255) DEFAULT NULL,
  `travel_date` varchar(255) DEFAULT NULL,
  `travel_time` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_other`
--

LOCK TABLES `orders_other` WRITE;
/*!40000 ALTER TABLE `orders_other` DISABLE KEYS */;
INSERT INTO `orders_other` VALUES ('b25349e7-5d88-4396-96cc-7d153070f51e','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:18',5,'Test','Test',1,'shanghai','100',2,'6A',1,'taiyuan','K1235','2022-10-01 00:00:00','2022-10-01 00:00:00'),('18a06073-0c49-4fd1-b7cb-79b2d8a402d5','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2022-11-22 19:30:41',5,'Test','Test',1,'shanghai','100',2,'6A',1,'taiyuan','K1235','2022-10-01 00:00:00','2022-10-01 00:00:00');
/*!40000 ALTER TABLE `orders_other` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment` (
  `id` varchar(36) NOT NULL,
  `order_id` varchar(36) DEFAULT NULL,
  `payment_price` varchar(255) DEFAULT NULL,
  `user_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES ('4f4751fb-10f1-4b7c-92ea-bbebde812454','5ad7750b-a68b-49c0-a8c0-32776b067701','10000.0','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f'),('432a6347-f56d-49ea-9433-418d58eb7aa3','5ad7750b-a68b-49c0-a8c0-32776b067701','10000.0','4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_config`
--

DROP TABLE IF EXISTS `price_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `price_config` (
  `id` varchar(36) NOT NULL,
  `basic_price_rate` double NOT NULL,
  `first_class_price_rate` double NOT NULL,
  `route_id` varchar(36) DEFAULT NULL,
  `train_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `route_type_idx` (`train_type`,`route_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_config`
--

LOCK TABLES `price_config` WRITE;
/*!40000 ALTER TABLE `price_config` DISABLE KEYS */;
INSERT INTO `price_config` VALUES ('6d20b8cb-039c-474c-ae25-b6177ea41152',0.38,1,'92708982-77af-4318-be25-57ccb0ff69ad','GaoTieOne'),('c5679b7e-4a54-4f52-9939-1ae86ba16fa7',0.5,1,'aefcef3f-3f42-46e8-afd7-6cb2a928bd3d','GaoTieOne'),('719287d6-d3e7-4b54-9a92-71d039748b22',0.7,1,'a3f256c1-0e43-4f7d-9c21-121bf258101f','GaoTieOne'),('7de18cf8-bb17-4bb2-aeb4-85d8176d3a93',0.6,1,'084837bb-53c8-4438-87c8-0321a4d09917','GaoTieTwo'),('d5c4523a-827c-468c-95be-e9024a40572e',0.45,1,'f3d4d4ef-693b-4456-8eed-59c0d717dd08','DongCheOne'),('b90a6ad7-ffad-4624-9655-48e9e185fa6c',0.35,1,'0b23bd3e-876a-4af3-b920-c50a90c90b04','ZhiDa'),('8fb01829-393f-4af4-9e96-f72866f94d14',0.35,1,'9fc9c261-3263-4bfa-82f8-bb44e06b2f52','ZhiDa'),('8b059dc5-01a2-4f8f-8f94-6c886b38bb34',0.32,1,'d693a2c5-ef87-4a3c-bef8-600b43f62c68','ZhiDa'),('dd0e572e-7443-420c-8280-7d8215636069',0.3,1,'20eb7122-3a11-423f-b10a-be0dc5bce7db','TeKuai'),('0eb474c9-f8be-4119-8681-eb538a404a6a',0.2,1,'1367db1f-461e-4ab7-87ad-2bcc05fd9cb7','KuaiSu');
/*!40000 ALTER TABLE `price_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route` (
  `id` varchar(36) NOT NULL,
  `end_station` varchar(255) DEFAULT NULL,
  `start_station` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route`
--

LOCK TABLES `route` WRITE;
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` VALUES ('0b23bd3e-876a-4af3-b920-c50a90c90b04','taiyuan','shanghai'),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52','beijing','nanjing'),('d693a2c5-ef87-4a3c-bef8-600b43f62c68','shanghai','taiyuan'),('20eb7122-3a11-423f-b10a-be0dc5bce7db','taiyuan','shanghai'),('1367db1f-461e-4ab7-87ad-2bcc05fd9cb7','hangzhou','shanghaihongqiao'),('92708982-77af-4318-be25-57ccb0ff69ad','shanghai','nanjing'),('aefcef3f-3f42-46e8-afd7-6cb2a928bd3d','shanghai','nanjing'),('a3f256c1-0e43-4f7d-9c21-121bf258101f','shanghai','nanjing'),('084837bb-53c8-4438-87c8-0321a4d09917','shanghai','suzhou'),('f3d4d4ef-693b-4456-8eed-59c0d717dd08','suzhou','shanghai'),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','chengdudong','fengtai');
/*!40000 ALTER TABLE `route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_distances`
--

DROP TABLE IF EXISTS `route_distances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route_distances` (
  `route_id` varchar(36) NOT NULL,
  `distances` int(11) DEFAULT NULL,
  `distances_order` int(11) NOT NULL,
  PRIMARY KEY (`route_id`,`distances_order`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_distances`
--

LOCK TABLES `route_distances` WRITE;
/*!40000 ALTER TABLE `route_distances` DISABLE KEYS */;
INSERT INTO `route_distances` VALUES ('0b23bd3e-876a-4af3-b920-c50a90c90b04',0,0),('0b23bd3e-876a-4af3-b920-c50a90c90b04',350,1),('0b23bd3e-876a-4af3-b920-c50a90c90b04',1000,2),('0b23bd3e-876a-4af3-b920-c50a90c90b04',1300,3),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52',0,0),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52',500,1),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52',700,2),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52',1200,3),('d693a2c5-ef87-4a3c-bef8-600b43f62c68',0,0),('d693a2c5-ef87-4a3c-bef8-600b43f62c68',300,1),('d693a2c5-ef87-4a3c-bef8-600b43f62c68',950,2),('d693a2c5-ef87-4a3c-bef8-600b43f62c68',1300,3),('20eb7122-3a11-423f-b10a-be0dc5bce7db',0,0),('20eb7122-3a11-423f-b10a-be0dc5bce7db',1300,1),('1367db1f-461e-4ab7-87ad-2bcc05fd9cb7',0,0),('1367db1f-461e-4ab7-87ad-2bcc05fd9cb7',150,1),('1367db1f-461e-4ab7-87ad-2bcc05fd9cb7',300,2),('92708982-77af-4318-be25-57ccb0ff69ad',0,0),('92708982-77af-4318-be25-57ccb0ff69ad',100,1),('92708982-77af-4318-be25-57ccb0ff69ad',150,2),('92708982-77af-4318-be25-57ccb0ff69ad',200,3),('92708982-77af-4318-be25-57ccb0ff69ad',250,4),('aefcef3f-3f42-46e8-afd7-6cb2a928bd3d',0,0),('aefcef3f-3f42-46e8-afd7-6cb2a928bd3d',250,1),('a3f256c1-0e43-4f7d-9c21-121bf258101f',0,0),('a3f256c1-0e43-4f7d-9c21-121bf258101f',200,1),('a3f256c1-0e43-4f7d-9c21-121bf258101f',250,2),('084837bb-53c8-4438-87c8-0321a4d09917',0,0),('084837bb-53c8-4438-87c8-0321a4d09917',50,1),('f3d4d4ef-693b-4456-8eed-59c0d717dd08',0,0),('f3d4d4ef-693b-4456-8eed-59c0d717dd08',50,1),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381',0,0),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381',150,1),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381',360,2),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381',500,3),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381',1100,4),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381',1400,5);
/*!40000 ALTER TABLE `route_distances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_stations`
--

DROP TABLE IF EXISTS `route_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route_stations` (
  `route_id` varchar(36) NOT NULL,
  `stations` varchar(255) DEFAULT NULL,
  `stations_order` int(11) NOT NULL,
  PRIMARY KEY (`route_id`,`stations_order`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_stations`
--

LOCK TABLES `route_stations` WRITE;
/*!40000 ALTER TABLE `route_stations` DISABLE KEYS */;
INSERT INTO `route_stations` VALUES ('0b23bd3e-876a-4af3-b920-c50a90c90b04','shanghai',0),('0b23bd3e-876a-4af3-b920-c50a90c90b04','nanjing',1),('0b23bd3e-876a-4af3-b920-c50a90c90b04','shijiazhuang',2),('0b23bd3e-876a-4af3-b920-c50a90c90b04','taiyuan',3),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52','nanjing',0),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52','xuzhou',1),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52','jinan',2),('9fc9c261-3263-4bfa-82f8-bb44e06b2f52','beijing',3),('d693a2c5-ef87-4a3c-bef8-600b43f62c68','taiyuan',0),('d693a2c5-ef87-4a3c-bef8-600b43f62c68','shijiazhuang',1),('d693a2c5-ef87-4a3c-bef8-600b43f62c68','nanjing',2),('d693a2c5-ef87-4a3c-bef8-600b43f62c68','shanghai',3),('20eb7122-3a11-423f-b10a-be0dc5bce7db','shanghai',0),('20eb7122-3a11-423f-b10a-be0dc5bce7db','taiyuan',1),('1367db1f-461e-4ab7-87ad-2bcc05fd9cb7','shanghaihongqiao',0),('1367db1f-461e-4ab7-87ad-2bcc05fd9cb7','jiaxingnan',1),('1367db1f-461e-4ab7-87ad-2bcc05fd9cb7','hangzhou',2),('92708982-77af-4318-be25-57ccb0ff69ad','nanjing',0),('92708982-77af-4318-be25-57ccb0ff69ad','zhenjiang',1),('92708982-77af-4318-be25-57ccb0ff69ad','wuxi',2),('92708982-77af-4318-be25-57ccb0ff69ad','suzhou',3),('92708982-77af-4318-be25-57ccb0ff69ad','shanghai',4),('aefcef3f-3f42-46e8-afd7-6cb2a928bd3d','nanjing',0),('aefcef3f-3f42-46e8-afd7-6cb2a928bd3d','shanghai',1),('a3f256c1-0e43-4f7d-9c21-121bf258101f','nanjing',0),('a3f256c1-0e43-4f7d-9c21-121bf258101f','suzhou',1),('a3f256c1-0e43-4f7d-9c21-121bf258101f','shanghai',2),('084837bb-53c8-4438-87c8-0321a4d09917','suzhou',0),('084837bb-53c8-4438-87c8-0321a4d09917','shanghai',1),('f3d4d4ef-693b-4456-8eed-59c0d717dd08','shanghai',0),('f3d4d4ef-693b-4456-8eed-59c0d717dd08','suzhou',1),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','fengtai',0),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','zhengding',1),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','zhengzhoukonggang',2),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','xiangyangdong',3),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','chongqingbei',4),('fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','chengdudong',5);
/*!40000 ALTER TABLE `route_stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_config`
--

DROP TABLE IF EXISTS `security_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `security_config` (
  `id` varchar(36) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_config`
--

LOCK TABLES `security_config` WRITE;
/*!40000 ALTER TABLE `security_config` DISABLE KEYS */;
INSERT INTO `security_config` VALUES ('2d353ed5-49cc-45ae-a4f8-37e15915b31a','Max in 1 hour','max_order_1_hour','2147483647'),('01f613e6-d957-4e52-b79a-8e799d614a0d','Max not used','max_order_not_use','2147483647');
/*!40000 ALTER TABLE `security_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `stay_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_gnneuc0peq2qi08yftdjhy7ok` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES ('0be41443-15a5-406f-9733-dfb4c9a58a70','shanghaihongqiao',10),('0d6dc7e3-c6e9-4a10-a496-7779adba6776','jiaxingnan',2),('2051842b-2a02-46ae-9867-bc7157ea7666','zhengding',3),('285a59cf-8579-41ba-ad71-1a8f5c286bc4','jinan',5),('296f5b12-6cd5-42c7-973f-fa218b71ee0a','shanghai',10),('2d371a1b-d04c-4695-910c-b8ba63ff522c','taiyuan',5),('3bd204db-8d8e-4d37-a7df-bcf1ceecbc71','xuzhou',7),('4046d108-ab36-4118-9ecc-8d7097d1bf45','zhenjiang',2),('5db4c0de-0288-49ae-bd16-66f6e61f9534','xiangyangdong',3),('65fdf361-25cc-407e-8983-a2a6b0af9893','suzhou',3),('68bd7d85-c203-43ae-bf40-96e8e86ca20d','chongqingbei',5),('6ec9b51e-cea4-4fc2-b56a-607320e974b1','chengdudong',5),('9473fcd8-ce6e-4361-8c48-07dce2a05390','hangzhou',9),('a8d59b0d-b145-4cd9-b0eb-1fa87fffdb24','nanjing',8),('b69ef845-20e5-4e36-b202-fd0e59347bf1','beijing',10),('d37617e9-2495-4970-bcb0-db332384d5e9','wuxi',3),('d4992dcc-b228-451b-baa4-ffe5c52c9710','shijiazhuang',8),('d9861815-c19a-4e1c-a998-cd55aa0084f2','zhengzhoukonggang',5),('ec66626c-ff02-4489-ba3d-e9521bcef077','fengtai',7),('f5438efb-0e0a-4baa-a5c2-ebfefd349302','wanzhou',2);
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station_food_list`
--

DROP TABLE IF EXISTS `station_food_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station_food_list` (
  `store_id` varchar(255) NOT NULL,
  `food_name` varchar(255) DEFAULT NULL,
  `price` double NOT NULL,
  KEY `FK789k11aygpihdosaug6hrh7r2` (`store_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station_food_list`
--

LOCK TABLES `station_food_list` WRITE;
/*!40000 ALTER TABLE `station_food_list` DISABLE KEYS */;
INSERT INTO `station_food_list` VALUES ('cfced4ed-1bb5-4f89-8044-f1b9fd0fe7ee','Hamburger',5),('cfced4ed-1bb5-4f89-8044-f1b9fd0fe7ee','Cola',2),('cfced4ed-1bb5-4f89-8044-f1b9fd0fe7ee','Chicken',10.5),('49dbf70b-fd55-4c61-9ba0-649289f4cc76','Rice',1.2),('49dbf70b-fd55-4c61-9ba0-649289f4cc76','Chicken Soup',2.5),('7fcb72dd-7720-4ece-a393-d69dc9206b5d','Big Burger',1.2),('7fcb72dd-7720-4ece-a393-d69dc9206b5d','Bone Soup',2.5),('8aaf1667-c1b1-4473-8b14-7da857a49f06','Big Burger',1.2),('8aaf1667-c1b1-4473-8b14-7da857a49f06','Bone Soup',2.5),('b4932044-c483-4560-9f06-214c289d40ab','Big Mac',2.2),('b4932044-c483-4560-9f06-214c289d40ab','McChicken',1.5),('59843fb4-31e7-4dbe-913f-0d1f616decb9','Big Burger',1.2),('59843fb4-31e7-4dbe-913f-0d1f616decb9','Bone Soup',2.5),('f6d44dea-6b58-4d3d-8ec3-be97ed93f0ea','French Fries',1.2),('f6d44dea-6b58-4d3d-8ec3-be97ed93f0ea','Vegetable Seafood Soup',2.5),('85a23ac5-3109-48c5-85e1-aee0b8228dcc','Hot Chocolate',1.2),('85a23ac5-3109-48c5-85e1-aee0b8228dcc','Pineapple Pie',2.5),('ff652fa1-8552-4952-a874-b4f0b5296c5b','Karubi Beef',1.2),('ff652fa1-8552-4952-a874-b4f0b5296c5b',' Low Fat Yogurt Blackberry',2.5);
/*!40000 ALTER TABLE `station_food_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station_food_store`
--

DROP TABLE IF EXISTS `station_food_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station_food_store` (
  `store_id` varchar(255) NOT NULL,
  `business_time` varchar(255) DEFAULT NULL,
  `delivery_fee` double NOT NULL,
  `station_name` varchar(255) DEFAULT NULL,
  `store_name` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`store_id`),
  UNIQUE KEY `station_store_idx` (`station_name`,`store_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station_food_store`
--

LOCK TABLES `station_food_store` WRITE;
/*!40000 ALTER TABLE `station_food_store` DISABLE KEYS */;
INSERT INTO `station_food_store` VALUES ('cfced4ed-1bb5-4f89-8044-f1b9fd0fe7ee','10:00-20:00',20,'shanghai','KFC','01-234567'),('49dbf70b-fd55-4c61-9ba0-649289f4cc76','08:00-21:00',10,'shanghai','Good Taste','6228480012'),('7fcb72dd-7720-4ece-a393-d69dc9206b5d','08:00-23:00',15,'nanjing','Burger King','88348215681'),('8aaf1667-c1b1-4473-8b14-7da857a49f06','08:00-23:00',15,'nanjing','Pizza Hut','2382614'),('b4932044-c483-4560-9f06-214c289d40ab','08:00-23:00',15,'nanjing','McDonald\'s','2836485'),('59843fb4-31e7-4dbe-913f-0d1f616decb9','09:00-23:00',15,'suzhou','Roman Holiday','3769464'),('f6d44dea-6b58-4d3d-8ec3-be97ed93f0ea','08:00-23:00',15,'beijing','Perfect','975335664'),('85a23ac5-3109-48c5-85e1-aee0b8228dcc','08:00-21:00',15,'beijing','Delicious','237452946'),('ff652fa1-8552-4952-a874-b4f0b5296c5b','08:00-21:00',15,'taiyuan','GOODWILL','23753855');
/*!40000 ALTER TABLE `station_food_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_food`
--

DROP TABLE IF EXISTS `train_food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `train_food` (
  `id` varchar(36) NOT NULL,
  `trip_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_104u6slgvuqsgue17v5p4cx45` (`trip_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_food`
--

LOCK TABLES `train_food` WRITE;
/*!40000 ALTER TABLE `train_food` DISABLE KEYS */;
INSERT INTO `train_food` VALUES ('5918662e-48b1-44fc-b307-dcbc7d46fadb','G1234'),('4fb62ce5-c41d-49b4-a717-0ae36bd25da7','G1235'),('d384e0f9-3dfd-4bf4-8a8c-b4ad257c8dca','G1236'),('524eb576-ae80-44b1-a302-33550b3eddbe','G1237'),('42416a8f-0638-40ad-9881-0e6881b02e8b','D1345');
/*!40000 ALTER TABLE `train_food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_food_list`
--

DROP TABLE IF EXISTS `train_food_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `train_food_list` (
  `trip_id` varchar(36) NOT NULL,
  `food_name` varchar(255) DEFAULT NULL,
  `price` double NOT NULL,
  KEY `FKjf1mr4qeh5wxc3rxhoe8oxwm1` (`trip_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_food_list`
--

LOCK TABLES `train_food_list` WRITE;
/*!40000 ALTER TABLE `train_food_list` DISABLE KEYS */;
INSERT INTO `train_food_list` VALUES ('5918662e-48b1-44fc-b307-dcbc7d46fadb','Egg Soup',3.2),('5918662e-48b1-44fc-b307-dcbc7d46fadb','Pork Chop with rice',9.5),('4fb62ce5-c41d-49b4-a717-0ae36bd25da7','Pork pickled mustard green noodles',10),('4fb62ce5-c41d-49b4-a717-0ae36bd25da7','Soup',3.7),('4fb62ce5-c41d-49b4-a717-0ae36bd25da7','Beef with rice',9.5),('d384e0f9-3dfd-4bf4-8a8c-b4ad257c8dca','Glutinous rice',0.9),('d384e0f9-3dfd-4bf4-8a8c-b4ad257c8dca','Seafood noodles',9.5),('524eb576-ae80-44b1-a302-33550b3eddbe','Rice and vegetable roll',1),('524eb576-ae80-44b1-a302-33550b3eddbe','Vegetable soup',0.8),('524eb576-ae80-44b1-a302-33550b3eddbe','Spring rolls',1.5),('42416a8f-0638-40ad-9881-0e6881b02e8b','Oily bean curd',2),('42416a8f-0638-40ad-9881-0e6881b02e8b','Soup',3.7),('42416a8f-0638-40ad-9881-0e6881b02e8b','Spicy hot noodles',5),('d384e0f9-3dfd-4bf4-8a8c-b4ad257c8dca','Dumplings',5.5);
/*!40000 ALTER TABLE `train_food_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_type`
--

DROP TABLE IF EXISTS `train_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `train_type` (
  `id` varchar(36) NOT NULL,
  `average_speed` int(11) DEFAULT NULL,
  `confort_class` int(11) DEFAULT NULL,
  `economy_class` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_3ayk8fx1ak7c37s5udyh8n3s2` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_type`
--

LOCK TABLES `train_type` WRITE;
/*!40000 ALTER TABLE `train_type` DISABLE KEYS */;
INSERT INTO `train_type` VALUES ('d0a42d72-cf02-4f5d-8489-827cd793af28',250,2147483647,2147483647,'GaoTieOne'),('fd4cf0ba-d93d-4940-b5a2-48cacda7ef0e',200,2147483647,2147483647,'GaoTieTwo'),('429840db-b073-414f-81eb-378d2630cf3e',180,2147483647,2147483647,'DongCheOne'),('bbbf27dc-da12-4ac5-a65c-1ffe214fb1e8',120,2147483647,2147483647,'ZhiDa'),('e76c1a46-3852-4477-afc6-1463fd91eee2',120,2147483647,2147483647,'TeKuai'),('b630516b-b747-4b8e-96e3-d122273af32f',90,2147483647,2147483647,'KuaiSu');
/*!40000 ALTER TABLE `train_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trip`
--

DROP TABLE IF EXISTS `trip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trip` (
  `id` varchar(36) NOT NULL,
  `end_time` varchar(255) DEFAULT NULL,
  `route_id` varchar(255) DEFAULT NULL,
  `start_station_name` varchar(255) DEFAULT NULL,
  `start_time` varchar(255) DEFAULT NULL,
  `stations_name` varchar(255) DEFAULT NULL,
  `terminal_station_name` varchar(255) DEFAULT NULL,
  `train_type_name` varchar(255) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip`
--

LOCK TABLES `trip` WRITE;
/*!40000 ALTER TABLE `trip` DISABLE KEYS */;
INSERT INTO `trip` VALUES ('db3be605-41a9-472a-a83f-d6171741c346','2013-05-04 15:51:52','92708982-77af-4318-be25-57ccb0ff69ad','shanghai','2013-05-04 09:00:00','suzhou','taiyuan','GaoTieOne','1234',0),('a16cf0bb-2875-4659-bdb2-bea9d1913771','2013-05-04 17:51:52','aefcef3f-3f42-46e8-afd7-6cb2a928bd3d','shanghai','2013-05-04 12:00:00','suzhou','taiyuan','GaoTieOne','1235',0),('f57c52c1-9d72-4d76-80f8-146d7cbda568','2013-05-04 20:51:52','a3f256c1-0e43-4f7d-9c21-121bf258101f','shanghai','2013-05-04 14:00:00','suzhou','taiyuan','GaoTieOne','1236',0),('a00b981d-f709-4cee-b68c-1c80c4ec3237','2013-05-04 17:21:52','084837bb-53c8-4438-87c8-0321a4d09917','shanghai','2013-05-04 08:00:00','suzhou','taiyuan','GaoTieTwo','1237',0),('43fa8e72-8a35-47a6-8266-0de77ea56c13','2013-05-04 19:59:52','f3d4d4ef-693b-4456-8eed-59c0d717dd08','shanghai','2013-05-04 07:00:00','suzhou','taiyuan','DongCheOne','1345',1),('7feeff24-9e6e-455e-b7c0-577a2e373f87',NULL,'fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','fengtai','2022-11-22 19:32:57',NULL,'chengdudong','GaoTieOne','9001',0),('6e39f4e3-c4d8-4828-883b-168c74badb1e',NULL,'fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','fengtai','2022-11-22 19:32:57',NULL,'chengdudong','GaoTieTwo','9002',0),('b279ff0b-aef2-4a97-aeb2-725d0ed115f7',NULL,'fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','fengtai','2022-11-22 19:32:57',NULL,'chengdudong','DongCheOne','8003',1);
/*!40000 ALTER TABLE `trip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trip2`
--

DROP TABLE IF EXISTS `trip2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trip2` (
  `id` varchar(36) NOT NULL,
  `end_time` varchar(255) DEFAULT NULL,
  `route_id` varchar(255) DEFAULT NULL,
  `start_station_name` varchar(255) DEFAULT NULL,
  `start_time` varchar(255) DEFAULT NULL,
  `stations_name` varchar(255) DEFAULT NULL,
  `terminal_station_name` varchar(255) DEFAULT NULL,
  `train_type_name` varchar(255) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip2`
--

LOCK TABLES `trip2` WRITE;
/*!40000 ALTER TABLE `trip2` DISABLE KEYS */;
INSERT INTO `trip2` VALUES ('99333ab7-09d7-48bd-9b49-8449f40cf4b6','2013-05-04 15:51:52','0b23bd3e-876a-4af3-b920-c50a90c90b04','shanghai','2013-05-04 09:51:52','nanjing','beijing','ZhiDa','1234',2),('97389464-a382-4256-af73-5f7a4267c306','2013-05-04 17:51:52','9fc9c261-3263-4bfa-82f8-bb44e06b2f52','shanghai','2013-05-04 11:31:52','nanjing','beijing','ZhiDa','1235',2),('069a368a-13ba-43b1-9488-5d8ea0705548','2013-05-04 12:51:52','d693a2c5-ef87-4a3c-bef8-600b43f62c68','shanghai','2013-05-04 7:05:52','nanjing','beijing','ZhiDa','1236',2),('6eae9ef1-baf4-40fb-95ae-a1c6b44fe32d','2013-05-04 17:21:52','20eb7122-3a11-423f-b10a-be0dc5bce7db','shanghai','2013-05-04 08:31:52','nanjing','beijing','TeKuai','1235',3),('b5e64333-ad15-4ce8-b249-af8e73972c4a','2013-05-04 19:59:52','1367db1f-461e-4ab7-87ad-2bcc05fd9cb7','shanghai','2013-05-04 07:51:52','nanjing','beijing','KuaiSu','1345',4),('82fce822-7cd0-4ad0-bb18-22bafb805d7c',NULL,'fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','fengtai','2022-11-22 19:32:57',NULL,'chengdudong','ZhiDa','8004',2),('bc6e48c8-1f58-4b9b-ab5a-bb31e4dfe7de',NULL,'fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','fengtai','2022-11-22 19:32:57',NULL,'chengdudong','TeKuai','8005',3),('2d056680-9b86-4eb8-92e4-4de13b55ddf0',NULL,'fd97cbc4-72fd-4f36-b2cf-f3028a5ba381','fengtai','2022-11-22 19:32:57',NULL,'chengdudong','KuaiSu','8006',4);
/*!40000 ALTER TABLE `trip2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` varchar(36) NOT NULL,
  `document_num` varchar(255) DEFAULT NULL,
  `document_type` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `gender` int(11) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','2135488099312X',1,'trainticket_notify@163.com',1,'111111','fdse_microservice'),('f80faabd-a593-461e-a70d-08761a4d0e31','5599488099312X',1,'ts@fd1.edu.cn',1,'111111','chair1');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_roles` (
  `user_id` varchar(36) NOT NULL,
  `roles` varchar(255) DEFAULT NULL,
  KEY `FKmdtdu7txekccv58vkr6emnl1m` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES ('4d2a46c7-71cb-4cf1-b5bb-b68406d9da6f','ROLE_USER'),('b4f140aa-e4d0-42fc-91e4-d4fd4d482057','ROLE_ADMIN'),('f80faabd-a593-461e-a70d-08761a4d0e31','ROLE_USER');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voucher`
--

DROP TABLE IF EXISTS `voucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voucher` (
  `voucher_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(1024) NOT NULL,
  `travelDate` varchar(1024) NOT NULL,
  `travelTime` varchar(1024) NOT NULL,
  `contactName` varchar(1024) NOT NULL,
  `trainNumber` varchar(1024) NOT NULL,
  `seatClass` int(11) NOT NULL,
  `seatNumber` varchar(1024) NOT NULL,
  `startStation` varchar(1024) NOT NULL,
  `destStation` varchar(1024) NOT NULL,
  `price` float NOT NULL,
  PRIMARY KEY (`voucher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voucher`
--

LOCK TABLES `voucher` WRITE;
/*!40000 ALTER TABLE `voucher` DISABLE KEYS */;
/*!40000 ALTER TABLE `voucher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wait_list_order`
--

DROP TABLE IF EXISTS `wait_list_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wait_list_order` (
  `id` varchar(36) NOT NULL,
  `account_id` varchar(36) DEFAULT NULL,
  `contacts_document_number` varchar(255) DEFAULT NULL,
  `contacts_document_type` int(11) NOT NULL,
  `contacts_id` varchar(255) DEFAULT NULL,
  `contacts_name` varchar(255) DEFAULT NULL,
  `created_time` varchar(255) DEFAULT NULL,
  `from_station` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `seat_type` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `to_station` varchar(255) DEFAULT NULL,
  `train_number` varchar(255) DEFAULT NULL,
  `travel_time` varchar(255) DEFAULT NULL,
  `wait_util_time` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wait_list_order`
--

LOCK TABLES `wait_list_order` WRITE;
/*!40000 ALTER TABLE `wait_list_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `wait_list_order` ENABLE KEYS */;
UNLOCK TABLES;
/*!50112 SET @disable_bulk_load = IF (@is_rocksdb_supported, 'SET SESSION rocksdb_bulk_load = @old_rocksdb_bulk_load', 'SET @dummy_rocksdb_bulk_load = 0') */;
/*!50112 PREPARE s FROM @disable_bulk_load */;
/*!50112 EXECUTE s */;
/*!50112 DEALLOCATE PREPARE s */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-22 19:36:56
