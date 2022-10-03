<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');

$user_id = $_POST['user_id'];
$order_id = $_POST['order_id'];
$code = $_POST['code'];
$so = $_POST['operative_system'];
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$verificarSesion = verifyInfoUserVersion($user_id, $code, $so, $token);


if (isset($_POST['user_id'], $_POST['order_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    if (!$verificarSesion['verify']) {
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT bookorder_get_reason_reject(" . $user_id . "," . $order_id . ");");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = 'ok';
        $arrRecord['reason'] = $consulta[0][0];
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {
        $arrRecord['success'] = "202";
        $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud para ver detalle del pedido rechazado';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetros al intentar buscar ver detalle de pedido rechazado';
    echo json_encode($arrRecord);
    exit;
}
?>