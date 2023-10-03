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
-- Table structure for table `kullanicilar`
--

DROP TABLE IF EXISTS `kullanicilar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kullanicilar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) DEFAULT NULL,
  `surname` varchar(45) DEFAULT NULL,
  `email` varchar(60) NOT NULL,
  `telno` varchar(11) DEFAULT NULL,
  `gender` varchar(5) DEFAULT NULL,
  `city` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kullanicilar`
--

LOCK TABLES `kullanicilar` WRITE;
/*!40000 ALTER TABLE `kullanicilar` DISABLE KEYS */;
INSERT INTO `kullanicilar` VALUES (1,'John','Doe','john@example.com','1234567890','Male','İstanbul'),(2,'Jane','Smith','jane@example.com','9876543210','Femal','Ankara'),(3,'David','Johnson','david@example.com','5551234567','Male','İzmir'),(4,'Mary','Williams','mary@example.com','9998887777','Femal','Antalya'),(5,'Michael','Brown','michael@example.com','1112223333','Male','Bursa'),(6,'Jennifer','Lee','jennifer@example.com','5555555555','Femal','Adana'),(7,'James','Taylor','james@example.com','8889990000','Male','Trabzon'),(8,'Lisa','Anderson','lisa@example.com','7777777777','Femal','Eskişehir'),(9,'Robert','Miller','robert@example.com','1231231234','Male','Konya'),(10,'William','Wilson','william@example.com','5556667777','Male','Mersin'),(11,'Patricia','Moore','patricia@example.com','3333333333','Femal','Gaziantep'),(12,'Charles','Clark','charles@example.com','1111111111','Male','Diyarbakır'),(13,'Richard','Young','richard@example.com','9998887777','Male','Isparta'),(14,'Betty','Walker','betty@example.com','5555555555','Femal','Malatya'),(15,'Joseph','Hall','joseph@example.com','7777777777','Male','Kahramanmaraş'),(16,'Dorothy','Green','dorothy@example.com','1112223333','Femal','Denizli'),(17,'Thomas','Harris','thomas@example.com','8889990000','Male','Erdemli'),(18,'Sandra','King','sandra@example.com','5551234567','Femal','Muğla'),(19,'Daniel','Baker','daniel@example.com','1234567890','Male','Bolu'),(20,'Nancy','Evans','nancy@example.com','5556667777','Femal','Trakya'),(21,'Paul','Gonzalez','paul@example.com','9999999999','Male','Erzurum'),(22,'Karen','Turner','karen@example.com','9876543210','Femal','Kastamonu'),(23,'Mark','White','mark@example.com','1231231234','Male','Giresun'),(24,'Linda','Jackson','linda@example.com','3333333333','Femal','Samsun'),(25,'Donald','Hill','donald@example.com','1111111111','Male','Sinop'),(26,'Cynthia','Adams','cynthia@example.com','7777777777','Femal','Ordu'),(27,'Kenneth','Scott','kenneth@example.com','7777777777','Male','Rize'),(28,'Ronald','Young','ronald@example.com','5551234567','Male','Isparta'),(29,'Brian','Walker','brian@example.com','1231231234','Male','Antalya'),(30,'Shirley','Allen','shirley@example.com','1111111111','Femal','Alanya'),(31,'Scott','Wright','scott@example.com','1234567890','Male','Antalya'),(32,'Laura','Baker','laura@example.com','9876543210','Femal','Izmir'),(33,'Kevin','Robinson','kevin@example.com','1231231234','Male','Ankara'),(38,'Baris','Balcikcoa','baris','54545','Erkek','Eskişehir'),(41,'sadasd','asdas','asdasdas','','Erkek','Adana'),(42,'asads','asdasd','asdasd','444','Erkek','Bitlis'),(44,'adsas','ddd','ddd','66','Erkek','Bingöl'),(50,'email','email','email@@email','55','Erkek','Gaziantep'),(54,'ELA','Yıldız','eepee@0909in098fo.com','5555555555','erkek','Eskişehir'),(55,'baris','balcikoca','barisbalcikoca@gmail.com','5442409231','Erkek','Afyonkarahisar'),(56,'denee','dene','dene','1','Erkek','Bilecik'),(57,'dene','dene','dene2','11','Erkek','Bilecik'),(59,'mel','kel','sananae','666','Erkek','Malatya'),(128,'baris','balcikcoa','barisbalcikoca@hotmail.com','55544422','Erkek','Bolu'),(131,'uuu','yyy','gg@gmail.com','4444','Erkek','Adana'),(134,'melikegozdas','gzds','m22@gmailcom','1234567890','femal','Eskişehir'),(137,'melike','gzds','m23@gmail.com','2345675','Kadın','Ankara'),(138,'ECEM','Yıldız','ainf886765557o123.com','5555555555','erkek','Mersin'),(140,'ECEM','Yıldız','MAİL.com','5555555555','erkek','Mersin'),(141,'ECEM','Yıldız','MAİL1.com','5555555555','erkek','Mersin'),(145,'ECEM','Yıldız','MAİL2.com','5555555555','erkek','Mersin'),(148,'ECEM','Yıldız','MAİL3.com','5555555555','erkek','Mersin'),(150,'melikegozdas','gzds','m25@gmailcom','1234567890','femal','Ankara'),(152,'ELA','Yıldız','e8989info.com','5555555555','erkek','Eskişehir'),(153,'ECEM','Yıldız','MAİL4.com','5555555555','erkek','Mersin'),(154,'ECEM','Yıldız','MAİL8.com','5555555555','erkek','Mersin'),(157,'ECEM','Yıldız','MAİL9.com','5555555555','erkek','Mersin'),(158,'ECEM','Yıldız','MAİL10.com','5555555555','erkek','Mersin'),(160,'ECEM','Yıldız','MAİL110.com','5555555555','erkek','Mersin'),(162,'ECEM','Yıldız','MAİL12.com','5555555555','erkek','Mersin'),(167,'','','','','Erkek','Eskişehir'),(168,'5','','utkuu18@gmail.com','05546472203','Erkek','Tepebaşı'),(169,'Utku','Kağan','uu@gmail.com','05546472203','Erkek','Adana'),(174,'Utku','Kağan ','Yavuzdoğan','05546472203','Erkek','Adana'),(176,'Ahmet','Mehmet','ahmeh@gmail.com','5546','null',''),(177,'Ahmet','Mehmet','ahmeht@gmail.com','505 820 963','Erkek','Mersin'),(178,'Selim ','Salim','sesa@gmail.con','5464646545','Erkek','Mersin'),(183,'Utku Kağan','Yavuzdoğan','utkuu1908@gmail.com','333333333','Erkek','Mersin'),(184,'MERYEM','ÇAVLAN','example@info.com','05554443333','kadın','Eskişehir'),(186,'Meryem','Cavlan','meryem_@example.com','5554442233','Erkek','Afyonkarahisar');
/*!40000 ALTER TABLE `kullanicilar` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 11:37:34
