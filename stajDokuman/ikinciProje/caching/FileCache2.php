<?php
class FileCache
{
    private $sql;
    private $params;
    private $types;
    private $cacheKey;
    private $cacheTime;

    private $cacheDirectory = 'cache'; // Önbellek dosyalarının saklanacağı klasör
    private $config;
    private $mysqli; // Veritabanı bağlantısı

    public function __construct($sql, $params, $types, $cacheTime)
    {
        $this->sql = $sql;
        $this->params = $params;
        $this->types = $types;
        $this->cacheKey = md5($sql . serialize($params));
        $this->cacheTime = $cacheTime; 
        $this->config = include("mlk_ayarlar.php");
        // Veritabanı bağlantısını oluşturma
        $servername = $this->config['servername'];
        $username = $this->config['username'];
        $password = $this->config['password'];
        $dbname = $this->config['dbname'];
        $this->mysqli = new mysqli($servername, $username, $password, $dbname);
        // Bağlantıyı kontrol et
        if ($this->mysqli->connect_error) {
            die("Bağlantı hatası: " . $this->mysqli->connect_error);
        }
        
        // Önbellek dizinini belirleme
        $cacheDirectory = 'cache';
        if (!file_exists($cacheDirectory)) {
            mkdir($cacheDirectory, 0777, true);
        }
        
    }

    public function get()
    {
        $cacheFile = $this->getCacheFilePath();

        if (file_exists($cacheFile) && filemtime($cacheFile) > time() - $this->cacheTime) {
            return unserialize(file_get_contents($cacheFile));
        }
        return null;

    }

    public function put($data)
    {
        if ($this->cacheTime > 0) { // cacheTime sıfırdan büyükse
        $cacheFile = $this->getCacheFilePath();
        file_put_contents($cacheFile, serialize($data));
        }
    }

    private function getCacheFilePath()
    {
        $hashedKey = $this->cacheKey;
        return $this->cacheDirectory . '/' . $hashedKey;
    }

    public function result()
    {
    $cachedData = $this->get(); // Mevcut önbelleği al
    if ($cachedData !== null) {
        echo "Önbellekteki veri:<br>";
        echo "<br>";
        print_r($cachedData);
    } 
    else {
        // Önbellekte veri yok, veritabanından çek
        $stmt = $this->mysqli->prepare($this->sql);
        // Parametreleri bağlama
        $stmt->bind_param($this->types, ...$this->params);
        $stmt->execute();
        $result = $stmt->get_result();
        
        while ($row = $result->fetch_all()) {
            $data[] = $row;
        }
        // Veriyi önbelleğe ekleme
        $this->put($data);
        $cachedData = $data;
        echo "Veritabanında sorgu çalıştı.<br>";
        // mysqli bağlantısını kapat
        $this->mysqli->close();
    }
    }
}
?>
