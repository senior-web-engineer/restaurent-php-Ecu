<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($menu_id) && $menu_id != "" && isset($name) && $name != "" && isset($res_id) && $res_id != ""){

    $editmenu_details=$api->editmenu_details($menu_id,$name,$res_id);
    if($editmenu_details)
    {  
        echo $editmenu;
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