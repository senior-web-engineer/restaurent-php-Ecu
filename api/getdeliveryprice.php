<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';

//Verify if account is active
mysqli_set_charset($conn, 'utf8');

$res_id = $_REQUEST['res_id'];
$lat = $_REQUEST['lat'];
$lon = $_REQUEST['long'];
//if ($_REQUEST['city'] == 'Santo Domingo') {
//    $_REQUEST['city'] = 'Santo Domingo de los Colorados';
//}
$city = $_REQUEST['city'];

try {
    $_conexion = ConexionLogin::getConnection();
    $consulta = $_conexion->select("SELECT bookorder_get_deliveryprice(" . $res_id . ",'" . $lat . "','" . $lon . "','" . $city . "');");
    $arrRecord['success'] = "1";
    $data[] = array("delivery_price" => $consulta[0][0]);
    $arrRecord['order_details'] = $data;
    echo json_encode($arrRecord);
    exit;
} catch (Exception $exc) {
    if ($exc->getCode() == "45001") {
        $arrRecord['success'] = "2";
        $data[] = array("message" => 'Lo sentimos la ciudad enviada para el pedido no se encuentra registrada');
        $arrRecord['order_details'] = $data;
        echo json_encode($arrRecord);
        exit;
    } else if ($exc->getCode() == "45002") {
        $arrRecord['success'] = "3";
        $data[] = array("message" => 'Lo sentimos la Tienda al que envía la orden no existe');
        $arrRecord['order_details'] = $data;
        echo json_encode($arrRecord);
        exit;
    } else if ($exc->getCode() == "45004") {
        $arrRecord['success'] = "4";
        $data[] = array("message" => 'Lo sentimos no se aceptan pedidos para la Tienda desde su ubicación');
        $arrRecord['order_details'] = $data;
        echo json_encode($arrRecord);
        exit;
    } else if ($exc->getCode() == "45003") {
        $arrRecord['success'] = "5";
        $data[] = array("message" => 'Lo sentimos la Tienda en este momento no está atentido');
        $arrRecord['order_details'] = $data;
        echo json_encode($arrRecord);
        exit;
    } else {
        $arrRecord['success'] = "10";
        $data[] = array("message" => 'Lo sentimos por el momento no podemos procesar tu solicitud');
        $arrRecord['order_details'] = $data;
        echo json_encode($arrRecord);
        exit;
    }
}
?>