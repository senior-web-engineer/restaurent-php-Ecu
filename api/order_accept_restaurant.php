<?php
include '../application/db_config.php';
include '../system/controllers/encriptacion.php';
//include '../order_message.php';
//include 'error_response.php';
$objEncrip = new cEncriptacion();

$arrRecord = array();
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$order_id = $_REQUEST["order_id"];
$restaurant_id = $_REQUEST["restaurant_id"];
$time_order = $_REQUEST["time_order"];
$restaurantowner_id = $_REQUEST["restaurantowner_id"];
if (isset($_POST['order_id'], $_POST['time_order'], $_POST['restaurant_id'], $_POST['restaurantowner_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    $verificarSesion = verifyInfoRestaurantOwnerVersion($restaurantowner_id, $code, $so, $token);
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-8') {
        echo json_encode($verificarSesion);
        exit;
    }
    //Push Notification
    $order_user = mysqli_query($conn, "SELECT `id`, `res_id`, `user_id`, `order_phone`, `orig_id`, `delivery_price`, `is_assigned` FROM `fooddelivery_bookorder` WHERE `id`='" . $order_id . "'");
    $user = mysqli_fetch_array($order_user);
    $user_id = $user['user_id'];
    $res_id = $user['res_id'];
    $is_assigned = $user['is_assigned'];
    $notes = $user['orig_id'];
    $order_phone = str_replace(' ', '', $user['order_phone']);
    $delivery_price = $user['delivery_price'];


    $date = date('Y-m-d H:i:s');
    try {
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->select("SELECT bookorder_accept_order_restaurant(" . $restaurant_id . ",'" . $date . "'," . $order_id . ",'" . $time_order . "');");
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
            $arrRecord['message'] = 'La orden ya fue rechazada automaticamente por expiración del tiempo de aceptación por parte del repartidor!';
            echo json_encode($arrRecord);
            exit;
        } elseif ($exc->getCode() == "45009") {
            $arrRecord['success'] = "9";
            $arrRecord['message'] = 'Lo sentimos, la orden ya fue rechazada automaticamente por expiración del tiempo de aceptación por parte del restaurante!';
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
        $arrRecord['message'] = "Te has comprometido en tener listo el pedido, el repartidor llegará en " . $time_order . " minutos.";

        //envio de notificación WhatsApp cliente Compra Web
        if ($notes == '4') {
            //consulta datos rider
            $query_rider = mysqli_query($conn, "SELECT `name`, `vehicle_no`, `vehicle_type` FROM `fooddelivery_delivery_boy` WHERE `id` = {$is_assigned};");
            $ListRider = mysqli_fetch_array($query_rider);
            $Rider = explode(" ", $ListRider['name']);
            $nameRider = $Rider[0];
            $vehicle_no = $ListRider['vehicle_no'];
            $vehicle_type = $ListRider['vehicle_type'];

            $random = rand(1, 9000);
            $newDate = date('s') . $random;
            $hora = date('H:i');
            //$order_accept = mt_rand(8, 18);
            $horaActual = '';
            if ($hora >= '18:00') {
                $horaActual = 'Feliz noche 🤗.';
            } else {
                $horaActual = 'Feliz día 🤗.';
            }
            $OrderRiderId = $objEncrip->encrypt($newDate . "=" . $order_id);

            //envio de notificacion WhatsApp
            $curl = curl_init();
            curl_setopt_array($curl, array(
                CURLOPT_URL => "https://api.ultramsg.com/instance10025/messages/chat",
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_ENCODING => "",
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 30,
                CURLOPT_SSL_VERIFYHOST => 0,
                CURLOPT_SSL_VERIFYPEER => 0,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => "POST",
                CURLOPT_POSTFIELDS => "token=58vjtfb5gh9lxo3r&to={$order_phone}&body=¡Hola! Soy HANNA, asistente virtual de Faster.%0AConfirmamos tu orden *Nº {$order_id}.* _{$nameRider},_ está a cargo de tu pedido. {$vehicle_type} con Placa {$vehicle_no}. Tiempo aproximado de preparación es de {$time_order} minutos. %0A*Delivery $" . $delivery_price . "*%0A%0A_*Monitorea tu pedido aquí*_ 🛰 https://app.faster.com.ec/system/tracking?token={$OrderRiderId}. _Además, podrás calificar nuestro servicio ⭐, ver el detalle del pedido, consejos de seguridad y ver los datos del repartidor._%0A*Responde un OK para activar el link.*%0A%0A☝🏼 *Primero Ecuador* 🇪🇨%0A{$horaActual}%0A%0A📱 ```Descarga Faster Delivery App en Play Store.```&priority=10&referenceId=",
                CURLOPT_HTTPHEADER => array(
                    "content-type: application/x-www-form-urlencoded"
                ),
            ));
            //Enviar notificación a los delivery boy
            $queryDeliveryBoysAssign = mysqli_query($conn, "SELECT `token` FROM `fooddelivery_tokendata` WHERE `type`='android' AND `delivery_boyid`='$is_assigned';");
            $iDelivery = 0;
            $reg_idDelivery = array();
            while ($resDelivery = mysqli_fetch_array($queryDeliveryBoysAssign)) {
                $reg_idDelivery[$iDelivery] = $resDelivery['token'];
                $iDelivery++;
            }

            $data = 'Esta orden fue registrada desde la app de cliente, realiza el proceso en tiempo real desde tu aplicación. Revisa las notas de la orden para entregar con éxito.';
            $dataDeliveryBoy = array(
                'title' => $nameStore . ' aceptó el pedido',
                'message' => $data,
                'click_action' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
                'show_push' => 'true',
                'show_dialog' => 'true',
                'activity_dialog' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
                'button_dialog' => 'Ingresar'
            );
            $fieldsDelivery = array(
                'registration_ids' => $reg_idDelivery,
                'data' => $dataDeliveryBoy,
                "time_to_live" => 0,
                "priority" => "high"
            );
            sendNotificationAndroid($conn, $fieldsDelivery);
            $arrRecord['success'] = "1";
            $arrRecord['message'] = "Te has comprometido en tener listo el pedido, el repartidor llegará en " . $time_order . " minutos.";
            echo json_encode($arrRecord);

            $response = curl_exec($curl);
            $err = curl_error($curl);

            curl_close($curl);

            if ($err) {
                echo "cURL Error #:" . $err;
            } else {
                echo $response;
            }
            exit;
        }
        //fin

        //consulta tienda
        $orderStore = mysqli_query($conn, "SELECT `name` FROM `fooddelivery_restaurant` WHERE `id`='" . $res_id . "'");
        $store = mysqli_fetch_array($orderStore);
        $nameStore = $store['name'];

        //Enviar notificación al cliente
        $queryClient = mysqli_query($conn, "SELECT `token` FROM `fooddelivery_tokendata` WHERE `type`='android' AND `user_id`='$user_id';");
        $iCliente = 0;
        $reg_idCliente = array();
        while ($resDelivery = mysqli_fetch_array($queryClient)) {
            $reg_idCliente[$iCliente] = $resDelivery['token'];
            $iCliente++;
        }
        $dataClient = array(
            'title' => 'Faster',
            'message' => $nameStore . ' está preparando tu pedido. Gracias por apoyar al desarrollo económico 🇪🇨.',
            'click_action' => 'faster.com.ec.CompleteOrder_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'faster.com.ec.DialogActivitySimple_TARGET',
            'button_dialog' => 'Ingresar'
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
        $queryDeliveryBoysAssign = mysqli_query($conn, "SELECT `token` FROM `fooddelivery_tokendata` WHERE `type`='android' AND `delivery_boyid`='$is_assigned';");
        $iDelivery = 0;
        $reg_idDelivery = array();
        while ($resDelivery = mysqli_fetch_array($queryDeliveryBoysAssign)) {
            $reg_idDelivery[$iDelivery] = $resDelivery['token'];
            $iDelivery++;
        }

        $data = 'Esta orden fue registrada desde la app de cliente, realiza el proceso en tiempo real desde tu aplicación. Revisa las notas de la orden para entregar con éxito.';
        $dataDeliveryBoy = array(
            'title' => $nameStore . ' aceptó el pedido',
            'message' => $data,
            'click_action' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
            'button_dialog' => 'Ingresar'
        );
        $fieldsDelivery = array(
            'registration_ids' => $reg_idDelivery,
            'data' => $dataDeliveryBoy,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fieldsDelivery);
        echo json_encode($arrRecord);
        exit;
    } else {
        $arrRecord['success'] = "4";
        $arrRecord['message'] = "Lo sentimos no podemos procesar tu solicitud al aceptar pedido";
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar aceptar pedido';
    echo json_encode($arrRecord);
    exit;
}
