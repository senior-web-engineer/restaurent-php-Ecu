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

if (isset($_POST['deliverboy_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    $verificarSesion = verifyInfoDeliveryBoyVersion($deliverboy_id, $code, $so, $token);
    $_conexion = ConexionLogin::getConnection();
    // si es diferente de pedido pendiente
    if (!$verificarSesion['verify'] && $verificarSesion['success'] != '-6' && $verificarSesion['success'] != '-7' && $verificarSesion['success'] != '-3') {
        $consulta = $_conexion->select("SELECT  delivery_boy_get_presence($deliverboy_id);");
        $verificarSesion['attendance'] = $consulta[0][0];
        echo json_encode($verificarSesion);
        exit;
    }
    $deliverboy_id = $_REQUEST["deliverboy_id"];
    $sql = mysqli_query($conn, "SELECT now()>max_payment_date as defeated,payments_get_seconds_max_date_payment(id) as time_start,payments_count_bookorders_deliveryboy(id) as items,`id`,`create_date`,`payment_date`,`max_payment_date`,`status` "
            . ",`description`,`deliveryboy_id`,amount,base_use_aplication,comision  FROM fooddelivery_payments "
            . "WHERE type='deliveryboy' AND deliveryboy_id='$deliverboy_id' AND DATE(`create_date`)>DATE(NOW()) - INTERVAL 60 DAY ORDER BY id DESC;");
    $cont = 0;
    while ($rows = mysqli_fetch_array($sql)) {
        $rows['status'] = ($rows['defeated'] == true && $rows['status'] == 'pending') ? 'defeated' : $rows['status'];
        $data[$cont] = array(
            "id" => $rows['id'],
            "create_date" => date("d-m-Y H:i:s", strtotime($rows['create_date'])),
            "payment_date" => ($rows['payment_date'] != "" || $rows['payment_date'] != null) ? date("d-m-Y H:i:s", strtotime($rows['payment_date'])) : null,
            "max_payment_date" => date("d-m-Y H:i:s", strtotime($rows['max_payment_date'])),
            "deliveryboy_id" => $rows['deliveryboy_id'],
            "base_use_aplication" => $rows['base_use_aplication'],
            "comision" => $rows['comision'],
            "amount" => $rows['amount'],
            "status" => $rows['status'],
            "time_start" => $rows['time_start'],
            "items" => $rows['items']
        );
        $cont++;
    }

    if (isset($data)) {
        if (!empty($data)) {
            $arrRecord['success'] = "1";
            $arrRecord['order'] = $data;
            $arrRecord['message'] = 'Pagos listados';
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['message'] = 'No se ha encontrado historial de pagos';
            echo json_encode($arrRecord);
            exit;
        }
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['message'] = 'No se ha encontrado historial de pagos';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar al intentar consultar historial de pagos';

    echo json_encode($arrRecord);
    exit;
}
?>