<?php

// Önbellek sınıfını projeye dahil etme
require_once 'FileCache2.php'; 

/*
// Sorgu ve parametreleri belirleme
$sql = "SELECT * FROM orakoglu_staj1.kullanicilar WHERE city = ? "; // Sorgunun SQL kodunu burada tanımlayın
$params = array("Mersin"); // Sorgu için parametreleri bir dizi olarak belirleyin
$types = "s";
*/

/*
$sql = "INSERT INTO orakoglu_staj1.kullanicilar(username, surname, email, telno, gender, city)
    VALUES(?, ?, ?, ?, ?, ?)"; // Sorgunun SQL kodunu burada tanımlayın
$params = array("melikegozdas","gozdas", "mg61@gmail.com","555","Kadın","Eskişehir"); // Sorgu için parametreleri bir dizi olarak belirleyin
// types string=s, integer=i, boolean=b, double=d
$types = "ssssss";
*/


$jsonData = '{"username":"melikegozdas","surname":"gzds","email":"mg5@gmailcom","telno":"1234567890","gender":"female","city":"Eskişehir"}';

$sql = "CALL kaydet(?)";
$params = array(
    $jsonData,
);
$types = "s";

/*
$sql = "CALL sehirGoster(?, ?)";
$params = array(
    "Eskişehir", "result"
);
$types = "ss";
*/

$time = 60;

// Önbellek sınıfını başlatma ve önbelleğe veriyi yükleme
$fileCache = new FileCache($sql, $params, $types, $time);
$fileCache->result();
/*
// Önbellekten veriyi alma veya veritabanından çekme
$cachedData = $fileCache->get();
if ($cachedData !== null) {
    echo "Önbellekteki veri:<br>";
    echo "<br>";
    print_r($cachedData);
} 
else {
    // Önbellekte veri yok, veritabanından çek
    $stmt = $mysqli->prepare($sql);
    // Parametreleri bağlama
    $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = [
        'title' => $params[0],
        'author' => $params[1],
        'category' => $params[2],
        'status' => $params[3]
    ];

    // Veriyi önbelleğe ekleme
    $fileCache->put($data);

    echo "Veritabanında sorgu çalıştı.<br>";
}
*/

// Veritabanı bağlantısını kapat
//$mysqli->close();
?>