<?php

include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();
mysqli_set_charset($conn, "utf8");

if (isset($_REQUEST["restaurant_id"])) {
    $restaurant_id = $_REQUEST["restaurant_id"];
    $sql = mysqli_query($conn, "SELECT payments_count_bookorders_restaurant(id) as items,`id`,`create_date`,`payment_date`,`max_payment_date`,`status` ,`description`,`restaurant_id`,`amount` FROM fooddelivery_payments WHERE type='restaurant' AND restaurant_id='$restaurant_id';");
    $cont = 0;
    while ($rows = mysqli_fetch_array($sql)) {
        $data[$cont] = array(
            "id" => $rows['id'],
            "create_date" => date("d/m/Y H:i:s", strtotime($rows['create_date'])),
            "payment_date" => ($rows['payment_date'] != "" || $rows['payment_date'] != null) ? date("d/m/Y H:i:s", strtotime($rows['payment_date'])) : null,
            "max_payment_date" => date("d/m/Y H:i:s", strtotime($rows['max_payment_date'])),
            "restaurant_id" => $rows['restaurant_id'],
            "amount" => $rows['amount'],
            "status" => $rows['status'],
            "items" => $rows['items']
        );
        $cont++;
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