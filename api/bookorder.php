<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
//validar el restaurante y no el usuario
//no importa si el usuario-1 tiene pedidos
$user_id = filter_var($_POST['user_id'], FILTER_SANITIZE_NUMBER_INT);
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$verificarSesion = verifyInfoUserVersion($user_id, $code, $so, $token);

if (isset($_POST['user_id'], $_POST['code'], $_POST['operative_system'], $headers['Authorization'])) {
    if (!$verificarSesion['verify']) {
        echo json_encode($verificarSesion);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar crear pedido';
    echo json_encode($arrRecord);
    exit;
}

//Obtenemos el identificador del restaurant
$res_id = $_POST['res_id'];

$sqlSelectVerifyEnableRest = mysqli_query($conn, "SELECT `id` from `fooddelivery_restaurant` "
    . "WHERE `id`=$res_id "
    . "AND `is_active`=0 ;");
$resVerifyRes = mysqli_fetch_array($sqlSelectVerifyEnableRest);
if (count($resVerifyRes) == 0) {
    $arrRecord['success'] = "-4";
    $arrRecord['message'] = 'Lo sentimos la tienda a la que intentas hacer el pedido no está atendiendo, inténtelo más tarde.';
    echo json_encode($arrRecord);
    exit;
}

if (isset($_POST['user_id']) || isset($_POST['res_id']) || isset($_POST['lat']) || isset($_POST['long']) || isset($_POST['order_phone']) || isset($_POST['address'])) {

    if ($_POST['total_price'] > '0.00') {

        $date = date('Y-m-d H:i:s');
        $payment_method = '1';
        //$auto_accept = '0';
        $total_general = $_POST['total_general'];
        $order_dni = $_POST['order_dni'];
        $order_name = ucwords(strtolower($_POST['order_name']));
        $order_phone = $_POST['order_phone'];
        $amount_pay = $_POST['amount_pay'];
        $user_id = $_POST['user_id'];
        $res_id = $_POST['res_id'];
        $order_note = $_POST['order_note'];
        $address_id = $_POST['address_id'];
        $address = $_POST['address'];
        $lat = $_POST['lat'];
        $long = $_POST['long'];
        $food_desc = $_POST['food_desc'];
        $total_price = $_POST['total_price'];
        $delivery_price = $_POST['delivery_price'];
        $record = '1';
        $notify = '1';
        $status = '0';
        $new = str_replace("%20", " ", $address);
        $created_at = time();

        mysqli_set_charset($conn, "utf8");

        $sql = "INSERT INTO fooddelivery_bookorder (`order_dni`,`order_name`,`order_phone`,`amount_pay`,`id`, `user_id`, `res_id`, `add_id`, `address`, `lat`, `long`, `orig_id`, `total_price`, `payment`, `created_at`, `notify`, `status`, `delivery_price`, `total_general`,`order_note`) "
            . "values('$order_dni','$order_name','$order_phone','$amount_pay',NULL,'" . $user_id . "','" . $res_id . "','" . $address_id . "','" . $new . "','" . $lat . "','" . $long . "','" . $record . "','" . $total_price . "','" . $payment_method . "','" . $date . "','" . $notify . "','" . $status . "','" . $delivery_price . "','" . $total_general . "','" . $order_note . "')";
        $res = mysqli_query($conn, $sql);
        $last_id = mysqli_insert_id($conn);

        $datadesc = json_decode($food_desc, true);
        $Order = $datadesc['Order'];

        //validacion $last_id es mayor que 0
        if ($last_id != 0 || $last_id != null) {
            foreach ($Order as $val) {
                //insertar en la tabla de descripcion de productos
                $sql_qry = "INSERT INTO fooddelivery_food_desc(order_id,res_id,ItemId,ItemQty,ItemAmt) VALUES('$last_id','$res_id','" . $val['ItemId'] . "', '" . $val['ItemQty'] . "', '" . $val['ItemAmt'] . "')";
                $qry = mysqli_query($conn, $sql_qry);

                //ejecutar este codigo solo en tiendas con stock
                $sql = "SELECT `id` FROM `fooddelivery_store_inventory` WHERE `store_id`='$res_id' AND `status`='active'";
                $result = $conn->query($sql);
                $row = $result->fetch_assoc();
                if ($row['id'] <> '') {
                    //consulta stock
                    $sql = "SELECT `stock` FROM `fooddelivery_submenu` WHERE `id`= '" . $val['ItemId'] . "'";
                    $result = $conn->query($sql);

                    //actualiza el stock
                    foreach ($result as $list) {
                        $stock = $list['stock'] - $val['ItemQty'];
                        if ($stock >= 0) {
                            $sqlUpdate = "UPDATE `fooddelivery_submenu` SET `stock` = '$stock' WHERE `id` = '" . $val['ItemId'] . "'";
                            $qry = mysqli_query($conn, $sqlUpdate);
                        }
                    }
                }
            }
        } else {
            //insertar Logs
            $sql = "INSERT INTO fooddelivery_logs(`id`,`order_id`,`registered`,`logs`) VALUES(NULL, '$last_id', NOW(), 'app')";
            $result = $conn->query($sql);
            $arrRecord['success'] = "250";
            $arrRecord['message'] = 'Revisa tus productos una vez más, busca un antojo y agrégalo.';
            echo json_encode($arrRecord);
            exit;
        }

        // Aquí enviar el push 
        $order_id = $last_id;
        $user_id = $user_id;
        $queryDeliveryBoysFree = mysqli_query($conn, "SELECT
            t.*,
            ROUND((6371 * ACOS(COS(RADIANS(b.longitude )) * COS(RADIANS(r.lon)) * COS(RADIANS(r.lat) - RADIANS(b.latitude)) + SIN(RADIANS(b.longitude )) * SIN(RADIANS(r.lon)))), 2) AS distance
        FROM
            fooddelivery_tokendata AS t
            INNER JOIN fooddelivery_delivery_boy AS b ON b.id = t.delivery_boyid
            CROSS JOIN fooddelivery_restaurant AS r  ON r.id = $res_id
        WHERE
            t.type = 'android'
            AND t.delivery_boyid IN (SELECT id
                                    FROM
                                        (SELECT
                                            id, delivery_boy_count_bookorders_today(id) AS orders
                                        FROM
                                            fooddelivery_delivery_boy
                                        WHERE
                                            payments_verify_expired_deliveryboy(id) = 0
                                                AND `attendance` = 'yes'
                                                AND `status` = 'active'
                                                AND `session` = 'yes'
                                                AND `level_id` IN (2)
                                                AND `id` NOT IN (SELECT DISTINCT
                                                    `is_assigned`
                                                FROM
                                                    `fooddelivery_bookorder`
                                                WHERE
                                                    `status` IN (1,3,5))
                                        ORDER BY orders ASC) AS sub1)
        HAVING distance BETWEEN 0 AND 20;");
        $i = 0;
        $reg_id = array();
        while ($resDelivery = mysqli_fetch_array($queryDeliveryBoysFree)) {
            $reg_id[$i] = $resDelivery['token'];
            $i++;
        }
        $massage = $deliveryenable_all_msg;
        $registrationIds = $reg_id;
        $dataFcm = array(
            'title' => 'Pedido disponible',
            'message' => 'Tienes un nuevo pedido disponible para ti',
            'click_action' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
            'show_push' => 'true',
            'show_dialog' => 'true',
            'activity_dialog' => 'repartidor.faster.com.ec.DeliveryStatus_TARGET',
            'button_dialog' => 'Ingresar',
        );
        $fields = array(
            'registration_ids' => $reg_id,
            'data' => $dataFcm,
            "time_to_live" => 0,
            "priority" => "high"
        );
        sendNotificationAndroid($conn, $fields);
        mysqli_set_charset($conn, 'utf8');
        $sqlSelect = mysqli_query($conn, "SELECT fr.lat as restaurant_lat,fr.lon as restaurant_lon,fb.id as order_id,fb.res_id , 
        fr.address as restaurant_address , fb.total_price as order_amount,fr.id,fr.name as restaurant_name ,delivery_price,total_general,FROM_UNIXTIME(created_at) as create_at
        FROM fooddelivery_bookorder fb 
        inner join fooddelivery_restaurant fr on fb.res_id = fr.id
        where user_id=$user_id
        ORDER BY fb.id DESC limit 1");
        $res = mysqli_fetch_array($sqlSelect);
        $date = date('d-m-Y H:i:s', strtotime($res['create_at'])); {
            $data[] = array(
                "total_general" => $res['total_general'],
                "restaurant_name" => $res['restaurant_name'],
                "restaurant_address" => $res['restaurant_address'],
                "order_amount" => $res['order_amount'],
                "delivery_price" => $res['delivery_price'],
                "order_date" => $date,
                "order_id" => $res['order_id'],
                "order_lat" => $lat,
                "order_lon" => $long,
                "restaurant_lat" => $res['restaurant_lat'],
                "restaurant_lon" => $res['restaurant_lon']
            );
            //$data1 = array();
        }
        if (isset($data)) {

            if (!empty($data)) {

                $arrRecord['success'] = "1";
                $arrRecord['message'] = 'Pedido enviado correctamente';
                $arrRecord['order_details'] = $data;
                echo json_encode($arrRecord);
                exit;
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['message'] = 'No se ha podido realizar el pedido inténtelo más tarde';
                echo json_encode($arrRecord);
                exit;
            }
            $arrRecord['success'] = "0";
        } else {
            $arrRecord['message'] = 'No se ha podido realizar el pedido inténtelo más tarde';
            echo json_encode($arrRecord);
            exit;
        }
    } else {
        $arrRecord['success'] = "23";
        $arrRecord['message'] = 'Tu conexión a Internet es inestable, cierra la aplicación y vuelve a intentar.';
        echo json_encode($arrRecord);
        exit;
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar realizar el pedido.';
    echo json_encode($arrRecord);
    exit;
}
