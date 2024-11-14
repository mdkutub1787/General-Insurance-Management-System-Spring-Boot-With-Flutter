-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: spring_boot_with_flutter
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fire_rate_%` double NOT NULL,
  `gross_premium` double NOT NULL,
  `net_premium` double NOT NULL,
  `rsd_rate_%` double NOT NULL,
  `tax_rate_%` double NOT NULL,
  `policy_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK12cs3o8e3uekh5o6ssnr0ka8m` (`policy_id`),
  CONSTRAINT `FK12cs3o8e3uekh5o6ssnr0ka8m` FOREIGN KEY (`policy_id`) REFERENCES `policies` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills`
--

LOCK TABLES `bills` WRITE;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
INSERT INTO `bills` VALUES (54,10,6900,6000,10,15,14),(55,10,2530,2200,1,15,19);
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marine_insurance_details`
--

DROP TABLE IF EXISTS `marine_insurance_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marine_insurance_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) NOT NULL,
  `bank_name` varchar(255) NOT NULL,
  `coverage` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `policyholder` varchar(255) NOT NULL,
  `stock_item` varchar(255) NOT NULL,
  `sum_insured` double NOT NULL,
  `sum_insured_usd` double NOT NULL,
  `usd_rate` double NOT NULL,
  `via` varchar(255) NOT NULL,
  `voyage_from` varchar(255) NOT NULL,
  `voyage_to` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marine_insurance_details`
--

LOCK TABLES `marine_insurance_details` WRITE;
/*!40000 ALTER TABLE `marine_insurance_details` DISABLE KEYS */;
INSERT INTO `marine_insurance_details` VALUES (31,'Jigatola Roard , DhanmondiDhaka 1203','Dhaka Bank PLC,Rajarbagh ,Dhaka','Lorry Risk Only','2024-11-05','M/s Rofik  Enterprise  , Prop: Md. Rofik Chowdhury  ','Cosmetics and Library',35835,300,119.45,'Benapole Port','India','Dhaka'),(32,'lalbagh Roard , Lalabagh Dhaka 1203','Islami Bank Bangladesh PLC, Dhanmondi Branch, Dhaka','Lorry Risk Only','2024-11-08','Kacci Bhai , Prop: Md. Raju Chowdhury  ','Food',11945,100,119.45,'Benapole Port','India','Dhaka');
/*!40000 ALTER TABLE `marine_insurance_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marinebillmoneyreceipts`
--

DROP TABLE IF EXISTS `marinebillmoneyreceipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marinebillmoneyreceipts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `class_of_insurance` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `issued_against` varchar(255) DEFAULT NULL,
  `issuing_office` varchar(255) DEFAULT NULL,
  `mode_of_payment` varchar(255) DEFAULT NULL,
  `marinebill_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKit071wy2vmy9u8wrmsmuwx73k` (`marinebill_id`),
  CONSTRAINT `FKit071wy2vmy9u8wrmsmuwx73k` FOREIGN KEY (`marinebill_id`) REFERENCES `marineinsurancebills` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marinebillmoneyreceipts`
--

LOCK TABLES `marinebillmoneyreceipts` WRITE;
/*!40000 ALTER TABLE `marinebillmoneyreceipts` DISABLE KEYS */;
INSERT INTO `marinebillmoneyreceipts` VALUES (20,'Fire Insurance','2024-11-14','UH/4554','Dhaka','Bank Transfer',34),(21,'Fire Insurance','2024-11-14','VBBHHB/522','Pabna','Credit Card',35);
/*!40000 ALTER TABLE `marinebillmoneyreceipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marineinsurancebills`
--

DROP TABLE IF EXISTS `marineinsurancebills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marineinsurancebills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `gross_premium` double NOT NULL,
  `marine_rate_%` double NOT NULL,
  `net_premium` double NOT NULL,
  `stamp_duty` double NOT NULL,
  `tax_rate_%` double NOT NULL,
  `war_srcc_rate_%` double NOT NULL,
  `marine_details_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKi6j82j1sakgo7xnuujctsmi6p` (`marine_details_id`),
  CONSTRAINT `FKi6j82j1sakgo7xnuujctsmi6p` FOREIGN KEY (`marine_details_id`) REFERENCES `marine_insurance_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marineinsurancebills`
