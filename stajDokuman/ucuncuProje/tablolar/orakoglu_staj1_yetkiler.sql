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
-- Table structure for table `yetkiler`
--

DROP TABLE IF EXISTS `yetkiler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yetkiler` (
  `yetki_id` int NOT NULL AUTO_INCREMENT,
  `yetki_ad` varchar(255) NOT NULL,
  PRIMARY KEY (`yetki_id`),
  UNIQUE KEY `yetki_ad_UNIQUE` (`yetki_ad`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yetkiler`
--

LOCK TABLES `yetkiler` WRITE;
/*!40000 ALTER TABLE `yetkiler` DISABLE KEYS */;
INSERT INTO `yetkiler` VALUES (1,'e_durak_ekle'),(2,'e_durak_guncelle'),(3,'e_durak_sil'),(4,'e_guzergah_ekle'),(5,'e_guzergah_guncelle'),(6,'e_guzergah_sil'),(7,'e_sefer_ekle'),(8,'e_sefer_guncelle'),(9,'e_sefer_sil');
/*!40000 ALTER TABLE `yetkiler` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 14:28:07
