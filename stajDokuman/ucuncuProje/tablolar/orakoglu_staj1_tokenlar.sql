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
-- Table structure for table `tokenlar`
--

DROP TABLE IF EXISTS `tokenlar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokenlar` (
  `token_id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `son_kullanma_tarihi` datetime DEFAULT NULL,
  `kullaniciAd` varchar(255) NOT NULL,
  `sifre` varchar(255) NOT NULL,
  PRIMARY KEY (`token_id`),
  UNIQUE KEY `kullaniciAd_UNIQUE` (`kullaniciAd`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokenlar`
--

LOCK TABLES `tokenlar` WRITE;
/*!40000 ALTER TABLE `tokenlar` DISABLE KEYS */;
INSERT INTO `tokenlar` VALUES (1,'bd3af940e5287593d7333202c57424bde1f2fb0bbc611e98b10d4c6a38114f7b51925924','2023-09-23 18:40:38','MERYEM','1234'),(2,'76141d954faccba92425a7f42e16e1e40334c5142017ea1f5daa74ec6b02574a32f749fa','2023-09-24 14:20:49','BARIŞ','1234'),(3,'c68f8bd3c74c5a2230792a6e006a7c27496824176e67c59cadb997f424a49a93a0fb7a37','2023-09-14 13:51:26','MELİKE','1234'),(4,'98b8e95d79d8846ddad33400fb108cddb34a662068b49f8f08f72ec403a83b5ea92af0e0','2023-09-13 14:37:23','UTKU','1234');
/*!40000 ALTER TABLE `tokenlar` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 14:28:11
