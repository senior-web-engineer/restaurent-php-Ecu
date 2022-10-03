<?php

include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();
mysqli_set_charset($conn, "utf8");
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$restaurant_id = $_REQUEST["restaurant_id"];
$restaurantowner_id = $_REQUEST["restaurantowner_id"];
if (isset($_REQUEST["restaurant_id"], $_REQUEST["restaurantowner_id"], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    $verificarSesion = verifyInfoRestaurantOwnerVersion($restaurantowner_id, $code, $so, $token);
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-8') {
        echo json_encode($verificarSesion);
        exit;
    }
    $sql = mysqli_query($conn, "SELECT `id`, `created_at`, `status`, user_id, delivery_price, total_price, restaurant_get_name(`res_id`) AS `restaurant_name` FROM `fooddelivery_bookorder` "
            . "WHERE `res_id`='" . $restaurant_id . "' "
            . "AND `status` in(2,3,4)"
                ." AND DATE(`created_at`)>DATE(NOW()) - INTERVAL 60 DAY "
            . " ORDER BY `id` DESC");


    while ($rows = mysqli_fetch_array($sql)) {

        $sql2 = mysqli_query($conn, "SELECT * FROM `fooddelivery_food_desc` WHERE `order_id`='" . $rows["id"] . "'");
        $rows2 = mysqli_num_rows($sql2);
        $date = date_format(date_create($rows['created_at']), 'd-m-Y H:i:s');

        $sql3 = mysqli_query($conn, "SELECT `currency` FROM `fooddelivery_restaurant` WHERE `id`='" . $rows["res_id"] . "'");
        $rows3 = mysqli_fetch_array($sql3);
        $currency = $rows3['currency'];
        $dollar = explode('-', $currency);
        $val = $dollar[1];

        $_text_status = "";
        if ($rows['status'] == 0) {
            $_text_status = "Buscando repartidor";
        } else if ($rows['status'] == 1) {
            $_text_status = "Aceptado por la tienda";
        } else if ($rows['status'] == 2) {
            $_text_status = "Rechazado por la tienda";
        } else if ($rows['status'] == 3) {
            $_text_status = "Repartidor en camino";
        } else if ($rows['status'] == 4) {
            $_text_status = "Pedido entregado";
        } else if ($rows['status'] == 5) {
            $_text_status = "Aceptado por repartidor";
        } else if ($rows['status'] == 6) {
            $_text_status = "Sin respuesta de repartidores";
        } else if ($rows['status'] == 7) {
            $_text_status = "Sin respuesta de la Tienda";
        }
        $data[] = array(
            "restaurant_name" => $rows['restaurant_name'],
            "order_no" => $rows['id'],
            "user_id" => $rows['user_id'],
            "delivery_price" => $rows['delivery_price'],
            "total_amount" => $rows['total_price'],
            "items" => $rows2,
            "date" => $date,
            "currency" => $val,
            "status" => $status,
            "time_rest" => "0",
            "text_status" => $_text_status,
            "status" => $rows['status']
        );
    }

    if (isset($data)) {
        if (!empty($data)) {
            $arrRecord['success'] = "1";
            $arrRecord['order'] = $data;
            $arrRecord['message'] = "Historial de pedidos listados";
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['message'] = "No se ha encontrado historial de pedidos";
            echo json_encode($arrRecord);
            exit;
        }
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['message'] = "No se ha encontrado historial de pedidos";
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar consultar órdenes';
    echo json_encode($arrRecord);
    exit;
}
//echo '<pre>',print_r($arrRecord,1),'</pre>';
?>