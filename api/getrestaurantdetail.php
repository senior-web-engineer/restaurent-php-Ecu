<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if(isset($res_id) && $res_id != "" && isset($lat) && $lat != "" && isset($lon) && $lon != ""){

    $getrestaurantdetail=$api->getrestaurantfulldetail($res_id,$lat,$lon);
    if($getrestaurantdetail)
    {
        $json[]=array("status"=>"Success","Restaurant_Detail"=>$getrestaurantdetail);
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