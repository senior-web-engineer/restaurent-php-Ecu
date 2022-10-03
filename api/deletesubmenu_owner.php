<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != ""){
 
    $delete=$api->deletesubmenu($id);
    if($delete)
    {  
        echo $deletesubmenu;
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