<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';

$user_id = $_POST['user_id'];
$code = $_POST['code'];
$so = $_POST['operative_system'];
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);

if (isset($_POST['user_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    if ($user_id == "" || $user_id == null || strlen($user_id) == 0) {
        $arrRecord['success'] = "5";
        $arrRecord['message'] = 'La sesión actual ha expirado por favor ingrese nuevamente';
        echo json_encode($arrRecord);
        exit;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT user_check_user_token_version($user_id,'$token','$code','$so');");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = 'ok';
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {
        if ($exc->getCode() == "45001") {
            $arrRecord['success'] = "2";
            $arrRecord['message'] = 'Existe una nueva versión de Faster, por favor descárgala para seguir utilizando la aplicación.';
            echo json_encode($arrRecord);
            exit;
        } else if ($exc->getCode() == "45002") {
            $arrRecord['success'] = "3";
            $arrRecord['message'] = 'Lo sentimos, la cuenta asociada a su número se encuentra inhabilitada por mal uso, para reactivarla comuniquese con servicio al cliente';
            echo json_encode($arrRecord);
            exit;
        } else if ($exc->getCode() == "45003") {
            $arrRecord['success'] = "4";
            $arrRecord['message'] = 'Has iniciado sesión con tu número de teléfono desde otro dispositivo, esta sesión será cerrada';
            echo json_encode($arrRecord);
            exit;
        } else if ($exc->getCode() == "45005") {
            $arrRecord['success'] = "5";
            $arrRecord['message'] = 'No existe ninguna cuenta asociada al usuario enviado';
            echo json_encode($arrRecord);
            exit;
        } else if ($exc->getCode() == "45006") {
            $arrRecord['success'] = "6";
            $arrRecord['message'] = '¡Usted tiene un pago pendiente!';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "10";
            $arrRecord['message'] = 'Lo sentimos, por el momento no podemos procesar tu solicitud';

            echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar verificar información de usuario';
    
    echo json_encode($arrRecord);
    exit;
}
//Si para ejecutar el resto
?>