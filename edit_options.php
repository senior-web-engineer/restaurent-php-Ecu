<?php
session_start();
@$uid = $_SESSION['uid'];
@$role = $_SESSION['role'];
//print_r($role); exit();
if ($role != '1') {
    echo "<script>window.location='index.php'</script>";
    session_destroy();
}
include_once 'controllers/restaurant.php';
$user = new dashboard();

$qu_string = $_SERVER['QUERY_STRING'];
$id_val = $user->encrypt_decrypt("decrypt", $qu_string);
$id_exp = explode("=", $id_val);
$id = $id_exp[1];
$res = $user->getrestaurantdetail($id);
$res_own = $user->getresowner($res->id);

if (isset($_REQUEST['editrestaurant'])) {
        extract($_REQUEST);
        $date = date('d-m-Y H:i:s');
        $user->editoptions($id, $open_time, $close_time, $commission, $ally, $monday, $tuesday, $wednesday, $thursday, $friday, $saturday, $sunday, $uid, $date);
        if ($user) {
            ?><script>window.location = 'dashboard.php';</script><?php
        } else {
            ?><script>alert("Error: compruebe las conexiones de la base de datos y las clases principales.");</script><?php
        }
}

?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Faster | Editar Opciones</title>
        <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
        <meta content="" name="Faster" />
		<!-- Favicon -->
		<link rel="icon" href="assets/images/favicon.ico">
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
        <link href="assets/css/jquery-ui.min.css" rel="stylesheet" />
        <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
        <link href="assets/css/font-awesome.min.css" rel="stylesheet" />
        <link href="assets/fontawesome/css/all.css" rel="stylesheet" />
        <link href="assets/css/animate.min.css" rel="stylesheet" />
        <link href="assets/css/style.min.css" rel="stylesheet" />
        <link href="assets/css/style-responsive.min.css" rel="stylesheet" />
        <link href="assets/css/default.css" rel="stylesheet" id="theme" />
        <link href="assets/css/bwizard.min.css" rel="stylesheet" />
        <link href="assets/css/bootstrap-timepicker.min.css" rel="stylesheet" />
        <link href="assets/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
        <link href="assets/css/parsley.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&key=AIzaSyDwJZhcB4EIMSfGexpLmuZ0pQZbPz2IZaU"></script>
        <script src="../assets/js/locationpicker.js"></script>
    </head>
    <body class="boxed-layout">
        <div id="page-loader" class="fade in"><span class="spinner"></span></div>
        <div id="page-container" class="page-container fade page-without-sidebar page-header-fixed page-with-top-menu">
            <?php
            // include 'include/header.php';
            // include 'include/topmenu.php';
            ?>
            <div id="content" class="content">
                <div class="breadcrumb pull-right" style="padding-right: 16px;">
                    <button class="btn btn-inverse" onclick="window.location = 'dashboard.php'"><i class="far fa-arrow-alt-circle-left"></i> Atrás</button>
                </div>
                <h1 class="page-header">Editar Opciones de Tienda</h1>
                <div class="row">
                    <form class="form-horizontal form-bordered" data-parsley-validate="true" name="demo-form" method="post" enctype="multipart/form-data" role="form" onsubmit="return Validar_registro();">
                        <div class="col-md-6">
                            <div class="panel panel-inverse" data-sortable-id="form-validation-1">
                                <div class="panel-heading">
                                    <h4 class="panel-title">Detalles de la Tienda</h4>
                                </div>
                                <div class="panel-body panel-form">
                                    <div class="form-group">
                                        <label class="control-label col-md-4 col-sm-4" for="fullname">Nombre de la Tienda </label>
                                        <div class="col-md-6 col-sm-6">
                                            <strong><input class="form-control" type="text" value="<?php echo $res->name; ?>" id="name" name="name" placeholder="Nombre de la Tienda" data-parsley-required="true" maxlength="50" pattern=".{3,}" readonly="" style="cursor: no-drop;"/></strong>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-4">Apertura</label>
                                        <div class="col-md-6">
                                            <div class="input-group bootstrap-timepicker">
                                                <input id="timepicker" type="text" value="<?php echo $res->open_time; ?>" class="form-control" name="open_time" />
                                                <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-4">Cierra</label>
                                        <div class="col-md-6">
                                            <div class="input-group bootstrap-timepicker">
                                                <input id="timepicker1" type="text" value="<?php echo $res->close_time; ?>" class="form-control" name="close_time" />
                                                <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" align="center">
                                        <strong style="color: #000000;">Horario</strong>
                                        <div class="col-md-12">
                                            <table class="table table-responsive table-striped text-center">
                                                <tbody>
                                                    <tr style="color: #000000;">
                                                        <td><strong>Lun </strong><input type="checkbox" name="monday" value="YES" <?php if ($res->monday == 'YES') {echo 'checked';} ?>/></td>
                                                        <td><strong>Mar </strong><input type="checkbox" name="tuesday" value="YES"  <?php if ($res->tuesday == 'YES') {echo 'checked';} ?>/></td>
                                                        <td><strong>Mié </strong><input type="checkbox" name="wednesday" value="YES"  <?php if ($res->wednesday == 'YES') {echo 'checked';} ?>/></td>
                                                        <td><strong>Jue </strong><input type="checkbox" name="thursday" value="YES"  <?php if ($res->thursday == 'YES') {echo 'checked';} ?>/></td>
                                                        <td><strong>Vie </strong><input type="checkbox" name="friday" value="YES"  <?php if ($res->friday == 'YES') {echo 'checked';} ?>/></td>
                                                        <td><strong>Sáb </strong><input type="checkbox" name="saturday" value="YES"  <?php if ($res->saturday == 'YES') {echo 'checked';} ?>/></td>
                                                        <td><strong>Dom </strong><input type="checkbox" name="sunday" value="YES"  <?php if ($res->sunday == 'YES') {echo 'checked';} ?>/></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <br/>
                                    <br/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="panel panel-inverse" data-sortable-id="form-validation-2">
                                <div class="panel-heading">
                                    <h4 class="panel-title">Más Detalles de la Tienda</h4>
                                </div>
                                <div class="panel-body panel-form">
                                    <div class="form-group">
                                        <label class="control-label col-md-4 col-sm-4" for="website">Ciudad </label>
                                        <div class="col-md-6 col-sm-6">
                                            <input class="form-control" type="text" value="<?php echo $res->city; ?>" id="name" name="name" placeholder="Ciudad" data-parsley-required="true" maxlength="50" pattern=".{3,}" readonly="" style="cursor: no-drop;"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-4 col-sm-4" for="website">Dinámico </label>
                                        <div class="col-md-6 col-sm-6">
                                            <select name="ally" class="form-control" required>
                                                <option value="<?php echo $res->ally; ?>" selected><?php echo $res->ally; ?></option>
                                                <?php
                                                if (in_array($uid, [1, 5, 8, 6, 10, 23])){
                                                ?>
                                                <option value="NO">NO</option>
                                                <option value="Gratis">Gratis</option>
                                                <option value="- 0.10">- 0.10</option>
                                                <option value="- 0.20">- 0.20</option>
                                                <option value="- 0.25">- 0.25</option>
                                                <option value="- 0.30">- 0.30</option>
                                                <option value="- 0.40">- 0.40</option>
                                                <option value="- 0.50">- 0.50</option>
                                                <option value="- 0.60">- 0.60</option>
                                                <option value="- 0.70">- 0.70</option>
                                                <option value="- 0.80">- 0.80</option>
                                                <option value="- 0.90">- 0.90</option>
                                                <option value="- 1.00">- 1.00</option>
                                                <option value="+ 0.05">+ 0.05</option>
                                                <option value="+ 0.10">+ 0.10</option>
                                                <option value="+ 0.20">+ 0.20</option>
                                                <option value="+ 0.25">+ 0.25</option>
                                                <option value="+ 0.30">+ 0.30</option>
                                                <option value="+ 0.40">+ 0.40</option>
                                                <option value="+ 0.50">+ 0.50</option>
                                                <option value="+ 0.60">+ 0.60</option>
                                                <option value="+ 0.70">+ 0.70</option>
                                                <option value="+ 0.80">+ 0.80</option>
                                                <option value="+ 0.90">+ 0.90</option>
                                                <option value="+ 1.00">+ 1.00</option>
                                                <?php
                                                } else {
                                                ?>
                                                <option value="NO">NO</option>
                                                <?php
                                                }
                                                ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-4 col-sm-4" for="website">Comisión</label>
                                        <div class="col-md-6 col-sm-6">
                                            <select name="commission" class="form-control" required>
                                                <option value="<?php echo $res->commission; ?>" selected><?php echo $res->commission ."%"; ?></option>
                                                <option value="0" >0%</option>
                                                <option value="3" >3%</option>
                                                <option value="5" >5%</option>
                                                <option value="8" >8%</option>
                                                <option value="10" >10%</option>
                                                <option value="15" >15%</option>
                                                <option value="20" >20%</option>
                                                <option value="25" >25%</option>
                                                <option value="30" >30%</option>
                                            </select>
                                        </div>
                                    </div>
                                    <br/>
                                    <div align="center">
                                        <button type="submit" name="editrestaurant" id="addresto" class="btn btn-primary"><strong><i class="fa fa-edit"></i> Actualizar </strong></button>
                                    </div>
                                    <br/>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <script src="assets/validacion.js"></script>
        <script src="assets/identificacion.js"></script>
        <script src="assets/ajax.functions.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery-migrate-1.1.0.min.js"></script>
        <script src="assets/js/jquery-ui.min.js"></script>
        <script src="assets/js/jquery.slimscroll.min.js"></script>
        <script src="assets/js/jquery.cookie.js"></script>
        <script src="assets/js/bootstrap-datepicker.js"></script>
        <script src="assets/js/ion.rangeSlider.min.js"></script>
        <script src="assets/js/bootstrap-colorpicker.min.js"></script>
        <script src="assets/js/masked-input.min.js"></script>
        <script src="assets/js/bootstrap-timepicker.min.js"></script>
        <script src="assets/js/bootstrap-datetimepicker.min.js"></script>
        <script src="assets/js/bwizard.js"></script>
        <script src="assets/js/parsley.js"></script>
        <script src="assets/js/form-wizards.demo.min.js"></script>
        <script src="assets/js/form-wizards-validation.demo.min.js"></script>
        <script src="assets/js/form-plugins.demo.min.js"></script>
        <script src="assets/js/apps.min.js"></script>
        <script>
            $(document).ready(function () {
                App.init();
                FormWizardValidation.init();
                FormPlugins.init();
            });
        </script>
    </body>
</html>