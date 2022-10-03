<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($address) && $address != ""){

    $insertdelivery_address=$api->insertdelivery_address($user_id, $latitude, $longitude, $address, $alias, $phone, $delivery_note, $department_number);
    if($insertdelivery_address) {  
        echo $success_delivery_address;
    } else {
        echo $error;
    }
} else {
    echo $error;
}

?>