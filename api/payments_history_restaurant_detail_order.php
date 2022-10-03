<?php

include "../application/db_config.php";
include 'error_response.php';

mysqli_set_charset($conn, 'utf8');
if (isset($_REQUEST["order_id"])) {
    $query = mysqli_query($conn, "SELECT fb.id,fb.total_price , fb.created_at , fb.address , fb.payment , fb.lat , fb.long 
        , count(fd.order_id) as count , fd.ItemId , fu.fullname , fu.phone_no,restaurant_get_name(fb.res_id) as restaurant_name ,payments_get_amount_bookorder_restaurant(fb.id) AS payment_amount  from 
        fooddelivery_bookorder fb inner join fooddelivery_food_desc fd on fb.id = fd.order_id 
        inner join fooddelivery_users fu on fb.user_id = fu.id
        WHERE fb.id = '" . $_REQUEST['order_id'] . "' ORDER BY fb.id DESC");

    $res = mysqli_fetch_array($query);
    $date = date("d-M-Y H:s:ia", $res['created_at']);
    $data[] = array(
        "payment_amount" => $res['payment_amount'],
        "restaurant_name" => $res['restaurant_name'],
        "order_amount" => $res['total_price'],
        "payment" => $res['payment'],
        "date" => $date,
        "address" => $res['address'],
        "items" => $res['count'],
        "customer_name" => $res['fullname'],
        "phone" => $res['phone_no'],
        "lat" => $res['lat'],
        "long" => $res['long']
    );

    $arrName = array();
    $query_name = mysqli_query($conn, "SELECT fd.order_id,fd.ItemId , fd.ItemQty , fd.ItemAmt , fs.id , fs.name from 
        fooddelivery_food_desc fd inner join fooddelivery_submenu fs on fd.ItemId = fs.id
        WHERE fd.order_id = '" . $_REQUEST['order_id'] . "'");

    while ($res_name = mysqli_fetch_array($query_name)) {

        $arrName[] = array(
            "name" => $res_name['name'],
            "qty" => $res_name['ItemQty'],
            "amount" => $res_name['ItemAmt']
        );
        $arrName;
    }

    $data[0]['item_name'] = $arrName;


    if (isset($data)) {
        if (!empty($data)) {
            $arrRecord['success'] = "1";
            $arrRecord['Order'] = $data[0];
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['Order'] = $data_not_found;
        }
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['Order'] = $data_not_found;
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['Item'] = $item_not_found;
}
echo json_encode($arrRecord);
//echo '<pre>',print_r($arrRecord,1),'</pre>';
?>