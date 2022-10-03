<?php
include "../application/db_config.php";
include 'error_response.php';

	$query = mysqli_query($conn,"select * from fooddelivery_city ORDER BY id ASC");
    while ($res = mysqli_fetch_array($query))
    {
        $data[] = array(
            "city_name" => $res['cname']
        );
        $data1=array();
    }

    if (isset($data))
    {
        $data1['city'] = $data;
        echo json_encode($data1);
        //echo '<pre>',print_r($data1,1),'</pre>';
    }
    else
    {
        $arr = array("id" => $item_not_found);
        echo json_encode($arr);
    }
?>