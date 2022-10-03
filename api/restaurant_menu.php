<?php
include '../controllers/apicontroller.php';
include 'error_response.php';

$api = new apicontroller();
extract($_GET);
if(isset($res_id) && $res_id != "")
{
    $restmenu=$api->restaurantmenu($res_id);
    if($restmenu)
    {
        $json[]=array("status"=>"Success","Menu_Category"=>$restmenu);
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