<?php

@ob_start();
// Turn off error reporting
error_reporting(0);

// Report runtime errors
error_reporting(E_ERROR | E_WARNING | E_PARSE);

// Report all errors
error_reporting(E_ALL);

// Same as error_reporting(E   _ALL);
ini_set("error_reporting", E_ALL);

// Report all errors except E_NOTICE
error_reporting(E_ALL & ~E_NOTICE);
?> 
<?php

// $key = $getKey;
define('button', "Active");
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_PORT', '3306');
define('DB_DATABASE', 'test');
define('SECRET_KEY', 'F{I#x.,7\&~QzM4yKb+Q8cMiQ6IXv');
define('SECRET_IV', 'F?iaoD4q9$LZOH3]2>wHRI1sm');

function getDB() {
    $dbhost = DB_SERVER;
    $dbuser = DB_USERNAME;
    $dbpass = DB_PASSWORD;
    $dbname = DB_DATABASE;
    try {
        $dbConnection = new PDO("mysql:host=$dbhost;dbname=$dbname", $dbuser, $dbpass);
        $dbConnection->exec("set names utf8");
        $dbConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $dbConnection;
    } catch (PDOException $e) {
        // print_r($e);
        echo 'Connection failed: ' . $e->getMessage();
        exit;
    }
}

$conn = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// $sqlKey = mysqli_query($conn, "SELECT `id`, `created_at` FROM `fooddelivery_bookorder` ORDER BY id DESC LIMIT 1");
// $fetch = mysqli_fetch_array($sqlKey);
// $getKey = $fetch['created_at'] . " * " . $fetch['id'] . ' 0987365541dfgfdgd';

$query = mysqli_query($conn, "SELECT `timezone` FROM `fooddelivery_adminlogin` WHERE `id`='1' AND `role`='1'");
$fetch = mysqli_fetch_array($query);
$timezone = $fetch['timezone'];
mysqli_set_charset($conn, "utf8");
$default_time = explode(" - ", $timezone);
$vals = $default_time[0];
date_default_timezone_set($vals);

class ConexionLogin {

    private $_strcon;
    private $_con;
    private $_respuesta;
    private $_options = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');
    static $_instance;

    protected function __construct() {
        try {
            $this->_strcon = 'mysql:host=' . DB_SERVER . ';dbname=' . DB_DATABASE . ';port=' . DB_PORT . ';';
            $this->_con = new PDO($this->_strcon, DB_USERNAME, DB_PASSWORD, $this->_options);
            $this->_con->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $ex) {
            $arreglo[0] = array('reg' => -2, 'mensaje' => 'Error de conexión de base de datos');
            echo '' . json_encode($arreglo) . '';
        }
    }

    public static function getConnection() {
        if (self::$_instance === null) {
            self::$_instance = new self();
        }
        return self::$_instance;
    }

    public function __clone() {
        return false;
    }

    public function __wakeup() {
        return false;
    }

    public function beginTransaction() {
        $this->_con->beginTransaction();
    }

    public function commit() {
        $this->_con->commit();
    }

    public function rollBack() {
        $this->_con->rollBack();
    }

    public function errorCode() {
        return $this->_con->errorCode();
    }

    public function errorInfo() {
        return $this->_con->errorInfo();
    }

    public function inTransaction() {
        return $this->_con->inTransaction();
    }

    public function lastInsertId() {
        return $this->_con->lastInsertId();
    }

    public function select($sqlQuery) {
        $this->_respuesta = $this->_con->prepare($sqlQuery);
        $this->_respuesta->execute();
        $array = $this->_respuesta->fetchAll(PDO::FETCH_NUM);
        return $array;
    }

    public function execute($sqlQuery) {
        $this->_respuesta = $this->_con->prepare($sqlQuery);
        $res = $this->_respuesta->execute();
        return $res;
    }

    public function selectAssociative($sqlQuery) {
        $this->_respuesta = $this->_con->prepare($sqlQuery);
        $this->_respuesta->execute();
        $array = $this->_respuesta->fetchAll(PDO::FETCH_ASSOC);
        return $array;
    }

}

