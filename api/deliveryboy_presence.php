<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');

$session = filter_var($_POST['session'], FILTER_SANITIZE_STRING);
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$attendance = filter_var($_POST['attendance'], FILTER_SANITIZE_STRING);
$deliverboy_id = filter_var($_POST['deliverboy_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
if (isset( $_POST['attendance'], $_POST['deliverboy_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    $verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
     if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6') {
        $consulta = $_conexion->select("SELECT delivery_boy_get_presence($deliverboy_id);");
        $verificarSesion['attendance'] = $consulta[0][0];
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $consultaDelivery = $_conexion->select("SELECT delivery_boy_presence($deliverboy_id,'$attendance') as presence;");
        $consulta = $_conexion->select("SELECT delivery_boy_get_presence($deliverboy_id);");       
        $arrRecord['attendance'] = $consulta[0][0];
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