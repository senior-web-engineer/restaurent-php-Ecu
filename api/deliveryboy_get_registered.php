<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if (isset($deliverboy_id)) {
    $rname = $api->getdeliveryboyname($deliverboy_id);
    if ($rname) {
        echo json_encode($api->getRegisteredData($rname));
        exit;
    }
}
echo json_encode($error);
