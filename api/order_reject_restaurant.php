<?php

include "../application/db_config.php";
include '../order_message.php';
include 'error_response.php';
$arrRecord = array();
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);

$order_id = $_REQUEST["order_id"];
$reason_reject = $_REQUEST["reason_reject"];
$restaurant_id = $_REQUEST["restaurant_id"];
$restaurantowner_id = $_REQUEST["restaurantowner_id"];
if (isset($_POST['order_id'], $_POST['reason_reject'], $_POST['restaurant_id'], $_POST['restaurantowner_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {


    $verificarSesion = verifyInfoRestaurantOwnerVersion($restaurantowner_id, $code, $so, $token);
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-8') {
        echo json_encode($verificarSesion);
        exit;
    }
    //Push Notification
    $order_user = mysqli_query($conn, "select * from fooddelivery_bookorder WHERE `id`='" . $order_id . "'");
    $user = mysqli_fetch_array($order_user);
    $user_id = $user['user_id'];
    $is_assigned = $user['is_assigned'];

    $query = mysqli_query($conn, "select timezone from fooddelivery_adminlogin where id ='1'");
    $fetch = mysqli_fetch_array($query);
    $timezone = $fetch['timezone'];

    $default_time = explode(" - ", $timezone);
    $vals = $default_time[0];
    date_default_timezone_set($vals);
    $date = date('d-m-Y H:i');

    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT bookorder_reject_order_restaurant(" . $restaurant_id . ",'" . $date . "'," . $order_id . ",'" . $reason_reject . "');");
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
            $arrRecord['message'] = 'Lo sentimos, la orden se encuentra rechazada por la Tienda!';
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
            $arrRecord['message'] = 'Lo sentimos, la orden ya fue rechazada automaticamente por expiración del tiempo de aceptación por parte del repartidor!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45009") {
            $arrRecord['success'] = "9";
            $arrRecord['message'] = 'Lo sentimos, la orden ya fue rechazada automaticamente por expiración del tiempo de aceptación por parte de la Tienda!';
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
            $arrRecord['message'] = "Lo sentimos no podemos procesar tu solicitud al intentar rechazar la orden";
            echo json_encode($arrRecord);
            exit;
        }
    }
    if (isset($sql)) {
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "Haz rechazado el pedido";

        //Enviar notificación al cliente
        $queryClient = mysqli_query($conn, "SELECT * FROM fooddelivery_tokendata WHERE  type='android' AND user_id='$user_id';");
        $iCliente = 0;
        $reg_idCliente = array();
        while ($resDelivery = mysqli_fetch_array($queryClient)) {
            $reg_idCliente[$iCliente] = $resDelivery['token'];
            $iCliente++;
        }
        $dataClient = array(
            'title' => 'Pedido rechazado',
            'message' => 'Tu pedido ha sido rechazado por la Tienda',
            'click_action' => 'faster.com.ec.CompleteOrder_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'faster.com.ec.DialogActivitySimple_TARGET',
            'button_dialog' => 'Ingresar',
        );
        $fieldsCliente = array(
            'registration_ids' => $reg_idCliente,
            'data' => $dataClient,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fieldsCliente);
        //Fin Enviar notificación al cliente
        //Enviar notificación a los delivery boy
        $queryDeliveryBoysAssign = mysqli_query($conn, "SELECT * FROM fooddelivery_tokendata WHERE  type='android' AND delivery_boyid='$is_assigned';");
        $iDelivery = 0;
        $reg_idDelivery = array();
        while ($resDelivery = mysqli_fetch_array($queryDeliveryBoysAssign)) {
            $reg_idDelivery[$iDelivery] = $resDelivery['token'];
            $iDelivery++;
        }
        $dataDeliveryBoy = array(
            'title' => 'Pedido rechazado',
            'message' => 'Tu pedido asignado fue rechazado por la Tienda',
            'click_action' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'repartidor.faster.com.ec.DialogActivity_TARGET',
            'button_dialog' => 'Ingresar',
        );
        $fieldsDelivery = array(
            'registration_ids' => $reg_idDelivery,
            'data' => $dataDeliveryBoy,
            "time_to_live" => 0,
            "priority" => "high"
        );

        sendNotificationAndroid($conn, $fieldsDelivery);
        //Fin Enviar notificación a los delivery
        //Enviar notificación al restaurante
        $queryOwnerRestaurant = mysqli_query($conn, "SELECT * FROM fooddelivery_tokendata WHERE token<>'$token' AND (type='android' AND  restaurant_ownerid in (SELECT id FROM fooddelivery_res_owner WHERE res_id='$rest_id'));");
        $i = 0;
        $reg_id = array();
        while ($resOwnerRestaurant = mysqli_fetch_array($queryOwnerRestaurant)) {
            $reg_id[$i] = $resOwnerRestaurant['token'];
            $i++;
        }
        $message = array(
            'message' => $order_for_attending_restaurant_msg,
            'socket_action' => 'aliado.faster.com.ec.DeliveryStatus_TARGET',
            //'socket_action' => 'onepinpon.restaurante.DeliveryStatus_TARGET',
            'activity_dialog' => 'aliado.faster.com.ec.RestaurantStatus_TARGET',
            'show_notification' => false,
            'important' => false,
            'title' => 'Pedido rechazado');
        $fields = array(
            'registration_ids' => $reg_id,
            'data' => $message,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fields);
        //Fin Enviar notificación al restaurante
        echo json_encode($arrRecord);
        exit;
    } else {
        $arrRecord['success'] = "4";
        $arrRecord['message'] = "Lo sentimos no podemos procesar tu solicitud al rechazar pedido";
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar consultar Órdenes';
    echo json_encode($arrRecord);
    exit;
}
?>