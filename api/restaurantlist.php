<?php

include '../controllers/apicontroller.php';
include 'error_response.php';

$api = new apicontroller();

mysqli_set_charset($conn, 'utf8');
$sqlSelectVerifyLimit = mysqli_query($conn, "SELECT * FROM fooddelivery_bookorder where user_id=" . $_REQUEST['user_id'] . " AND status IN(0,1,5,3);");
$resVerifyLimit = mysqli_fetch_array($sqlSelectVerifyLimit);

if (count($resVerifyLimit) > 0) {
    $json[] = array("status" => "order_active");
    echo json_encode($json);
    exit;
}

extract($_GET);
$query = mysqli_query($conn, "select timezone from fooddelivery_adminlogin where id ='1'");
$fetch = mysqli_fetch_array($query);
$defaulttimezone = $fetch['timezone'];

$default_time = explode(" - ", $defaulttimezone);
$vals = $default_time[0];
//if ($location == 'Santo Domingo') {
//    $location= 'Santo Domingo de los Colorados';
//}
// verificar que exista la ciudad
$queryRadio = mysqli_query($conn, "select radio from fooddelivery_city where lower(cname)=lower('$location') limit 1;");
$fetchRadio = mysqli_fetch_array($queryRadio);
$radius = $fetchRadio[0];
if ($radius == null) {
    $radius = 0;
}
if (isset($timezone) && $timezone != "") {
    date_default_timezone_set($timezone);
    if (isset($location) && $location != "" && isset($search) && $search != "" && isset($lat) && $lat != "" && isset($lon) && $lon != "" && isset($radius) && $radius != "") {
        
        $offset = 0;
        $page_result = $_GET['noofrecords'];

        if ($_GET['pageno']) {
            $page_value = $_GET['pageno'];
            if ($page_value > 1) {
                $offset = ($page_value - 1) * $page_result;
            }
        }
        date_default_timezone_set($vals);
        $searchwithname = $api->locatemerestarant($search, $lat, $lon, "nope", $offset, $page_result, $radius);
       
        $pagecount = count($searchwithname);
        $num = $pagecount / $page_result;

        if ($searchwithname) {
            $json[] = array("status" => "Success", "Restaurant_list" => $searchwithname);
            echo json_encode($json);
            //echo '<pre>',print_r($json,1),'</pre>';
        } else {

            $offset = 0;
            $page_result = $_GET['noofrecords'];

            if ($_GET['pageno']) {
                $page_value = $_GET['pageno'];
                if ($page_value > 1) {
                    $offset = ($page_value - 1) * $page_result;
                }
            }
            date_default_timezone_set($vals);
            $searchwithcategorywise = $api->locatemerestarant($search, $lat, $lon, "category", $offset, $page_result, $radius);
            $pagecount = count($searchwithcategorywise);

            $num = $pagecount / $page_result;
            if ($searchwithcategorywise) {
                $json[] = array("status" => "Success", "Restaurant_list" => $searchwithcategorywise);
                echo json_encode($json);
                //echo '<pre>',print_r($json,1),'</pre>';
            } else {
                if ($page_value == 1 || ($page_value * $page_result) <= $pagecount) {
                    echo $not_found;
                } else {
                    echo $no_record_more;
                }
            }
        }
    } 
    else if (isset($location) && $location != "" && isset($lat) && $lat != "" && isset($lon) && $lon != "" && isset($radius) && $radius != "") {
        $offset = 0;
        $page_result = $_GET['noofrecords'];

        if ($_GET['pageno']) {
            $page_value = $_GET['pageno'];
            if ($page_value > 1) {
                $offset = ($page_value - 1) * $page_result;
            }
        }
        date_default_timezone_set($vals);
        $getrestaurantlist = $api->locatemerestarant($location, $lat, $lon, "location", $offset, $page_result, $radius);

        $pagecount = count($getrestaurantlist);

        $num = $pagecount / $page_result;

        if ($getrestaurantlist) {
            $json[] = array("status" => "Success", "Restaurant_list" => $getrestaurantlist);
            echo json_encode($json);
            //echo '<pre>',print_r($json,1),'</pre>';
        } else {
            if ($page_value == 1 || ($page_value * $page_result) <= $pagecount) {
                echo $not_found_location;
            } else {
                echo $no_record_more;
            }
        }
    }
    else {
        echo $error;
    }
} else {
    echo $timezone_check;
}
?>