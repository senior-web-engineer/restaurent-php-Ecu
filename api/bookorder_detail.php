<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';

//Verify if account is active
mysqli_set_charset($conn, 'utf8');
$sqlSelectVerifyActiveUser = mysqli_query($conn, "SELECT  * FROM fooddelivery_users WHERE id=" . $_POST['user_id'] . " AND status='active';");
$resVerifyActiveUser = mysqli_fetch_array($sqlSelectVerifyActiveUser);
if (count($resVerifyActiveUser) == 0) {
    $arrRecord['success'] = $user_inactive;
    $arrRecord['order_details'] = $user_inactive;
    echo json_encode($arrRecord);
    exit;
}
$order_id=$_POST['user_id'];
mysqli_set_charset($conn, 'utf8');
$sqlSelect = mysqli_query($conn, "SELECT  fb.id as order_id,fb.res_id , 
        fr.address as restaurant_address , fb.total_price as order_amount,fr.id,fr.name as restaurant_name ,delivery_price,total_general
        FROM fooddelivery_bookorder fb 
        inner join fooddelivery_restaurant fr on fb.res_id = fr.id
        where user_id=$user_id and status in(0,1,3,4,5)
            AND fb.id=$order_id
        ORDER BY fb.id DESC limit 1");
$res = mysqli_fetch_array($sqlSelect);
$date = date('Y/m/d H:i:s'); {
    $data[] = array(
        "total_general" => $res['total_general'],
        "restaurant_name" => $res['restaurant_name'],
        "restaurant_address" => $res['restaurant_address'],
        "order_amount" => $res['order_amount'],
        "delivery_price" => $res['delivery_price'],
        "order_date" => $date,
        "order_id" => $res['order_id'],
    );
    $data1 = array();
}
if (isset($data)) {

    if (!empty($data)) {
        $arrRecord['success'] = "Order Book Successfully";
        $arrRecord['order_details'] = $data;
        $arrRecord['message'] = "";
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['order_details'] = $data_not_found;
        $arrRecord['message'] = "";
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['order_details'] = $data_not_found;
    $arrRecord['message'] = "";
}

echo json_encode($arrRecord);
?>