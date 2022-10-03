<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($res_id) && $res_id != "" && isset($name) && $name != ""){

    $insertmenu=$api->insertmenu($res_id,$name);
    if($insertmenu)
    {  
       echo $success_menu;
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