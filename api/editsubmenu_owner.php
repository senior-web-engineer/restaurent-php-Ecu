<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($menu_id) && $menu_id != "" && isset($name) && $name != "" && isset($id) && $id != "" && isset($desc) && $desc && isset($price) && $price != ""){
 
    $editmenu_details=$api->editsubmenu_details($menu_id,$name,$id,$price,$desc);
    if($editmenu_details)
    {  
        echo $editsubmenu;
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