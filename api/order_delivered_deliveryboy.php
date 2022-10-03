<meta charset="UTF-8">
<?php

include "../application/db_config.php";
include '../order_message.php';
include 'error_response.php';
$arrRecord = array();
$order_id = $_REQUEST['order_id'];
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$deliverboy_id = filter_var($_POST['deliverboy_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);

if (isset($_POST['order_id'], $_POST['deliverboy_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    $verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6' && $verificarSesion['success'] != '-7') {
        $consulta = $_conexion->select("SELECT  delivery_boy_get_presence($deliverboy_id);");
        $verificarSesion['attendance'] = $consulta[0][0];
        echo json_encode($verificarSesion);
        exit;
    }

    //Push Notification
    $order_user = mysqli_query($conn, "SELECT `id`, `orig_id`, `user_id`, `res_id`, `is_assigned` FROM `fooddelivery_bookorder` WHERE `orig_id`='1' AND `id`='" . $order_id . "'");
    $user = mysqli_fetch_array($order_user);
    $user_id = $user['user_id'];
    $rest_id = $user['res_id'];

    $query = mysqli_query($conn, "select timezone from fooddelivery_adminlogin where id ='1'");
    $fetch = mysqli_fetch_array($query);
    $timezone = $fetch['timezone'];

    $default_time = explode(" - ", $timezone);
    $vals = $default_time[0];
    date_default_timezone_set($vals);
    $date = date('d-m-Y H:i');
    try {
        $consulta = $_conexion->select("SELECT bookorder_delivered_order(" . $_REQUEST["deliverboy_id"] . ",'" . $date . "'," . $order_id . ");");
        $sql = true;
    } catch (Exception $exc) {
        $sql = false;
        if ($exc->getCode() == "45002") {
            $arrRecord['success'] = "2";
            $arrRecord['message'] = "La orden no existe";
            echo json_encode($arrRecord);
            exit;
        } else if ($exc->getCode() == "45003") {
            $arrRecord['success'] = "3";
            $arrRecord['message'] = 'La orden se encuentra asignada a un repartidor y deberá ser aceptada o rechazada por la Tienda!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45004") {
            $arrRecord['success'] = "4";
            $arrRecord['message'] = 'La orden se encuentra aceptada por la Tienda y deberá ser recogida por el repartidor!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45005") {
            $arrRecord['success'] = "5";
            $arrRecord['message'] = 'Lo sentimos, la orden  se encuentra rechazada por la Tienda!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45006") {
            $arrRecord['success'] = "6";
            $arrRecord['message'] = 'La orden fue recogida y deberá ser entregada por el repartidor!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45007") {
            $arrRecord['success'] = "7";
            $arrRecord['message'] = 'La orden ya fue entregada al cliente!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45008") {
            $arrRecord['success'] = "8";
            $arrRecord['message'] = 'Lo sentimos, la orden ya fue rechazada automaticamente por expiración del tiempo de aceptaciÃ³n por parte del repartidor!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45009") {
            $arrRecord['success'] = "9";
            $arrRecord['message'] = 'Lo sentimos, la orden ya fue rechazada automaticamente por expiración del tiempo de aceptaciÃ³n por parte de la Tienda!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45010") {
            $arrRecord['success'] = "10";
            $arrRecord['message'] = "La orden fue calificada anteriormente";
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45011") {
            $arrRecord['success'] = "11";
            $arrRecord['message'] = "La orden fue enviada por el cliente y deberá ser aceptado o rechazado por el repartidor";
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "12";
            $arrRecord['message'] = "Lo sentimos no podemos procesar tu solicitud al intentar entregar la orden";
            echo json_encode($arrRecord);
            exit;
        }
    }
    if (isset($sql)) {
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "Pedido entregado por el Repartidor";

        //Enviar notificaciÃ³n al cliente
        $queryClient = mysqli_query($conn, "SELECT * FROM fooddelivery_tokendata WHERE  type='android' AND user_id='$user_id';");
        $iCliente = 0;
        $reg_idCliente = array();
        while ($resDelivery = mysqli_fetch_array($queryClient)) {
            $reg_idCliente[$iCliente] = $resDelivery['token'];
            $iCliente++;
        }
        $dataClient = array(
            'title' => 'Pedido entregado',
            'message' => 'Tu pedido ha sido entregado, gracias por confiar en Faster 🧡',
            'click_action' => 'faster.com.ec.CompleteOrder_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'faster.com.ec.DialogActivitySimple_TARGET',
            'button_dialog' => 'Calificar',
        );
        $fieldsCliente = array(
            'registration_ids' => $reg_idCliente,
            'data' => $dataClient,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fieldsCliente);
        //Fin Enviar notificaciÃ³n al cliente

        //Enviar notificación al restaurante
        $queryOwnerRestaurant = mysqli_query($conn, "SELECT * FROM fooddelivery_tokendata WHERE  type IN ('android','web') AND  restaurant_ownerid in (SELECT id FROM fooddelivery_res_owner WHERE res_id='$rest_id');");
        $i = 0;
        $reg_id = array();
        while ($resOwnerRestaurant = mysqli_fetch_array($queryOwnerRestaurant)) {
            $reg_id[$i] = $resOwnerRestaurant['token'];
            $i++;
        }

        //select rider
        $delyveryBoy = mysqli_query($conn, "SELECT `id`, `name` FROM `fooddelivery_delivery_boy` WHERE `id`='" . $deliverboy_id . "'");
        $rider = mysqli_fetch_array($delyveryBoy);
        $data = explode(" ", $rider['name']);
        $expl = $data[0];

        $dataRestaurant = array(
            'title' => 'Pedido entregado #' . $order_id,
            'message' => $expl . ' entrego el pedido con éxito.',
            'click_action' => 'aliado.faster.com.ec.RestaurantStatus_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'aliado.faster.com.ec.RestaurantStatus_TARGET',
            'button_dialog' => 'Ingresar'
        );
        $fieldsRestaurant = array(
            'registration_ids' => $reg_id,
            'data' => $dataRestaurant,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fieldsRestaurant);
        //Fin Enviar notificación al restaurante
    } else {
        $arrRecord['success'] = "4";
        $arrRecord['message'] = $order_no_processed;
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['message'] = $order_no_processed;
}
echo json_encode($arrRecord);
?>