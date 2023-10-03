<?php

$servername = "orakoglu.net";
$username = "orakoglu_xdr";
$password = "Xderiant1e99";
$dbname = "orakoglu_staj1";

try {
    $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if (isset($_POST["jsonData"])) {
        $data1 = $_POST["jsonData"];
        $data = json_decode($data1, true);
        $islem = $data["islem"];
       
        if ($islem == "register" && isset($data['parametreler'])) {
            $veri = $data['parametreler'];
            $jsonData = json_encode([
                'username' => $veri[0],
                'surname' => $veri[1],
                'email' => $veri[2],
                'telno' => $veri[3],
                'gender' => $veri[4],
                'city' => $veri[5]
            ]);
            try {
                $stmt = $db->prepare("CALL $islem(:param1)");
                $stmt->bindParam(':param1', $jsonData);
                $stmt->execute();
            } catch (PDOException $e) {
                echo "JSON encoding failed!";
            }
        } elseif ($islem == "sehirGoster" && isset($data['parametreler'])) {
            $veri = $data['parametreler'];
            try {
                $stmt = $db->prepare("CALL sehirGoster(:param1, @result)");
                $stmt->bindParam(':param1', $veri[0], PDO::PARAM_STR);
                $stmt->execute();

                $stmt = $db->prepare("SELECT @result AS result");
                $stmt->execute();
                $result = $stmt->fetch(PDO::FETCH_ASSOC);
                echo $result['result'];
            } catch (PDOException $e) {
                echo "nerde yanlışlık";
            }
        } else {
            echo "Başarısız";
        }
    }
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>
