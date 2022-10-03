<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if(isset($deliverboy_id)){
    $rname = $api->getdeliveryboyname($deliverboy_id);
    $rtoken = $api->getdeliveryboytoken($deliverboy_id);
    if($rname){
        $dts = explode(",", $working_date);
        $tps = explode(",", $working_time);
        for ($i = 0 ; $i < count($dts) -1 ; $i++){
            $api->registerWorkingTime($rname, $dts[$i], $tps[$i]);
        }
        if($rtoken) $api->sendPush($rtoken);
    }
    else{
        echo $error;
    }
}
else
{
    echo $error;
}
