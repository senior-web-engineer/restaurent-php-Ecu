<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($res_id) && $res_id != "" ){

    $deliveryboy_details=$api->deliveryboy_details($res_id);
    if($deliveryboy_details)
    {  
        $json[]=array("status"=>"Success","order_details"=>$deliveryboy_details);
        echo json_encode($json);
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