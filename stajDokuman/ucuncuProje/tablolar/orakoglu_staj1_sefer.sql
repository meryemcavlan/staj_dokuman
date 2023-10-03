-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: orakoglu.net    Database: orakoglu_staj1
-- ------------------------------------------------------
-- Server version	8.0.31-cll-lve

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
-- Table structure for table `sefer`
--

DROP TABLE IF EXISTS `sefer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sefer` (
  `sefer_id` int NOT NULL AUTO_INCREMENT,
  `otobus_id` int DEFAULT NULL,
  `guzergah_id` int DEFAULT NULL,
  `kalkis_saati` varchar(20) NOT NULL,
  PRIMARY KEY (`sefer_id`),
  KEY `otobus_id` (`otobus_id`),
  KEY `guzergah_id` (`guzergah_id`),
  CONSTRAINT `sefer_ibfk_1` FOREIGN KEY (`otobus_id`) REFERENCES `otobus` (`otobus_id`),
  CONSTRAINT `sefer_ibfk_2` FOREIGN KEY (`guzergah_id`) REFERENCES `guzergah` (`guzergah_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sefer`
--

LOCK TABLES `sefer` WRITE;
/*!40000 ALTER TABLE `sefer` DISABLE KEYS */;
INSERT INTO `sefer` VALUES (2,2,3,'08:00'),(3,2,2,'09:00'),(4,10,3,'07:00'),(14,10,3,'02:10'),(15,10,3,'10:30'),(19,9,8,'09:00'),(20,9,8,'09:30'),(21,9,8,'10:00'),(22,28,8,'10:00');
/*!40000 ALTER TABLE `sefer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 14:28:08
