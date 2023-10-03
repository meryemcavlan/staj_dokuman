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
-- Table structure for table `token_yetki`
--

DROP TABLE IF EXISTS `token_yetki`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_yetki` (
  `token_yetki_id` int NOT NULL AUTO_INCREMENT,
  `kullanici_ad` varchar(255) NOT NULL,
  `yetki_id` int NOT NULL,
  PRIMARY KEY (`token_yetki_id`),
  KEY `kullanici_ad` (`kullanici_ad`),
  KEY `yetki_id` (`yetki_id`),
  CONSTRAINT `token_yetki_ibfk_1` FOREIGN KEY (`kullanici_ad`) REFERENCES `tokenlar` (`kullaniciAd`),
  CONSTRAINT `token_yetki_ibfk_2` FOREIGN KEY (`yetki_id`) REFERENCES `yetkiler` (`yetki_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_yetki`
--

LOCK TABLES `token_yetki` WRITE;
/*!40000 ALTER TABLE `token_yetki` DISABLE KEYS */;
INSERT INTO `token_yetki` VALUES (1,'MERYEM',1),(2,'MERYEM',2),(3,'MERYEM',3),(4,'MERYEM',4),(5,'MERYEM',5),(6,'MERYEM',6),(7,'MERYEM',7),(8,'MERYEM',8),(9,'MERYEM',9),(10,'BARIŞ',1),(11,'BARIŞ',2),(12,'BARIŞ',4),(13,'BARIŞ',5),(14,'BARIŞ',7),(15,'BARIŞ',8),(16,'MELİKE',1),(17,'MELİKE',3),(18,'MELİKE',4),(19,'MELİKE',6),(20,'MELİKE',7),(21,'MELİKE',9),(22,'UTKU',2),(23,'UTKU',3),(24,'UTKU',5),(25,'UTKU',6),(26,'UTKU',8),(27,'UTKU',9);
/*!40000 ALTER TABLE `token_yetki` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 14:28:16
