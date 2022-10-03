<?php

include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_GET);
if (isset($phone) && $phone != "") {
    $login = $api->phoneVerify($phone);
    if ($login) {
        $json[] = array("status" => "Success", "user_detail" => $login);
        echo json_encode($json);
    } else {
        echo $fail;
    }
} else {
    echo $error;
}
?>