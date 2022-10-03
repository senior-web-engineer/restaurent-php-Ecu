<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != ""){

    $restaurant_details=$api->restaurant_details_owner($id);
    if($restaurant_details)
    {  
      $json[]=array("status"=>"Success","restaurant_details"=>$restaurant_details);
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