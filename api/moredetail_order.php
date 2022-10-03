<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != "" ){

    $moredetail=$api->moredetail($id);
    if($moredetail)
    {  
        $json[]=array("status"=>"Success","order_details"=>$moredetail);
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