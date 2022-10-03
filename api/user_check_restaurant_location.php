<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');

$user_id = $_POST['user_id'];
$lat = $_POST['lat'];
$lon = $_POST['lon'];
//if ($_POST['city'] == 'Santo Domingo') {
//    $_POST['city'] = 'Santo Domingo de los Colorados';
//}
$city = $_POST['city'];
$code = $_POST['code'];
$so = $_POST['operative_system'];
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$verificarSesion = verifyInfoUserVersion($user_id, $code, $so, $token);


if (isset($_POST['user_id'], $_POST['lat'], $_POST['lon'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    if (!$verificarSesion['verify']) {
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT user_check_restaurant_location_city('" . $lat . "','" . $lon . "');");
        $arrRecord['success'] = "1";
        $arrRecord['city'] = $consulta[0][0];
        $arrRecord['message'] = 'ok';
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {
        if ($exc->getCode() == "45004") {
            $arrRecord['success'] = "200";
            $arrRecord['message'] = 'Lo sentimos, aún no tenemos cobertura en tu zona.';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45004") {
            $arrRecord['success'] = "201";
            $arrRecord['message'] = 'Lo sentimos, aún no tenemos cobertura en tu zona.';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "202";
            $arrRecord['message'] = 'Lo sentimos, por el momento no podemos procesar tu solicitud para buscar tiendas cercanos';
             echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetros al intentar buscar tiendas cercanas';
    echo json_encode($arrRecord);
    exit;
}
?>