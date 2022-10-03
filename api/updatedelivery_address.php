<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != ""){

    $updatedelivery_address=$api->updatedelivery_address($id, $user_id, $latitude, $longitude, $address, $alias, $phone, $delivery_note, $department_number);
  	if ($updatedelivery_address) {
      	echo '[{"status":"Success","Msg":"Delivery address is updated Successfully"}]';
    }
  	else {
      	echo $no_record;
    }
    
}
else
{
    echo $error;
}

?>