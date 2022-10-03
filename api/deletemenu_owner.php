<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != ""){
 
    $delete=$api->deletemenu($id);
    if($delete)
    {  
        echo $deletemenu;
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