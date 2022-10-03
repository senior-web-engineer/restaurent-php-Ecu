<?php
include "../application/db_config.php";
include 'error_response.php';
$arrRecord = array();

if (isset($_REQUEST["order_id"])) {

    $order_id = $_REQUEST['order_id'];
    
    $sqlSelect = mysqli_query($conn,"SELECT fb.id as order_id,fb.user_id,fb.created_at,fb.res_id , fr.address as restaurant_address , fb.total_price as order_amount,fr.id,fr.name as restaurant_name,fu.email,fu.fullname FROM fooddelivery_bookorder fb 
        inner join fooddelivery_restaurant fr on fb.res_id = fr.id
        inner join fooddelivery_users fu on fb.user_id = fu.id
        where fb.id='".$order_id."'");
    $res = mysqli_fetch_array($sqlSelect);
    {
        $data[] = array(
            "order_id" => $res['order_id'],
            "user_id" => $res['user_id'],
            "restaurant_name" => $res['restaurant_name'],
            "restaurant_address" => $res['restaurant_address'],
            "order_amount" => $res['order_amount'],
            "fullname" => $res['fullname'],
            "email" => $res['email'],
        );
    }

    $nameex = explode(' ', $res['fullname']);
    $firstname = $nameex[0];
    $lastname = $nameex[1];

    $date = date("d-M-Y H:i:s", $res['created_at']);

    require_once 'vendor/autoload.php';

    MercadoPago\SDK::configure(['ACCESS_TOKEN' => 'TEST-5660155854286752-081400-2bf177e1d133206a99ee09afa5f6741d-345436371']);

    $preference = new MercadoPago\Preference();

      $item = new MercadoPago\Item();
      $item->id = "Code";
      $item->title = "Enormous Wooden Hat";
      $item->description = "Description";
      $item->category_id = "Category";
      $item->picture_url = "https://www.mercadopago.com/org-img/MP3/home/logomp3.gif";
      $item->quantity = 1;
      $item->currency_id = "ARS";
      $item->unit_price = 14.79;

      $payer = new MercadoPago\Payer();
      $payer->name = "Chirag";
      $payer->surname = "Redixbit";
      $payer->date_created = "2014-07-28T09:50:37.521-04:00";
      $payer->email = "test_user_19653727@testuser.com";
      $payer->phone = "4444-4444";
      $payer->identification = "12345678";
      $payer->address = "address";

      $preference->items = array($item);
      $preference->payer = $payer;
      $preference->save();

      print_r($preference);
}
//echo json_encode($arrRecord);
//echo '<pre>',print_r($arrRecord,1),'</pre>';
?>