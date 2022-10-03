<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
//Verify if account is active
mysqli_set_charset($conn, 'utf8');

$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$restaurantowner_id = filter_var($_POST['restaurantowner_id'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);


if (isset($_POST['restaurantowner_id'], $_POST['restaurant_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    function encode($number) {
        return strtr(rtrim(base64_encode(pack('i', $number)), '='), '+/', '-_');
    }

    $verificarSesion = verifyInfoRestaurantOwnerVersion($restaurantowner_id, $code, $so, $token);
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-8') {
        $verificarSesion['status'] = 1;
        $verificarSesion['restaurantowner_detail'] = $consulta;
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $sql = mysqli_query($conn, "SELECT `id`, `res_id`, `created_at`, `status`, `user_id`, `delivery_price`, `total_price`, `total_general`, `order_phone`, bookorder_get_seconds_next_show(id) AS `time_rest` FROM `fooddelivery_bookorder` "
                . "WHERE `res_id`='" . $_REQUEST["restaurant_id"] . "' AND (status IN(5,1) OR (status=0 and user_id=-1)) AND `orig_id` IN (1,4) ORDER BY `status` DESC, `id` DESC;");

        $sql4 = mysqli_query($conn, "SELECT `enable` FROM `fooddelivery_restaurant` WHERE `id`='" .  $_POST['restaurant_id'] . "'");
        $rows4 = mysqli_fetch_array($sql4);
        $message_enable = $rows4['enable'];

        while ($rows = mysqli_fetch_array($sql)) {
            $sql2 = mysqli_query($conn, "SELECT * FROM `fooddelivery_food_desc` WHERE `order_id`='" . $rows["id"] . "'");
            $rows2 = mysqli_num_rows($sql2);
            //$date = date_format(date_create($rows['created_at']), 'd-m-Y H:i:s');

            $sql3 = mysqli_query($conn, "SELECT `enable`,`currency`,restaurant_get_normal_orders_pending(id) as `assigned` FROM `fooddelivery_restaurant` WHERE `id`='" . $rows["res_id"] . "'");
            $rows3 = mysqli_fetch_array($sql3);
            // $currency = $rows3['currency'];
            $assigned = $rows3['assigned'];
            $message_enable = $rows3['enable'];
            // $dollar = explode('-', $currency);
            // $val = $dollar[1];
            $_text_status = "";

            if ($rows['status'] == 0) {
                $_text_status = "Buscando repartidor";
            } else if ($rows['status'] == 1) {
                $_text_status = "Aceptado por la tienda";
            } else if ($rows['status'] == 2) {
                $_text_status = "Rechazo por la tienda";
            } else if ($rows['status'] == 3) {
                $_text_status = "Repartidor en camino";
            } else if ($rows['status'] == 4) {
                $_text_status = "Pedido entregado";
            } else if ($rows['status'] == 5) {
                $_text_status = "Aceptado por repartidor";
            } else if ($rows['status'] == 6) {
                $_text_status = "Sin respuesta de repartidores";
            } else if ($rows['status'] == 7) {
                $_text_status = "Sin respuesta de la tienda";
            }

            /*$dateTime = $rows['assign_date_time'];
            $timestamp = strtotime($dateTime);
            $datefrom = date('d-m-Y', $timestamp);

            $today = date('d-m-Y');
            $last_date = $datefrom;*/

            $data[] = array(
                "order_no" => $rows['id'],
                "user_id" => $rows['user_id'],
                "delivery_price" => $rows['delivery_price'],
                "total_amount" => $rows['total_price'],
                "total_general" => $rows['total_general'],
                "items" => $rows2,
                "time_rest" => $rows['time_rest'],
                "text_status" => $_text_status,
                "status" => $rows['status'],
                "order_phone" => $rows['order_phone'],
                "order_short_id" => encode($rows['id'])
            );
        }

        if (isset($data)) {
            if (!empty($data)) {
                $arrRecord['success'] = "1";
                $arrRecord['order'] = $data;
                $arrRecord['message'] = "Órdenes listadaS";
                $arrRecord['assigned'] = $assigned;
                $arrRecord['message_enable'] = $message_enable;
                echo json_encode($arrRecord);
                exit;
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['message'] = "No se encontraron órdenes";
                $arrRecord['message_enable'] = $message_enable;
                echo json_encode($arrRecord);
                exit;
            }
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['message'] = "No se encontraron órdenes";
            $arrRecord['message_enable'] = $message_enable;
            echo json_encode($arrRecord);
            exit;
        }
    } catch (Exception $exc) {

        $arrRecord['success'] = "204";
        $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al intentar consultar Órdenes';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar consultar Órdenes';
    echo json_encode($arrRecord);
    exit;
}
