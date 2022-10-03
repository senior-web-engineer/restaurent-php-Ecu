<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);

if(isset($deliverboy_id)){
    $rname = $api->getdeliveryboyname($deliverboy_id);
    if($rname){
        if($api->CanRegister($rname)){
            echo json_encode($api->getRegisterData());
            exit;
        }
        else{
            $curday = date('N');
            if ($curday < 4) {
                $rdate = date("d-m-Y", mktime(0, 0, 0, date('n'), date('j') + 4 - $curday, date('Y')));
                $rday = 4;
            } elseif ($curday < 7) {
                $rdate = date("d-m-Y", mktime(0, 0, 0, date('n'), date('j') + 7 - $curday, date('Y')));
                $rday = 7;
            } else{
            	$rdate = date("d-m-Y", mktime(0, 0, 0, date('n'), date('j') + 4, date('Y')));
                $rday = 4;
            }
            echo json_encode(array("success" => false, "week" => $rday, "date" => $rdate));
        }
    }
}
echo json_encode($error);
