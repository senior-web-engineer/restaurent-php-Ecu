<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');
$delivery_boy_id = filter_var($_POST['delivery_boy_id'], FILTER_SANITIZE_NUMBER_INT);
$user_id = filter_var($_POST['user_id'], FILTER_SANITIZE_NUMBER_INT);
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$order_id = filter_var($_POST['order_id'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$verificarSesion = verifyInfoUserVersion($user_id, $code, $so, $token);

if (isset($_POST['delivery_boy_id'], $_POST['order_id'], $_POST['user_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != 6) {
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("select bookorder_verify_remember_order($user_id,$order_id,$delivery_boy_id);");
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "Se ha enviado una notificación al cliente";

        echo json_encode($arrRecord);
        //Enviar notificación al cliente
        $queryClient = mysqli_query($conn, "SELECT * FROM fooddelivery_tokendata WHERE  type='android' AND user_id='$user_id';");
        $iCliente = 0;
        $reg_idCliente = array();
        while ($resDelivery = mysqli_fetch_array($queryClient)) {
            $reg_idCliente[$iCliente] = $resDelivery['token'];
            $iCliente++;
        }
        $dataClient = array(
            'title' => 'Tu pedido ha llegado',
            'message' => 'El repartidor está fuera de tu casa, por favor sal a recibir el pedido',
            'click_action' => 'faster.com.ec.CompleteOrder_TARGET',
            'show_push' => 'false',
            'show_dialog' => 'true',
            'activity_dialog' => 'faster.com.ec.DialogActivitySimple_TARGET',
            'button_dialog' => 'Ingresar',
        );
        $fieldsCliente = array(
            'registration_ids' => $reg_idCliente,
            'data' => $dataClient,
            "time_to_live" => 20
        );
        sendNotificationAndroid($conn, $fieldsCliente);
        exit;
    } catch (Exception $exc) {
        if ($exc->getCode() == "45034") {
            $arrRecord['success'] = "203";
            $arrRecord['message'] = 'La orden enviada no existe';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45035") {
            $arrRecord['success'] = "204";
            $arrRecord['message'] = 'No le puede recordar al cliente ya que entregó o aún no recibe la orden';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45036") {
            $arrRecord['success'] = "205";
            $arrRecord['message'] = 'El usuario enviado no coincide con el de la orden';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45037") {
            $arrRecord['success'] = "206";
            $arrRecord['message'] = 'La orden aún no está asignada';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "207";
            $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al recordar al cliente';
            echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar recordar al cliente';
    echo json_encode($arrRecord);
    exit;
}
?>