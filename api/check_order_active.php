<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';


//Verificar si tiene un pedido pendiente
mysqli_set_charset($conn, 'utf8');
$sqlSelectVerifyLimit = mysqli_query($conn, "SELECT * FROM fooddelivery_bookorder where user_id=" . $_REQUEST['user_id'] . " AND status IN(0,1,5,3);");
$resVerifyLimit = mysqli_fetch_array($sqlSelectVerifyLimit);
if (count($resVerifyLimit) > 0) {
    $arrRecord['status'] = true;
    echo json_encode($arrRecord);
    exit;
} else {
    $arrRecord['status'] = false;
    echo json_encode($arrRecord);
    exit;
}
?>