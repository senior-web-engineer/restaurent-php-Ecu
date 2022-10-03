<?php
include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();

if (isset($_REQUEST["email"]) && isset($_REQUEST["password"])) {
    $user_name = preg_match('/^[0-9a-z\W@.]*$/', strip_tags($_REQUEST["email"]));
    $user_pass = preg_match('/^[0-9a-z\W]*$/', strip_tags($_REQUEST["password"]));

    if ($user_name && $user_pass) {
        mysqli_set_charset($conn,"utf8");
        $sql = mysqli_query($conn,"SELECT id, name, phone, email, password, vehicle_no, vehicle_type,image FROM fooddelivery_delivery_boy WHERE email='" . strip_tags($_REQUEST["email"]) . "' and password='" . strip_tags($_REQUEST["password"]) . "'");
        $rows = mysqli_fetch_array($sql);

        $data[] = array(
            "id" => $rows['id'],
            "name" => $rows['name'],
            "phone" => $rows['phone'],
            "email" => $rows['email'],
            "vehicle_no" => $rows['vehicle_no'],
            "vehicle_type" => $rows['vehicle_type'],
            "image" => $rows['image']
        );
        $sqlSession = mysqli_query($conn,"UPDATE `fooddelivery_delivery_boy` SET `session`='yes' WHERE id='".$rows['id']."'");
        $data1=array();

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