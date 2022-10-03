<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($menu_id) && $menu_id != ""){

    $getmenu=$api->getsubmenu_details($menu_id);
    if($getmenu)
    {  
      $json[]=array("status"=>"Success","submenu_details"=>$getmenu);
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