<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');


$phone_no = filter_var($_POST['phone_no'], FILTER_SANITIZE_STRING);

if (isset($_POST['phone_no'])) {
    try {

        $_conexion = ConexionLogin::getConnection();
        // CONSULTA OBTIENE : id,fullname,email,phone_no,referal_code,image,created_at,login_with
        $consulta = $_conexion->selectAssociative("CALL user_get_user_by_phone('$phone_no');");
        if (count($consulta) > 0) {
            $cont = 0;
            while ($cont < count($consulta)) {
                $consulta[$cont]['fullname'] = htmlspecialchars_decode($consulta[$cont]['fullname'], ENT_QUOTES);
                $consulta[$cont]['image'] = htmlspecialchars_decode($consulta[$cont]['image'], ENT_QUOTES);
                $cont++;
            }
            $arrRecord['success'] = "1";
            $arrRecord['user_detail'] = $consulta;
            $arrRecord['message'] = 'ok';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "2";
            $arrRecord['user_detail'] = array();
//            $arrRecord['message'] = "No se encontró información con el teléfono enviado";
            echo json_encode($arrRecord);
            exit;
        }
    } catch (Exception $exc) {
        $arrRecord['success'] = "10";
        $arrRecord['user_detail'] = array();
        $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $data[] = array("message" => 'Error de envío de parámetos al intentar registrar información de usuario');
    $arrRecord['user_detail'] = $data;
    echo json_encode($arrRecord);
    exit;
}
?>