<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($order_id) && $order_id != "" && isset($boy_id) && $boy_id != ""){

$sendresult = array();

$query=mysqli_query($conn,"select * from fooddelivery_bookorder WHERE id='$order_id'");
$row=mysqli_fetch_array($query);
$order_id=$row['id'];
$user_id=$row['user_id'];

$querya=mysqli_query($conn,"select * from fooddelivery_server_key");
$resa=mysqli_fetch_array($querya);
$google_api_key=$resa['android_key'];
$ios_api_key=$resa['ios_key'];


$sendresult = array();
// Notification Data
$query=mysqli_query($conn,"select * from fooddelivery_tokendata where user_id='".$user_id."'");
$res1=mysqli_fetch_array($query);
if ($res1['type'] == 'android') {
    
    $reg_id= $res1['token'];
    $registrationIds =  $reg_id;

    $massage = "Your Order has been assigned to delivery boy, you will get knocked at your door step";

        $message = array(
            'message' => $massage,
            'title' => 'Estado de su pedido');

        $fields = array(
            'registration_ids'  => array($registrationIds),
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
        if($response['success']>0)
        {
            $sendresult['android'] = $response['success'];
        }
        else
        {
           $sendresult['android'] = 0;
        }

} elseif ($res1['type'] == 'Iphone') {

    $reg_id= $res1['token'];
    $registrationIds =  $reg_id ;

        $massage = "Your Order has been assigned to delivery boy, you will get knocked at your door step";

        $msgs = array(
        'body'  => $massage,
        'title'     => "Estado de su pedido",
        'vibrate'   => 1,
        'sound'     => 1,
        );

        $fields = array(
            'registration_ids'  => array($registrationIds),
            'notification'      => $msgs
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
// Notification Data
$sql=mysqli_query($conn,"select * from fooddelivery_tokendata where delivery_boyid='".$boy_id."'");
$res=mysqli_fetch_array($sql);
if ($res['type'] == 'android') {
    
    $reg_id= $res['token'];
    $registrationIds =  $reg_id;

    $massage = "You have assigned new order delivery by restaurant, pickup as soon as possible.";

        $message = array(
            'message' => $massage,
            'title' => 'Estado de su pedido');

        $fields = array(
            'registration_ids'  => array($registrationIds),
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
        if($response['success']>0)
        {
            $sendresult['android'] = $response['success'];
        }
        else
        {
           $sendresult['android'] = 0;
        }

} elseif ($res['type'] == 'Iphone') {

    $reg_id= $res['token'];
    $registrationIds =  $reg_id ;

        $massage = "You have assigned new order delivery by restaurant, pickup as soon as possible.";

        $msgs = array(
        'body'  => $massage,
        'title'     => "Estado de su pedido",
        'vibrate'   => 1,
        'sound'     => 1,
        );

        $fields = array(
            'registration_ids'  => array($registrationIds),
            'notification'      => $msgs
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
$update=mysqli_query($conn,"UPDATE `fooddelivery_bookorder` SET status='5',assign_date_time='".$date."',assign_status='active',`is_assigned`='".$boy_id."' WHERE `id`='".$order_id."'");
if($update)
{
    echo $assign;
  
} else {
    echo $no_record;
   
}

}else{
	echo $error;
}
?>