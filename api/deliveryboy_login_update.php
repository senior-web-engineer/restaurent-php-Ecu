<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');


$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$email = filter_var($_POST['email'], FILTER_SANITIZE_STRING);
$password = filter_var($_POST['password'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);


if (isset($_POST['email'], $_POST['password'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {


    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->selectAssociative("CALL delivery_boy_login('$email','$password','$token','$so');");
        $deliveryboy_id = $consulta[0]['id'];

        // $verificarSesion = verifyInfoDeliveryBoyVersion($deliveryboy_id, $code, $so, $token);
        // if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6') {
        //     $verificarSesion['status'] = 1;
        //     $verificarSesion['deliveryboy_detail'] = $consulta;
        //     echo json_encode($verificarSesion);
        //     exit;
        // }
        $arrRecord['status'] = "1";
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "ok";
        $arrRecord['deliveryboy_detail'] = $consulta;
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {

        if ($exc->getCode() == "45001") {
            $arrRecord['status'] = 0;
            $arrRecord['success'] = "203";
            $arrRecord['message'] = 'Información de acceso inválida';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['status'] = 0;
            $arrRecord['success'] = "204";
            $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al intentar verificar información de acceso';
             echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['status'] = 0;
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar verificar información de acceso';
    echo json_encode($arrRecord);
    exit;
}
?>