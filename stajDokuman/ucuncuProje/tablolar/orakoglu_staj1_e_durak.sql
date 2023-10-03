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
-- Table structure for table `e_durak`
--

DROP TABLE IF EXISTS `e_durak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `e_durak` (
  `durak_id` int NOT NULL AUTO_INCREMENT,
  `durak_no` int NOT NULL,
  PRIMARY KEY (`durak_id`),
  UNIQUE KEY `durak_no` (`durak_no`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `e_durak`
--

LOCK TABLES `e_durak` WRITE;
/*!40000 ALTER TABLE `e_durak` DISABLE KEYS */;
INSERT INTO `e_durak` VALUES (1,1),(2,2),(3,3),(52,4),(53,5),(55,6),(57,7),(59,8),(65,9),(13,10),(66,11),(69,12),(72,13),(75,14),(14,15),(17,16),(19,17),(21,18),(22,19),(24,20),(25,21),(27,22),(28,23),(30,24),(31,25),(33,26),(35,27),(42,28),(44,29),(76,31),(78,32),(77,41),(46,50),(48,51),(49,52),(51,53),(81,81),(36,100),(60,101),(6,150),(8,152),(4,159),(39,252);
/*!40000 ALTER TABLE `e_durak` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 14:28:09
