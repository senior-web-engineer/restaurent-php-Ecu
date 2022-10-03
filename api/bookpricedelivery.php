<?php

include "../application/db_config.php";
include 'error_response.php';

if (isset($_POST['res_id'])) {
    $lat = $_POST['lat'];
    $long = $_POST['long'];
} else {
    $arrRecord['data']['success'] = 0;
    $arrRecord['data']['book_price_details'] = $peramitter_not_set;
}
echo json_encode($arrRecord);
?>