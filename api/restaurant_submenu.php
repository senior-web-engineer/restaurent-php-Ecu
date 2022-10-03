<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if(isset($menucategory_id) && $menucategory_id != "")
{
    $restmenu=$api->restaurantsubmenu($menucategory_id);
    if($restmenu)
    {
        $json[]=array("status"=>"Success","Menu_List"=>$restmenu);
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