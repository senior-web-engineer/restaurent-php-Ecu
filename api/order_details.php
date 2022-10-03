<?php

include '../controllers/apicontroller.php';
include 'error_response.php';

mysqli_set_charset($conn, 'utf8');
$sqlSelectVerifyLimit = mysqli_query($conn, "SELECT `id` FROM `fooddelivery_bookorder` WHERE `id`=" . $_REQUEST['order_id'] . " AND `status` IN(0,1,5,3);");
$resVerifyLimit = mysqli_fetch_array($sqlSelectVerifyLimit);
$estado_orden_active;
if (count($resVerifyLimit) > 0) {
    $estado_orden_active = "active";
} else {
    $estado_orden_active = "inactive";
}

mysqli_set_charset($conn, 'utf8');
if (strlen($_GET['order_id']) == 0 || $_GET['order_id'] == null || $_GET['order_id'] == 'null') {
    $query = mysqli_query($conn, "SELECT fb.lat order_lat,fb.long order_lon,bookorder_ratting_getstatus(fb.id) ratting,fb.total_general,fb.status,bookorder_get_seconds_next_show(fb.id) as time_rest,fb.delivery_price,fb.is_assigned as is_assigned,fb.id as order_id,fb.res_id , fr.address as restaurant_address , 
        fb.total_price as order_amount, fb.created_at , fb.accept_date_time , fb.accept_status , fb.delivery_date_time , fb.delivery_status ,
        fb.delivered_date_time , fb.delivered_status , fb.reject_date_time , fb.reject_status , fr.id,fr.name as restaurant_name , fr.photo ,
        fr.phone ,fr.lat as restaurant_lat,fr.lon  as restaurant_lon, fr.delivery_time,bookorder_get_time_order(fb.id) as end_time,fb.assign_date_time,fb.assign_status
        FROM fooddelivery_bookorder fb 
        inner join fooddelivery_restaurant fr on fb.res_id = fr.id where fb.user_id='" . $_GET['user_id'] . "' order by fb.id DESC LIMIT 1; ");
} else {
    $query = mysqli_query($conn, "SELECT fb.lat order_lat,fb.long order_lon,bookorder_ratting_getstatus(fb.id) ratting,fb.total_general,fb.status,bookorder_get_seconds_next_show(fb.id) as time_rest,fb.delivery_price,fb.is_assigned as is_assigned,fb.id as order_id,fb.res_id , fr.address as restaurant_address , 
        fb.total_price as order_amount, fb.created_at , fb.accept_date_time , fb.accept_status , fb.delivery_date_time , fb.delivery_status , 
        fb.delivered_date_time , fb.delivered_status , fb.reject_date_time , fb.reject_status , fr.id,fr.name as restaurant_name , fr.photo ,
        fr.phone ,fr.lat as restaurant_lat,fr.lon  as restaurant_lon, fr.delivery_time,bookorder_get_time_order(fb.id) as end_time,fb.assign_date_time,fb.assign_status 
        FROM fooddelivery_bookorder fb 
        inner join fooddelivery_restaurant fr on fb.res_id = fr.id where fb.id='" . $_GET['order_id'] . "'");
}

$res = mysqli_fetch_array($query);

//print_r( $res['is_assigned']);
$deliveryboy_id = $res['is_assigned'];
//echo $deliveryboy_id;
$queryDeliveryBoy = mysqli_query($conn, "SELECT fooddelivery_delivery_boy.name AS name,fooddelivery_allies.name as ally_name,phone,vehicle_type, image,fooddelivery_delivery_boy.vehicle_no
            FROM fooddelivery_delivery_boy ,fooddelivery_allies
            WHERE fooddelivery_delivery_boy.id=$deliveryboy_id
            AND fooddelivery_delivery_boy.allies_id=fooddelivery_allies.id  LIMIT 1; ");
$resDeliveryBoy = mysqli_fetch_array($queryDeliveryBoy);
//echo $restaurant_name = $res['restaurant_name']; exit();
// $stemp = $res['created_at'];
$stemp = date_format(date_create($res['created_at']), 'd-m-Y H:i:s');
// $odate = date('d-m-Y', $stemp);
$odate = date_format(date_create($stemp), 'd-m-Y');

// $otime = date('H:i', $stemp);
$otime = date_format(date_create($stemp), 'H:i');
$oddate = $otime . ' ' . $odate;
$delivery_time = $res['delivery_time'];

$date = new DateTime($oddate);
$date->modify('+' . $delivery_time . ' minutes');
$ddate = date("H:i d-m-Y", strtotime($res['end_time']));

/*if ($res['auto_reject_deliveryboys_status'] == '') {
    $reject_auto_deliveryboy = 'Deactivate';
} else {
    $reject_auto_deliveryboy = 'Activate';
}
if ($res['auto_reject_restaurant_status'] == '') {
    $reject_auto_restaurant = 'Deactivate';
} else {
    $reject_auto_restaurant = 'Activate';
}*/
if ($res['assign_status'] == '') {
    $assign_order = 'Deactivate';
} else {
    $assign_order = 'Activate';
}
if ($res['accept_status'] == '') {
    $order_verified = 'Deactivate';
} else {
    $order_verified = 'Activate';
}

if ($res['delivery_status'] == '') {
    $delivery_status = 'Deactivate';
} else {
    $delivery_status = 'Activate';
}

if ($res['delivered_status'] == '') {
    $delivered_status = 'Deactivate';
} else {
    $delivered_status = 'Activate';
}

if ($res['reject_status'] == '') {
    $reject_status = 'Deactivate';
} else {
    $reject_status = 'Activate';
}
$_GET['order_id'] = $res['order_id'];
$data[] = array(
    "time_rest" => $res['time_rest'],
    "status" => $res['status'],
    "deliveryboy_name" => $resDeliveryBoy['name'],
    "ally_name" => $resDeliveryBoy['ally_name'],
    "deliveryboy_phone" => $resDeliveryBoy['phone'],
    "deliveryboy_image" => $resDeliveryBoy['image'],
    "deliveryboy_vehicle_no" => $resDeliveryBoy['vehicle_no'],
    "deliveryboy_vehicle_type" => $resDeliveryBoy['vehicle_type'],
    "restaurant_name" => $res['restaurant_name'],
    "restaurant_lat" => $res['restaurant_lat'],
    "restaurant_lon" => $res['restaurant_lon'],
    "order_lat" => $res['order_lat'],
    "order_lon" => $res['order_lon'],
    "restaurant_address" => $res['restaurant_address'],
    "restaurant_contact" => $res['phone'],
    "restaurant_image" => $res['photo'],
    "ratting" => $res['ratting'],
    "order_amount" => $res['order_amount'],
    "order_time" => $oddate,
    "delivery_time" => $ddate,
    "order_id" => $res['order_id'],
    "delivery_price" => $res['delivery_price'],
    "total_price" => $res['total_general'],
    "order_verified_date" => $res['accept_date_time'] == null ? null : date("d-m-Y H:i", strtotime($res['accept_date_time'])),
    "order_verified" => $order_verified,
    "delivery_date_time" => $res['delivery_date_time'] == null ? null : date("d-m-Y H:i", strtotime($res['delivery_date_time'])),
    "delivery_status" => $delivery_status,
    "delivered_date_time" => $res['delivered_date_time'] == null ? null : date("d-m-Y H:i", strtotime($res['delivered_date_time'])),
    "delivered_status" => $delivered_status,
    "reject_date_time" => $res['reject_date_time'] == null ? null : date("d-m-Y H:i", strtotime($res['reject_date_time'])),
    "reject_status" => $reject_status,
    "assign_date_time" => $res['assign_date_time'] == null ? null : date("d-m-Y H:i", strtotime($res['assign_date_time'])),
    "assign_status" => $assign_order,
    "reject_auto_restaurant_date_time" => 'null',
    "reject_auto_restaurant_status" => 'Activate',
    "reject_auto_deliveryboy_date_time" => 'null',
    "reject_auto_deliveryboy_status" => 'Activate',
    "order_status" => $estado_orden_active
);
//$data1 = array();

if (isset($data)) {
    if (!empty($data)) {
        $arrRecord['success'] = "1";
        $arrRecord['order_details'] = $data;
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['order_details'] = $data_not_found;
    }
} else {
    $arrRecord['success'] = "0";
    $arrRecord['order_details'] = $data_not_found;
}

echo json_encode($arrRecord);
//echo '<pre>',print_r($arrRecord,1),'</pre>';
?>