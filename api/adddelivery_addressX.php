<?php
extract($_REQUEST);
include 'cSql.class.php';
//include 'cLimpiarCodigo.php';
class apiaddress
{
    public function insertdelivery_address(){

        if (isset($_POST['user_id']) && $_POST['address'] != "") {
            // $objLim = new cLimpiarCodigo();
            $user_id = $_POST['user_id'];
            $latitude = $_POST['latitude'];
            $longitude = $_POST['longitude'];
            $address = $_POST['address'];
            $alias = $_POST['alias'];
            $phone = $_POST['phone'];
            $delivery_note = $_POST['delivery_note'];
            $department_number = $_POST['department_number'];

            //$objLim = new cLimpiarCodigo();
            /*$user_id = "125";
            $latitude = "-125151";
            $longitude = "-15452222222";
            $address = "dddddddddd";
            $alias = "aliasss";
            $phone = "098855445";
            $delivery_note = "note";
            $department_number = "215";*/
            //$objVal = new cValidacion;
            //$valresultado = '';

            //$objCodi = new cCodigo;
            //$codigo = $objCodi->formatear_codigo("pecon_contac", "PECON_CODIGO", "CONT");
            $objSql = new cSql;
            $campos = "`user_id`, `date_address`, `latitude`, `longitude`, `address`, `alias`, `phone`, `delivery_note`, `department_number`";
            $valores = "'" . $user_id . "',now(),'" . $latitude . "', '" . $longitude . "', '" . $address . "', '" . $alias . "', '" . $phone . "', '" . $delivery_note . "', '" . $department_number . "'";
            //$objSql->insertar("fooddelivery_delivery_address", $campos, $valores);
            //echo $user_id . " - " . $delivery_note;
            if ($objSql->insertar("fooddelivery_delivery_address", $campos, $valores) == true) {
                //$valresultado = "Datos guardados";
                //echo $valresultado;
                return true;
            } else {
                //$valresultado = 'Se produjo un error. Intente nuevamente';
                //echo $valresultado;
                return false;
            }
        }
    }
}
?>