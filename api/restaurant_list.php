<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
////Verify if account is active
mysqli_set_charset($conn, 'utf8');

$user_id = filter_var($_GET['user_id'], FILTER_SANITIZE_NUMBER_INT);
$lat = $_GET['lat'];
$lon = $_GET['lon'];
//if ($_GET['city'] == 'Santo Domingo') {
//    $_GET['city'] = 'Santo Domingo de los Colorados';
//}
$city = filter_var($_GET['city'], FILTER_SANITIZE_STRING);
$code = filter_var($_GET['code'], FILTER_SANITIZE_STRING);
$so = filter_var($_GET['operative_system'], FILTER_SANITIZE_STRING);
$search = filter_var($_GET['search'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);
$verificarSesion = verifyInfoUserVersion($user_id, $code, $so, $token);

if (isset($_GET['pageno'], $_GET['noofrecords'], $_GET['search'], $_GET['user_id'], $_GET['lat'], $_GET['lon'], $_GET['city'], $_GET['code'], $_GET['operative_system'], $headers['Authorization'])) {
    if (!$verificarSesion['verify']) {
        echo json_encode($verificarSesion);
        exit;
    }
    try {
        $offset = 0;
        $records = $_GET['noofrecords'];

        if ($_GET['pageno']) {
            $page_value = $_GET['pageno'];
            if ($page_value > 1) {
                $offset = ($page_value - 1) * $records;
            }
        }
        $_conexion = ConexionLogin::getConnection();
//        echo "CALL restaurant_get_restaurants_by_city('$search','$lat','$lon ','$city',$records,$offset);";
        $consulta = $_conexion->selectAssociative("CALL restaurant_get_restaurants_by_city('$search','$lat','$lon ','$city',$records,$offset);");

        $pagecount = count($consulta);

        if ($pagecount > 0) {
            $arrRecord['success'] = "1";
            $arrRecord['message'] = "ok";

            $cont = 0;
            while ($cont < count($consulta)) {
                $idRestaurant = $consulta[$cont]['id'];
//                $consulta[$cont]['close_time']=$consulta[$cont]['open_time'];
//                 $consulta[$cont]['open_time']=$consulta[$cont]['close_time'];
                $consultaCategory = $_conexion->selectAssociative("CALL category_get_categories_by_restaurant($idRestaurant);");
                $categoryTmp = [];
                $contCategory = 0;
                while ($contCategory < count($consultaCategory)) {
                    $categoryTmp[$contCategory] = $consultaCategory[$contCategory]['name'];
                    $contCategory++;
                }
                $consulta[$cont]['Category'] = $categoryTmp;

                $consulta[$cont]['res_status'] = $consulta[$cont]['openclosehorario'] == "1" ? 'open' : 'closed';
                $consulta[$cont]['res_status_manual'] = $consulta[$cont]['enable'] == "1" ? 'open' : 'closed';
                if ($consulta[$cont]['res_status'] == 'open') {

                    if ($consulta[$cont]['res_status_manual'] == 'open') {
                        $consulta[$cont]['open_time'] = $consulta[$cont]['close_time'];
                    } else {
                        
                    }
                } else {
                    $consulta[$cont]['close_time'] = $consulta[$cont]['open_time'];
                }
                $cont++;
            }
            $arrRecord['restaurant_list'] = $consulta;
            echo json_encode($arrRecord);
            exit;
        } else {
            if ($page_value == 1 || ($page_value * $records) <= $pagecount) {
                $arrRecord['success'] = "201";
                $arrRecord['message'] = "Lo sentimos mucho, aún no hay Tiendas disponibles o no tenemos cobertura en tu zona.";
                $arrRecord['restaurant_list'] = $consulta;
                echo json_encode($arrRecord);
                exit;
            } else {
                $arrRecord['success'] = "202";
                $arrRecord['message'] = "Ya se cargaron todos los datos con la búsqueda enviada.";
                $arrRecord['restaurant_list'] = $consulta;
                echo json_encode($arrRecord);
                exit;
            }
        }
    } catch (Exception $exc) {
        if ($exc->getCode() == "45012") {
            $arrRecord['success'] = "203";
            $arrRecord['message'] = 'Lo sentimos mucho, aún no hay Tiendas disponibles o no tenemos cobertura en tu zona.';
            $arrRecord['restaurant_list'] = array();
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "204";
            $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud al buscar Tiendas.';
            $arrRecord['restaurant_list'] = array();
            echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetos al intentar listar Tiendas.';
    $arrRecord['restaurant_list'] = array();
    echo json_encode($arrRecord);
    exit;
}
?>