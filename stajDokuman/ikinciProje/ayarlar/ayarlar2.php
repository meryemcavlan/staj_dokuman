<?php
$servername = "orakoglu.net";
$username = "orakoglu_xdr";
$password = "Xderiant1e99";
$dbname = "orakoglu_staj1";

try {
    $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    if(isset($_POST["jsonData"])){
 
    $data1=$_POST["jsonData"];
    // JSON veriyi PHP dizisine dönüştür
    $data = json_decode($data1, true);
    
    // "islem" anahtarının değerini al
    $islem = $data["islem"];
    
    echo $islem;
    // İşlemi kontrol et
    if ($islem=="register") {
        if (isset($data['parametreler'])){
            $veri=$data['parametreler'];
            $data = array(
                'username' => $veri[0],
                'surname' => $veri[1],
                'email' => $veri[2],
                'telno' => $veri[3],
                'gender' => $veri[4],
                'city' => $veri[5]

            );

            
            $jsonData = json_encode($data);
            try{
                $stmt = $db->prepare("CALL $islem(:param1)");
                $stmt->bindParam(':param1',$jsonData);
                $stmt->execute();
            }catch(PDOException $e){
                echo "JSON encoding failed!";
            }
                
                

        }
    
    }else if($islem=="sehirGoster"){
        
        if ($islem == "sehirGoster") {
            $veri = $data['parametreler'];
            try {
                $stmt = $db->prepare("CALL sehirGoster(:param1, @result)");
                $stmt->bindParam(':param1', $veri[0], PDO::PARAM_STR);
                $stmt->execute();
        
                // OUT parametresini almak için bir sorgu daha yapalım
                $stmt = $db->prepare("SELECT @result AS result");
                $stmt->execute();
                $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
                $sonuc = $result['result']; // OUT parametresi burada kullanılabilir
        
                echo "Saklı yordamın döndürdüğü sonuç: " . $sonuc;
            } catch (PDOException $e) {
                echo "nerde yanlışlık";
            }
        }
        


    }
     else {
        // Diğer işlemleri burada yapabilirsiniz
        return "Başarısız";
    }}

} catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>
