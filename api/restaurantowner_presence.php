<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
mysqli_set_charset($conn, 'utf8');
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$status = filter_var($_POST['status'], FILTER_SANITIZE_STRING);
$restaurantowner_id = filter_var($_POST['restaurantowner_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
if (isset($_POST['status'], $_POST['restaurantowner_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    $verificarSesion = verifyInfoRestaurantOwnerVersion($restaurantowner_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-8') {
        $consulta = $_conexion->select("SELECT restaurant_owner_get_presence($restaurantowner_id);");
        $verificarSesion['status'] = $consulta[0][0];
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $consultaDelivery = $_conexion->select("SELECT restaurant_owner_presence($restaurantowner_id,'$status');");
        $consulta = $_conexion->select("SELECT restaurant_owner_get_presence($restaurantowner_id);");
        $arrRecord['presence'] = $consulta[0][0];
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "ok";
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {
        $arrRecord['success'] = "204";
        $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al intentar modificar disponibilidad';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar modificar disponibilidad';

    echo json_encode($arrRecord);
    exit;
}
?>