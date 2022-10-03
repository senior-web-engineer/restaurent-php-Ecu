<?php
@ob_start();
// Turn off error reporting
error_reporting(0);
// Report runtime errors
error_reporting(E_ERROR | E_WARNING | E_PARSE);
// Report all errors
error_reporting(E_ALL);
// Same as error_reporting(E   _ALL);
ini_set("error_reporting", E_ALL);
// Report all errors except E_NOTICE
error_reporting(E_ALL & ~E_NOTICE);
?> 
<?php
include 'cSql.class.php';
/*$user_id = $_POST['user_id'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$address = $_POST['address'];
$alias = $_POST['alias'];
$phone = $_POST['phone'];
$delivery_note = $_POST['delivery_note'];
$department_number = $_POST['department_number'];*/
// $objLim = new cLimpiarCodigo();
$user_id = "125";
$latitude = "-125151";
$longitude = "-15452222222";
$address = "dddddddddd";
$alias = "aliasss";
$phone = "098855445";
$delivery_note = "note";
$department_number = "215";
//$objVal = new cValidacion;
$valresultado = '';

//$objCodi = new cCodigo;
//$codigo = $objCodi->formatear_codigo("pecon_contac", "PECON_CODIGO", "CONT");
$objSql = new cSql;
$campos = "`user_id`, `date_address`, `latitude`, `longitude`, `address`, `alias`, `phone`, `delivery_note`, `department_number`";
$valores = "'" . $user_id . "',now(),'" . $latitude . "', '" . $longitude . "', '" . $address . "', '" . $alias . "', '" . $phone . "', '" . $delivery_note . "', '" . $department_number . "'";
//$objSql->insertar("fooddelivery_delivery_address", $campos, $valores);
//echo $user_id . " - " . $delivery_note;
if ($objSql->insertar("fooddelivery_delivery_address", $campos, $valores) == true) {
    $valresultado = "Datos guardados";
    echo $valresultado;
} else {
    $valresultado = 'Se produjo un error. Intente nuevamente';
    echo $conn;
}

?>