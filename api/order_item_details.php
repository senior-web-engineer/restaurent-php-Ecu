<?php
include "../application/db_config.php";
include 'error_response.php';

mysqli_set_charset($conn,'utf8');
if (isset($_REQUEST["order_id"])) {
    $query = mysqli_query($conn, "SELECT total_price from fooddelivery_bookorder WHERE id = '".$_REQUEST['order_id']."'");
    
    $res = mysqli_fetch_array($query);
        $data[] = array(
            "order_amount" => $res['total_price']
        );

        $arrName = array();
        $query_name = mysqli_query($conn, "SELECT fd.order_id,fd.ItemId , fd.ItemQty , fd.ItemAmt , fs.id , fs.name , fs.desc from 
        fooddelivery_food_desc fd inner join fooddelivery_submenu fs on fd.ItemId = fs.id
        WHERE fd.order_id = '".$_REQUEST['order_id']."'");

        while ($res_name = mysqli_fetch_array($query_name))
        {

            $arrName[] = array(
                "name" => $res_name['name'],
                "description" => $res_name['desc'],
                "qty" => $res_name['ItemQty'],
                "amount" => number_format((float)$res_name['ItemAmt'], 2, ',', '')
            );
            $arrName;

        }

        $data[0]['item_name'] = $arrName;

        
        if (isset($data)) {
            if (!empty($data)) {
                $arrRecord['success'] = "1";
                $arrRecord['Order'] = $data[0];
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['Order'] = $data_not_found;
            }
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['Order'] = $data_not_found;
        }
    } else {
        $arrRecord['success'] = "0";
        $arrRecord['Item'] = $item_not_found;
    }
    echo json_encode($arrRecord);
    //echo '<pre>',print_r($arrRecord,1),'</pre>';
?>