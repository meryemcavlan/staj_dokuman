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
-- Dumping routines for database 'orakoglu_staj1'
--
/*!50003 DROP PROCEDURE IF EXISTS `allShow` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `allShow`(
In ad varchar(50)
)
BEGIN
SELECT * FROM `orakoglu_staj1`.`users`;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deneme` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `deneme`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE v_username VARCHAR(50);
    DECLARE v_surname VARCHAR(50);
    DECLARE v_email VARCHAR(50);
    DECLARE v_telno VARCHAR(50);
    DECLARE v_gender VARCHAR(50);
    DECLARE v_city VARCHAR(50);

    -- JSON verisinden kullanıcı bilgilerini çıkar
    
    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET v_surname = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET v_email = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));
    SET v_telno = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."3"'));
    SET v_gender = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."4"'));
    SET v_city = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."5"'));

    -- Belirtilen e-posta adresine sahip kullanıcıyı güncelle
    UPDATE orakoglu_staj1.kullanicilar
    SET
        username = v_username,
        surname = v_surname,
        telno = v_telno,
        gender = v_gender,
        city = v_city
    WHERE email = v_email;

    -- Güncelleme başarılı ise
    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;

    SELECT result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deneme4` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `deneme4`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobus_no INT;
    DECLARE guzergah_listesi JSON;

    -- JSON verisinden otobus_no değerini çıkar ve INT olarak sakla
    SET otobus_no = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));

    -- Belirli otobus_no'ya sahip olan guzergah_id'leri listeleyin
    SELECT JSON_ARRAYAGG(guzergah_id) INTO guzergah_listesi
    FROM e_sefer
    WHERE otobus_no = otobus_no
    GROUP BY guzergah_id;

    IF guzergah_listesi IS NOT NULL THEN
        -- Başarılı durumda, hata yok ve guzergah_listesi JSON dizisini result'e atayın
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', guzergah_listesi));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, boş bir JSON nesnesi döndürün
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deneme5` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `deneme5`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE kalkis_saatleri JSON;

    -- JSON verisinden otobus_no değerini çıkar ve VARCHAR olarak sakla
    SET otobus_no_param = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));

    -- Verilen otobus_no'yu kullanarak otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_no_param;

    -- Otobus_id'ye göre ilgili seferlerin kalkış saatlerini JSON dizisi olarak çek
    SELECT JSON_ARRAYAGG(JSON_UNQUOTE(kalkis_saati)) INTO kalkis_saatleri
    FROM orakoglu_staj1.sefer 
    WHERE otobus_id = otobusID
    ORDER BY TIME_FORMAT(kalkis_saati, '%H:%i'); -- Kalkış saatlerini saat ve dakika cinsinden sırala

    IF kalkis_saatleri IS NOT NULL THEN
        -- Başarılı durumda, hata yok ve kalkis_saatleri JSON dizisini result'e atayın
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', kalkis_saatleri));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, boş bir JSON nesnesi döndürün
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;

    -- Sonucu döndürün
    SELECT result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_durak_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_durak_ekle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE durak_numarasi INT;
    DECLARE is_duplicate INT DEFAULT 0;

    SET durak_numarasi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

    -- Daha önce aynı durak_no ile kayıt var mı kontrol et
    IF NOT EXISTS (SELECT 1 FROM orakoglu_staj1.e_durak WHERE durak_no = durak_numarasi) THEN
        -- Yeni durak kaydını ekle
        INSERT INTO orakoglu_staj1.e_durak(durak_no)
        VALUES (durak_numarasi);

        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Ekleme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Ekleme işlemi başarısız', 'result', JSON_ARRAY()));
        END IF;
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Bu durak numarası var', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_durak_guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_durak_guncelle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE eski_durak_no INT;
    DECLARE yeni_durak_no INT;
    DECLARE durak_count INT;

    -- JSON verisinden eski ve yeni durak_no'ları çıkar
    SET eski_durak_no = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET yeni_durak_no = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));

    -- Yeni durak_no'nun, e_durak tablosunda başka kayıtlarda olup olmadığını kontrol et
    SELECT COUNT(*) INTO durak_count
    FROM e_durak
    WHERE durak_no = yeni_durak_no;

    IF durak_count = 0 THEN
        -- Eğer yeni durak_no başka kayıtlarda yoksa, güncelleme işlemini gerçekleştir
        UPDATE e_durak
        SET durak_no = yeni_durak_no
        WHERE durak_no = eski_durak_no;

        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Güncelleme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Güncelleme işlemi başarısız', 'result', JSON_ARRAY()));
        END IF;
    ELSE
        -- Eğer yeni durak_no başka kayıtlarda varsa, güncelleme işlemini yapma
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Yeni durak numarası mevcut', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_durak_sil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_durak_sil`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE durak_no_param INT;
    DECLARE durakID INT;
    DECLARE guzergah_durak_count INT;

    -- JSON verisinden durak_no değerini çıkar ve INT olarak sakla
    SET durak_no_param = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

    -- Verilen durak_no'ya ait kaydın durak_id'sini bul
    SELECT durak_id INTO durakID
    FROM e_durak
    WHERE durak_no = durak_no_param;

    IF durakID IS NOT NULL THEN
        -- Durak ID'si bulunduğunda, bu ID ile e_guzergah_durak tablosunda kayıt var mı kontrol et
        SELECT COUNT(*) INTO guzergah_durak_count
        FROM e_guzergah_durak
        WHERE durak_id = durakID;

        IF guzergah_durak_count > 0 THEN
            -- Durak kullanımda olduğunu belirt
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Durak kullanımda olduğu için silinemiyor', 'result', JSON_ARRAY()));
        ELSE
            -- Durak kullanılmıyorsa, silme işlemini gerçekleştir
            DELETE FROM e_durak
            WHERE durak_no = durak_no_param;

            IF ROW_COUNT() > 0 THEN
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Silme işlemi başarılı', 'result', JSON_ARRAY(durak_no_param)));
            ELSE
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Silme işlemi başarısız', 'result', JSON_ARRAY()));
            END IF;
        END IF;
    ELSE
        -- Belirtilen durak_no ile eşleşen bir kayıt bulunmazsa hata mesajı döndürün
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Belirtilen durak numarası bulunamadı', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergaha_gore_numara` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergaha_gore_numara`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_adi VARCHAR(255);
    DECLARE guzergahID INT;
    DECLARE otobus_no_list JSON;

    SET guzergah_adi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

    -- Guzergah_ad'a göre guzergah_id'yi bul
    SELECT guzergah_id
    INTO guzergahID
    FROM e_guzergah
    WHERE guzergah_ad = guzergah_adi;

    -- Otobüs numaralarını sırala ve JSON olarak al (yinelenenleri hariç tut)
    SET SESSION group_concat_max_len = 1000000; -- Gruplandırma sınırını artır
    SELECT
        CONCAT('[', GROUP_CONCAT(DISTINCT '"', otobus_no, '"' ORDER BY otobus_no SEPARATOR ','), ']') INTO otobus_no_list
    FROM e_sefer
    WHERE guzergah_id = guzergahID;

    -- JSON dizisinin uzunluğunu kontrol et
    IF JSON_LENGTH(otobus_no_list) > 0 THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', otobus_no_list));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte boş bir JSON nesnesi döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergah_ad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergah_ad`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
DECLARE guzergah_list JSON; -- Otobus numaralarını saklamak için bir değişken
SELECT JSON_ARRAYAGG(guzergah_ad)
INTO guzergah_list
FROM (
    SELECT DISTINCT guzergah_ad
    FROM e_guzergah
    ORDER BY guzergah_ad
) AS temp;

    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', guzergah_list));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergah_durak_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergah_durak_ekle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_id_param INT;
    DECLARE durak_id_param INT;
    DECLARE kayit_count INT;

    SET guzergah_id_param = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET durak_id_param = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    
    INSERT INTO e_guzergah_durak(guzergah_id, durak_id)
	VALUES (guzergah_id_param, durak_id_param);


    IF ROW_COUNT() > 0 THEN
        SET result =JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result',JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergah_durak_guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergah_durak_guncelle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE eski_guzergah_id INT;
    DECLARE yeni_guzergah_id INT;
    DECLARE eski_durak_id INT;
    DECLARE yeni_durak_id INT;
    DECLARE kayit_count INT;

    -- JSON verisinden eski ve yeni guzergah_id'leri çıkar
    SET eski_guzergah_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET yeni_guzergah_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));

    -- JSON verisinden eski ve yeni durak_id'leri çıkar
    SET eski_durak_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));
    SET yeni_durak_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."3"'));

    -- Verilen guzergah_id ve durak_id ile kayıt var mı kontrol et
    SELECT COUNT(*) INTO kayit_count
    FROM e_guzergah_durak
    WHERE guzergah_id = eski_guzergah_id
    AND durak_id = eski_durak_id;

    -- Güncelleme işlemini gerçekleştir
	UPDATE e_guzergah_durak
	SET guzergah_id = yeni_guzergah_id,
		durak_id = yeni_durak_id
	WHERE guzergah_id = eski_guzergah_id
	AND durak_id = eski_durak_id;

	IF ROW_COUNT() > 0 THEN
		SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'güncelleme başarılı', 'result', JSON_ARRAY(json_data)));
	ELSE
		SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'güncelleme başarısız', 'result', JSON_ARRAY()));
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergah_durak_sil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergah_durak_sil`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_durakID INT;
    SET guzergah_durakID = CAST(JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"')) AS SIGNED);

    -- Belirtilen guzergah_id ve durak_id ile eşleşen kaydı sil
    DELETE FROM e_guzergah_durak
    WHERE guzergah_id = guzergah_durakID;

    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'silme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'silme işlemi başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergah_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergah_ekle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_numarasi INT;
    DECLARE guzergah_adi VARCHAR(255);
    DECLARE guzergah_count INT;

    SET guzergah_numarasi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET guzergah_adi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));

    -- Aynı guzergah numarası zaten var mı kontrol et
    SELECT COUNT(*) INTO guzergah_count
    FROM orakoglu_staj1.e_guzergah
    WHERE guzergah_no = guzergah_numarasi;

    IF guzergah_count > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Bu güzergah numarası zaten mevcut', 'result', JSON_ARRAY()));
    ELSE
        -- Aynı guzergah adı zaten var mı kontrol et
        SELECT COUNT(*) INTO guzergah_count
        FROM orakoglu_staj1.e_guzergah
        WHERE guzergah_ad = guzergah_adi;

        IF guzergah_count > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Bu güzergah adı zaten mevcut', 'result', JSON_ARRAY()));
        ELSE
            -- Yeni guzergah kaydını ekle
            INSERT INTO orakoglu_staj1.e_guzergah(guzergah_no, guzergah_ad)
            VALUES (guzergah_numarasi, guzergah_adi);

            IF ROW_COUNT() > 0 THEN
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Ekleme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
            ELSE
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Ekleme işlemi başarısız', 'result', JSON_ARRAY()));
            END IF;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergah_guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergah_guncelle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE eski_guzergah_ad VARCHAR(255);
    DECLARE yeni_guzergah_ad VARCHAR(255);
    DECLARE guzergah_count INT;

    -- JSON verisinden eski ve yeni guzergah_no'ları çıkar
    SET eski_guzergah_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET yeni_guzergah_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));

    -- Yeni guzergah_no'nun, e_guzergah tablosunda başka kayıtlarda olup olmadığını kontrol et
    SELECT COUNT(*) INTO guzergah_count
    FROM e_guzergah
    WHERE (guzergah_ad = yeni_guzergah_ad) AND (guzergah_ad != eski_guzergah_ad);

    IF guzergah_count = 0 THEN
        -- Eğer yeni guzergah_no başka kayıtlarda yoksa, güncelleme işlemini gerçekleştir
        UPDATE e_guzergah
        SET guzergah_ad = yeni_guzergah_ad
        WHERE guzergah_ad = eski_guzergah_ad;

        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Güncelleme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Güncelleme işlemi başarısız', 'result', JSON_ARRAY()));
        END IF;
    ELSE
        -- Eğer yeni guzergah_no başka kayıtlarda varsa, güncelleme işlemini yapma
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Yeni güzergah adı mevcut', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_guzergah_sil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_guzergah_sil`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergahID INT;
	DECLARE guzergah_durak_count INT;
    DECLARE sefer_count INT;
    DECLARE guzergah_adi VARCHAR(255);
    SET guzergah_adi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    
    -- Güzergah ID'sini al
    SELECT guzergah_id INTO guzergahID
    FROM e_guzergah
    WHERE guzergah_ad = guzergah_adi;

    IF guzergahID IS NOT NULL THEN
        -- Güzergah ID'si bulunduğunda, bu ID ile e_guzergah_durak veya e_sefer tablosunda kayıt var mı kontrol et


        SELECT COUNT(*) INTO guzergah_durak_count
        FROM e_guzergah_durak
        WHERE guzergah_id = guzergahID;

        SELECT COUNT(*) INTO sefer_count
        FROM e_sefer
        WHERE guzergah_id = guzergahID;

        IF guzergah_durak_count > 0 OR sefer_count > 0 THEN
            -- Güzergahın kullanıldığını ve silinemeyeceğini belirt
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Güzergah kullanımda olduğu için silinemiyor', 'result', JSON_ARRAY()));
        ELSE
            -- Güzergah kullanılmıyorsa, silme işlemini gerçekleştir
            DELETE FROM e_guzergah
            WHERE guzergah_id = guzergahID;

            IF ROW_COUNT() > 0 THEN
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Silme işlemi başarılı', 'result', JSON_ARRAY(guzergah_adi)));
            ELSE
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Silme işlemi başarısız', 'result', JSON_ARRAY()));
            END IF;
        END IF;
    ELSE
        -- Belirtilen guzergah_ad ile eşleşen bir kayıt bulunamazsa hata mesajı döndürün
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Belirtilen güzergah adı bulunamadı', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_numaraya_gore_sefer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_numaraya_gore_sefer`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobus_numarasi INT;
    DECLARE guzergah_ad_list JSON;
    
    SET otobus_numarasi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    
    -- E_sefer tablosundan alınan guzergah_id'leri kullanarak e_guzergah tablosundan guzergah_ad'ları getir
    SET SESSION group_concat_max_len = 1000000; -- Gruplandırma sınırını artır
    SELECT
        CONCAT('[ "', GROUP_CONCAT(guzergah_ad ORDER BY guzergah_no SEPARATOR ' * '), '" ]') INTO guzergah_ad_list
    FROM e_guzergah
    WHERE guzergah_id IN (
        SELECT DISTINCT guzergah_id
        FROM e_sefer
        WHERE otobus_no = otobus_numarasi
    );
    
     -- JSON dizisinin uzunluğunu kontrol et
    IF JSON_LENGTH(guzergah_ad_list) > 0 THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', guzergah_ad_list));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte boş bir JSON nesnesi döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_otobus_guzergah_kalkis_saatleri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_otobus_guzergah_kalkis_saatleri`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_id_list JSON;
    DECLARE hedef_guzergah_id INT;
    DECLARE formatli_kalkis_saati JSON; 
    DECLARE otobus_numarasi INT;
    
    -- JSON verisinden otobus_no değerini çıkar ve INT olarak sakla
    SET otobus_numarasi = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));
    
    -- Belirli otobus numarasına ait guzergah_id'leri JSON formatında al
    SET guzergah_id_list = (
        SELECT JSON_ARRAYAGG(guzergah_id)
        FROM e_sefer
        WHERE otobus_no = otobus_numarasi
    );
    
    -- En küçük guzergah_no'ya sahip olan guzergah_id'yi bul
    SELECT guzergah_id INTO hedef_guzergah_id
    FROM (
        SELECT guzergah_id
        FROM e_guzergah
        WHERE guzergah_id IN (SELECT guzergah_id FROM JSON_TABLE(guzergah_id_list, '$[*]' COLUMNS(guzergah_id INT PATH '$')) as subquery)
        ORDER BY guzergah_no
        LIMIT 1
    ) AS subquery;
    
    -- Geçici bir tabloya kalkış saatlerini sakla ve sırala
    CREATE TEMPORARY TABLE temp_kalkis_saati AS
    SELECT TIME_FORMAT(STR_TO_DATE(kalkis_saati, '%H:%i'), '%H:%i') AS kalkis_saatleri
    FROM e_sefer
    WHERE guzergah_id = hedef_guzergah_id AND otobus_no = otobus_numarasi
    ORDER BY STR_TO_DATE(kalkis_saati, '%H:%i');
    
    -- Geçici tablodan saatleri bir JSON listesine dönüştür ve ata
    SET formatli_kalkis_saati = (
        SELECT JSON_ARRAYAGG(kalkis_saatleri) FROM temp_kalkis_saati
    );
    
    -- Geçici tabloyu temizle
    DROP TEMPORARY TABLE IF EXISTS temp_kalkis_saati;

    IF JSON_LENGTH(formatli_kalkis_saati) > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', formatli_kalkis_saati));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_otobus_kalkis_saat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_otobus_kalkis_saat`(
   IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_id_list JSON;
    DECLARE hedef_guzergah_id INT;
    DECLARE formatli_kalkis_saati JSON; 
    DECLARE otobus_numarasi INT;
    
    -- JSON verisinden otobus_no değerini çıkar ve INT olarak sakla
    SET otobus_numarasi = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));
    
    -- Belirli otobus numarasına ait guzergah_id'leri JSON formatında al
    SET guzergah_id_list = (
        SELECT JSON_ARRAYAGG(guzergah_id)
        FROM e_sefer
        WHERE otobus_no = otobus_numarasi
    );
    
    -- En küçük guzergah_no'ya sahip olan guzergah_id'yi bul
    SELECT guzergah_id INTO hedef_guzergah_id
    FROM (
        SELECT guzergah_id
        FROM e_guzergah
        WHERE guzergah_id IN (SELECT guzergah_id FROM JSON_TABLE(guzergah_id_list, '$[*]' COLUMNS(guzergah_id INT PATH '$')) 
        as subquery)
        ORDER BY guzergah_no
        LIMIT 1
    ) AS subquery;
    
    -- Geçici bir tabloya kalkış saatlerini sakla ve sırala
    CREATE TEMPORARY TABLE temp_kalkis_saati AS
    SELECT TIME_FORMAT(STR_TO_DATE(kalkis_saati, '%H:%i'), '%H:%i') AS kalkis_saatleri
    FROM e_sefer
    WHERE guzergah_id = hedef_guzergah_id AND otobus_no = otobus_numarasi
    ORDER BY STR_TO_DATE(kalkis_saati, '%H:%i');
    
    -- Geçici tablodan saatleri bir JSON listesine dönüştür ve ata
    SET formatli_kalkis_saati = (
        SELECT JSON_ARRAYAGG(kalkis_saatleri) FROM temp_kalkis_saati
    );
    
    -- Geçici tabloyu temizle
    DROP TEMPORARY TABLE IF EXISTS temp_kalkis_saati;

    IF JSON_LENGTH(formatli_kalkis_saati) > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', formatli_kalkis_saati));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_otobus_numara` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_otobus_numara`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobus_list JSON; -- Otobus numaralarını saklamak için bir değişken

    -- Otobus numaralarını JSON dizisine ekleyin
    SELECT JSON_ARRAYAGG(CONVERT(otobus_no, CHAR))
    INTO otobus_list
    FROM (
        SELECT DISTINCT otobus_no
        FROM e_sefer
        ORDER BY otobus_no
    ) AS temp;

    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', otobus_list));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_sefer_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_sefer_ekle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_ad_param VARCHAR(255);
    DECLARE guzergah_id_param INT;
    DECLARE otobus_no_param INT;
    DECLARE kalkis_saati_param VARCHAR(10);
    DECLARE kayit_count INT;

    -- JSON verisinden gerekli alanları çıkar ve değişkenlere atayın
    SET guzergah_ad_param = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET otobus_no_param = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET kalkis_saati_param = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));

    -- Verilen guzergah_ad_param'dan guzergah_id'yi bulun
    SELECT guzergah_id INTO guzergah_id_param
    FROM e_guzergah
    WHERE guzergah_ad = guzergah_ad_param;

    -- Aynı otobus_no, guzergah_id_param ve kalkis_saati_param'a sahip kayıt var mı kontrol et
    SELECT COUNT(*) INTO kayit_count
    FROM e_sefer
    WHERE otobus_no = otobus_no_param
    AND guzergah_id = guzergah_id_param
    AND kalkis_saati = kalkis_saati_param;

    IF kayit_count = 0 THEN
        -- Eğer aynı kayıt bulunmuyorsa, veriyi tabloya ekleyin
        INSERT INTO e_sefer (guzergah_id, otobus_no, kalkis_saati)
        VALUES (guzergah_id_param, otobus_no_param, kalkis_saati_param);

        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Ekleme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Ekleme işlemi başarısız', 'result', JSON_ARRAY()));
        END IF;
    ELSE
        -- Eğer aynı kayıt bulunuyorsa, hata mesajı döndürün
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Bu sefer bilgileri mevcut', 'result', JSON_ARRAY(json_data)));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_sefer_guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_sefer_guncelle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE eski_guzergah_ad VARCHAR(255);
    DECLARE eski_guzergah_id INT;
    DECLARE eski_otobus_no INT;
    DECLARE eski_kalkis_saati VARCHAR(10);
    DECLARE yeni_guzergah_ad VARCHAR(255);
    DECLARE yeni_guzergah_id INT;
    DECLARE yeni_otobus_no INT;
    DECLARE yeni_kalkis_saati VARCHAR(10);
    
    -- JSON verisinden eski ve yeni alanları çıkar ve değişkenlere atayın
    SET eski_guzergah_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET yeni_guzergah_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET eski_otobus_no = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));
    SET yeni_otobus_no = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."3"'));
    SET eski_kalkis_saati = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."4"'));
    SET yeni_kalkis_saati = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."5"'));

    -- Eski guzergah adından guzergah_id'yi bulun
    SELECT guzergah_id INTO eski_guzergah_id
    FROM e_guzergah
    WHERE guzergah_ad = eski_guzergah_ad;

    -- Eski verilerle aynı kayıt var mı kontrol et
    IF EXISTS (
        SELECT 1
        FROM e_sefer
        WHERE guzergah_id = eski_guzergah_id
        AND otobus_no = eski_otobus_no
        AND kalkis_saati = eski_kalkis_saati
    ) THEN
        -- Eğer aynı kayıt bulunuyorsa, yeni guzergah adından guzergah_id'yi bulun
        SELECT guzergah_id INTO yeni_guzergah_id
        FROM e_guzergah
        WHERE guzergah_ad = yeni_guzergah_ad;

        -- Eğer yeni guzergah_id, yeni_otobus_no ve yeni_kalkis_saati'ne sahip bir veri yoksa güncelle
        IF NOT EXISTS (
            SELECT 1
            FROM e_sefer
            WHERE guzergah_id = yeni_guzergah_id
            AND otobus_no = yeni_otobus_no
            AND kalkis_saati = yeni_kalkis_saati
        ) THEN
            UPDATE e_sefer
            SET guzergah_id = yeni_guzergah_id,
                otobus_no = yeni_otobus_no,
                kalkis_saati = yeni_kalkis_saati
            WHERE guzergah_id = eski_guzergah_id
            AND otobus_no = eski_otobus_no
            AND kalkis_saati = eski_kalkis_saati;

            IF ROW_COUNT() > 0 THEN
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Güncelleme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
            ELSE
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Güncelleme işlemi başarısız', 'result', JSON_ARRAY(json_data)));
            END IF;
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Bu sefer bilgileri mevcut', 'result', JSON_ARRAY(json_data)));
        END IF;
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Girilen sefer bilgileri bulunamadı', 'result', JSON_ARRAY(json_data)));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_sefer_guzergah_adlari` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_sefer_guzergah_adlari`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobus_numarasi INT;
    DECLARE guzergah_ad_list JSON;
    
    SET otobus_numarasi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    
    -- E_sefer tablosundan alınan guzergah_id'leri kullanarak e_guzergah tablosundan guzergah_ad'ları getir
    SET SESSION group_concat_max_len = 1000000; -- Gruplandırma sınırını artır
    SELECT
        CONCAT('[', GROUP_CONCAT('"', guzergah_ad, '"' ORDER BY guzergah_no SEPARATOR ','), ']') INTO guzergah_ad_list
    FROM e_guzergah
    WHERE guzergah_id IN (
        SELECT DISTINCT guzergah_id
        FROM e_sefer
        WHERE otobus_no = otobus_numarasi
    );
    
    
     -- JSON dizisinin uzunluğunu kontrol et
    IF JSON_LENGTH(guzergah_ad_list) > 0 THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', guzergah_ad_list));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte boş bir JSON nesnesi döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_sefer_sil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_sefer_sil`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE sefer_id_param INT;
    DECLARE kayit_var INT DEFAULT 0; -- Kaydın mevcut olup olmadığını kontrol etmek için değişken tanımlayın

    -- JSON verisinden sefer_id'yi çıkar ve değişkene atayın
    SET sefer_id_param = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

    -- Belirtilen sefer_id'ye sahip kaydın mevcut olup olmadığını kontrol et
    SELECT COUNT(*) INTO kayit_var
    FROM e_sefer
    WHERE sefer_id = sefer_id_param;

    IF kayit_var > 0 THEN
        -- Kayıt mevcutsa, silme işlemini gerçekleştirin
        DELETE FROM e_sefer
        WHERE sefer_id = sefer_id_param;

        IF ROW_COUNT() > 0 THEN
            -- Silme işlemi başarılıysa, sonucu döndürün
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Silme işlemi başarılı', 'result', JSON_ARRAY(json_data)));
        ELSE
            -- Silme işlemi başarısızsa, uygun bir hata mesajı döndürün
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Silme işlemi başarısız', 'result', JSON_ARRAY()));
        END IF;
    ELSE
        -- Kayıt mevcut değilse, uygun bir hata mesajı döndürün
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Silinecek sefer bilgileri bulunamadı', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_token_yetkiler` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_token_yetkiler`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE kullanici_adi VARCHAR(255);
    DECLARE yetki_adlar JSON;

    SET kullanici_adi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

    -- Kullanıcıya ait yetki_adlarını al
    SELECT JSON_ARRAYAGG(yetki_ad) INTO yetki_adlar
    FROM orakoglu_staj1.token_yetki ty
    JOIN orakoglu_staj1.yetkiler y ON ty.yetki_id = y.yetki_id
    WHERE ty.kullanici_ad = kullanici_adi;

    -- Yetki var mı kontrol et ve sonucu JSON olarak döndür
    IF yetki_adlar IS NOT NULL THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', yetki_adlar));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_token_yetki_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_token_yetki_ekle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE kullanici_adi VARCHAR(255);
    DECLARE yetki_adi VARCHAR(255);
    DECLARE yetkiID INT;
    DECLARE yetki_var INT DEFAULT 0;
    
	SET kullanici_adi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET yetki_adi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    
    -- yetki_adi'na karşılık gelen yetki_id'yi al
    SELECT yetki_id INTO yetkiID
    FROM orakoglu_staj1.yetkiler
    WHERE yetki_ad = yetki_adi;
    
    IF yetkiID IS NULL THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY('Geçersiz yetki adı.')));
    ELSE
        -- Kullanıcının bu yetkiye sahip olup olmadığını kontrol et
        SELECT COUNT(*) INTO yetki_var
        FROM orakoglu_staj1.token_yetki
        WHERE kullanici_ad = kullanici_adi AND yetki_id = yetkiID;
        
        IF yetki_var > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY('Bu yetki zaten var.')));
        ELSE
            -- Yetkiyi eklemeye devam et
            INSERT INTO orakoglu_staj1.token_yetki(kullanici_ad, yetki_id)
            VALUES (kullanici_adi, yetkiID);
            
            IF ROW_COUNT() > 0 THEN
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(json_data)));
            ELSE
                SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
            END IF;
        END IF;
    END IF;  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `e_yetki_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `e_yetki_ekle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE yetki_adi VARCHAR(255);
    DECLARE yetki_var INT DEFAULT 0;
    
	SET yetki_adi = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    
    -- Veritabanında yetki adını kontrol et
    SELECT COUNT(*) INTO yetki_var
    FROM orakoglu_staj1.yetkiler
    WHERE yetki_ad = yetki_adi;
    
    IF yetki_var > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY('Bu yetki zaten var.')));
    ELSE
        -- Yetkiyi eklemeye devam et
        INSERT INTO orakoglu_staj1.yetkiler(yetki_ad)
        VALUES (yetki_adi);
        
        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(json_data)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
        END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guncelle`(
  IN json_data JSON,
  OUT result JSON
)
BEGIN
   -- JSON veriyi parçalayın ve gerekli alanları alın
   SET @UserEmail = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.useremail'));
   SET @NewTelNo = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.telno'));
   SET @NewUsername = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.username'));

   -- Veritabanında güncelleme işlemini gerçekleştirin
   UPDATE kullanici
   SET telno = @NewTelNo, username = @NewUsername
   WHERE email = @UserEmail;
   
   -- Dönüş değeri
   SET result = JSON_OBJECT('status', 'success');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guncellemedeneme` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guncellemedeneme`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE username VARCHAR(50);
    DECLARE surname VARCHAR(50);
    DECLARE email VARCHAR(50);
    DECLARE telno VARCHAR(50);
    DECLARE gender VARCHAR(50);
    DECLARE city VARCHAR(50);

    SET username = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET surname = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET email = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));
    SET telno = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."3"'));
    SET gender = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."4"'));
    SET city = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."5"'));

    -- Check if the email already exists in the table
    IF EXISTS (SELECT 1 FROM orakoglu_staj1.kullanicilar WHERE email = email) THEN
        -- Update the existing record based on the email
        UPDATE orakoglu_staj1.kullanicilar
        SET
            username = username,
            surname = surname,
            telno = telno,
            gender = gender,
            city = city
        WHERE email = email;
    ELSE
        -- Insert a new record if the email doesn't exist
        INSERT INTO orakoglu_staj1.kullanicilar(username, surname, email, telno, gender, city)
        VALUES (username, surname, email, telno, gender, city);
    END IF;

    -- Set the result to indicate success
    SET result = '{"message": "Operation completed successfully"}';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guzergah` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guzergah`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE guzergah_ad VARCHAR(50);
DECLARE guzergah_aciklama VARCHAR(50);

SET guzergah_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."0"'));
SET guzergah_aciklama = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."1"'));

INSERT INTO orakoglu_staj1.guzergah(guzergah_ad, guzergah_aciklama)
VALUES (guzergah_ad, guzergah_aciklama);

 IF ROW_COUNT() > 0 THEN
        SET result =JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result',JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guzergaha_gore_numara` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guzergaha_gore_numara`(
    IN guzergah_no JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergahID INT;
    DECLARE otobus_no_liste JSON;
    DECLARE guzergah VARCHAR(45);

    -- JSON verisinden guzergah_ad değerini çıkar
    SET guzergah = JSON_UNQUOTE(JSON_EXTRACT(guzergah_no, '$."0"'));

    -- Verilen güzergah adına göre güzergah ID'sini bul
    SELECT guzergah_id INTO guzergahID
    FROM orakoglu_staj1.guzergah
    WHERE guzergah_ad = guzergah;

    -- Geçici bir tablo oluştur
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_otobus_no (otobus_no VARCHAR(45));

    -- Güzergah ID'sine sahip seferlerin otobüs numaralarını geçici tabloya ekle (DISTINCT ile)
    INSERT INTO temp_otobus_no (otobus_no)
    SELECT DISTINCT o.otobus_no
    FROM orakoglu_staj1.sefer s
    INNER JOIN orakoglu_staj1.otobus o ON s.otobus_id = o.otobus_id
    WHERE s.guzergah_id = guzergahID;

    -- Geçici tablodan otobüs numaralarını JSON dizisine dönüştür
    SELECT JSON_ARRAYAGG(otobus_no)
    INTO otobus_no_liste
    FROM temp_otobus_no;

    -- Geçici tabloyu temizle
    DROP TEMPORARY TABLE IF EXISTS temp_otobus_no;

    -- JSON dizisinin uzunluğunu kontrol et
    IF JSON_LENGTH(otobus_no_liste) > 0 THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', otobus_no_liste));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte boş bir JSON nesnesi döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guzergah_aciklama_getir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guzergah_aciklama_getir`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE guzergah_aciklama VARCHAR(255);

    -- JSON verisinden otobus_no değerini çıkar
    SET otobus_no_param = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));

    -- Verilen otobus_no'ya ait otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_no_param;

    -- Otobus_id'ye göre ilgili seferin guzergah açıklamasını al
    SELECT g.guzergah_aciklama
    INTO guzergah_aciklama
    FROM orakoglu_staj1.sefer s
    INNER JOIN orakoglu_staj1.guzergah g ON s.guzergah_id = g.guzergah_id
    WHERE s.otobus_id = otobusID
    LIMIT 1; -- Yalnızca bir kaydı seç

    IF guzergah_aciklama IS NOT NULL THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(guzergah_aciklama)));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte hata durumunu döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guzergah_adina_gore_numara` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guzergah_adina_gore_numara`(
    IN guzergah_ad_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergahID INT;
    DECLARE otobus_no_liste JSON DEFAULT '[]';

    -- JSON verisinden guzergah_ad değerini çıkar
    SET guzergah_ad_param = JSON_UNQUOTE(JSON_EXTRACT(guzergah_ad_param, '$."0"'));

    -- Verilen güzergah adına göre güzergah ID'sini bul
    SELECT guzergah_id INTO guzergahID
    FROM orakoglu_staj1.guzergah
    WHERE guzergah_ad = guzergah_ad_param;

    -- Güzergah ID'sine sahip seferlerin otobüs numaralarını al
    SELECT JSON_ARRAYAGG(o.otobus_no)
    INTO otobus_no_liste
    FROM orakoglu_staj1.sefer s
    INNER JOIN orakoglu_staj1.otobus o ON s.otobus_id = o.otobus_id
    WHERE s.guzergah_id = guzergahID;

    -- JSON dizisinin uzunluğunu kontrol et
    IF JSON_LENGTH(otobus_no_liste) > 0 THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', otobus_no_liste));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte boş bir JSON nesnesi döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guzergah_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guzergah_ekle`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE guzergah_ad VARCHAR(50);
DECLARE guzergah_aciklama VARCHAR(5000);

SET guzergah_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."0"'));
SET guzergah_aciklama = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."1"'));

INSERT INTO orakoglu_staj1.guzergah(guzergah_ad, guzergah_aciklama)
VALUES (guzergah_ad, guzergah_aciklama);

 IF ROW_COUNT() > 0 THEN
        SET result =JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result',JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `güzergah_guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `güzergah_guncelle`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE ad VARCHAR(50);
DECLARE yeni_ad VARCHAR(50);
DECLARE yeni_aciklama VARCHAR(255);


    -- JSON verisinden eski_otobus_no ve yeni_otobus_no değerlerini çıkar
    SET ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET yeni_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
	SET yeni_aciklama = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));

    -- Belirtilen eski_otobus_no'ya sahip kaydın otobus_no değerini güncelle
    UPDATE orakoglu_staj1.guzergah
    SET
		guzergah_ad=yeni_ad,
        guzergah_aciklama=yeni_aciklama

    WHERE guzergah_ad = ad; 

    -- Güncelleme başarılı ise
    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'guzergah guncelleme başarılı', 'result', JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY(json_data)));
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guzergah_sil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guzergah_sil`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE silinecek_guzergah_ad VARCHAR(50);

    -- JSON verisinden güzergah adı değerini çıkar ve VARCHAR olarak sakla
    SET silinecek_guzergah_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

    DELETE FROM orakoglu_staj1.guzergah WHERE guzergah_ad = silinecek_guzergah_ad ;

    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(silinecek_guzergah_ad)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
    SELECT result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guzergah_veri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `guzergah_veri`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE guzergah_liste JSON;

    -- Guzergah tablosundan guzergah_aciklama alanını seç ve * karakterine göre verileri bölelim
    SELECT JSON_ARRAYAGG(JSON_UNQUOTE(JSON_EXTRACT_INDEX(guzergah_aciklama, '*'))) INTO guzergah_liste
    FROM orakoglu_staj1.guzergah
    ORDER BY guzergah_aciklama; -- Alfabetik sıralama

    IF JSON_ARRAY_LENGTH(guzergah_liste) > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'guzergah VERİ GÖNDERME başarılı', 'result', guzergah_liste));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `kalkis_saati_getir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `kalkis_saati_getir`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE kalkis_saati JSON;

    -- JSON verisinden otobus_no değerini çıkar
    SET otobus_no_param = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));

    -- Verilen otobus_no'ya ait otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_no_param;

    -- Otobus_id'ye göre ilgili seferlerin kalkış saatlerini al
    SELECT JSON_ARRAYAGG(s.kalkis_saati)
    INTO kalkis_saati
    FROM orakoglu_staj1.sefer s
    WHERE s.otobus_id = otobusID;

    -- JSON dizisinin uzunluğunu kontrol et
     IF kalkis_saati IS NOT NULL THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', kalkis_saati));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte boş bir JSON nesnesi döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `kalkis_saatleri_getir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `kalkis_saatleri_getir`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE kalkis_saati_listesi_json JSON;
    
    -- JSON verisinden otobus_no değerini çıkar ve VARCHAR olarak sakla
    SET otobus_no_param = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));
    
    -- Verilen otobus_no'yu kullanarak otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_no_param;
    
    -- Otobus_id'ye göre ilgili saatleri bir geçici tabloya çek
    CREATE TEMPORARY TABLE temp_kalkis_saati AS
    SELECT STR_TO_DATE(kalkis_saati, '%H:%i') AS kalkis_saati
    FROM orakoglu_staj1.sefer
    WHERE otobus_id = otobusID
    ORDER BY STR_TO_DATE(kalkis_saati, '%H:%i');
    
    -- Geçici tablodan saatleri JSON dizisine dönüştürün
    SET kalkis_saati_listesi_json = (
        SELECT JSON_ARRAYAGG(TIME_FORMAT(kalkis_saati, '%H:%i')) FROM temp_kalkis_saati
    );
    
    IF kalkis_saati_listesi_json IS NOT NULL THEN
        -- Başarılı durumda, hata yok ve sıralanmış kalkis_saati_listesi JSON dizisini result'e atayın
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', kalkis_saati_listesi_json));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, boş bir JSON nesnesi döndürün
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
    -- Sonucu döndürün
    SELECT result;
    
    -- Geçici tabloyu temizleyin
    DROP TEMPORARY TABLE IF EXISTS temp_kalkis_saati;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `kaydet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `kaydet`(
    IN json_data JSON
   
)
BEGIN
    DECLARE username VARCHAR(50);
    DECLARE surname VARCHAR(50);
    DECLARE email VARCHAR(50);
    DECLARE telno VARCHAR(50);
    DECLARE gender VARCHAR(50);
    DECLARE city VARCHAR(50);

    SET username = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.username'));
    SET surname = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.surname'));
    SET email = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.email'));
    SET telno = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.telno'));
    SET gender = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.gender'));
    SET city = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.city'));

      -- Kontrol etmek için e-posta adresinin daha önce kullanılıp kullanılmadığını kontrol et
    IF (SELECT COUNT(*) FROM orakoglu_staj1.kullanicilar WHERE email = email) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bu e-posta adresi zaten kullanılıyor.';
    ELSE
        -- E-posta adresi daha önce kullanılmamışsa, kullanıcıyı ekleyin
        INSERT INTO orakoglu_staj1.kullanicilar(username, surname, email, telno, gender, city)
        VALUES(username, surname, email, telno, gender, city);
    END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `kayit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `kayit`(
    IN json_data JSON,
     OUT result JSON
)
BEGIN

DECLARE username VARCHAR(50);
DECLARE surname VARCHAR(50);
DECLARE email VARCHAR(50);
DECLARE telno VARCHAR(50);
DECLARE gender VARCHAR(50);
DECLARE city VARCHAR(50);


SET username = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."0"'));
SET surname = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."1"'));
SET email = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."2"'));
SET telno = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."3"'));
SET gender = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."4"'));
SET city = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."5"'));

INSERT INTO orakoglu_staj1.kullanicilar(username, surname, email, telno, gender, city)

VALUES (username, surname, email, telno, gender, city);


 IF ROW_COUNT() > 0 THEN
        SET result =JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result',JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
    SELECT result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `kayitSil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `kayitSil`(
  IN json_data JSON,
  OUT result JSON
)
BEGIN
  DECLARE silinecek_mail VARCHAR(50);

  -- JSON verisini ayrıştırma
  SET silinecek_mail = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

  -- Belirtilen ID'ye sahip olan kullanıcıyı silme
  DELETE FROM orakoglu_staj1.kullanicilar WHERE email = silinecek_mail;
  IF ROW_COUNT() > 0 THEN
        SET result =JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Başarılı bir şekilde veri silindi.', 'result', JSON_ARRAY()));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Veri silme işlemi başarısız', 'result', JSON_ARRAY()));
    END IF;
    
    SELECT result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `numaraya_gore_guzergah` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `numaraya_gore_guzergah`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE guzergah_aciklama VARCHAR(255);

    -- JSON verisinden otobus_no değerini çıkar
    SET otobus_no_param = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));

    -- Verilen otobus_no'ya ait otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_no_param;

    -- Otobus_id'ye göre ilgili seferin guzergah açıklamasını al
    SELECT g.guzergah_aciklama
    INTO guzergah_aciklama
    FROM orakoglu_staj1.sefer s
    INNER JOIN orakoglu_staj1.guzergah g ON s.guzergah_id = g.guzergah_id
    WHERE s.otobus_id = otobusID
    LIMIT 1; -- Yalnızca bir kaydı seç

    IF guzergah_aciklama IS NOT NULL THEN
        -- Veri başarıyla alındı
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(guzergah_aciklama)));
    ELSE
        -- Veri bulunamazsa veya hatalıysa, hata bilgisi ile birlikte hata durumunu döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `otobus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `otobus`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE otobus_list JSON; -- Kullanıcı adlarını saklamak için bir değişken
SELECT JSON_ARRAYAGG(otobus_no)
    INTO otobus_list
    FROM orakoglu_staj1.otobus
    ORDER BY otobus_no;
IF ROW_COUNT() > 0 THEN
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', otobus_list));
ELSE
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `otobus_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `otobus_ekle`(
	 IN json_data JSON,
     OUT result JSON
 )
BEGIN
DECLARE otobus_no VARCHAR(50);

SET otobus_no = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."0"'));

INSERT INTO orakoglu_staj1.otobus(otobus_no) VALUES (otobus_no);

IF ROW_COUNT() > 0 THEN
        SET result =JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result',JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
    SELECT result;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `otobus_guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `otobus_guncelle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE eski_otobus_no VARCHAR(50);
    DECLARE yeni_otobus_no VARCHAR(50);

    -- JSON verisinden eski_otobus_no ve yeni_otobus_no değerlerini çıkar
    SET eski_otobus_no = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET yeni_otobus_no = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));

    -- Belirtilen eski_otobus_no'ya sahip kaydın otobus_no değerini güncelle
    UPDATE orakoglu_staj1.otobus
    SET
        otobus_no = yeni_otobus_no
    WHERE otobus_no = eski_otobus_no; 

    -- Güncelleme başarılı ise
    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY(json_data)));
    END IF;

    SELECT result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `otobus_guzergah` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `otobus_guzergah`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE guzergah_liste JSON;
SELECT JSON_ARRAYAGG(guzergah_ad) INTO guzergah_liste FROM orakoglu_staj1.guzergah;

IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'guzergah VERİ GÖNDERME başarılı', 'result', guzergah_liste));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `otobus_numara` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `otobus_numara`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE otobus_list JSON; -- Kullanıcı adlarını saklamak için bir değişken
-- Otobus numaralarını integer'a çevirip sıralayarak JSON dizisine ekleyin
    SELECT JSON_ARRAYAGG(CONVERT(otobus_no, SIGNED))
    INTO otobus_list
    FROM orakoglu_staj1.otobus
    ORDER BY CONVERT(otobus_no, SIGNED);
IF ROW_COUNT() > 0 THEN
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', otobus_list));
ELSE
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `otobus_sefer_guzergah_kalkis_saat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `otobus_sefer_guzergah_kalkis_saat`(
    IN otobus_no_param VARCHAR(50),
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE guzergah_kalkis_liste JSON DEFAULT '[]';

    -- Verilen otobus_no'ya ait otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_no_param;

    -- Otobus_id'ye göre sefer tablosundan gerekli verileri al
    SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'guzergah_aciklama', g.guzergah_aciklama,
        'kalkis_saati', s.kalkis_saati
    ))
    INTO guzergah_kalkis_liste
    FROM orakoglu_staj1.sefer s
    INNER JOIN orakoglu_staj1.guzergah g ON s.guzergah_id = g.guzergah_id
    WHERE s.otobus_id = otobusID;

    IF JSON_ARRAY_LENGTH(guzergah_kalkis_liste) > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', guzergah_kalkis_liste));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `otobus_sil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `otobus_sil`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE silinecek_otobus_no VARCHAR(50);

    SET silinecek_otobus_no = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

    -- Otobüsü otobus_no'ya göre sil
    DELETE FROM orakoglu_staj1.otobus WHERE otobus_no = silinecek_otobus_no;

    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(silinecek_otobus_no)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
    SELECT result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `register`(
    IN json_data JSON
   
)
BEGIN
    DECLARE username VARCHAR(50);
    DECLARE surname VARCHAR(50);
    DECLARE email VARCHAR(50);
    DECLARE telno VARCHAR(50);
    DECLARE gender VARCHAR(50);
    DECLARE city VARCHAR(50);

    SET username = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.username'));
    SET surname = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.surname'));
    SET email = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.email'));
    SET telno = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.telno'));
    SET gender = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.gender'));
    SET city = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$.city'));

    INSERT INTO orakoglu_staj1.kullanicilar(username, surname, email, telno, gender, city)
    VALUES(username, surname, email, telno, gender, city);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `saat_proc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `saat_proc`(
    IN otobus_no_param JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE kalkis_saatleri JSON;
    DECLARE otobus_numara INT;
    
    -- JSON verisinden otobus_no değerini çıkar
    SET otobus_numara = JSON_UNQUOTE(JSON_EXTRACT(otobus_no_param, '$."0"'));
    
    -- Verilen otobus_no'ya ait otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_numara;
    
    -- Otobus_id'ye göre ilgili seferlerin kalkış saatlerini sorgula
    -- Seferleri sıralayarak saatleri ekleyin

    SELECT JSON_ARRAYAGG(JSON_UNQUOTE(s.kalkis_saati))
    INTO kalkis_saatleri
    FROM orakoglu_staj1.sefer s
    WHERE s.otobus_id = otobusID
    ORDER BY STR_TO_DATE(s.kalkis_saati, '%H:%i');
    
    -- Eğer saatler boşsa, bir hata nesnesi döndürün
    IF JSON_LENGTH(kalkis_saatleri) > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', kalkis_saatleri));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sefer_ekle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `sefer_ekle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobus_sefer INT;
    DECLARE guzergah_sefer INT;
    DECLARE saat_sefer VARCHAR(10);
    
    SET otobus_sefer = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET guzergah_sefer = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET saat_sefer = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));
    
    -- Aynı otobüs, güzergah ve saatte sefer var mı kontrol et
    IF NOT EXISTS (
        SELECT 1
        FROM orakoglu_staj1.sefer
        WHERE otobus_id = otobus_sefer
        AND guzergah_id = guzergah_sefer
        AND kalkis_saati = saat_sefer
    ) THEN
        INSERT INTO orakoglu_staj1.sefer (otobus_id, guzergah_id, kalkis_saati)
        VALUES (otobus_sefer, guzergah_sefer, saat_sefer);
        
        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'sefer ekleme başarılı', 'result', JSON_ARRAY(json_data)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'sefer ekleme başarısız', 'result', JSON_ARRAY()));
        END IF;
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'aynı sefer zaten mevcut', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sefer_guncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `sefer_guncelle`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE otobus_sefer INT;
    DECLARE guzergah_sefer INT;
    DECLARE saat_sefer VARCHAR(10);
    DECLARE guncel_saat_sefer VARCHAR(10);

    SET otobus_sefer = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET guzergah_sefer = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET saat_sefer = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."2"'));
    SET guncel_saat_sefer = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."3"'));

    -- Verilen otobüs, güzergah ve saatte seferi bul ve sadece saatini güncelle
    UPDATE orakoglu_staj1.sefer
    SET kalkis_saati = guncel_saat_sefer
    WHERE otobus_id = otobus_sefer
    AND guzergah_id = guzergah_sefer
    AND kalkis_saati = saat_sefer;

    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'sefer güncelleme başarılı', 'result', JSON_ARRAY(json_data)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'sefer güncelleme başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sefer_sil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `sefer_sil`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN

DECLARE silinecek_sefer_id VARCHAR(50);

SET silinecek_sefer_id = CAST(JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"')) AS SIGNED);

DELETE FROM orakoglu_staj1.sefer WHERE sefer_id = silinecek_sefer_id;
    IF ROW_COUNT() > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', JSON_ARRAY(silinecek_sefer_id)));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
    
    SELECT result;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sefer_veri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `sefer_veri`(
    IN otobus_no_param VARCHAR(50),
    OUT result JSON
)
BEGIN
    DECLARE otobusID INT;
    DECLARE sefer_guzergah_liste JSON DEFAULT '[]';

    -- Verilen otobus_no'ya ait otobus_id'yi bul
    SELECT otobus_id INTO otobusID
    FROM orakoglu_staj1.otobus
    WHERE otobus_no = otobus_no_param;

    -- Otobus_id'ye göre sefer tablosundan gerekli verileri al
    SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'guzergah_aciklama', g.guzergah_aciklama,
        'kalkis_saati', s.kalkis_saati
    ))
    INTO sefer_guzergah_liste
    FROM orakoglu_staj1.sefer s
    INNER JOIN orakoglu_staj1.guzergah g ON s.guzergah_id = g.guzergah_id
    WHERE s.otobus_id = otobusID;

    IF JSON_ARRAY_LENGTH(sefer_guzergah_liste) > 0 THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', sefer_guzergah_liste));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sehirGetir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `sehirGetir`(
IN bos JSON,
OUT result JSON)
BEGIN
    DECLARE json_array JSON;
    SELECT JSON_UNQUOTE(JSON_ARRAYAGG(city_name)) INTO json_array
    FROM (
        SELECT DISTINCT city_name FROM orakoglu_staj1.cities
    ) AS distinct_cities;
    IF json_array IS NOT NULL THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', json_array));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', json_array));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sehirGoster` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `sehirGoster`(
    IN sehir JSON,
    OUT result JSON
)
BEGIN
    DECLARE username_list JSON; -- Kullanıcı adlarını saklamak için bir değişken
    DECLARE veri varchar(50);
	SET veri = (JSON_UNQUOTE(JSON_EXTRACT(sehir, '$."0"')));
    
    -- Kullanıcı adlarını sorgudan alıp değişkene atama yap
    SELECT JSON_ARRAYAGG(JSON_OBJECT('username', username, 'surname', surname, 'email', email, 'telno', telno, 'gender', gender, 'city', city))
    INTO username_list
    FROM `orakoglu_staj1`.`kullanicilar`
    WHERE city LIKE CONCAT('%', veri, '%');

    IF username_list IS NOT NULL THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'Başarılı. Şehire ait veriler getirildi.', 'result', username_list));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'Başarısız. Şehre ait veriler getirilemedi.', 'result', JSON_ARRAY()));
    END IF;
    
    SELECT result;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sehirKategori` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `sehirKategori`(
    IN bos JSON,
    OUT result JSON
)
BEGIN
    DECLARE json_array JSON;

    SELECT JSON_UNQUOTE(JSON_ARRAYAGG(city)) INTO json_array
    FROM (
        SELECT DISTINCT city FROM orakoglu_staj1.kullanicilar
        ORDER BY city
    ) AS distinct_cities;

    IF json_array IS NOT NULL THEN
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', json_array));
    ELSE
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', json_array));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `show`(
In ad varchar(50)
)
BEGIN
SELECT * FROM `orakoglu_staj1`.`users`
WHERE JSON_UNQUOTE(JSON_EXTRACT(`attributes`, '$.city')) LIKE CONCAT('%', ad, '%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `showValues` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `showValues`(
    IN ad VARCHAR(50)
)
BEGIN
    DECLARE json_result JSON;

    SET json_result = (SELECT JSON_ARRAYAGG(JSON_OBJECT('username', username))
                       FROM `orakoglu_staj1`.`kullanicilar`
                       WHERE city = ad);
    SELECT json_result AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenEkle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenEkle`(
    IN json_data JSON, 
    OUT result JSON
)
BEGIN
    DECLARE rastgele_token VARCHAR(255);
    DECLARE kullaniciad VARCHAR(255);
    DECLARE kullanici_id INT;
    DECLARE sifre VARCHAR(255);
    
    IF JSON_VALID(json_data) THEN
        -- Doğru JSON, işlemi devam ettir
        SET kullaniciad = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."0"'));
        SET sifre = JSON_UNQUOTE(JSON_EXTRACT(json_data,'$."1"'));
        SET rastgele_token = CONCAT(SHA1(RAND()), MD5(NOW()));
        
        
        -- Belirteci veritabanına ekleyin
        INSERT INTO orakoglu_staj1.tokenlar (token, son_kullanma_tarihi, kullaniciAd, sifre)
        VALUES (rastgele_token, DATE_ADD(NOW(), INTERVAL 30 DAY), kullaniciad, sifre);
        
        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'başarılı', 'result', rastgele_token));
            
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', JSON_ARRAY()));
        END IF;
    ELSE
        -- Hatalı JSON, işlemi durdur ve hata mesajı döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'hatalı json', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenGuncelle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenGuncelle`(
    IN json_data JSON, 
    OUT result JSON
)
BEGIN
    DECLARE rastgele_token VARCHAR(255);
    DECLARE kullanici_ad VARCHAR(255);
    DECLARE kullanici_id INT;
    DECLARE girilen_sifre VARCHAR(255);

    -- Doğru JSON, işlemi devam ettir
    SET kullanici_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET girilen_sifre = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET rastgele_token = CONCAT(SHA1(RAND()), MD5(NOW()));

    -- Kullanici_id için bir sonraki kullanılabilir değeri alın
    SELECT token 
    FROM orakoglu_staj1.tokenlar 
    WHERE kullaniciAd = kullanici_ad AND sifre = girilen_sifre;
        UPDATE orakoglu_staj1.tokenlar
        SET token = rastgele_token,
        son_kullanma_tarihi = DATE_ADD(NOW(), INTERVAL 1 MINUTE)
        WHERE kullaniciAd = kullanici_ad AND sifre = girilen_sifre ;

        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'true', 'result', JSON_ARRAY(rastgele_token)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'false', 'result', JSON_ARRAY('YETKİSİZ KULLANICI GİRİŞİ')));
        END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenKontrol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenKontrol`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE tokenAl VARCHAR(255);
DECLARE tokenTablo INT;

SET tokenAl = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));

SELECT COUNT(*) INTO tokenTablo
FROM orakoglu_staj1.tokenlar
WHERE token = tokenAl;

IF tokenTablo =1 THEN
	SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'TOKEN KONTROL BAŞARILI', 'result', tokenTablo));
ELSE
	SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'başarısız', 'result', 0));
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenlar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenlar`(IN json_data JSON,OUT result JSON)
BEGIN
  DECLARE username VARCHAR(255);
  DECLARE sif VARCHAR(255);
  DECLARE dogru INT;
  
  SET username = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
  SET sif = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
  
  SET dogru = (
    SELECT COUNT(*)
    FROM `orakoglu_staj1`.`tokenlar`
    WHERE kullaniciAd LIKE CONCAT('%', username, '%')
  );

  IF dogru = 1 THEN
    SET @sifre_db = (
      SELECT sifre
      FROM `orakoglu_staj1`.`tokenlar`
      WHERE kullaniciAd LIKE CONCAT('%', username, '%')
      LIMIT 1
    );

    IF sif = @sifre_db THEN
      SET result = JSON_UNQUOTE(JSON_OBJECT('durum', 'başarılı', 'result', JSON_ARRAY(1)));
    ELSE
      SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'parola hatalı', 'durum', 'başarısız', 'result', JSON_ARRAY()));
    END IF;
  ELSE
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'kullanıcı bulunamadı', 'durum', 'başarısız', 'result', JSON_ARRAY()));
  END IF;

  SELECT result AS 'response';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenPhp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenPhp`(
    IN json_data JSON, 
    OUT result JSON
)
BEGIN
    DECLARE rastgele_token VARCHAR(255);
    DECLARE kullanici_ad VARCHAR(255);
    DECLARE kullanici_id INT;
    DECLARE girilen_sifre VARCHAR(255);

    -- Doğru JSON, işlemi devam ettir
    SET kullanici_ad = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET girilen_sifre = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));
    SET rastgele_token = CONCAT(SHA1(RAND()), MD5(NOW()));

    -- Kullanici_id için bir sonraki kullanılabilir değeri alın
    SELECT token 
    FROM orakoglu_staj1.tokenlar 
    WHERE kullaniciAd = kullanici_ad AND sifre = girilen_sifre;
        UPDATE orakoglu_staj1.tokenlar
        SET token = rastgele_token,
        son_kullanma_tarihi = DATE_ADD(NOW(), INTERVAL 1 MINUTE)
        WHERE kullaniciAd = kullanici_ad AND sifre = girilen_sifre ;

        IF ROW_COUNT() > 0 THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'true', 'result', JSON_ARRAY(rastgele_token)));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'false', 'result', JSON_ARRAY('YETKİSİZ KULLANICI GİRİŞİ')));
        END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenSil` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenSil`(IN tokenID INT, IN userID INT)
BEGIN
    DECLARE tokenOwner INT;
    SELECT kullanici_id INTO tokenOwner FROM tokenlar WHERE id = tokenID;
    
    IF tokenOwner = userID THEN
        DELETE FROM tokenlar WHERE id = tokenID;
        SELECT 'Token silindi.' AS message;
    ELSE
        SELECT 'Yetkiniz yok.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenYetki` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenYetki`(
IN json_data JSON,
OUT result JSON
)
BEGIN
DECLARE tokenAl VARCHAR(255);
DECLARE tokenTablo VARCHAR(255);
DECLARE tokenYetkiler VARCHAR(255);
DECLARE tokenKullanici INT;

SET tokenAl = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
SET tokenYetkiler = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));

SELECT COUNT(*) INTO tokenKullanici
FROM orakoglu_staj1.tokenlar
WHERE token = tokenAl;

SELECT kullaniciAd INTO tokenTablo
FROM orakoglu_staj1.tokenlar
WHERE token = tokenAl;
IF tokenKullanici =1 THEN
IF tokenTablo = "MERYEM" THEN
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'true', 'result', JSON_ARRAY("sınırsız yetki")));
ELSEIF tokenTablo = "BARIŞ" AND JSON_SEARCH('["e_guzergah_sil", "e_durak_sil", "e_sefer_sil"]', 'one', tokenYetkiler) IS NOT NULL THEN
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'false', 'result', JSON_ARRAY("sefer, güzergah, durak silemezsiniz")));
ELSEIF tokenTablo = "MELİKE" AND JSON_SEARCH('["e_guzergah_guncelle", "e_durak_guncelle", "e_sefer_guncelle"]', 'one', tokenYetkiler) IS NOT NULL THEN
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'false', 'result', JSON_ARRAY("sefer, güzergah, durak güncelleyemezsiniz")));
ELSEIF tokenTablo = "UTKU" AND JSON_SEARCH('["e_guzergah_ekle", "e_durak_ekle", "e_sefer_ekle"]', 'one', tokenYetkiler) IS NOT NULL THEN
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'false', 'result', JSON_ARRAY("sefer, güzergah, durak ekleyemezsiniz")));
ELSE 
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'true', 'result', JSON_ARRAY("ilgili yetki var",tokenTablo)));
END IF;
ELSE 
    SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'var', 'durum', 'false', 'result', JSON_ARRAY("İSTENMEYEN KULLANICI")));
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tokenYetkiler` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orakoglu_xdr`@`%` PROCEDURE `tokenYetkiler`(
    IN json_data JSON,
    OUT result JSON
)
BEGIN
    DECLARE tokenAl VARCHAR(255);
    DECLARE tokenTablo VARCHAR(255);
    DECLARE token_yetkiler VARCHAR(255);
    DECLARE tokenKullanici INT;
    DECLARE sonuc JSON;
    DECLARE sonuc2 JSON;

    SET tokenAl = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."0"'));
    SET token_yetkiler = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$."1"'));

    -- Token kullanıcısını kontrol et
    SELECT COUNT(*) INTO tokenKullanici
    FROM orakoglu_staj1.tokenlar
    WHERE token = tokenAl;

    -- Token tablosundan kullanıcı adını al
    SELECT kullaniciAd INTO tokenTablo
    FROM orakoglu_staj1.tokenlar
    WHERE token = tokenAl;

    -- Eğer token kullanıcısı bulunursa
    IF tokenKullanici = 1 THEN
        -- tokenTablo'dan gelen kullanıcı adıyla token_yetki tablosundaki yetki_id'leri al
        CREATE TEMPORARY TABLE TempYetkiIDs AS
        SELECT ty.yetki_id
        FROM orakoglu_staj1.token_yetki ty
        JOIN orakoglu_staj1.tokenlar t ON ty.token_yetki_id = t.token_id
        WHERE t.kullaniciAd = tokenTablo;

        -- Yetki adlarını al ve sonucu JSON olarak döndür
        SELECT JSON_ARRAYAGG(yetki_ad) INTO sonuc2
        FROM orakoglu_staj1.yetkiler
        WHERE yetki_id IN (SELECT yetki_id FROM TempYetkiIDs);

        -- Kullanıcının sahip olduğu yetki_adlarını al
        SELECT JSON_ARRAYAGG(yetki_ad) INTO sonuc
        FROM orakoglu_staj1.token_yetki ty
        JOIN orakoglu_staj1.yetkiler y ON ty.yetki_id = y.yetki_id
        WHERE ty.kullanici_ad = tokenTablo;
        -- SELECT json_object('sonuc',sonuc);

        IF JSON_SEARCH(sonuc, 'one', token_yetkiler) IS NOT NULL THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'true', 'result', sonuc));
        ELSEIF JSON_SEARCH(sonuc2, 'one', token_yetkiler) IS NULL THEN
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'false', 'result', JSON_ARRAY()));
        ELSE
            SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'Böyle bir yetki bulunamadı.', 'durum', 'false', 'result', JSON_ARRAY()));
        END IF;
        
        -- TempYetkiIDs tablosunu temizle
        DROP TEMPORARY TABLE IF EXISTS TempYetkiIDs;
    ELSE
        -- Token kullanıcısı bulunamazsa boş bir JSON sonucu döndür
        SET result = JSON_UNQUOTE(JSON_OBJECT('hata', 'yok', 'durum', 'false', 'result', JSON_ARRAY()));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 11:37:40
