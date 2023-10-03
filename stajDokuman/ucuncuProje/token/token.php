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
            for ($i = 0; $i < count($data['token']); $i++) {
                // Her veriyi ilgili anahtarla eşleştirerek JSON dizisine ekle
                $tokenData[$i] = $data['token'][$i];
            }
            
            // JSON verisini oluştur
            $tokenData = json_encode($tokenData, JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);
            //Procedure 
            $stmt = $db->prepare("CALL tokenPhp(:param1, @result)");
            $stmt->bindParam(':param1', $tokenData);
            $stmt->execute();
    
            $stmt = $db->prepare("SELECT @result AS result");
            $stmt->execute();
            $innerResult = $stmt->fetch(PDO::FETCH_ASSOC);
            $tokenal = json_decode($innerResult['result'], true);
            //echo $tokenal['result'];
            //echo json_encode($tokenal['result'], JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT); 

            if ($tokenal['durum'] == 'true') {
                if(isset($data['islem']))
                {
                    
                      try {

                    
                    $tokenData2[0] = $tokenal['result'][0];
                    $tokenData2[1] = $data["islem"];
                    
                    // JSON verisini oluştur
                    $tokenData2 = json_encode($tokenData2, JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);
                    //echo $tokenData2;
                    $stmt = $db->prepare("CALL tokenYetkiler(:param1, @result)");
                    $stmt->bindParam(':param1', $tokenData2);
                    $stmt->execute();
            
                    $stmt = $db->prepare("SELECT @result AS result");
                    $stmt->execute();
                    $innerResult = $stmt->fetch(PDO::FETCH_ASSOC);
                    $result = json_decode($innerResult['result'], true);
                    echo $result['durum']; // JSON verisini bir diziye çevir
                    if ($result['durum'] === "true") {
                        for ($i = 0; $i < count($data['parametreler']); $i++) {
                
        
                            // Her veriyi ilgili anahtarla eşleştirerek JSON dizisine ekleyin
                            $jsonData[$i] = $data['parametreler'][$i];
                        }
                        
                        // JSON verisini oluşturun
                        $jsonData = json_encode($jsonData, JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);
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
                        $result = array("result" => "sefer, güzergah, durak ekleyemezsiniz");
                        echo json_encode($result, JSON_UNESCAPED_UNICODE);

                        // json_encode ile sonucu döndürün
                        //echo json_encode($result, JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);  
                    }
                } catch (PDOException $e) {
                    echo "Bir şeyler başarısız oldu!<br>".$e;
                }
                }
                else
                {
                    echo '{"result":["true"]}';
                }
                
            }
        } else {
            echo "merhaba";
            echo json_encode($tokenal['result'], JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);
        }
        // Yetkilendirme kontrolü
    }
} catch (PDOException $e) {
    echo "Bağlantı başarısız: " . $e->getMessage();
}
?>
