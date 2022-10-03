<meta charset="UTF-8">
<?php
include "../application/db_config.php";
include '../order_message.php';
include 'error_response.php';
$arrRecord = array();

//$deliveryBody = $_REQUEST["deliverboy_id"];
$order_id = $_REQUEST["order_id"];
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$deliverboy_id = filter_var($_POST['deliverboy_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);

if (isset($_POST['order_id'], $_POST['deliverboy_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    $verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
    if (!$verificarSesion['verify']) {
        $consulta = $_conexion->select("SELECT delivery_boy_get_presence($deliverboy_id);");
        $verificarSesion['attendance'] = $consulta[0][0];
        echo json_encode($verificarSesion);
        exit;
    }

    //Push Notification
    $order_user = mysqli_query($conn, "SELECT `id`, `notes`, `user_id`, `res_id` FROM `fooddelivery_bookorder` WHERE `id`='" . $order_id . "' AND `notes` <> '3'");
    $user = mysqli_fetch_array($order_user);
    $user_id = $user['user_id'];
    $rest_id = $user['res_id'];
    // $is_assigned = $user['is_assigned'];

    //consulta rider
    $sqlRider = mysqli_query($conn, "SELECT `name` FROM `fooddelivery_delivery_boy` WHERE `id`='" . $deliverboy_id . "'");
    $rider = mysqli_fetch_array($sqlRider);
    $name = explode(" ", $rider['name']);
    $explName = $name[0];

    /*$query = mysqli_query($conn, "select timezone from fooddelivery_adminlogin where id ='1'");
    $fetch = mysqli_fetch_array($query);
    $timezone = $fetch['timezone'];

    $default_time = explode(" - ", $timezone);
    $vals = $default_time[0];
    date_default_timezone_set($vals);*/
    $date = date('d-m-Y H:i');
    try {
        $consulta = $_conexion->select("SELECT bookorder_assign_order(" . $_REQUEST["deliverboy_id"] . ",'" . $date . "'," . $order_id . ");");
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
            $arrRecord['message'] = 'La orden se encuentra asignada a un repartidor y deberá ser aceptada o rechazada por el la Tienda!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45004") {
            $arrRecord['success'] = "4";
            $arrRecord['message'] = 'La orden se encuentra aceptada por la Tienda y deberá ser recogida por el repartidor!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45005") {
            $arrRecord['success'] = "5";
            $arrRecord['message'] = 'Lo sentimos, la orden fue encuentra rechazada por la Tienda!';
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
            $arrRecord['message'] = 'La orden ya fue rechazada automaticamente por expiración del tiempo de aceptación por parte del repartidor!';
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
            $arrRecord['message'] = "Lo sentimos no podemos procesar tu solicitud al intentar aceptar la orden";
            echo json_encode($arrRecord);
            exit;
        }
    }
    if (isset($sql)) {
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "Has aceptado la orden, comunícate con la tienda de inmediato.";

        /*$queryDeliveryBoysFree = mysqli_query($conn, "SELECT
            t.*,
            ROUND((6371 * ACOS(COS(RADIANS(b.longitude )) * COS(RADIANS(r.lon)) * COS(RADIANS(r.lat) - RADIANS(b.latitude)) + SIN(RADIANS(b.longitude )) * SIN(RADIANS(r.lon)))), 2) AS distance
        FROM
            fooddelivery_tokendata AS t
            INNER JOIN fooddelivery_delivery_boy AS b ON b.id = t.delivery_boyid
            CROSS JOIN fooddelivery_restaurant AS r ON r.id = $rest_id
        WHERE
            t.type = 'android'
            AND t.delivery_boyid IN (SELECT id
                                    FROM
                                        (SELECT
                                            id, DELIVERY_BOY_COUNT_BOOKORDERS_TODAY(id) AS orders
                                        FROM
                                            fooddelivery_delivery_boy
                                        WHERE
                                            PAYMENTS_VERIFY_EXPIRED_DELIVERYBOY(id) = 0
                                                AND attendance = 'yes'
                                                AND status = 'active'
                                                AND session = 'yes'
                                                AND id NOT IN (SELECT DISTINCT
                                                    is_assigned
                                                FROM
                                                    fooddelivery_bookorder
                                                WHERE
                                                    status IN (5,3,1,0))
                                        ORDER BY orders ASC) AS sub1)
        HAVING distance BETWEEN 0 AND 20;");
        $iDelivery = 0;
        $reg_idDelivery = array();
        while ($resDelivery = mysqli_fetch_array($queryDeliveryBoysFree)) {
            $reg_idDelivery[$iDelivery] = $resDelivery['token'];
            $iDelivery++;
        }
        $dataDelivery = array(
            'title' => 'Pedido aceptado por un repartidor',
            'message' => 'Un pedido disponible ya fue aceptado por un repartidor',
            'click_action' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
            'show_push' => 'false',
            'show_dialog' => 'true',
            'activity_dialog' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
            'button_dialog' => 'Ok'
        );
        $fieldsDelivery = array(
            'registration_ids' => $reg_idDelivery,
            'data' => $dataDelivery,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fieldsDelivery);*/

        //Enviar notificación al restaurante
        $queryOwnerRestaurant = mysqli_query($conn, "SELECT `token` FROM `fooddelivery_tokendata` WHERE `type` IN ('android','web') AND `restaurant_ownerid` IN (SELECT `id` FROM `fooddelivery_res_owner` WHERE `res_id`='$rest_id');");
        $i = 0;
        $reg_id = array();
        while ($resOwnerRestaurant = mysqli_fetch_array($queryOwnerRestaurant)) {
            $reg_id[$i] = $resOwnerRestaurant['token'];
            $i++;
        }
        $dataRestaurant = array(
            'title' => 'Orden nueva',
            'message' => 'Existe una nueva orden para ti, acepta lo antes posible y ten lista la orden para que retire el repartidor 🙌.',
            'click_action' => 'aliado.faster.com.ec.RestaurantStatus_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'aliado.faster.com.ec.RestaurantStatus_TARGET',
            'button_dialog' => 'Ingresar'
        );
        $fields = array(
            'registration_ids' => $reg_id,
            'data' => $dataRestaurant,
            "time_to_live" => 0
        );
        sendNotificationAndroid($conn, $fields);
        //Fin Enviar notificación al restaurante

        //Enviar notificación al cliente
        $queryClient = mysqli_query($conn, "SELECT `token` FROM `fooddelivery_tokendata` WHERE `type`='android' AND  `user_id`='$user_id';");
        $iClient = 0;
        $reg_idCliente = array();
        while ($resClient = mysqli_fetch_array($queryClient)) {
            $reg_idCliente[$iClient] = $resClient['token'];
            $iClient++;
        }
        $dataClient = array(
            'title' => 'Orden asignada',
            'message' => $explName . ' está atendiendo tu pedido 🤩.',
            'click_action' => 'faster.com.ec.CompleteOrder_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'faster.com.ec.DialogActivitySimple_TARGET',
            'button_dialog' => 'Ingresar'
        );
        $fieldsClient = array(
            'registration_ids' => $reg_idCliente,
            'data' => $dataClient,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fieldsClient);
        //Fin Enviar notificación al cliente
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['message'] = "Orden no fue procesada";
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['message'] = "Error de envío de parámetros al intentar aceptar orden";
}
echo json_encode($arrRecord);
exit;
?>