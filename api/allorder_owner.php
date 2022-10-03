<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if(isset($id) && $id != ""){

    $getallorder=$api->order_owner_id($id);
    if($getallorder)
    {  
       
        $json[]=array("status"=>"Success","order_details"=>$getallorder);
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