<?php
include "../application/db_config.php";
include 'error_response.php';

mysqli_set_charset($conn, 'utf8');
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$restaurantowner_id = filter_var($_POST['restaurantowner_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
if (isset($_POST['order_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    $verificarSesion = verifyInfoRestaurantOwnerVersion($restaurantowner_id, $code, $so, $token);
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-8') {
        $verificarSesion['restaurantowner_detail'] = $consulta;
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $query = mysqli_query($conn, "SELECT fb.user_id as user_id ,fb.order_dni as user_dni ,fb.order_note,fb.is_assigned,fb.id,fb.status,bookorder_get_seconds_next_show(fb.id) as time_rest, fb.created_at 
        , count(fd.order_id) as count,fb.delivery_price,fb.total_price ,fb.total_general 
        , fb.payment ,fb.orig_id,fb.amount_pay ,(fb.amount_pay-fb.total_general) as order_change,
       fb.address AS user_address, fb.lat AS user_lat, fb.long AS user_long,fb.order_phone AS user_phone,fb.order_name AS user_name
         , fu.image as user_image, fb.res_id as restaurant_id  , fd.ItemId
        from 
        fooddelivery_bookorder fb 
        inner join fooddelivery_food_desc fd 
        on fb.id = fd.order_id 
        inner join fooddelivery_users fu 
        on fb.user_id = fu.id
        WHERE fb.id= " . $_REQUEST['order_id'] . " "
                . "ORDER BY fb.id DESC");

        $res = mysqli_fetch_array($query);

        $queryDeliveryboy = mysqli_query($conn, "SELECT * FROM fooddelivery_delivery_boy WHERE id=" . $res['is_assigned'] . ";");

        $resDeliveryboy = mysqli_fetch_array($queryDeliveryboy);
        $_text_status = "";
        if ($res['status'] == 0) {
            $_text_status = "Buscando repartidor";
        } else if ($res['status'] == 1) {
            $_text_status = "Repartidor en camino";
        } else if ($res['status'] == 2) {
            $_text_status = "Rechazado por la tienda";
        } else if ($res['status'] == 3) {
            $_text_status = "En camino al domicilio";
        } else if ($res['status'] == 4) {
            $_text_status = "Pedido entregado";
        } else if ($res['status'] == 5) {
            $_text_status = "Esperando tu aceptación";
        } else if ($res['status'] == 6) {
            $_text_status = "Sin respuesta de repartidores";
        } else if ($res['status'] == 7) {
            $_text_status = "Sin respuesta de la Tienda";
        }
        //$date = date("d-M-Y H:s:ia", $res['created_at']);
        $dataOrder[] = array(
            "text_status" => $_text_status,
            "status" => $res['status'],
            "order_change" => $res['order_change'],
            "order_price" => $res['total_price'],
            "total_general" => $res['total_general'],
            "delivery_price" => $res['delivery_price'],
            "amount_pay" => $res['amount_pay'],
            "payment" => $res['payment'],
            "time_rest" => $res['time_rest'],
            "notes" => (($res['order_note'] == null || $res['order_note'] == '') ? 'Ninguna' : $res['order_note'] )
        );
        $dataUser[] = array(
            "user_id" => $res['user_id'],
            "user_address" => $res['user_address'],
            "user_name" => $res['user_name'],
            "user_phone" => $res['user_phone'],
            "user_lat" => $res['user_lat'],
            "user_long" => $res['user_long'],
            "user_image" => $res['user_image'],
            "user_dni" => $res['user_dni'],
        );
        $dataDeliveryboy[] = array(
            "deliveryboy_name" => $resDeliveryboy['name'],
            "deliveryboy_image" => $resDeliveryboy['image'],
            "deliveryboy_vehicle_type" => $resDeliveryboy['vehicle_type'],
            "deliveryboy_vehicle_no" => $resDeliveryboy['vehicle_no'],
            "deliveryboy_phone" => $resDeliveryboy['phone']
        );

        $arrName = array();
        $query_name = mysqli_query($conn, "SELECT fd.order_id, fd.ItemId, fd.ItemQty, fd.ItemAmt, fs.id , fs.name, fs.desc  from fooddelivery_food_desc fd inner join fooddelivery_submenu fs on fd.ItemId = fs.id
        WHERE fd.order_id = '" . $_REQUEST['order_id'] . "'");

        while ($res_name = mysqli_fetch_array($query_name)) {
            $arrName[] = array(
                "name" => $res_name['name'],
                "description" => $res_name['desc'],
                "qty" => $res_name['ItemQty'],
                "amount" => $res_name['ItemAmt']
            );
            $arrName;
        }

        $dataOrder[0]['item_name'] = $arrName;

        if (isset($dataOrder)) {
            if (!empty($dataOrder)) {
                $arrRecord['success'] = "1";
                $arrRecord['order'] = $dataOrder[0];
                $arrRecord['user'] = $dataUser[0];
                $arrRecord['deliveryboy'] = $dataDeliveryboy[0];
                $arrRecord['message'] = "Información de orden listada";
                echo json_encode($arrRecord);
                exit;
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['message'] = "No se encontró información de la orden enviada";
                echo json_encode($arrRecord);
                exit;
            }
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['message'] = "No se encontró información de el pedido enviado";
            echo json_encode($arrRecord);
            exit;
        }
    } catch (Exception $exc) {

        $arrRecord['status'] = "10";
        $arrRecord['success'] = "204";
        $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al intentar consultar órdenes';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar consultar órdenes';
    echo json_encode($arrRecord);
    exit;
}
?>