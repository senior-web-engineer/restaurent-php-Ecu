<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($res_id) && $res_id != ""){

    $getmenu=$api->getmenu_details($res_id);
    if($getmenu)
    {  
      $json[]=array("status"=>"Success","menu_details"=>$getmenu);
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