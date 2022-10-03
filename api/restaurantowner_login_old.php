<?php

include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();

if (isset($_REQUEST["email"]) && isset($_REQUEST["password"])) {
    $user_name = preg_match('/^[0-9a-z\W@.]*$/', strip_tags($_REQUEST["email"]));
    $user_pass = preg_match('/^[0-9a-z\W]*$/', strip_tags($_REQUEST["password"]));

    if ($user_name && $user_pass) {
        mysqli_set_charset($conn, "utf8");
        $sql = mysqli_query($conn, "SELECT fooddelivery_res_owner.id as restaurant_ownerid,username,fooddelivery_restaurant.id as id,name ,address,open_time,close_time,lat,lon,city,enable    FROM fooddelivery_res_owner,"
                . "fooddelivery_restaurant WHERE fooddelivery_restaurant.id=fooddelivery_res_owner.res_id AND fooddelivery_res_owner.email='" . strip_tags($_REQUEST["email"]) . "' and fooddelivery_res_owner.password='" . strip_tags($_REQUEST["password"]) . "'");
        $rows = mysqli_fetch_array($sql);

        $data[] = array(
            "restaurant_ownerid" => $rows['restaurant_ownerid'],
            "username" => $rows['username'],
            "id" => $rows['id'],
            "name" => $rows['name'],
            "address" => $rows['address'],
            "open_time" => $rows['open_time'],
            "close_time" => $rows['close_time'],
            "lat" => $rows['lat'],
            "lon" => $rows['lon'],
            "city" => $rows['city'],
            "enable" => $rows['enable']
        );
        $data1 = array();
        $sqlSession = mysqli_query($conn, "UPDATE `fooddelivery_restaurant` SET `session`=1 WHERE id='" . $rows['id'] . "'");
        if ($rows > 0) {
            foreach ($rows as $row) {
                $arrRecord['data']['success'] = "1";
                $arrRecord['data']['login'] = $data;
            }
        } else {
            $arrRecord['data']['success'] = "0";
            $arrRecord['data']['login'] = $invalid;
        }
    } else {
        $arrRecord['data']['success'] = "0";
        $arrRecord['data']['login'] = $data_not_found;
    }
} else {
    $arrRecord['data']['success'] = 0;
    $arrRecord['data']['login'] = $data_not_found;
}

echo json_encode($arrRecord);
?>