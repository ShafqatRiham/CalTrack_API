-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: caltrack_project_db
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `activity_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `log_date` date NOT NULL,
  `steps` int DEFAULT '0',
  `calories_burned` decimal(8,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`activity_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
INSERT INTO `activity_logs` VALUES (1,1,'2026-07-08',2000,80.00,'2026-07-07 18:44:27'),(2,2,'2026-07-09',1000,40.00,'2026-07-09 10:29:49'),(3,1,'2026-07-09',2000,80.00,'2026-07-09 17:30:34'),(4,1,'2026-07-10',1000,40.00,'2026-07-09 18:08:39'),(5,1,'2026-07-05',500,20.00,'2026-07-09 18:11:05');
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_goals`
--

DROP TABLE IF EXISTS `daily_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_goals` (
  `goal_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `goal_date` date NOT NULL,
  `calorie_goal` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`goal_id`),
  UNIQUE KEY `unique_user_date` (`user_id`,`goal_date`),
  CONSTRAINT `daily_goals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_goals`
--

LOCK TABLES `daily_goals` WRITE;
/*!40000 ALTER TABLE `daily_goals` DISABLE KEYS */;
INSERT INTO `daily_goals` VALUES (1,1,'2026-07-10',2000,'2026-07-09 18:22:24'),(2,1,'2026-07-09',1700,'2026-07-09 18:23:03');
/*!40000 ALTER TABLE `daily_goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foods`
--

DROP TABLE IF EXISTS `foods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foods` (
  `food_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `calories` decimal(8,2) NOT NULL,
  `protein` decimal(8,2) DEFAULT '0.00',
  `carbs` decimal(8,2) DEFAULT '0.00',
  `fat` decimal(8,2) DEFAULT '0.00',
  `fiber` decimal(8,2) DEFAULT '0.00',
  `sugar` decimal(8,2) DEFAULT '0.00',
  `sodium` decimal(8,2) DEFAULT '0.00',
  `serving_size` varchar(50) DEFAULT '100g',
  `source` enum('api','custom') NOT NULL DEFAULT 'custom',
  `external_api_id` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`food_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `foods_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foods`
--

LOCK TABLES `foods` WRITE;
/*!40000 ALTER TABLE `foods` DISABLE KEYS */;
INSERT INTO `foods` VALUES (1,NULL,'5 Fairtrade Bananas',85.00,1.10,19.30,0.50,1.40,18.10,0.00,'100g','api','01768558','2026-07-01 05:06:55'),(2,NULL,'pain Burger complet',269.09,9.40,44.00,5.00,0.00,0.00,0.00,'100g','api','3029330801924','2026-07-05 17:45:13'),(3,NULL,'Compote de pomme allégée',63.00,0.30,14.00,0.20,0.00,0.00,0.00,'100g','api','3045320517101','2026-07-09 08:42:41'),(4,NULL,'Apple & raisin oat bars',426.00,5.60,59.00,17.00,0.00,0.00,0.00,'100g','api','5060482840179','2026-07-09 08:43:23'),(5,NULL,'Organic Hard Boiled Eggs',136.00,13.60,0.00,9.09,0.00,0.00,0.00,'100g','api','0851387007072','2026-07-09 09:01:24'),(6,NULL,'Bananes',88.98,0.00,22.88,0.00,0.00,0.00,0.00,'100g','api','3192340348960','2026-07-09 09:23:18'),(7,NULL,'Banana chips',528.00,2.00,56.00,32.00,0.00,0.00,0.00,'100g','api','8718403887518','2026-07-09 09:24:31'),(8,NULL,'Vanilla Ice Cream',251.00,4.30,20.00,17.00,0.00,0.00,0.00,'100g','api','3415581101928','2026-07-09 10:16:54'),(9,NULL,'Kinder Chocolate Ice Cream',370.00,6.10,32.00,24.20,0.00,0.00,0.00,'100g','api','8000500406427','2026-07-09 10:19:03'),(10,NULL,'Prince Goût Chocolat au blé complet',467.00,6.30,69.00,17.00,0.00,0.00,0.00,'100g','api','7622210449283','2026-07-09 10:19:42'),(11,NULL,'Coke Zero',1.00,0.00,0.00,0.00,0.00,0.00,0.00,'100g','api','5449000214799','2026-07-09 10:29:19'),(12,NULL,'Rôti de Poulet - 100% filet',109.33,22.00,0.50,2.20,0.00,0.00,0.00,'100g','api','3302740039362','2026-07-09 17:26:33'),(13,NULL,'Sour Cream & Onion',525.00,6.00,56.00,30.00,0.00,0.00,0.00,'100g','api','5053990155354','2026-07-09 17:27:22'),(14,NULL,'KING COOKIES',483.00,5.20,61.50,24.00,0.00,0.00,0.00,'100g','api','6111259343108','2026-07-09 18:09:37');
/*!40000 ALTER TABLE `foods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meal_log_items`
--

DROP TABLE IF EXISTS `meal_log_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meal_log_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `log_id` int NOT NULL,
  `food_id` int NOT NULL,
  `quantity` decimal(8,2) NOT NULL DEFAULT '1.00',
  `unit` varchar(20) DEFAULT '100g',
  `calories` decimal(8,2) NOT NULL,
  `protein` decimal(8,2) DEFAULT '0.00',
  `carbs` decimal(8,2) DEFAULT '0.00',
  `fat` decimal(8,2) DEFAULT '0.00',
  PRIMARY KEY (`item_id`),
  KEY `log_id` (`log_id`),
  KEY `food_id` (`food_id`),
  CONSTRAINT `meal_log_items_ibfk_1` FOREIGN KEY (`log_id`) REFERENCES `meal_logs` (`log_id`),
  CONSTRAINT `meal_log_items_ibfk_2` FOREIGN KEY (`food_id`) REFERENCES `foods` (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal_log_items`
--

LOCK TABLES `meal_log_items` WRITE;
/*!40000 ALTER TABLE `meal_log_items` DISABLE KEYS */;
INSERT INTO `meal_log_items` VALUES (1,1,1,1.00,'100g',85.00,1.10,19.30,0.50),(2,2,2,1.00,'100g',269.09,9.40,44.00,5.00),(3,3,3,1.00,'100g',63.00,0.30,14.00,0.20),(4,4,3,1.00,'100g',63.00,0.30,14.00,0.20),(5,5,4,1.00,'100g',426.00,5.60,59.00,17.00),(6,6,4,1.00,'100g',426.00,5.60,59.00,17.00),(7,7,5,1.00,'100g',136.00,13.60,0.00,9.09),(8,8,6,1.00,'100g',88.98,0.00,22.88,0.00),(9,9,7,1.00,'100g',528.00,2.00,56.00,32.00),(10,10,8,1.00,'100g',251.00,4.30,20.00,17.00),(11,11,9,1.00,'100g',370.00,6.10,32.00,24.20),(12,12,10,1.00,'100g',467.00,6.30,69.00,17.00),(13,13,11,1.00,'100g',1.00,0.00,0.00,0.00),(14,14,12,1.00,'100g',109.33,22.00,0.50,2.20),(15,15,13,1.00,'100g',525.00,6.00,56.00,30.00),(16,16,14,1.00,'100g',483.00,5.20,61.50,24.00);
/*!40000 ALTER TABLE `meal_log_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meal_logs`
--

DROP TABLE IF EXISTS `meal_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meal_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `meal_type` enum('breakfast','lunch','dinner','snack') NOT NULL,
  `log_date` date NOT NULL,
  `log_time` time DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `meal_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal_logs`
--

LOCK TABLES `meal_logs` WRITE;
/*!40000 ALTER TABLE `meal_logs` DISABLE KEYS */;
INSERT INTO `meal_logs` VALUES (1,1,'breakfast','2026-07-01','08:30:00','2026-07-05 17:25:49'),(2,1,'breakfast','2026-07-06','02:45:11','2026-07-05 17:45:13'),(3,1,'snack','2026-07-09','17:42:00','2026-07-09 08:42:42'),(4,1,'dinner','2026-07-09','17:43:00','2026-07-09 08:43:18'),(5,1,'dinner','2026-07-09','17:43:00','2026-07-09 08:43:23'),(6,1,'dinner','2026-07-09','17:55:00','2026-07-09 08:55:06'),(7,1,'snack','2026-07-09','18:01:00','2026-07-09 09:01:25'),(8,1,'snack','2026-07-09','18:23:00','2026-07-09 09:23:19'),(9,1,'snack','2026-07-08','18:24:00','2026-07-09 09:24:31'),(10,1,'snack','2026-07-09','19:16:00','2026-07-09 10:16:55'),(11,1,'snack','2026-07-09','19:19:00','2026-07-09 10:19:04'),(12,1,'snack','2026-07-10','19:19:00','2026-07-09 10:19:42'),(13,2,'snack','2026-07-09','19:29:00','2026-07-09 10:29:19'),(14,4,'breakfast','2026-07-10','02:26:00','2026-07-09 17:26:33'),(15,5,'breakfast','2026-07-10','02:27:00','2026-07-09 17:27:23'),(16,1,'breakfast','2026-07-05','03:09:00','2026-07-09 18:09:37');
/*!40000 ALTER TABLE `meal_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `weight` decimal(5,2) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight_unit` enum('kg','lbs') DEFAULT 'kg',
  `height_unit` enum('cm','ft') DEFAULT 'cm',
  `gender` enum('male','female','other','prefer_not_to_say') DEFAULT NULL,
  `streak` int DEFAULT '0',
  `last_log_date` date DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'testuser','test@email.com','$2b$10$2FKnyu9wspwJ/kC0V5lzM.1HQwrnJC6iAj6iULsJiAWsWRTrAqiFK','2026-06-28 16:47:41',NULL,NULL,'kg','cm',NULL,1,'2026-07-05'),(2,'test','test@gmail.com','$2b$10$40dnc.DMSheraoyHcWEbzOcGGTopa9aOuNs6ugdb.ibPlXEnCizWK','2026-07-06 05:36:18',NULL,NULL,'kg','cm',NULL,1,'2026-07-09'),(4,'test1','test1@gmail.com','$2b$10$V8Ik.T4AiQft0I1UaOKQsuYlwVEcDjK3Rq8qY4qOad9Y/R2FEISki','2026-07-09 17:22:05',NULL,156.00,'kg','cm','male',1,'2026-07-10'),(5,'test2','test2@gmail.com','$2b$10$nMvy9.FnGvpzPf9Ep8qXduEBK4aaxpcLcJ1MA4AZIFIWMVBIUvRXa','2026-07-09 17:22:42',NULL,NULL,'kg','cm','female',1,'2026-07-10'),(6,'test3','teset3@gmail.com','$2b$10$LPjdSD8LGz/Q1U1Nkg9LS.l3WqRY53bPkt6T68QeAPxQMPjc0lKrS','2026-07-09 17:23:18',NULL,NULL,'kg','cm','other',0,NULL),(7,'test4','test4@gmail.com','$2b$10$7n/MQTu3jgRfJmFzfOm34emTBwRriXNoKgwIFwUcuG6/9KNiXIDLq','2026-07-09 17:23:47',NULL,NULL,'kg','cm','prefer_not_to_say',0,NULL),(8,'test5','test5@gmail.com','$2b$10$RjECZk263qfNvIMC84kike8S0Ka7gdHZvOQQIrVj5cTwVa3dcqAze','2026-07-09 17:24:12',NULL,NULL,'kg','cm','prefer_not_to_say',0,NULL),(9,'test6','test6@gmail.com','$2b$10$ZWi1tTyuwLmn3a42y1hj..HTs.CUWj2UY2wscSdCl5yLuFOuRxGTK','2026-07-09 17:24:48',NULL,NULL,'kg','cm','prefer_not_to_say',0,NULL),(10,'test7','test7@gmail.com','$2b$10$p.d06Dx673ygi2YfMrHyDOBJVINs//12SzoELkY0H2B7y61vDNqgq','2026-07-09 17:25:18',NULL,NULL,'kg','cm','prefer_not_to_say',0,NULL),(11,'test8','test8@gmail.com','$2b$10$sFMwJw23jh/SHTEECGGcDe68vyQ7LYqDImYRk.JAHkqjE9KVHpNne','2026-07-09 17:25:43',NULL,NULL,'kg','cm','prefer_not_to_say',0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-10  5:04:18
