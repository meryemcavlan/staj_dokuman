<?php

$servername = "orakoglu.net";
$username = "orakoglu_xdr";
$password = "Xderiant1e99";
$dbname = "orakoglu_staj1";

try {
    $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if (isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW'])) {
        $username = $_SERVER['PHP_AUTH_USER'];
        $password = $_SERVER['PHP_AUTH_PW'];
        
        // Yetkilendirme sorgusu
        $sorgu = $db->prepare("SELECT COUNT(*) FROM `tokenlar` WHERE kullaniciAd = :username AND sifre = :password");
        $sorgu->bindParam(':username', $username);
        $sorgu->bindParam(':password', $password);
        $sorgu->execute();
        $count = $sorgu->fetchColumn();

        // Yetkilendirme kontrolü
        if ($count === 0) {
            header('WWW-Authenticate: Basic realm="API Yetkilendirmesi"');
            header('HTTP/1.0 401 Unauthorized');
            echo 'Yetkilendirme başarısız.';
            exit;
        }

        // API işlemleri
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            if (isset($_POST["jsonData"])) {
                $data = json_decode($_POST["jsonData"], true);

                if (isset($data["islem"]) && isset($data['parametreler'])) {
                    // JSON verisini oluşturun
                    $jsonData = json_encode($data['parametreler'], JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);

                    try {
                        $stmt = $db->prepare("CALL " . $data["islem"] . "(:param1, @result)");
                        $stmt->bindParam(':param1', $jsonData);
                        $stmt->execute();
                
                        $stmt = $db->prepare("SELECT @result AS result");
                        $stmt->execute();
                        $result = $stmt->fetch(PDO::FETCH_ASSOC);
                        echo json_encode($result);
                        
                    } catch (PDOException $e) {
                        echo "Bir şeyler başarısız oldu!<br>".$e->getMessage();
                    }
                } else {
                    echo "Geçersiz veri formatı veya eksik parametreler!";
                }
            } else {
                echo "jsonData post verisi eksik!";
            }
        } else {
            header('HTTP/1.0 405 Method Not Allowed');
            echo 'İzin verilmeyen HTTP metodu.';
        }
    } else {
        header('WWW-Authenticate: Basic realm="API Yetkilendirmesi"');
        header('HTTP/1.0 401 Unauthorized');
        echo 'Yetkilendirme başarısız.';
        exit;
    }

} catch (PDOException $e) {
    echo "Bağlantı başarısız: " . $e->getMessage();
}
?>
