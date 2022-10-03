<?php

include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();

if (isset($_REQUEST["deliverboy_id"])) {

        $sql = mysqli_query($conn,"SELECT * FROM fooddelivery_delivery_boy where id='".$_REQUEST['deliverboy_id']."'");
        

        $rows = mysqli_fetch_array($sql);

            $data[] = array(
                "name" => $rows['name'],
                "phone" => $rows['phone'],
                "email" => $rows['email'],
                "vehicle_no" => $rows['vehicle_no'],
                "vehicle_type" => $rows['vehicle_type']
            );

        if (isset($data)) {
            if (!empty($data)) {
                $arrRecord['success'] = "1";
                $arrRecord['order'] = $data;
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['order'] = $data_not_found;
            }
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['order'] = $data_not_found;
        }
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['order'] = $peramitter_not_set;
    }
    echo json_encode($arrRecord);
    //echo '<pre>',print_r($arrRecord,1),'</pre>';
 ?>