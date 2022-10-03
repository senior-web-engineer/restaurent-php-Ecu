<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
//$deliverboy_id = filter_var($_POST['deliverboy_id'], FILTER_SANITIZE_NUMBER_INT);
$deliverboy_id = '45';
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
//if (isset($_POST['deliverboy_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    //$verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
//    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6') {
//        echo json_encode($verificarSesion);
//        exit;
//    }
    try {

        $sql = mysqli_query($conn, "SELECT *,payments_verify_bookorder_exist(id) as exist_payment,bookorder_get_seconds_next_show(id) as time_rest,payments_get_amount_bookorder_deliveryboy(id) AS "
                . "payment_amount,payments_get_base_bookorder_deliveryboy(id) AS payment_base,payments_get_comision_bookorder_deliveryboy(id) AS payment_comision "
                . " FROM fooddelivery_bookorder "
                . " WHERE status  IN(2,4,6,7)  "
                . " and is_assigned=$deliverboy_id "
                . " and id NOT IN(SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id NOT IN("
                . " SELECT id "
                . " FROM fooddelivery_payments "
                . " WHERE type='deliveryboy' "
                . " AND STATUS<>'pending' "
                . " AND deliveryboy_id=$deliverboy_id)) "
                . " ORDER BY id DESC LIMIT 50;");
        

        //while ($rows = mysqli_fetch_assoc($sql)) {
            $date = date('Y-m-d');
            //$sqlUser = mysqli_query($conn, "SELECT image FROM fooddelivery_users WHERE id=" . $rows["user_id"] . ";");
            $sqlUser = mysqli_query($conn, "SELECT sum(delivery_price) AS suma FROM `fooddelivery_bookorder` WHERE DATE_FORMAT(FROM_UNIXTIME(`created_at`), '%Y-%m-%d')='$date' and `is_assigned`=45 LIMIT 1;");
            $rowsUser = mysqli_fetch_array($sqlUser);
            //$row_rs_ciudad = mysqli_fetch_assoc($sqlUser);
            //$sum = $sum + $row_rs_ciudad['SUMA'];
            
            /*$rowsUser = mysqli_fetch_array($sqlUser);
            $sql2 = mysqli_query($conn, "SELECT * FROM fooddelivery_food_desc WHERE order_id='" . $rows["id"] . "'");
            $rows2 = mysqli_num_rows($sql2);

            $sqlRestaurant = mysqli_query($conn, "SELECT name FROM fooddelivery_restaurant WHERE id='" . $rows["res_id"] . "'");
            $rowsRestaurant = mysqli_fetch_array($sqlRestaurant);
            $currency = $rows3['currency'];
            $date = date("d-m-Y H:i:s", $rows['created_at']);
            $dates = date("d-m-Y H:i:s", $rows['created_at']);
            $status = $rows['status'];

            $dollar = explode('-', $currency);
            $val = $dollar[1];
            $dateTime = $rows['assign_date_time'];
            $timestamp = strtotime($dateTime);
            $datefrom = date('d-m-Y', $timestamp);

            $today = date('d-m-Y');
            $last_date = $datefrom;
            $_text_status = "";

            if ($rows['status'] == 0) {
                $_text_status = "Buscando un Rider";
            } else if ($rows['status'] == 1) {
                $_text_status = "Aceptado por la Tienda";
            } else if ($rows['status'] == 2) {
                $_text_status = "Anulada por la Tienda";
            } else if ($rows['status'] == 3) {
                $_text_status = "Rider en camino";
            } else if ($rows['status'] == 4) {
                $_text_status = "Orden entregada";
            } else if ($rows['status'] == 5) {
                $_text_status = "Pendiente aceptar por la Tienda";
            } else if ($rows['status'] == 6) {
                $_text_status = "Sin respuesta de repartidores";
            } else if ($rows['status'] == 7) {
                $_text_status = "Sin respuesta de la Tienda";
            }*/
            $data[] = array(
                "payment_amount ==>" => $rowsUser['suma']
            );
        //}

        if (isset($data)) {
            if (!empty($data)) {
                $arrRecord['success'] = "1";
                $arrRecord['message'] = "Órdenes listadas";
                $arrRecord['order'] = $data;
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['message'] = "No se encontraron Órdenes";
            }
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['message'] = "No se encontraron Órdenes";
        }
        echo json_encode($arrRecord);
        exit;
    } catch (Exception $exc) {
        $arrRecord['success'] = "204";
        $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al intentar ver la Orden';
        echo json_encode($arrRecord);
        exit;
    }
//} else {
//    $arrRecord['success'] = "20";
//    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar ver la Orden';
//
//    echo json_encode($arrRecord);
//    exit;
//}
?>