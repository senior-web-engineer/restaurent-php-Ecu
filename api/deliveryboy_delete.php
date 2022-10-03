<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != "" ){

    $delete_deliveryboy=$api->delete_deliveryboy($id);
    if($delete_deliveryboy)
    {  
        echo $delete_boy;
    }
    else
    {
        echo $no_record;
    }
}
else
{
    echo $error;
}
?>