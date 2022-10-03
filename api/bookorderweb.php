<?php
if (isset($_REQUEST['addorder'])) {
    session_start();
    @$uid = $_SESSION['uid'];
    @$role = $_SESSION['role'];

    if ($role != '1') {
        echo "<script>window.location='../index.php'</script>";
        session_destroy();
    }
    include "../application/db_config.php";

    //Obtenemos el identificador del restaurant
    $res_id = $_POST['store_id'];
    //Verify if delivery boys active and enable
    mysqli_set_charset($conn, 'utf8');
    $sqlSelectVerifyEnable = mysqli_query($conn, "SELECT
    b.*,
    ROUND((6371 * ACOS(COS(RADIANS(b.longitude )) * COS(RADIANS(r.lon)) * COS(RADIANS(r.lat) - RADIANS(b.latitude)) + SIN(RADIANS(b.longitude )) * SIN(RADIANS(r.lon)))), 2) AS distance
    from fooddelivery_delivery_boy as b
    cross join fooddelivery_restaurant as r on r.id = $res_id
    WHERE payments_verify_expired_deliveryboy(b.id)=0
    AND b.attendance='yes'
    AND b.status='active'
    AND b.session='yes'
    AND b.id NOT IN(SELECT DISTINCT is_assigned
    FROM fooddelivery_bookorder where status IN(5,3))
    HAVING distance BETWEEN 0 AND 20;");
    $resVerify = mysqli_fetch_array($sqlSelectVerifyEnable);
    if (count($resVerify) == 0) {
        $arrRecord['success'] = "-2";
        $arrRecord['message'] = 'Lo sentimos no tenemos repartidores disponibles en el momento, inténtelo más tarde.';
        echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'orders.php';</script>";
        exit;
    }

    $sqlSelectVerifyEnableRest = mysqli_query($conn, "SELECT * from fooddelivery_restaurant "
        . "WHERE id=$res_id "
        . "AND `is_active` is null ;");
    $resVerifyRes = mysqli_fetch_array($sqlSelectVerifyEnableRest);
    if (count($resVerifyRes) == 0) {
        $arrRecord['success'] = "-4";
        $arrRecord['message'] = 'Lo sentimos la Tienda a la que intentas hacer el pedido no está atendiendo, inténtelo más tarde.';
        echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'orders.php';</script>";
        exit;
    }

    if (isset($_POST['order_note'])) {

        if ($_POST['user_id_individual'] > '1' || $_POST['order_phone'] > '1' || $_POST['assign_rider'] > '1' || $_POST['store_id'] > '1') {

            if ($_POST['delivery_price'] > 0.99) {

                $store_id = $_POST['store_id'];
                if ($store_id == '682') { //Tienda Santo Domingo
                    $order_dni = '9999999999';
                    $order_name = 'Faster Soporte';
                    $address = $_POST['logistic'];
                    $lat = '-0.259384';
                    $long = '-79.170022';
                    $notes = '2';
                    $total_price = number_format('0.00', 2, '.', '');
                    $prod = '9407'; //id submenu
                    $res_id = $_POST['store_id']; //Pide Lo Que Sea id
                    $user_id = $_POST['user_id']; //Faster Soporte
                    $order_phone = $_POST['order_phone'];
                    $order_note = $_POST['order_note'];
                    $delivery_price = number_format($_POST['delivery_price'], 2, '.', '');
                    $amount_pay = $delivery_price;
                    $total_general = number_format($delivery_price + $total_price, 2, '.', '');
                    $notify = '1';
                    $status = '0';
                } elseif ($store_id == '683') { //Tienda Santa Elena
                    $order_dni = '9999999999';
                    $order_name = 'Faster Soporte';
                    $address = $_POST['logistic'];
                    $lat = '-2.205456';
                    $long = '-80.958405';
                    $notes = '2';
                    $total_price = number_format('0.00', 2, '.', '');
                    $prod = '9408'; //id submenu
                    $res_id = $_POST['store_id']; //Pide Lo Que Sea id
                    $user_id = $_POST['user_id']; //Faster Soporte
                    $order_phone = $_POST['order_phone'];
                    $order_note = $_POST['order_note'];
                    $delivery_price = number_format($_POST['delivery_price'], 2, '.', '');
                    $amount_pay = $delivery_price;
                    $total_general = number_format($delivery_price + $total_price, 2, '.', '');
                    $notify = '1';
                    $status = '0';
                } elseif ($store_id == '684') { //Tienda Guayaquil
                    $order_dni = '9999999999';
                    $order_name = 'Faster Soporte';
                    $address = 'Sucursal Guayaquil';
                    $lat = '-2.1889152';
                    $long = '-79.8892503';
                    $notes = '2';
                    $total_price = number_format('0.00', 2, '.', '');
                    $prod = '9409'; //id submenu
                    $res_id = $_POST['store_id']; //Pide Lo Que Sea id
                    $user_id = $_POST['user_id']; //Faster Soporte
                    $order_phone = $_POST['order_phone'];
                    $order_note = $_POST['order_note'];
                    $delivery_price = number_format($_POST['delivery_price'], 2, '.', '');
                    $amount_pay = $delivery_price;
                    $total_general = number_format($delivery_price + $total_price, 2, '.', '');
                    $notify = '1';
                    $status = '0';
                }

                mysqli_set_charset($conn, "utf8");

                $sql = "insert into fooddelivery_bookorder (order_dni,order_name,order_phone,amount_pay,`id`, `user_id`, `res_id`, `address`, `lat`, `long`, `notes`, `total_price`, `payment`, `created_at`, `notify`, `status`, `delivery_price`, `total_general`,order_note) "
                    . "values('$order_dni','$order_name','$order_phone','$amount_pay',NULL,'" . $user_id . "','" . $res_id . "','" . $address . "','" . $lat . "','" . $long . "','" . $notes . "','" . $total_price . "','Contra Entrega',UNIX_TIMESTAMP( DATE_FORMAT(NOW(6), '%Y-%m-%d %H:%i:%s')),'" . $notify . "','" . $status . "','" . $delivery_price . "','" . $total_general . "','" . $order_note . "')";
                $res = mysqli_query($conn, $sql);
                $last_id = mysqli_insert_id($conn);

                //validacion $last_id es mayor que 0
                if ($last_id != 0 || $last_id != null) {
                    $sql_qry = "INSERT INTO fooddelivery_food_desc(order_id,res_id,ItemId,ItemQty,ItemAmt) VALUES('$last_id','$res_id','$prod', '1', '0.0')";
                    $qry = mysqli_query($conn, $sql_qry);
                } else {
                    $arrRecord['success'] = "0";
                    $arrRecord['message'] = 'Existe una orden pendiente de procesar, agrega una nueva orden con otro usuario.';
                    echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'orders.php';</script>";
                    exit;
                }

                //Aquí enviar el push 
                $order_id = $last_id;
                $user_id = $user_id;
                $queryDeliveryBoysFree = mysqli_query($conn, "SELECT
            t.*,
            ROUND((6371 * ACOS(COS(RADIANS(b.longitude )) * COS(RADIANS(r.lon)) * COS(RADIANS(r.lat) - RADIANS(b.latitude)) + SIN(RADIANS(b.longitude )) * SIN(RADIANS(r.lon)))), 2) AS distance
        FROM
            fooddelivery_tokendata AS t
            INNER JOIN fooddelivery_delivery_boy AS b ON b.id = t.delivery_boyid
            CROSS JOIN fooddelivery_restaurant AS r ON r.id = $res_id
        WHERE
            t.type = 'android'
            AND t.delivery_boyid IN (SELECT id
                                    FROM
                                        (SELECT
                                            id, DELIVERY_BOY_COUNT_BOOKORDERS_TODAY(id) AS orders
                                        FROM
                                            fooddelivery_delivery_boy
                                        WHERE
                                            PAYMENTS_VERIFY_EXPIRED_DELIVERYBOY(id) = 0
                                                AND attendance = 'yes'
                                                AND status = 'active'
                                                AND session = 'yes'
                                                AND id NOT IN (SELECT DISTINCT
                                                    is_assigned
                                                FROM
                                                    fooddelivery_bookorder
                                                WHERE
                                                    status IN (1,3,5))
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
                    $data1 = array();
                }
                if (isset($data)) {

                    if (!empty($data)) {

                        $arrRecord['success'] = "1";
                        $arrRecord['message'] = 'Pedido enviado correctamente';
                        $arrRecord['order_details'] = $data;
                        echo "<script>window.location = 'orders.php';</script>";
                        exit;
                    } else {
                        $arrRecord['success'] = "0";
                        $arrRecord['message'] = 'No se ha podido realizar el pedido inténtelo más tarde';
                        echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'orders.php';</script>";
                        exit;
                    }
                    $arrRecord['success'] = "0";
                } else {
                    $arrRecord['message'] = 'No se ha podido realizar el pedido inténtelo más tarde';
                    echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'orders.php';</script>";
                    exit;
                }
            } else {
                $arrRecord['success'] = "23";
                $arrRecord['message'] = 'El valor de entrega debe ser mayor a 1.00 dolar. Ingresa un valor Ej: 2.50';
                echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'dashboard';</script>";
                exit;
            }
        } else {
            $arrRecord['success'] = "20";
            $arrRecord['message'] = 'Error de envío de parámetos, elimina historial del navegador';
            echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'orders.php';</script>";
            exit;
        }
    } else {
        $arrRecord['success'] = "20";
        $arrRecord['message'] = 'Error de envío de parámetos al intentar realizar el pedido';
        echo "<script>alert('" . $arrRecord['message'] . "'); window.location = 'orders.php';</script>";
        exit;
    }
}
