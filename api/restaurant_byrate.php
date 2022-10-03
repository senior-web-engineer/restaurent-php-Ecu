<?php

include '../controllers/apicontroller.php';
include 'error_response.php';

$api = new apicontroller();
extract($_GET);
$query = mysqli_query($conn, "select timezone from fooddelivery_adminlogin where id ='1'");
$fetch = mysqli_fetch_array($query);
$defaulttimezone = $fetch['timezone'];

$default_time = explode(" - ", $defaulttimezone);
$vals = $default_time[0];

$queryRadio = mysqli_query($conn, "select radio from fooddelivery_city where lower(cname)=lower('$location') limit 1;");
$fetchRadio = mysqli_fetch_array($queryRadio);
$radius= $fetchRadio[0];
if ($radius == null) {
    $radius = 0;
}

if (isset($timezone) && $timezone != "") {
    date_default_timezone_set($timezone);
    if
    (
            isset($location) && $location != "" &&
            isset($lat) && $lat != "" &&
            isset($lon) && $lon != "" &&
            isset($radius) && $radius != ""
    ) {
        date_default_timezone_set($vals);
        $getrestaurantlist = $api->locatemerestarantrat($location, $lat, $lon, "location", $radius);

        if ($getrestaurantlist) {
            $json[] = array("status" => "Success", "Restaurant_list" => $getrestaurantlist);
            echo json_encode($json);
            //echo '<pre>',print_r($json,1),'</pre>';
        } else {
            echo $not_found;
        }
    }
} else {
    echo $timezone_check;
}
?>