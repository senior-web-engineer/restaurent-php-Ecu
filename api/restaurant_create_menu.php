<?php

include "../application/db_config.php";
include '../order_message.php';
include 'error_response.php';
$arrRecord = array();

if (isset($_REQUEST["restaurant_id"], $_REQUEST["name"])) {
    $restaurant_id = $_REQUEST["restaurant_id"];
    $name = $_REQUEST['name'];
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT restaurant_update_menu(" . $restaurant_id . ",'" . $name . "');");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "Categoría ingresada exitosamente";
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {
        if ($exc->getCode() == "45001") {
            $arrRecord['success'] = "2";
            $arrRecord['message'] = "Ya tiene una categoría con el nombre ingresado";
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "10";
            $arrRecord['message'] = "Lo sentimos, en este momento no podemos procesar tu solicitud.";
            echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['message'] = $order_no_processed;
}
echo json_encode($arrRecord);
?>