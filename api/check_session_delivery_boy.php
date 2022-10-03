<?php

include "../application/db_config.php";
include 'error_response.php';


$arrRecord = array();
if (isset($_REQUEST["token"]) && isset($_REQUEST["type"]) && $_REQUEST["token"] != '' && $_REQUEST["type"] != '') {
    $token = $_REQUEST["token"];
    $type = $_REQUEST["type"];
    $delivery_boyid = $_REQUEST['delivery_boyid'];
    if ($token && $type) {
        $device_chk = mysqli_query($conn, "SELECT (id) FROM fooddelivery_tokendata where token = '" . $_REQUEST["token"] . "'");
        $div = mysqli_fetch_array($device_chk);
        if (isset($div['id']) && $div['id'] != '') {
            $user = mysqli_query($conn, "UPDATE fooddelivery_tokendata SET user_id='0' WHERE user_id = '" . $_REQUEST["user_id"] . "'");
            $delivery_boy_update = mysqli_query($conn, "UPDATE fooddelivery_tokendata SET delivery_boyid='0' WHERE delivery_boyid = '" . $_REQUEST["delivery_boyid"] . "'");
            $restaurant_owner_update = mysqli_query($conn, "UPDATE fooddelivery_tokendata SET restaurant_ownerid='0' WHERE restaurant_ownerid = '" . $_REQUEST["restaurant_ownerid"] . "'");
            $sql1 = mysqli_query($conn, "UPDATE fooddelivery_tokendata SET delivery_boyid='" . $_REQUEST['delivery_boyid'] . "',user_id='" . $_REQUEST["user_id"] . "',token = '" . $_REQUEST["token"] . "',type = '" . $_REQUEST["type"] . "',restaurant_ownerid= '" . $_REQUEST["restaurant_ownerid"] . "' WHERE id = " . $div['id']);
            $arrRecord['data']['success'] = "1";
            $arrRecord['data']['message'] = "Device has been updated";
        } else {
            $sql = mysqli_query($conn, "INSERT INTO fooddelivery_tokendata VALUES(null,'" . $_REQUEST['delivery_boyid'] . "','" . $_REQUEST["user_id"] . "','" . $_REQUEST["token"] . "','" . $_REQUEST["type"] . "','" . $_REQUEST["restaurant_ownerid"] . "')");
            $arrRecord['data']['success'] = "1";
            $arrRecord['data']['message'] = "Device has been registered";
        }
    } else {
        $arrRecord['data']['success'] = "0";
        $arrRecord['data']['message'] = "Device not registered";
    }
} else {
    $arrRecord['data']['success'] = "0";
    $arrRecord['data']['message'] = "Something went wrong";
}
echo json_encode($arrRecord);
?>