<?php

include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();

if (isset($_POST["status"])) {

    $attendance = $_POST['status'];
    $session= $_POST['session'];
    
    $restaurant_id = $_POST['restaurant_id'];
        $sql = mysqli_query($conn,"UPDATE `fooddelivery_restaurant` SET  "
                . "`session`=".$session.", `enable`='".$attendance."' "
                . " WHERE id IN(select res_id FROM fooddelivery_res_owner WHERE id='".$restaurant_id."');");

        if ($sql) {
                $arrRecord['data']['success'] = "1";
                $arrRecord['data']['presence'] = $attendance;
                 $arrRecord['data']['session'] = $session;
        } else {
            $arrRecord['data']['success'] = 0; 
            $arrRecord['data']['presence'] = $invalid;
        }      

} else {
    $arrRecord['data']['success'] = 0;
    $arrRecord['data']['presence'] = $data_not_found;
}

echo json_encode($arrRecord);
 ?>