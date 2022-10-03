<?php

include "../application/db_config.php";
include 'error_response.php';
if (isset($_GET['phone']) && $_GET['phone'] != "") {

    $phone = "+" . $_GET['phone'];
    try {
        $_conexion = ConexionLogin::getConnection();

        $consulta = $_conexion->select("Select `id`,`fullname`,	`phone_no`,	`image` from fooddelivery_users where phone_no='$phone'");
        if (count($consulta) > 0) {
            $arrRecord['success'] = "1";
            $data[] = array("id" => $consulta[0][0], "fullname" => $consulta[0][1], "phone_no" => $consulta[0][2], "image" => $consulta[0][3], "message" => "Información listada");
            $arrRecord['order_details'] = $data;
            echo json_encode($arrRecord);
        } else {
            $arrRecord['success'] = "2";
            $data[] = array("data" => Array(), "message" => "No se encontró información");
            $arrRecord['order_details'] = $data;
            echo json_encode($arrRecord);
        }
        exit;
    } catch (Exception $exc) {
        $arrRecord['success'] = "10";
//         $data[] = array("data" => Array(), "message" => "Por el momento no podemos procesar tu solicitud");
        $data[] = array("data" => Array(), "message" => "Por el momento no podemos procesar tu solicitud");
        $arrRecord['order_details'] = $data;
        echo json_encode($arrRecord);
        exit;
    }
} else {
    echo $error;
}
?>