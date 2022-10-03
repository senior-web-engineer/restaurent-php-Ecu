<?php
    include '/home/faster/public_html/controllers/controller_push.php';
    $api = new controllerpush();
    $today = date("Y-m-d");
    $deliveryboy_list_of_token = $api->getDeliveryBoyListOfToken($today);
    // print_r($deliveryboy_list_of_token);
    // echo date("Y-m-d H:i:s");
    if (!empty($deliveryboy_list_of_token)) $api->sendAlarm($deliveryboy_list_of_token);
    exit;
