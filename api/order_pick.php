<?php

include "../application/db_config.php";
include '../order_message.php';
include 'error_response.php';
$arrRecord = array();

if (isset($_REQUEST["order_id"])) {
    $order_id = $_REQUEST['order_id'];
    
    //Push Notification
    $order_user=mysqli_query($conn,"select * from fooddelivery_bookorder WHERE `id`='".$order_id."'");
    $user=mysqli_fetch_array($order_user);
    $user_id=$user['user_id'];

    $querya=mysqli_query($conn,"select * from fooddelivery_server_key");
    $resa=mysqli_fetch_array($querya);
    $google_api_key=$resa['android_key'];
    $ios_api_key=$resa['ios_key'];

    $sendresult = array();
    $query=mysqli_query($conn,"select * from fooddelivery_tokendata where type='android' AND user_id='".$user_id."'");
    $res=mysqli_fetch_array($query);
    $reg_id = $res['token'];
    $massage = $pickorder_msg;
        
    if ($res['type'] == 'android') {

        $registrationIds =  $reg_id ;
        
        $message = array(
            'message' => $massage,
            'title' => 'Estado de su pedido');

        $fields = array(
            'registration_ids'  =>  array($registrationIds),
            'data'      => $message
        );

        $url = 'https://fcm.googleapis.com/fcm/send';

        $headers = array(
            'Authorization: key='.$google_api_key,// . $api_key,
            'Content-Type: application/json'
        );

        $json =  json_encode($fields);

        $ch = curl_init();
       
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS,$json);

        $result = curl_exec($ch);
        //print_r($result); exit();
        if ($result === FALSE){
                die('Curl failed: ' . curl_error($ch));
            }   

            curl_close($ch);
            $response=json_decode($result,true);
            //print_r($response); exit();
            if($response['success']>0)
            {
                $sendresult['android'] = $response['success'];
            }
            else
            {
               $sendresult['android'] = 0;
            }
    } else {
        $queryios=mysqli_query($conn,"select * from fooddelivery_tokendata where type='Iphone' AND user_id='".$user_id."'");
        $resios=mysqli_fetch_array($queryios);

        $reg_id= $resios['token'];

        $registrationIds = $reg_id;

        $msg = array(
        'body'  => $massage,
        'title'     => "Notification",
        'vibrate'   => 1,
        'sound'     => 1,
        );

        $fields = array(
            'registration_ids'  => array($registrationIds),
            'notification'      => $msg
        );
        
        $headers = array(
            'Authorization: key=' . $ios_api_key,
            'Content-Type: application/json'
        );

        $ch = curl_init();
        curl_setopt( $ch,CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send' );
        curl_setopt( $ch,CURLOPT_POST, true );
        curl_setopt( $ch,CURLOPT_HTTPHEADER, $headers );
        curl_setopt( $ch,CURLOPT_RETURNTRANSFER, true );
        curl_setopt( $ch,CURLOPT_SSL_VERIFYPEER, false );
        curl_setopt( $ch,CURLOPT_POSTFIELDS, json_encode( $fields ) );
        $result = curl_exec($ch );

        if ($result === FALSE){
            die('Curl failed: ' . curl_error($ch));
        }   

        curl_close($ch);
        $response=json_decode($result,true);
        //print_r($response); exit();
        if($response['success']>0)
        {
            {
                $sendresult['ios'] = $response['success'];
            }
        }
        else
        {
           $sendresult['ios'] = 0;
        }
    }
    $query = mysqli_query($conn,"select timezone from fooddelivery_adminlogin where id ='1'");
    $fetch = mysqli_fetch_array($query);
    $timezone = $fetch['timezone'];

    $default_time = explode(" - ", $timezone);
    $vals = $default_time[0];
    date_default_timezone_set($vals);
    $date = date('d-m-Y H:i');

        $sql = mysqli_query($conn,"UPDATE `fooddelivery_bookorder` SET status='3',delivery_date_time='".$date."',delivery_status='active' WHERE `id`='".$order_id."'");

        if (isset($sql)) {
                $arrRecord['success'] = "1";
                $arrRecord['order'] = $picked;
            } else {
                $arrRecord['success'] = "0";
                $arrRecord['order'] = $data_not_found;
            }
        } else {
            $arrRecord['success'] = "0";
            $arrRecord['order'] = $data_not_found;
        }
    echo json_encode($arrRecord);
    //echo '<pre>',print_r($arrRecord,1),'</pre>';
 ?>