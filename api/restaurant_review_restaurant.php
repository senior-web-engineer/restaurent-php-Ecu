<?php

include "../application/db_config.php";
include '../order_message.php';
include 'error_response.php';
$arrRecord = array();

//$api = new apicontroller();

extract($_GET);
if (isset($res_id) && $res_id != "" &&
        isset($user_id) && $user_id != "" &&
        isset($review_text) &&
        isset($ratting) && $ratting != "") {
    $arrRecord = Array();
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT restaurant_qualify_restaurant(" . $res_id . "," . $user_id . ",'" . $review_text . "','" . $ratting . "');");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "Calificación realizada correctamente";
        echo "[" . json_encode($arrRecord) . "]";
        exit;
    } catch (Exception $exc) {
        $arrRecord['success'] = "10";
        $arrRecord['message'] = "No podemos procesar tu solicitud por el momento";
        echo "[" .json_encode($arrRecord). "]";
        exit;
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['message'] = "Error de envio de parámetros";
    echo "[" .json_encode($arrRecord). "]";
    exit;
}
?>