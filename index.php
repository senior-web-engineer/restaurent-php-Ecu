<?php
include('application/db_config.php');
session_start();
if (isset($_POST['login'])) 
{
    $username = $_POST['email'];
    $password = $_POST['password'];

    $qry = mysqli_query($conn,"SELECT id,email, password,role,username FROM fooddelivery_adminlogin WHERE email='".$username."' AND password='".$password."'
        UNION 
        SELECT id,email, password,role,username FROM fooddelivery_res_owner WHERE email='".$username."' AND password='".$password."'");

    $result = mysqli_fetch_array($qry);

    if($result['role']=='1')
    {
        session_start();
        $_SESSION['username'] = $result['username'];
        $_SESSION['uid'] = $result['id'];
        $_SESSION['role'] = $result['role'];
        echo "<script>window.location='dashboard.php'</script>";
    }
                
    if($result['role']=='2')
    {
        session_start();
        $_SESSION['username'] = $result['username'];
        $_SESSION['uid'] = $result['id'];
        $_SESSION['role'] = $result['role'];
        echo "<script>window.location='partners/dashboard'</script>";
    }else {
        $fail = '<strong>Usuario o contraseña es inválido</strong>';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Faster | Iniciar Sesión</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
    <meta content="" name="Faster - Delivery App" />
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
</head>
<body class="pace-top">
<div id="page-container" class="fade">
    <div class="login bg-black animated fadeInDown">
        <div class="login-header" align="center">
            <div class="brand">
                <img src="assets/img/logo_faster.png" width="50%" >
            </div>
        </div>
        <div class="login-content">
            <form  method="POST" class="margin-bottom-0">
                <div class="form-group m-b-20">
                    <div style="color: red;" align="center" ><?php echo $fail; ?></div>
                    <div id="msg" style="color: green;" align="center" ></div>
                </div>
                <div class="form-group m-b-20">
                    <input type="email" name="email" value="" class="form-control input-lg" placeholder="Correo electrónico" required/>
                </div>
                <div class="form-group m-b-20">
                    <input type="password" name="password" value="" class="form-control input-lg" placeholder="Contraseña" required/>
                </div>
                <div class="login-buttons">
                    <button type="submit" name="login" class="btn btn-success btn-block btn-lg"><strong><i class="fas fa-unlock-alt"></i> Iniciar Sesión</strong></button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="assets/js/jquery-1.9.1.min.js"></script>
<script src="assets/js/jquery-migrate-1.1.0.min.js"></script>
<script src="assets/js/jquery-ui.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/jquery.slimscroll.min.js"></script>
<script src="assets/js/jquery.cookie.js"></script>
<script src="assets/js/apps.min.js"></script>
<script>
    $(document).ready(function()
    {
        App.init();
    });
</script>
</body>
</html>