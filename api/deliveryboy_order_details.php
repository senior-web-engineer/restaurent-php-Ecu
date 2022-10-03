<?php

include "../application/db_config.php";
include 'error_response.php';


$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$deliverboy_id = filter_var($_POST['deliverboy_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$assign = '0';
if (isset($_POST['order_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    $verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6') {
        echo json_encode($verificarSesion);
        exit;
    }

    if ($_POST['order_id'] == "-1") {
        $query = mysqli_query($conn, "SELECT fb.is_assigned,fb.order_dni as user_dni,fb.order_note as order_note,fb.user_id as user_id,fb.add_id as add_id, fb.orig_id as orig_id, fb.id,fb.status,bookorder_get_seconds_next_show(fb.id) as time_rest, fb.created_at, count(fd.order_id) as count,fb.delivery_price,fb.total_price ,fb.total_general, fb.payment ,fb.amount_pay ,(fb.amount_pay-fb.total_general) as order_change, fb.address AS user_address, fb.lat AS user_lat, fb.long AS user_long,fb.order_phone AS user_phone,fb.order_name AS user_name, fu.image as user_image, fb.res_id as restaurant_id, fd.ItemId
        from 
        fooddelivery_bookorder fb 
        inner join fooddelivery_food_desc fd 
        on fb.id = fd.order_id 
        inner join fooddelivery_users fu 
        on fb.user_id = fu.id
        WHERE fb.is_assigned= " . $deliverboy_id . " " . "ORDER BY fb.id DESC LIMIT 1");
    } else {

        $query = mysqli_query($conn, "SELECT fb.is_assigned,fb.order_dni as user_dni,fb.order_note as order_note,fb.user_id as user_id,fb.add_id as add_id,fb.orig_id as orig_id,fb.id,fb.status,bookorder_get_seconds_next_show(fb.id) as time_rest, fb.created_at, count(fd.order_id) as count,fb.delivery_price,fb.total_price ,fb.total_general, fb.payment,fb.amount_pay,(fb.amount_pay-fb.total_general) as order_change, fb.address AS user_address, fb.lat AS user_lat, fb.long AS user_long,fb.order_phone AS user_phone,fb.order_name AS user_name, fu.image as user_image, fb.res_id as restaurant_id  , fd.ItemId
        from 
        fooddelivery_bookorder fb 
        inner join fooddelivery_food_desc fd 
        on fb.id = fd.order_id 
        inner join fooddelivery_users fu 
        on fb.user_id = fu.id
        WHERE fb.id= " . $_REQUEST['order_id'] . " "
                . "ORDER BY fb.id DESC");
    }
    $res = mysqli_fetch_array($query);

    $queryRestaurant = mysqli_query($conn, "SELECT `name`,`address`,`photo`,`phone`,`lat`,`lon` FROM `fooddelivery_restaurant` WHERE `id`=" . $res['restaurant_id'] . ";");
    $_REQUEST['order_id'] = $res['id'];
    $resRestaurant = mysqli_fetch_array($queryRestaurant);
    $_text_status = "";
    
    //obtener datos de Riders
    $query_level = mysqli_query($conn, "SELECT `level_id`, `DESC_LEVELS` FROM `view_delivery_level` WHERE `id`=$deliverboy_id");
    $DeliveryBoyLevel = mysqli_fetch_array($query_level);

    //obtener direcion de cliente
    $sql_address = mysqli_query($conn, "SELECT * FROM `fooddelivery_delivery_address` WHERE `id`=" . $res['add_id'] . "");
    $address = mysqli_fetch_array($sql_address);

    //obtener metodo de pago
    $query_pay = mysqli_query($conn, "SELECT `desc` FROM `fooddelivery_payment_method` WHERE `id`=" . $res['payment'] . "");
    $payment_method = mysqli_fetch_array($query_pay);

    if ($res['is_assigned'] == $deliverboy_id && strlen($deliverboy_id) > 0) {
        $assign = '1';
    } else {
        $assign = '0';
    }

    if ($res['status'] == 0) {
        $_text_status = "Buscando un Rider";
        $assign = '1';
    } else if ($res['status'] == 1) {
        $_text_status = "Aceptado por la tienda";
    } else if ($res['status'] == 2) {
        $_text_status = "Anulada por la tienda";
    } else if ($res['status'] == 3) {
        $_text_status = "En camino a entregar";
    } else if ($res['status'] == 4) {
        $_text_status = "Orden entregada";
    } else if ($res['status'] == 5) {
        $_text_status = "Pendiente aceptar por la tienda";
    } else if ($res['status'] == 6) {
        $_text_status = "Sin respuesta de repartidores";
        $assign = '0';
    } else if ($res['status'] == 7) {
        $_text_status = "Sin respuesta de la tienda";
    }

    if ($res['orig_id'] == 1){
        $record = 'App';
    } elseif ($res['orig_id'] == 2) {
        $record = 'Web';
    } elseif ($res['orig_id'] == 3) {
        $record = 'Web Aliado';
    } elseif ($res['orig_id'] == 4) {
        $record = 'Compra Web';
    } elseif ($res['orig_id'] == 5) {
        $record = 'Compra Web Cliente';
    } elseif ($res['orig_id'] == 6) {
        $record = 'App iOS';
    }

    //$date = date_format(date_create($res['created_at']), 'd-M-Y H:i:s');
    $dataOrder[] = array(
        "text_status" => $_text_status,
        "notes" => $record,
        "status" => $res['status'],
        "order_no" => $res['id'],
        "order_change" => $res['order_change'],
        "order_price" => $res['total_price'],
        "order_note" => $res['order_note'] == "" ? "Ninguna" : $res['order_note'],
        "total_general" => $res['total_general'],
        "delivery_price" => $res['delivery_price'],
        "amount_pay" => $res['amount_pay'],
        "payment" => $payment_method['desc'],
        "time_rest" => $res['time_rest']
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
        "delivery_address" => $address['address'],
        "delivery_alias" => $address['alias'],
        "delivery_phone" => $address['phone'],
        "delivery_note" => $address['delivery_note'],
        "department_number" => $address['department_number']
    );
    $dataRestaurant[] = array(
        "restaurant_name" => $resRestaurant['name'],
        "restaurant_address" => $resRestaurant['address'],
        "restaurant_photo" => $resRestaurant['photo'],
        "restaurant_phone" => $resRestaurant['phone'],
        "restaurant_lat" => $resRestaurant['lat'],
        "restaurant_lon" => $resRestaurant['lon']
    );
    $dataDeliveryBoyLevel[] = array(
        "level_id" => $DeliveryBoyLevel['level_id'],
        "desc_levels" => $DeliveryBoyLevel['DESC_LEVELS']
    );

    $arrName = array();
    $query_name = mysqli_query($conn, "SELECT fd.order_id, fd.ItemId, fd.ItemQty, fd.ItemAmt, fs.id, fs.name, fs.desc from 
        fooddelivery_food_desc fd inner join fooddelivery_submenu fs on fd.ItemId = fs.id
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
            $arrRecord['assign'] = $assign;
            $arrRecord['success'] = "1";
            $arrRecord['order'] = $dataOrder[0];
            $arrRecord['user'] = $dataUser[0];
            $arrRecord['restaurant'] = $dataRestaurant[0];
            $arrRecord['DeliveryBoyLevel'] = $dataDeliveryBoyLevel[0];
            $arrRecord['message'] = "Detalle de orden enviada";
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['assign'] = $assign;
            $arrRecord['success'] = "0";
            $arrRecord['message'] = "No se encontró información de la orden enviado";
            echo json_encode($arrRecord);
            exit;
        }
    } else {
        $arrRecord['assign'] = $assign;
        $arrRecord['success'] = "0";
        $arrRecord['message'] = "No se encontró información del pedido enviado";
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['assign'] = $assign;
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar ver pedidos';

    echo json_encode($arrRecord);
    exit;
}
?>