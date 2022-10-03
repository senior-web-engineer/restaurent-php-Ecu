<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if(isset($res_id) && $res_id != "")
{
    $getreview=$api->getreviews($res_id);
    if($getreview)
    {
        $json[]=array("status"=>"Success","Reviews"=>$getreview);
        echo json_encode($json);
    }
    else
    {
        echo $review;
    }
}
else
{
    echo $error;
}
?>