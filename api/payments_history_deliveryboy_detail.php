<?php

include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();
mysqli_set_charset($conn, "utf8");
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$deliverboy_id = filter_var($_POST['deliverboy_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
if (isset($_POST['deliverboy_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization']) && isset($_REQUEST["payment_id"])) {
    $verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6' && $verificarSesion['success'] != '-7' && $verificarSesion['success'] != '-3') {
        $consulta = $_conexion->select("SELECT  delivery_boy_get_presence($deliverboy_id);");
        $verificarSesion['attendance'] = $consulta[0][0];
        echo json_encode($verificarSesion);
        exit;
    }
    $payment_id = $_REQUEST["payment_id"];
    $deliverboy_id = $_REQUEST["deliverboy_id"];
    $sql = mysqli_query($conn, "SELECT *,bookorder_get_seconds_next_show(id) as time_rest ,restaurant_get_name(res_id) as restaurant_name,payments_get_amount_bookorder_deliveryboy(id) AS "
            . "payment_amount,payments_get_base_bookorder_deliveryboy(id) AS payment_base,payments_get_comision_bookorder_deliveryboy(id) AS payment_comision "
            . "FROM fooddelivery_bookorder WHERE "
            . "is_assigned='$deliverboy_id' "
            . " AND id IN(SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id =(SELECT id FROM fooddelivery_payments "
            . "WHERE id=$payment_id))"
            . " AND status in(2,4,7) ORDER BY  id DESC");
    while ($rows = mysqli_fetch_array($sql)) {

        $sql2 = mysqli_query($conn, "SELECT * FROM fooddelivery_food_desc WHERE order_id='" . $rows["id"] . "'");
        $rows2 = mysqli_num_rows($sql2);
        $date = date("d-m-Y H:i:s", $rows['created_at']);

        $sql3 = mysqli_query($conn, "SELECT currency FROM fooddelivery_restaurant WHERE id='" . $rows["res_id"] . "'");
        $rows3 = mysqli_fetch_array($sql3);
        $currency = $rows3['currency'];

        $dollar = explode('-', $currency);
        $val = $dollar[1];
        $_text_status = "";
        if ($res['status'] == 0) {
            $_text_status = "Buscando repartidor";
        } else if ($res['status'] == 1) {
            $_text_status = "Aceptado por la Tienda";
        } else if ($res['status'] == 2) {
            $_text_status = "Rechazo por la Tienda";
        } else if ($res['status'] == 3) {
            $_text_status = "Repartidor en camino";
        } else if ($res['status'] == 4) {
            $_text_status = "Pedido entregado";
        } else if ($res['status'] == 5) {
            $_text_status = "Aceptado por repartidor";
        } else if ($res['status'] == 6) {
            $_text_status = "Sin respuesta de repartidores";
        } else if ($res['status'] == 7) {
            $_text_status = "Sin respuesta de la Tienda";
        }
        $data[] = array(
            "payment_amount" => $rows['payment_amount'],
            "payment_comision" => $rows['payment_comision'],
            "payment_base" => $rows['payment_base'],
            "restaurant_name" => $rows['restaurant_name'],
            "order_address" => $rows['address'],
            "order_no" => $rows['id'],
            "total_amount" => $rows['total_price'],
            "delivery_price" => $rows['delivery_price'],
            "items" => $rows2,
            "date" => $date,
            "currency" => $val,
            "status" => $status,
            "time_rest" => $rows['time_rest'],
            "text_status" => $_text_status,
            "status" => $rows['status']
        );
    }

    if (isset($data)) {
        if (!empty($data)) {
            $arrRecord['success'] = "1";
            $arrRecord['order'] = $data;
            $arrRecord['message'] = 'Detalle de pago listados';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['message'] = 'No tiene carreras realizadas';
            echo json_encode($arrRecord);
            exit;
        }
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['message'] = 'No tiene carreras realizadas';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar consultar detalle de historial de pagos';

    echo json_encode($arrRecord);
    exit;
}
?>