--

LOCK TABLES `marineinsurancebills` WRITE;
/*!40000 ALTER TABLE `marineinsurancebills` DISABLE KEYS */;
INSERT INTO `marineinsurancebills` VALUES (34,9242.05,10,7167,1000,15,10,31),(35,5121.02,10,3583.5,1000,15,20,32);
/*!40000 ALTER TABLE `marineinsurancebills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moneyreceipts`
--

DROP TABLE IF EXISTS `moneyreceipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moneyreceipts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_of_insurance` varchar(255) DEFAULT NULL,
  `date` date NOT NULL,
  `issued_against` varchar(255) DEFAULT NULL,
  `issuing_office` varchar(255) DEFAULT NULL,
  `mode_of_payment` varchar(255) DEFAULT NULL,
  `bill_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1jcxl9ufxqcvqhvnx8q9ylh3v` (`bill_id`),
  CONSTRAINT `FK1jcxl9ufxqcvqhvnx8q9ylh3v` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moneyreceipts`
--

LOCK TABLES `moneyreceipts` WRITE;
/*!40000 ALTER TABLE `moneyreceipts` DISABLE KEYS */;
INSERT INTO `moneyreceipts` VALUES (12,'Fire Insurance','2024-11-13','gjghjghjg','Kujhkdfgdfh','Cheque',54),(13,'Marine Insurance','2024-11-14','HH/4545','Dhaka','Credit Card',55);
/*!40000 ALTER TABLE `moneyreceipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policies`
--

DROP TABLE IF EXISTS `policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(255) NOT NULL,
  `bank_name` varchar(255) NOT NULL,
  `construction` varchar(255) NOT NULL,
  `coverage` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `interest_insured` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `period_from` date NOT NULL,
  `period_to` date NOT NULL,
  `policyholder` varchar(255) NOT NULL,
  `stock_insured` varchar(255) NOT NULL,
  `sum_insured` double NOT NULL,
  `used_as` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policies`
--

LOCK TABLES `policies` WRITE;
/*!40000 ALTER TABLE `policies` DISABLE KEYS */;
INSERT INTO `policies` VALUES (14,'Dhanmondi Roard , DhanmondiDhaka 1203','Islami Bank Bangladesh PLC, Dhaka','1st Class','Fire &/or Lightning only','2024-11-06','Food And Resturents','Dhanmondi Roard , DhanmondiDhaka 1203','The Insured','2024-11-06','2024-11-06','Towhid Bhai , Prop: Md. Towhid Chowdhury  ','food Resturents',30000,'Shop Only'),(19,'Dhanmondi Roard , DhanmondiDhaka 1203','Islami Bank Bangladesh PLC, Baliakandi Sub-Branch, Rajbari','2nd Class','Fire &/or Lightning only','2024-11-06','Food And Resturent','Dhanmondi Roard , DhanmondiDhaka 1203','The Insured','2024-11-30','2024-11-30','Kacci Bhabi , Prop: Md. Rezvi  Chowdhury  ','food Resturent',20000,'Shop-Cum-Godown only');
/*!40000 ALTER TABLE `policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_logged_out` bit(1) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKj8rfw4x0wjjyibfqq566j4qng` (`user_id`),
  CONSTRAINT `FKj8rfw4x0wjjyibfqq566j4qng` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES (1,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk2NzI4LCJleHAiOjE3MzA0ODMxMjh9.6932LTKDoExUyDXxVRGYYFLK2hKG_yPkD2SL77ODst7gQl6dsp2WzCBh2UYBaRit',1),(2,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk2ODQxLCJleHAiOjE3MzA0ODMyNDF9.eOi0fDOr-Of6W1p7rRpLsaHWkd5vCWI0LkOo5Ojq-BjEArXiA1hAcVMFd_8Pou_y',1),(3,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDM5Njk1NCwiZXhwIjoxNzMwNDgzMzU0fQ.Zt4k2ys4WoRz5tiivbNI74EJuPVjTZJhAakTt7x4r8NxFXMiFFZTMfaDTmzdEFN2',1),(4,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDM5NzEyNCwiZXhwIjoxNzMwNDgzNTI0fQ.sUWSt4aJbdz8tjORF7M9JJbEq3WJtDKvrGTARM1U1dOtw2qqVGg98uyieFaTQCoS',1),(5,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk3MjA2LCJleHAiOjE3MzA0ODM2MDZ9.hZU-e5q4CiJWbF2FTLXK6tKTNCKFFFCc6r0gInv_rHKggJTtIi31j-MYSqsf16n8',2),(6,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk3MjUxLCJleHAiOjE3MzA0ODM2NTF9.BXZjP2ydATk3cuYmxj5BnorTrYC_DB4HSPRK53NvTvDGyZywN4EWTroDa2yYFxUT',2),(7,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDM5NzQyOCwiZXhwIjoxNzMwNDgzODI4fQ.2ILqksuFB8UWwRkOi28ag9vCO_sVSOMwzqAaMaVs77fjwbLi0UfQU9BWQa6rmW5Q',1),(8,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk3NDUyLCJleHAiOjE3MzA0ODM4NTJ9.y_EwJ98SvDnTr2TiHX1yThgwuX0p_7B5bYL6Tej7Rq2Uypp2e2zlAdTzI7opV7Sb',2),(9,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDM5Nzc1MCwiZXhwIjoxNzMwNDg0MTUwfQ.eooDHQfRzOuBciyP47wVRFCuPLOu_ZUU5HYTyz6gI9gT6iIsTu2sRQVswle4iEV7',1),(10,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDM5Nzk0NywiZXhwIjoxNzMwNDg0MzQ3fQ.OA6D5HwwltXo-BGwBzD7oQmJPaaqaLuaf1cIYZBb-wScA5AyZiWUmk61RPvcTsll',1),(11,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk3OTc5LCJleHAiOjE3MzA0ODQzNzl9.I798zSWW2yr6NrvYZAuVw_0oyL_MLT0aOXn165Uv2hG9gIzx3i2YZ9OUTiCa9c7h',2),(12,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk4MDI0LCJleHAiOjE3MzA0ODQ0MjR9.FS09lFWx6opXgsE9VH-hO51bglXdrOdnlL3uRP3CYzh-ZKe0v2zEOMRbNUwL1Ccm',2),(13,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDM5ODA0NSwiZXhwIjoxNzMwNDg0NDQ1fQ.3-1uiXFkgCza_RhyLLcIFyeYJmhizeZnmfxi64g7QYOPG7dWKcqsZt1Nr5NbNLAp',1),(14,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDM5ODExOSwiZXhwIjoxNzMwNDg0NTE5fQ.W9Z15CRFRGrs6wiCQL_RmvJLf_Dy-kgARgD4YOxLm7Vqc-XwzDu9uRLldTGtSuVq',1),(15,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk4MTM4LCJleHAiOjE3MzA0ODQ1Mzh9.qld-0_lBz-OYK-yDsTd2S2vOYA3Y8Yy-rqKbUElrXctMtzTxNggu_2ali-uaQ9jI',2),(16,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk4MTU4LCJleHAiOjE3MzA0ODQ1NTh9.RSFnHm3HwBspMfIIk-mbxjMYkLD7mPCDFTzgYq-tDROx8RWuRRKgCaSM7cccF6CQ',2),(17,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk4MjI4LCJleHAiOjE3MzA0ODQ2Mjh9.ZkjLHswyxSH8a5JZymUEWOaO33A60qOxXdHM3Wcod6IqVyjFxPIblsYcntu_JmG9',2),(18,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwMzk4NDIyLCJleHAiOjE3MzA0ODQ4MjJ9.maM_KocYK9PhPsAjqlB-rx4rH7SyjZrDItCQ_b59esCq2NzSL8_dO4QiJd9laIeX',2),(19,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDQwMDI0MiwiZXhwIjoxNzMwNDg2NjQyfQ.YiQ4DVXHKzxKczL53At-uHZBDFYBDNtluW6czOta4-3uNMrNi1N_NNowhLSUBFMw',1),(20,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwNDAwNTgxLCJleHAiOjE3MzA0ODY5ODF9.550hN2REPC_3dC2MfOc1iuH8lsyLlhDHkCqDKrWFzWlR2OXgmLFEULWeTYAlfY5X',2),(21,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDQwMDc5NywiZXhwIjoxNzMwNDg3MTk3fQ.DRmQJKoTEfOCuVHr9-ZqcdKLKj3TYhnI22gCnxCCPXJE4ypQ6HX_N1k2VISZWEgK',1),(22,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwNDAwOTEzLCJleHAiOjE3MzA0ODczMTN9.O8OvjebuJ0KX0SugNssNc1-dc0PqIS2PN1DF0VjdUMeZDNzJ1NaP1VZeEE1MUs2M',2),(23,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwNDAwOTIyLCJleHAiOjE3MzA0ODczMjJ9.Op39Fh49Yoahb8ISpe8CUmOmgzq3o-PdnU-s3itVF4kx4ZGczpi7sAibEL_Rkbe0',2),(24,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDQwMTAwNCwiZXhwIjoxNzMwNDg3NDA0fQ.9K5hAMPuUg2MqUqoG4Lpn9vnqUOYBeilgwnWXJOMkO-KfVA5wlOCDPCuS1D6bViV',1),(25,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwOTA3NDcwLCJleHAiOjE3MzA5OTM4NzB9.XrK1JK32NBAegwo50LyqbGhJiTEF5xeIt1nxnjdAohlrgBmwoWual_YbOL3cB4dz',2),(26,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDkwNzYxNywiZXhwIjoxNzMwOTk0MDE3fQ.rGEce4bNho_ZBYdFrexD-ccQYvbraCb-BiINbzoeeZJYzroZOGG0SLe-X1i7XFkw',1),(27,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMwOTYwNjMzLCJleHAiOjE3MzEwNDcwMzN9.TF_XjJ_imbXi0I0lhKfaFV2Z4TXhZvEso7-ukY8QO_cFjmW9Km-vFl0ZXwPnKbnK',2),(28,_binary '','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMDk2MTUyMiwiZXhwIjoxNzMxMDQ3OTIyfQ.pVdNhxRLuLWjkYXRUd8YcHDJltB9R77V58cItajKAt7DAAbfHxk_3aAXMpzh4Nz8',1),(29,_binary '\0','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHViMTUwQGdtYWlsLmNvbSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzMxNTI0MTQxLCJleHAiOjE3MzE2MTA1NDF9.9zi6sKZfJz0ozY5QvrB2ML1zaw7iqG5j-_qkRN63LwSwhiBaRi3aCXWyaGGKxABw',2),(30,_binary '\0','eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJtZGt1dHVidWRkaW4xNzg3QGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTczMTUyNDE4OSwiZXhwIjoxNzMxNjEwNTg5fQ.GVNWsGoycPE1Qa6D1F7haluA9HC7eYsC-Qve9JI15i6vwEvaTj47Pw1VHpoPndXB',1);
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cell` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','PHARMACIST','USER') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  UNIQUE KEY `UK3wfgv34acy32imea493ekogs5` (`cell`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,_binary '','Dhaka','01763001787','2024-10-31','mdkutubuddin1787@gmail.com','Male','Kutub Uddin','$2a$10$9Ro07A4z681ji.JLGykCAeL/TYICxlFVQXsthlFvMKiz5xKcs.1fO','ADMIN'),(2,_binary '','Dhaka','01516573970','2024-10-31','mdkutub150@gmail.com','Male','Md Kutub Uddin','$2a$10$FXgXU1hAjzevHQb5uc6ROe0refjl5scE1qZANJmbMZA2YwN2EQLk.','USER');
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

-- Dump completed on 2024-11-14  9:44:32
