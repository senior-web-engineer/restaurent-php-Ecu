<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($name) && $name != "" && isset($menu_id) && $menu_id!= "" && isset($price) && $price != "" && isset($desc) && $desc != ""){

    $insertsubmenu=$api->insertsubmenu($menu_id,$name,$price,$desc);
    if($insertsubmenu)
    {  
       echo $success_submenu;
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