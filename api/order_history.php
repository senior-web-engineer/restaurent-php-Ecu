<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');

$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$deliverboy_id = filter_var($_POST['deliverboy_id'], FILTER_SANITIZE_NUMBER_INT);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
if (isset($_POST['deliverboy_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {

    $verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6') {
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        
            $sql = mysqli_query($conn, "SELECT `id`, `status`, `created_at`, `total_price`, `delivery_price`, `total_general` FROM `fooddelivery_bookorder` "
                    . "WHERE `status` IN (2,4) "
                    . " AND `is_assigned`=$deliverboy_id "
                    . "ORDER BY `id` DESC;");
        

        while ($rows = mysqli_fetch_array($sql)) {
            /*$sqlUser = mysqli_query($conn, "SELECT image FROM fooddelivery_users WHERE id=" . $rows["user_id"] . ";");
            $rowsUser = mysqli_fetch_array($sqlUser);*/

            $sqlRestaurant = mysqli_query($conn, "SELECT `name` FROM `fooddelivery_restaurant` WHERE `id`='" . $rows["res_id"] . "'");
            $rowsRestaurant = mysqli_fetch_array($sqlRestaurant);
            $status = $rows['status'];
            $date = date_format(date_create($rows['created_at']), 'd-m-Y H:i:s');

            /*$currency = $rows3['currency'];
            $dollar = explode('-', $currency);
            $val = $dollar[1];
            $dateTime = $rows['assign_date_time'];
            $timestamp = strtotime($dateTime);
            $datefrom = date('d-m-Y', $timestamp);

            $today = date('d-m-Y');
            $last_date = $datefrom;*/
            $data[] = array(
                "status" => $status,
                "order_no" => $rows['id'],
                "total_amount" => $rows['total_price'],
                "delivery_price" => $rows['delivery_price'],
                "total_general" => $rows['total_general'],
                "status" => $status,
                "restaurant_name" => $rowsRestaurant['name']
            );
        }

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
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar ver la Orden';

    echo json_encode($arrRecord);
    exit;
}
?>