function sendNotificationAndroid($conn, $fields) {
    $querya = mysqli_query($conn, "SELECT * FROM `fooddelivery_server_key`");
    $resa = mysqli_fetch_array($querya);
    $google_api_key = $resa['android_key'];
    $url = 'https://fcm.googleapis.com/fcm/send';
    $headers = array(
        'Authorization: key=' . $google_api_key, // . $api_key,
        'Content-Type: application/json'
    );
    $json = json_encode($fields);
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    $result = curl_exec($ch);
    if ($result === FALSE) {
        // die('Curl failed: ' . curl_error($ch));
    }
    curl_close($ch);
    $response = json_decode($result, true);
    if ($response['success'] > 0) {
        // echo 'enviado';
    } else {
        // echo 'no enviado';
        $sendresult['android'] = 0;
    }
}

function obtenerExtensionImagen($_archivo) {
    if ($_archivo["type"] == "image/png") {
        $formato = "png";
    } else if ($_archivo["type"] == "image/jpeg") {
        $formato = "jpeg";
    } else {
        $formato = "jpeg";
    }

    return $formato;
}

function verifyInfoUserVersion($user_id, $code, $so, $token) {

    if ($user_id == null || strlen($user_id) == 0) {
        $arrRecord['success'] = "5";
        $arrRecord['message'] = 'La sesión actual ha expirado por favor ingresa nuevamente';
        $arrRecord['verify'] = false;
        return $arrRecord;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT user_check_user_token_version($user_id,'$token','$code','$so');");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = 'ok';
        $arrRecord['verify_detail'] = $consulta;
        $arrRecord['verify'] = true;
        return $arrRecord;
    } catch (Exception $exc) {
        $arrRecord['verify'] = false;
        if ($exc->getCode() == "45001") {
            $arrRecord['success'] = "2";
            $arrRecord['message'] = 'Existe una nueva versión de Faster, por favor descárgala para seguir utilizando la aplicación.';
        } else if ($exc->getCode() == "45002") {
            $arrRecord['success'] = "3";
            $arrRecord['message'] = 'Lo sentimos, la cuenta asociada a tu número se encuentra inhabilitada por mal uso, para reactivarla comunícate con servicio al cliente.';
        } else if ($exc->getCode() == "45003") {
            $arrRecord['success'] = "4";
            //$arrRecord['message'] = 'Has iniciado sesión desde otro dispositivo.';
          	$arrRecord['message'] = 'La sesión ha caducado, vamos a verificar tu identidad. Por favor vuelve a ingresar un número de teléfono válido, el sistema te enviará un SMS. También debes ingresar correctamente tu nombre y apellido. ¡Faster piensa en tu seguridad!';
        } else if ($exc->getCode() == "45005") {
            $arrRecord['success'] = "5";
            $arrRecord['message'] = 'No existe ninguna cuenta asociada el usuario enviado';
        } else if ($exc->getCode() == "45006") {
            $arrRecord['success'] = "6";
            $arrRecord['message'] = '¡Usted tiene una orden pendiente!';
        } else {
            $arrRecord['success'] = "10";
            $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al verificar sesión';
        }
        return $arrRecord;
    }
}

