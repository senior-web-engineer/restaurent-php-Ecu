<?php

include '../controllers/apicontroller.php';
include 'error_response.php';

$api = new apicontroller();
extract($_GET);
$searchwithcategorywise = $api->variablesDistance();

$json[] = array("status" => "Success", "variables" => $searchwithcategorywise);
echo json_encode($json);
?>