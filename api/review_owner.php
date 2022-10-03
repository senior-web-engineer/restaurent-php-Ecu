<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if(isset($res_id) && $res_id != ""){

    $getallreview_owner=$api->getreviews_owner($res_id);
    if($getallreview_owner)
    {  
        $json[]=array("status"=>"Success","review_details"=>$getallreview_owner);
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