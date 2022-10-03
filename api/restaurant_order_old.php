<?php

include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();

mysqli_set_charset($conn, "utf8");

if (isset($_REQUEST["restaurant_id"])) {
    $sql = mysqli_query($conn, "SELECT * FROM fooddelivery_bookorder WHERE res_id='" . $_REQUEST["restaurant_id"] . "' and status IN(5,1);");


    while ($rows = mysqli_fetch_array($sql)) {
        $sql2 = mysqli_query($conn, "SELECT * FROM fooddelivery_food_desc WHERE order_id='" . $rows["id"] . "'");
        $rows2 = mysqli_num_rows($sql2);
        $date = date("d-M-Y H:s:ia", $rows['created_at']);

        $sql3 = mysqli_query($conn, "SELECT currency FROM fooddelivery_restaurant WHERE id='" . $rows["res_id"] . "'");
        $rows3 = mysqli_fetch_array($sql3);
        $currency = $rows3['currency'];

        $dollar = explode('-', $currency);
        $val = $dollar[1];
        if ($rows['status'] == '0') {
            $status = 'Order sent for all deliveryboys';
        } elseif ($rows['status'] == '1') {
            $status = 'Order accept for restaurant';
        } elseif ($rows['status'] == '2') {
            $status = 'Order reject for restaurant';
        } elseif ($rows['status'] == '3') {
            $status = 'Order is picked for delivery';
        } else if ($rows['status'] == '4') {
            $status = 'Order is delivered';
        } else if ($rows['status'] == '5') {
            $status = 'Order accept for deliveryboy';
        } else if ($rows['status'] == '6') {
            $status = 'Order reject automatically for deliveryboys';
        } else if ($rows['status'] == '7') {
            $status = 'Order reject automatically for restaurant';
        }

        $dateTime = $rows['assign_date_time'];
        $timestamp = strtotime($dateTime);
        $datefrom = date('d-m-Y', $timestamp);

        $today = date('d-m-Y');
        $last_date = $datefrom;
        $data[] = array(
            "order_no" => $rows['id'],
            "total_amount" => $rows['total_price'],
            "items" => $rows2,
            "date" => $date,
            "currency" => $val,
            "status" => $status
        );
    }

    if (isset($data)) {
        if (!empty($data)) {
            $arrRecord['success'] = "1";
            $arrRecord['order'] = $data;
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['order'] = $data_not_found;
        }
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['order'] = $data_not_found;
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['order'] = $peramitter_not_set;
}
echo json_encode($arrRecord);
//echo '<pre>',print_r($arrRecord,1),'</pre>';
?>