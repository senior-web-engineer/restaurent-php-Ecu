<?php
include '../controllers/apicontroller.php';
include 'error_response.php';

$api = new apicontroller();
extract($_GET);
$category = $api->restaurantcategory();
if($category)
{
    $json=array("status"=>"Success","Category_List"=>$category);
    echo json_encode($json);
}
else
{
    echo $no_record;
}
?>