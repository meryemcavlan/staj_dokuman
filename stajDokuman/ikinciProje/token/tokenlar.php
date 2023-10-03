<?php

$servername = "orakoglu.net";
$username = "orakoglu_xdr";
$password = "Xderiant1e99";
$dbname = "orakoglu_staj1";

try {
    $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Veritabanına bağlantı kurulamadı: " . $e->getMessage());
}

// Kullanıcı adı ve şifre
if (isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW'])) {
    $username = $_SERVER['PHP_AUTH_USER'];
    $password = $_SERVER['PHP_AUTH_PW'];
    
    $sorgu=$db->prepare("
    SELECT COUNT(*)
      FROM `orakoglu_staj1`.`tokenlar`
      WHERE kullaniciAd LIKE CONCAT('%','.$username.' , '%') AND sifre LIKE CONCAT('%', '.$password.', '%') ");
    $a=$sorgu->execute();
    echo $a;
    // Yetkilendirme kontrolü
    if ($a<1) {
        header('WWW-Authenticate: Basic realm="API Yetkilendirmesi"');
        header('HTTP/1.0 401 Unauthorized');
        echo 'Yetkilendirme başarısız.';
        exit;
    }

    // API işlemleri
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        // Örnek veriyi almak için bir GET isteği işleme
        $data = $db->prepare("SELECT *
        FROM `orakoglu_staj1`.`tokenlar`
        WHERE kullaniciAd LIKE CONCAT('%','.$username.' , '%') AND sifre LIKE CONCAT('%', '.$password.', '%') ");
        $data=$data->execute();

        header('Content-Type: application/json');
        echo json_encode($data);
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
?>
