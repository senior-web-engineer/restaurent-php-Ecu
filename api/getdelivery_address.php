<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($user_id) && $user_id != ""){

    $getdelivery_address=$api->getdelivery_address($user_id);
  	if ($getdelivery_address) {
      	echo json_encode($getdelivery_address);
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