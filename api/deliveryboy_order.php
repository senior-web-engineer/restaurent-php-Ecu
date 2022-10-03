<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
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
        $sqlLibre = mysqli_query($conn, "SELECT delivery_boy_count_bookorders(" . $deliverboy_id . ") AS pedidosactuales;");
        $rowsLibre = mysqli_fetch_array($sqlLibre);

        $sqlAtendiendoDel = false;
        $sqlAtendiendo = mysqli_query($conn, "SELECT `attendance` FROM `fooddelivery_delivery_boy` WHERE `id`=$deliverboy_id");
        while ($rows = mysqli_fetch_array($sqlAtendiendo)) {
            if ($rows['attendance'] == 'yes') {
                $sqlAtendiendoDel = true;
            }
        }
        //$DeliveryBoyAttendance = mysqli_fetch_array($sqlAtendiendo);
        
        //obtener datos de Riders
        $query_level = mysqli_query($conn, "SELECT `attendance`, `level_id`, `DESC_LEVELS` FROM `view_delivery_level` WHERE `id`=$deliverboy_id");
        $DeliveryBoyLevel = mysqli_fetch_array($query_level);
        //$DeliveryBoyAttendance = mysqli_fetch_array($sqlAtendiendo);
        if ($rowsLibre['pedidosactuales'] > 0) {
            $assigned = "1";
            $sql = mysqli_query($conn, "SELECT `id`, `res_id`, `status`, `created_at`, `orig_id`, `address`, `total_price`, `delivery_price`, `total_general`, bookorder_get_seconds_next_show(id) AS `time_rest`"
                    . " FROM `fooddelivery_bookorder` "
                    . "WHERE `is_assigned`='" . $deliverboy_id . "' AND `status` IN(1,3,5);");
        } else if ($sqlAtendiendoDel) {
            $assigned = "0";

            $sql = mysqli_query($conn, "SELECT FB.status, FB.id, FB.res_id, FB.delivery_price, FB.created_at, FB.address, FB.total_general, FB.total_price, FB.orig_id AS `orig_id`, bookorder_get_seconds_next_show(FB.id) AS `time_rest`,"
                        . " ROUND((6371 * ACOS(COS(RADIANS(FDB.longitude )) * COS(RADIANS(FR.lon)) * "
                        . " COS(RADIANS(FR.lat) - RADIANS(FDB.latitude)) + SIN(RADIANS(FDB.longitude )) * SIN(RADIANS(FR.lon)))), 2) AS distance"
                        . " FROM fooddelivery_bookorder AS FB "
                        . " INNER JOIN fooddelivery_restaurant AS FR ON FR.id = FB.res_id"
                        . " CROSS JOIN fooddelivery_delivery_boy AS FDB ON FDB.id = $deliverboy_id"
                        . " WHERE FB.status=0"
                        . " HAVING distance BETWEEN 0 AND 20"
                        . " ORDER BY FB.id ASC;");
        } else {
            $assigned = "0";
            $arrRecord['success'] = "230";
            $arrRecord['message'] = "¡Desconectado! | Para ver Órdenes debes estar conectado";
            $arrRecord['order'] = $data;
            $arrRecord['DeliveryBoyLevel'] = $DeliveryBoyLevel['DESC_LEVELS'];
            $arrRecord['DeliveryBoyAttendance'] = $DeliveryBoyLevel['attendance'];
            echo json_encode($arrRecord);
            exit;
        }

        while ($rows = mysqli_fetch_array($sql)) {
            /*$sqlUser = mysqli_query($conn, "SELECT `image` FROM `fooddelivery_users` WHERE `id`=" . $rows["user_id"] . ";");
            $rowsUser = mysqli_fetch_array($sqlUser);*/

            $sqlRestaurant = mysqli_query($conn, "SELECT `name` FROM `fooddelivery_restaurant` WHERE `id`='" . $rows["res_id"] . "'");
            $rowsRestaurant = mysqli_fetch_array($sqlRestaurant);
            //$currency = $rows3['currency'];
            $created_at = date_format(date_create($rows['created_at']), "d-m-Y H:i:s");
            $status = $rows['status'];
			$notes = $rows['orig_id'];

            if ($notes == 1) {
                $record = 'App';
            } elseif ($notes == 2) {
                $record = 'Web';
            } elseif ($notes == 3) {
                $record = 'Web Aliado';
            } elseif ($notes == 4) {
                $record = 'Compra Web';
            } elseif ($notes == 5) {
                $record = 'Compra Web Cliente';
            } elseif ($notes == 6) {
                $record = 'App iOS';
            }

            $data[] = array(
                "status" => $status,
              	"created_at" => $created_at,
                "order_no" => $rows['id'],
                "order_address" => $rows['address'],
                "total_amount" => $rows['total_price'],
                "delivery_price" => $rows['delivery_price'],
                "total_general" => $rows['total_general'],
                "time_rest" => $rows['time_rest'],
                "status" => $status,
                "DeliveryNotes" => $record,
                "restaurant_name" => $rowsRestaurant['name'],
                "DeliveryBoyLevelId" => $DeliveryBoyLevel['level_id']
            );
        }
        
        if (isset($data)) {
            if (!empty($data)) {
                $arrRecord['success'] = "1";
                $arrRecord['message'] = "Órdenes listadas";
                $arrRecord['assigned'] = $assigned;
                $arrRecord['order'] = $data;
                $arrRecord['DeliveryBoyLevel'] = $DeliveryBoyLevel['DESC_LEVELS'];
                $arrRecord['DeliveryBoyAttendance'] = $DeliveryBoyLevel['attendance'];
                echo json_encode($arrRecord);
                exit;
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['message'] = "¡Conectado! | No se encontraron Órdenes";
                $arrRecord['DeliveryBoyLevel'] = $DeliveryBoyLevel['DESC_LEVELS'];
                $arrRecord['DeliveryBoyAttendance'] = $DeliveryBoyLevel['attendance'];
                echo json_encode($arrRecord);
                exit;
            }
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['message'] = "¡Conectado! | No se encontraron Órdenes";
            $arrRecord['DeliveryBoyLevel'] = $DeliveryBoyLevel['DESC_LEVELS'];
            $arrRecord['DeliveryBoyAttendance'] = $DeliveryBoyLevel['attendance'];
            echo json_encode($arrRecord);
            exit;
        }
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