function verifyInfoDeliveryBoyVersion($deliveryboy_id, $code, $so, $token) {
    if ($token == null || strlen($token) == 0 || $token == 'null') {
        $arrRecord['success'] = "-11";
        $arrRecord['message'] = 'Token de acceso inválido, vamos a asignar un nuevo token, ingresa tus datos nuevamente.';
        $arrRecord['verify'] = false;
        return $arrRecord;
    }
    if ($deliveryboy_id == null || strlen($deliveryboy_id) == 0) {
        $arrRecord['success'] = "-8";
        $arrRecord['message'] = 'La sesión actual ha expirado por favor ingrese nuevamente';
        $arrRecord['verify'] = false;
        return $arrRecord;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT delivery_boy_check_delivery_boy_token_version($deliveryboy_id,'$token','$code','$so');");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = 'ok';
        $arrRecord['verify_detail'] = $consulta;
        $arrRecord['verify'] = true;
        return $arrRecord;
    } catch (Exception $exc) {
        $arrRecord['verify'] = false;
        if ($exc->getCode() == "45001") {
            $arrRecord['success'] = "-2";
            $arrRecord['message'] = 'Existe una nueva versión de Faster, por favor descárgala para seguir utilizando la aplicación.';
        } else if ($exc->getCode() == "45002") {
            $arrRecord['success'] = "-3";
            $arrRecord['message'] = 'El sistema ha detectado recurrencia en el incumplimiento de los términos y condiciones de Faster Rider.';
        } else if ($exc->getCode() == "45003") {
            $arrRecord['success'] = "-4";
            $arrRecord['message'] = 'Has iniciado sesión desde otro dispositivo';
        } else if ($exc->getCode() == "45005") {
            $arrRecord['success'] = "-5";
            $arrRecord['message'] = 'No existe ninguna cuenta asociada el usuario enviado';
        } else if ($exc->getCode() == "45006") {
            $arrRecord['success'] = "-6";
            $arrRecord['message'] = '¡Usted tiene una orden pendiente!';
        } else if ($exc->getCode() == "45007") {
            $arrRecord['success'] = "-7";
            $arrRecord['message'] = '¡Usted tiene un pago pendiente!';
        } else {
            $arrRecord['success'] = "-10";
            $arrRecord['message'] = 'Lo sentimos, por el momento no podemos procesar tu solicitud al verificar sesión';
        }
        return $arrRecord;
    }
}

function verifyInfoRestaurantOwnerVersion($restaurantowner_id, $code, $so, $token) {
    if ($token == null || strlen($token) == 0 || $token == 'null') {
        $arrRecord['success'] = "-11";
        $arrRecord['message'] = 'Token de acceso inválido, vamos a asignar un nuevo token, ingresa tus datos nuevamente.';
        $arrRecord['verify'] = false;
        return $arrRecord;
    }
    if ($restaurantowner_id == null || strlen($restaurantowner_id) == 0) {
        $arrRecord['success'] = "-5";
        $arrRecord['message'] = 'La sesión actual ha expirado por favor ingrese nuevamente';
        $arrRecord['verify'] = false;
        return $arrRecord;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT restaurant_check_restaurant_owner_token_version($restaurantowner_id,'$token','$code','$so');");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = 'ok';
        $arrRecord['verify_detail'] = $consulta;
        $arrRecord['verify'] = true;
        return $arrRecord;
    } catch (Exception $exc) {
        $arrRecord['verify'] = false;
        if ($exc->getCode() == "45001") {
            $arrRecord['success'] = "-2";
            $arrRecord['message'] = 'Existe una nueva versión de Faster, por favor descárgala para seguir utilizando la aplicación.';
        } else if ($exc->getCode() == "45002") {
            $arrRecord['success'] = "-3";
            $arrRecord['message'] = 'No existe ninguna cuenta asociada el usuario enviado';
        } else if ($exc->getCode() == "45003") {
            $arrRecord['success'] = "-4";
            $arrRecord['message'] = 'Lo sentimos, tu cuenta se encuentra bloqueada por incumplimiento de normativas, para reactivarla comunícate con el departamento de soluciones.';
        } else if ($exc->getCode() == "45004") {
            $arrRecord['success'] = "-5";
            $arrRecord['message'] = 'No existe ninguna cuenta de Tienda asociada el usuario enviado';
        } else if ($exc->getCode() == "45005") {
            $arrRecord['success'] = "-6";
            $arrRecord['message'] = 'La Tienda asociada a tu cuenta se encuentra bloqueada por incumplimiento de normativas, para reactivarla comunícate con el departamento de soluciones.';
        } else if ($exc->getCode() == "45006") {
            $arrRecord['success'] = "-7";
            $arrRecord['message'] = 'Has iniciado sesión desde otro dispositivo, cerraremos la aplicación. Por favor vuelve a abrirla para ingresar nuevamente.';
        } else if ($exc->getCode() == "45007") {
            $arrRecord['success'] = "-8";
            $arrRecord['message'] = '¡Usted tiene una orden pendiente!';
        } else if ($exc->getCode() == "45008") {
            $arrRecord['success'] = "-9";
            $arrRecord['message'] = '¡Usted tiene un pago pendiente!';
        } else {
            $arrRecord['success'] = "-10";
            $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al verificar sesión';
        }
        return $arrRecord;
    }
}
?>