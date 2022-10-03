<?php
    include '../controllers/apicontroller.php';
    include 'error_response.php';
    
    if(!empty($_GET)){
    
    	mysqli_set_charset($conn, 'utf8');
        $user_id = filter_var($_GET['user_id'], FILTER_SANITIZE_NUMBER_INT);
        $lat = $_GET['lat'];
        $lon = $_GET['lon'];
        $search = $_GET['search'];
        $city = filter_var($_GET['city'], FILTER_SANITIZE_STRING);
        $code = filter_var($_GET['code'], FILTER_SANITIZE_STRING);
        $so = filter_var($_GET['operative_system'], FILTER_SANITIZE_STRING);
        $headers = apache_request_headers();
        $tokenHeader = $headers['Authorization'];
        $token = str_replace("Bearer ", "", $tokenHeader);
        $verificarSesion = verifyInfoUserVersion($user_id, $code, $so, $token);
        if (!$verificarSesion['verify']) {
            echo json_encode($verificarSesion);
            exit;
        }
        
        if (isset($_GET['city'])) {
            $api = new apicontroller();
            echo json_encode($api->getAdvertisingList($lat, $lon, $city, $search));
            exit;
        }
        else{
       		$arrRecord['success'] = "20";
            $arrRecord['message'] = 'Error de envío de parámetos al intentar listar.';
            $arrRecord['restaurant_list'] = array();
            echo json_encode($arrRecord);
            exit;
        }
    }
    $arrRecord['success'] = "0";
    echo json_encode($arrRecord);
    exit;

