<?php 
// Önbellek sınıfını projeye dahil etme
require_once 'FileCache2.php'; 

if (isset($_POST["jsonData"])) {
    $data = json_decode($_POST["jsonData"], true);
    if (isset($data['parametreler'])){
    for ($i = 0; $i < count($data['parametreler']); $i++) {
        // Her veriyi ilgili anahtarla eşleştirerek JSON dizisine ekleyin
        $jsonData[$i] = $data['parametreler'][$i];
    } 
    // JSON verisini oluşturun
    $jsonData = json_encode($jsonData,JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT);  
    }else{$jsonData ='{"0":"bos"}';}


    $sql = "CALL ".$data["islem"]."(?,@result)";
    $params = array(
        $jsonData,
    );
    $types = "s";
    $time = 60;
    $fileCache = new FileCache($sql, $params, $types, $time);
    $fileCache->result();

} else {
    echo "jsonData post verisi eksik!";
}
?>