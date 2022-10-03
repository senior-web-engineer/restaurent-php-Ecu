<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != ""){

    $deletedelivery_address=$api->deletedelivery_address($id);
  	if ($deletedelivery_address) {
      	echo '[{"status":"Success","Msg":"Delivery address is removed successfully"}]';
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