<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($deliverboy_id)){
  
  	$api->registerDeliverboyPosition($deliverboy_id, $lat, $lon);
  
}