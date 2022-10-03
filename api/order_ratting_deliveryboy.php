<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');

$user_id = filter_var($_POST['user_id'], FILTER_SANITIZE_NUMBER_INT);
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$order_id = filter_var($_POST['order_id'], FILTER_SANITIZE_STRING);
$ratting_deliveryboy = filter_var($_POST['ratting_deliveryboy'], FILTER_SANITIZE_NUMBER_INT);
$review_deliveryboy = filter_var($_POST['review_deliveryboy'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$verificarSesion = verifyInfoUserVersion($user_id, $code, $so, $token);

if (isset($_POST['ratting_deliveryboy'], $_POST['review_deliveryboy'], $_POST['order_id'], $_POST['user_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    if (!$verificarSesion['verify']) {
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("select bookorder_ratting_deliveryboy($user_id,$order_id,$ratting_deliveryboy,'$review_deliveryboy');");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "Calificación exitosa!!";
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {
        if ($exc->getCode() == "45012") {
            $arrRecord['success'] = "203";
            $arrRecord['message'] = 'El pedido ha sido calificado anteriormente';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45013") {
            $arrRecord['success'] = "204";
            $arrRecord['message'] = 'No le está permitido calificar el pedido enviado';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45014") {
            $arrRecord['success'] = "205";
            $arrRecord['message'] = 'Aun no recibe la orden por lo tanto no puede calificar';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "204";
            $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al calificar pedido';
            echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar calificar pedido';
    echo json_encode($arrRecord);
    exit;
}
?>