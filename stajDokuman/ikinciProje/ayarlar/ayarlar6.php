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

        if (isset($data["islem"]) && isset($data['parametreler'])) {
        
            for ($i = 0; $i < count($data['parametreler']); $i++) {
                // Her veriyi ilgili anahtarla eşleştirerek JSON dizisine ekleme
                $jsonData[$i] = $data['parametreler'][$i];
            }
            
            // JSON verisini oluşturma
            $jsonData = json_encode($jsonData,JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);

            echo $jsonData;
            try {
                $stmt = $db->prepare("CALL " . $data["islem"] . "(:param1, @result)");
                $stmt->bindParam(':param1', $jsonData);
                $stmt->execute();
        
                $stmt = $db->prepare("SELECT @result AS result");
                $stmt->execute();
                $result = $stmt->fetch(PDO::FETCH_ASSOC);
                //echo $result['result'];
                
            } catch (PDOException $e) {
                echo "Bir şeyler başarısız oldu!<br>".$e;
            }
        } else {
            echo "Geçersiz veri formatı veya eksik parametreler!";
        }
    } else {
        echo "jsonData post verisi eksik!";
    }
} catch (PDOException $e) {
    echo "Bağlantı başarısız: " . $e->getMessage();
}
?>
