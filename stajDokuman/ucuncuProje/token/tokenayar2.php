<?php

$servername = "orakoglu.net";
$username = "orakoglu_xdr";
$password = "Xderiant1e99";
$dbname = "orakoglu_staj1";

try {
    $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if (isset($_POST["jsonData"])) {

        $data = json_decode($_POST["jsonData"], true);
        
        if (isset($data["token"])) {
            // Yetkilendirme sorgusu
            $tokenData = $data['token'];
            
            // JSON verisini oluştur
            $tokenData = json_encode($tokenData, JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);
            
            // Procedure 
            $stmt = $db->prepare("CALL tokenPhp(:param1, @result)");
            $stmt->bindParam(':param1', $tokenData);
            $stmt->execute();
    
            $stmt = $db->prepare("SELECT @result AS result");
            $stmt->execute();
            $sonuc = $stmt->fetch(PDO::FETCH_ASSOC);

            $tokenal = json_decode($sonuc['result'], true);
            
            if ($tokenal['durum'] == 'true') {
                try {
                    $tokenData1[0] = $tokenal['result'];
                    $tokenData1[1] = $data["islem"];
                    
                    // JSON verisini oluştur
                    $tokenData1 = json_encode($tokenData1, JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);
                    
                    $stmt = $db->prepare("CALL tokenYetki(:param1, @result)");
                    $stmt->bindParam(':param1', $tokenData1);
                    $stmt->execute();
            
                    $stmt = $db->prepare("SELECT @result AS result");
                    $stmt->execute();
                    $result = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($result['durum'] == "true") {
                        // Veritabanı işlemi başarılı
                        if (isset($data["islem"]) && isset($data['parametreler'])) {
                            for ($i = 0; $i < count($data['parametreler']); $i++) {
                                $jsonData[$i] = $data['parametreler'][$i];
                            }
                            $jsonData = json_encode($jsonData, JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);
                            try {
                                $stmt = $db->prepare("CALL " . $data["islem"] . "(:param1, @result)");
                                $stmt->bindParam(':param1', $jsonData);
                                $stmt->execute();
                                $stmt = $db->prepare("SELECT @result AS result");
                                $stmt->execute();
                                $result = $stmt->fetch(PDO::FETCH_ASSOC);
                            } catch (PDOException $e) {
                                echo "Bir şeyler başarısız oldu!<br>".$e;
                            }
                        } else {
                            echo "Geçersiz veri formatı veya eksik parametreler!";
                        }
                    } else {
                        echo "Yetkilendirme başarısız.";
                    }
                } catch (PDOException $e) {
                    echo "Bir şeyler başarısız oldu!<br>".$e;
                }
            } else {
                $result = $tokenal['result'];
            }
        } else {
            echo "Token eksik!";
        }
    } else {
        echo "jsonData post verisi eksik!";
    }
} catch (PDOException $e) {
    echo "Bağlantı başarısız: " . $e->getMessage();
}
?>
