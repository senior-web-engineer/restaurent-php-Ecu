<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if
(
    isset($res_id) && $res_id != "" &&
    isset($user_id) && $user_id != "" &&
    isset($review_text) && $review_text != "" &&
    isset($ratting) && $ratting != ""
)
{
    $created_at=time();
    $publishreview=$api->publishreview($res_id,$user_id,$review_text,$ratting,$created_at);
    if($publishreview)
    {
        echo $success;
    }
    else
    {
        echo $fail;
    }
}
else
{
    echo $error;
}

?>