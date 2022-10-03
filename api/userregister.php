<?php

include "../application/db_config.php";
include 'error_response.php';
include '../order_message.php';
//include_once ('../assets/resize/resize.php');
////Verify if account is active
mysqli_set_charset($conn, 'utf8');

$fullname = filter_var(trim(ucwords(strtolower($_POST['fullname']))), FILTER_SANITIZE_STRING);
$code = filter_var($_POST['code'], FILTER_SANITIZE_STRING);
$phone_no = filter_var($_POST['phone_no'], FILTER_SANITIZE_STRING);
$image = "profile_1615341022.jpeg";
$operative_system = filter_var($_POST['operative_system'], FILTER_SANITIZE_STRING);
$headers = apache_request_headers();
$tokenHeader = $headers['Authorization'];
$token = str_replace("Bearer ", "", $tokenHeader);

/*function store_uploaded_image($html_element_name, $url_imagen, $new_img_width, $new_img_height) {
    $image = new SimpleImage();
    $image->load($_FILES[$html_element_name]['tmp_name']);
    $image->resize($new_img_width, $new_img_height);
    $image->save($url_imagen);
    return true;
}*/


if (isset($_POST['fullname']) && isset($_POST['phone_no']) && isset($_POST['operative_system']) && isset($headers['Authorization']) && isset($_POST['code'])){
    try {
        $time = time();
        $imagename = "profile_1815071303.png";
        $_conexion = ConexionLogin::getConnection();
        $consulta = $_conexion->selectAssociative("CALL user_create_or_update_user('$fullname','$phone_no','$imagename','$token','$operative_system','$code');");
        $cont = 0;
        while ($cont < count($consulta)) {
            $consulta[$cont]['fullname'] = htmlspecialchars_decode($consulta[$cont]['fullname'], ENT_QUOTES);
            $consulta[$cont]['email'] = htmlspecialchars_decode($consulta[$cont]['email'], ENT_QUOTES);
            $consulta[$cont]['phone_no'] = htmlspecialchars_decode($consulta[$cont]['phone_no'], ENT_QUOTES);
            $consulta[$cont]['referal_code'] = htmlspecialchars_decode($consulta[$cont]['referal_code'], ENT_QUOTES);
            $consulta[$cont]['image'] = htmlspecialchars_decode($consulta[$cont]['image'], ENT_QUOTES);
            $consulta[$cont]['created_at'] = htmlspecialchars_decode($consulta[$cont]['created_at'], ENT_QUOTES);
            $consulta[$cont]['login_with'] = htmlspecialchars_decode($consulta[$cont]['login_with'], ENT_QUOTES);
            $cont++;
        }
        $arrRecord['success'] = "1";
        $arrRecord['message'] = "ok";
        $arrRecord["user_detail"] = $consulta;
        echo json_encode($arrRecord);
        exit;
        
    } catch (Exception $exc) {
        if ($exc->getCode() == "45001") {
            $arrRecord['success'] = "203";
            $arrRecord['message'] = 'Existe una nueva versión de Faster, por favor descárgala para seguir utilizando la aplicación.';
            $arrRecord['restaurant_list'] = array();
            echo json_encode($arrRecord);
            exit;
        } else {
            $arrRecord['success'] = "10";
            $arrRecord['message'] = 'Lo sentimos por el momento no podemos procesar tu solicitud';
            $arrRecord["user_detail"] = array();
            echo json_encode($arrRecord);
            exit;
        }
    }
} else {
    $arrRecord['success'] = "20";
    $arrRecord['message'] = 'Error de envío de parámetros al intentar registrar información de usuario';
    $arrRecord["user_detail"] = array();
    echo json_encode($arrRecord);
    exit;
}
?>