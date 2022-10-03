<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if(isset($email) && $email != "" && isset($password) && $password != ""){

    $loginowner=$api->getresowner($email,$password);
    if($loginowner)
    {  
        $json[]=array("status"=>"Success","res_owner"=>$loginowner);
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