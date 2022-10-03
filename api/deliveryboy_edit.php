<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($id) && $id != "" && isset($res_id) && $res_id != "" && isset($name) && $name != "" && isset($phone) && $phone != "" && isset($email) && $email != "" && isset($password) && $password != "" && isset($vehicle_no) && $vehicle_no != "" && isset($vehicle_type) && $vehicle_type != "" ){

    $edit_deliveryboy=$api->edit_deliveryboy($id,$res_id,$name,$phone,$email,$password,$vehicle_no,$vehicle_type);
    if($edit_deliveryboy)
    {  
        echo $edit_boy;
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