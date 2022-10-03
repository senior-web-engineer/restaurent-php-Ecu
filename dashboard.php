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
require_once 'controllers/cEncryption.php';
$objEncrip = new cEncryption();
$user = new dashboard();
// $countwaitorderrider = $user->countwaitorderrider();
// if (!$user->get_session())
// {
//     header("location:index.php");
// }
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <title>Faster | Dashboard</title>
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
    <link href="assets/css/parsley.css" rel="stylesheet" />
    <link href="assets/css/select2.css" rel="stylesheet" type="text/css">
    <script src="assets/js/pace.min.js"></script>
    <script type="text/javascript">
        $.get('https://ipapi.co/timezone', function(data) {
            $.get('https://ipapi.co/timezone', function(data) {
                $('.timezone').text(data);
            });
        });
    </script>
</head>

<body class="boxed-layout">
    <div id="page-loader" class="fade in"><span class="spinner"></span></div>
    <div id="page-container" class="page-container fade page-without-sidebar page-header-fixed page-with-top-menu">
        <?php
        // include 'include/header.php';
        // include 'include/topmenu.php';
        ?>
        <div id="content" class="content">
            <div class="breadcrumb" align="center">
                

                <div class="btn-group m-b-20">
                    <a href="free_delivery.php" class="btn btn-warning btn-white-without-border" data-toggle="tooltip" data-title="Tiendas con envío gratis"><i class="fas fa-donate"></i> Envío Gratis</a>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="result-container">
                        <form method="get">
                            <div class="input-group m-b-20">
                                <input type="hidden" name="page" value="1">
                                <input type="text" name="search" class="form-control input-white" value="<?php if (isset($_GET['search'])) echo $_GET['search']; ?>" placeholder="Buscar Tienda" />
                                <div class="input-group-btn">
                                    <button type="submit" class="btn btn-inverse"><i class="fa fa-search"></i> Buscar</button>
                                    <a href="dashboard.php" type="submit" class="btn btn-inverse"> Reiniciar filtro</a>
                                </div>
                            </div>
                        </form>
                        <div class="btn-group">
                            
                            <a href="viewnewresowner.php" class="btn btn-success btn-white-without-border">Tiendas</a>
                            <a href="addnewtypestore.php" class="btn btn-success btn-white-without-border">Tipo Tiendas</a>
                        </div>

                        <?php
                        $per_page = 10;
                        if (isset($_GET['page'])) {
                            $pageset = $_GET['page'];
                            if ($pageset == 1) {
                                $start = 0;
                                $page = $per_page;
                            } else {
                                $page = $_GET['page'] * $per_page;
                                $start = $page - $per_page;
                            }
                        } else {
                            $start = 0;
                            $page = $per_page;
                        }
                        if (isset($_GET['search'])) {
                            $search = $_GET['search'];
                            $qutotal = $user->getrestaurant($search, "searchtotal", "none", "none");
                            $query = $user->getrestaurant($search, "search", $start, $per_page);
                        } elseif (isset($_GET['AXOsdsdf872']) && $_GET['AXOsdsdf872']) {
                            $search_enc = $_GET['AXOsdsdf872'];
                            $search_data = $user->encrypt_decrypt("decrypt", $search_enc);
                            $val = explode("=", $search_data);
                            $filter = $val[1];
                            $qutotal = $user->getrestaurant($filter, "filtertotal", "none", "none");
                            $query = $user->getrestaurant($filter, "filter", $start, $per_page);
                        } else {
                            $query = $user->getrestaurant("none", "none", $start, $per_page);
                            $qutotal = $user->getrestaurant("none", "total", "none", "none");
                        } ?>

                        <?php
                        if (isset($_GET['search'])) {
                            $cadena = $_GET['search'];
                            $cadena = str_replace(' ', '+', $cadena);
                        }

                        $perpage = 10;
                        if (isset($_GET['page']) && !empty($_GET['page'])) {
                            $urlpage = $_GET['page'];
                        } else {
                            $urlpage = 1;
                        }
                        $start = ($urlpage * $perpage) - $perpage;
                        $PageSql = "SELECT `id` FROM `fooddelivery_restaurant` WHERE `type_store`<>'Publicidad' AND `is_active`=0;";
                        $pageres = mysqli_query($conn, $PageSql);
                        $totalres = mysqli_num_rows($pageres);
                        $endpage = ceil($totalres / $perpage);
                        $startpage = 1;
                        $nextpage = $urlpage + 1;
                        $previouspage = $urlpage - 1;
                        ?>
                        <select name="cliente" id="mibuscador" style="width: 20%;" onchange="filterpage(this.value)">
                            <option value="">Filtrar por ciudad</option>
                            <?php
                            $restaurntlist = $user->getallcityfilter();
                            foreach ($restaurntlist as $list) {
                                $qstring1asd = "cname=" . $list['cname'];
                                $enc_str1asd = $user->encrypt_decrypt("encrypt", $qstring1asd);
                            ?>
                                <option value="<?php echo $enc_str1asd; ?>">
                                    <?php
                                    if ($list['cname'] == 'Santo Domingo de los Colorados') {
                                        echo 'Santo Domingo';
                                    } else {
                                        echo $list['cname'];
                                    }
                                    ?>
                                </option>
                            <?php
                            }
                            ?>
                        </select>
                        <script>
                            function filterpage(id) {
                                window.location = "dashboard.php?AXOsdsdf872=" + id;
                            }
                        </script>
                        
                        <script>
                            function filterpage(id) {
                                window.location = "dashboard.php?AXOsdsdf872=" + id;
                            }
                        </script>
                        <ul class="pagination pagination-without-border pull-right m-t-0">
                            <?php if ($urlpage != $startpage) { ?>
                                <li class="page-item">
                                    <a class="page-link" href="<?php

                                                                if (isset($_GET['search'])) {
                                                                    echo "dashboard.php?search=" . $cadena . "&page=" . $startpage;
                                                                } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                    echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $startpage;
                                                                } else {
                                                                    echo "dashboard.php?page=" . $startpage;
                                                                }

                                                                ?>" tabindex="-1" aria-label="Previous">
                                        <span aria-hidden="true">Primero</span>
                                        <span class="sr-only">Primero</span>
                                    </a>
                                </li>
                            <?php } ?>
                            <?php if ($urlpage >= 2) { ?>
                                <li class="page-item"><a class="page-link" href="<?php
                                                                                    if (isset($_GET['search'])) {
                                                                                        echo "dashboard.php?search=" . $cadena . "&page=" . $previouspage;
                                                                                    } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                                        echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $previouspage;
                                                                                    } else {
                                                                                        echo "dashboard.php?page=" . $previouspage;
                                                                                    }

                                                                                    ?>"><?php echo $previouspage ?></a></li>
                            <?php } ?>
                            <li class="page-item active"><a class="page-link" href="<?php
                                                                                    if (isset($_GET['search'])) {
                                                                                        echo "dashboard.php?search=" . $cadena . "&page=" . $urlpage;
                                                                                    } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                                        echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $urlpage;
                                                                                    } else {
                                                                                        echo "dashboard.php?page=" . $urlpage;
                                                                                    }

                                                                                    ?>"><?php echo $urlpage ?></a></li>
                            <?php if ($urlpage != $endpage) { ?>
                                <li class="page-item"><a class="page-link" href="<?php
                                                                                    if (isset($_GET['search'])) {
                                                                                        echo "dashboard.php?search=" . $cadena . "&page=" . $nextpage;
                                                                                    } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                                        echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $nextpage;
                                                                                    } else {
                                                                                        echo "dashboard.php?page=" . $nextpage;
                                                                                    }

                                                                                    ?>"><?php echo $nextpage ?></a></li>
                                <li class="page-item">
                                    <a class="page-link" href="<?php
                                                                if (isset($_GET['search'])) {
                                                                    echo "dashboard.php?search=" . $cadena . "&page=" . $endpage;
                                                                } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                    echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $endpage;
                                                                } else {
                                                                    echo "dashboard.php?page=" . $endpage;
                                                                }
                                                                ?>" aria-label="Next">
                                        <span aria-hidden="true">Último</span>
                                        <span class="sr-only">Último</span>
                                    </a>
                                </li>
                            <?php } ?>
                        </ul><br />
                        <ul class="result-list">
                            <?php
                            if ($query) {
                                foreach ($query as $val) {
                                    $enc_idval = $user->encrypt_decrypt("encrypt", "res_id=" . $val['id']);
                                    if ($val['is_active'] == 1) {
                                        $bgcolor = "indianred";
                                        $color = "white";
                                    } else {
                                        $bgcolor = "";
                                        $color = "";
                                    }
                            ?>
                                    <li style="background-color: <?php echo $bgcolor; ?>; color: <?php echo $color; ?>;">
                                        <div class="result-image col-md-3">
                                            <img src="uploads/restaurant/<?php echo $val['photo']; ?>" style="height:197px; width:270px;" alt="" />
                                        </div>
                                        <div class="result-info col-md-6">
                                            <h4 class="title"><strong style="color:#000000;"><?php echo $val['name']; ?></strong></h4>
                                            <div class="location" style="color: <?php echo $color; ?>; white-space: nowrap; width: 100%; overflow: hidden; text-overflow: ellipsis;"><?php echo $val['address']; ?></div>
                                            <div class="desc" style="margin-top: 6px;">
                                                <font color="black">Teléfono:</font>
                                                <?php echo $val['phone']; ?>&nbsp;&nbsp;&nbsp;
                                                <font color="black">Creado: </font><?php echo date("d-m-Y H:i:s", $val['timestamp']); ?>&nbsp;&nbsp;&nbsp;
                                                <font color="black">Ciudad: </font>
                                                <?php
                                                $city = $val['city'];

                                                if ($city == 'Santo Domingo de los Colorados') {
                                                    echo 'Santo Domingo';
                                                } else {
                                                    echo $city;
                                                }
                                                ?>

                                            </div>
                                            <div class="desc" style="margin-top: -15px;">
                                                <font color="black">Horario: </font><strong style="color:#01b62e;"><?php echo date("h:i a", strtotime($val['open_time'])) . " ~ " . date("h:i a", strtotime($val['close_time'])); ?></strong>
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                <font color="black">Tipo: </font> <?php echo $val['type_store']; ?>
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                <font color="black"><strong>Valor Dinámico: </strong></font>
                                                <?php
                                                if ($val['ally'] == 'Gratis' || $val['ally'] == 'NO') {
                                                    echo '<strong style="color: #ff3f2e;">' . $val['ally'] . ' </strong>';
                                                } else {
                                                    echo '<strong style="color: #ff3f2e;"> ' . "$ " . $val['ally'] . ' </strong>';
                                                }
                                                ?>
                                            </div>
                                            
                                            <div class="btn-row">

                                                <a href="edit_options.php?<?php echo $enc_idval; ?>" data-toggle="tooltip" data-container="body" data-title="Opciones"><i class="fas fa-cog" style="color: #000000;"></i></a>
                                                
                                                <?php
                                                $resstatus = $user->res_openandclose($val['id'], $val['open_time'], $val['close_time']);
                                                ?>
                                                

                                            </div>
                                        </div>
                                        <div class="result-price col-md-2">
                                            <h4><strong style="color: black;">Rating </strong></h4>
                                            <small style="color: <?php echo $color; ?>;">TOTAL COMENTARIOS</small>
                                            <?php
                                            if ($resstatus == "open") {
                                            ?>
                                                <div class="btn btn-success"><strong><i class="fas fa-door-open"></i> OPEN </strong></div>
                                            <?php
                                            } else {
                                            ?>
                                                <div class="btn btn-danger"><strong><i class="fas fa-door-closed"></i> CLOSE </strong></div>
                                            <?php
                                            }
                                            ?>
                                        </div>
                                    </li>
                            <?php
                                }
                            }
                            ?>

                        </ul><br />
                        <?php
                        if ($query == '0') {
                            echo '<div align="center" style="color: #ff3f2e;"><strong>¡Oops! No hemos encontrado resultados para la búsqueda</strong></div><br/>';
                        }
                        ?>
                        <ul class="pagination pagination-without-border pull-right m-t-0">
                            <?php if ($urlpage != $startpage) { ?>
                                <li class="page-item">
                                    <a class="page-link" href="<?php

                                                                if (isset($_GET['search'])) {
                                                                    echo "dashboard.php?search=" . $cadena . "&page=" . $startpage;
                                                                } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                    echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $startpage;
                                                                } else {
                                                                    echo "dashboard.php?page=" . $startpage;
                                                                }

                                                                ?>" tabindex="-1" aria-label="Previous">
                                        <span aria-hidden="true">Primero</span>
                                        <span class="sr-only">Primero</span>
                                    </a>
                                </li>
                            <?php } ?>
                            <?php if ($urlpage >= 2) { ?>
                                <li class="page-item"><a class="page-link" href="<?php
                                                                                    if (isset($_GET['search'])) {
                                                                                        echo "dashboard.php?search=" . $cadena . "&page=" . $previouspage;
                                                                                    } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                                        echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $previouspage;
                                                                                    } else {
                                                                                        echo "dashboard.php?page=" . $previouspage;
                                                                                    }

                                                                                    ?>"><?php echo $previouspage ?></a></li>
                            <?php } ?>
                            <li class="page-item active"><a class="page-link" href="<?php
                                                                                    if (isset($_GET['search'])) {
                                                                                        echo "dashboard.php?search=" . $cadena . "&page=" . $urlpage;
                                                                                    } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                                        echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $urlpage;
                                                                                    } else {
                                                                                        echo "dashboard.php?page=" . $urlpage;
                                                                                    }

                                                                                    ?>"><?php echo $urlpage ?></a></li>
                            <?php if ($urlpage != $endpage) { ?>
                                <li class="page-item"><a class="page-link" href="<?php
                                                                                    if (isset($_GET['search'])) {
                                                                                        echo "dashboard.php?search=" . $cadena . "&page=" . $nextpage;
                                                                                    } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                                        echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $nextpage;
                                                                                    } else {
                                                                                        echo "dashboard.php?page=" . $nextpage;
                                                                                    }

                                                                                    ?>"><?php echo $nextpage ?></a></li>
                                <li class="page-item">
                                    <a class="page-link" href="<?php
                                                                if (isset($_GET['search'])) {
                                                                    echo "dashboard.php?search=" . $cadena . "&page=" . $endpage;
                                                                } elseif (isset($_GET['AXOsdsdf872'])) {
                                                                    echo "dashboard.php?AXOsdsdf872=" . $search_enc . "&page=" . $endpage;
                                                                } else {
                                                                    echo "dashboard.php?page=" . $endpage;
                                                                }
                                                                ?>" aria-label="Next">
                                        <span aria-hidden="true">Último</span>
                                        <span class="sr-only">Último</span>
                                    </a>
                                </li>
                            <?php } ?>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modal-dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">Ciudades</h4>
                </div>
                <div class="modal-body">
                    <div class="panel panel-inverse" data-sortable-id="form-validation-1">
                        <div class="panel-body panel-form" align="center">
                            <form class="form-horizontal form-bordered" data-parsley-validate="true" method="post" action="" name="demo-form" enctype="multipart/form-data">
                                <div class="btn-group m-l-10 m-b-20">
                                    <a href="#" class="btn btn-warning"><strong><i class="fas fa-map-marked-alt"></i> Santo Domingo<span class="label label-success m-l-5"><?php echo $santodomingo_city; ?></span></strong></a>
                                </div>
                                <div class="btn-group m-l-10 m-b-20">
                                    <a href="#" class="btn btn-warning"><strong><i class="fas fa-map-marked-alt"></i> Guayaquil<span class="label label-success m-l-5"><?php echo $guayaquil; ?></span></strong></a>
                                </div>
                                <div class="modal-footer">
                                    <a href="javascript:;" class="btn btn-success" data-dismiss="modal"><strong><i class="far fa-thumbs-up"></i> Aceptar</strong></a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/jquery-1.9.1.min.js"></script>
    <script src="assets/js/jquery-migrate-1.1.0.min.js"></script>
    <script src="assets/js/jquery-ui.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/jquery.slimscroll.min.js"></script>
    <script src="assets/js/jquery.cookie.js"></script>
    <script src="assets/js/parsley.js"></script>
    <script src="assets/js/apps.min.js"></script>
    <script>
        $(document).ready(function() {
            App.init();
        });
    </script>
    <script>
        function deleterestaurant(id) {
            var x = confirm("¿Estás seguro de que deseas eliminar?");
            if (x) {
                $.ajax({
                    type: "POST",
                    url: "ajax/deleterestaurant.php",
                    data: {
                        querystring: id
                    },
                    cache: false,
                    success: function(data) {
                        if (data) {
                            window.location = '<?php echo $_SERVER['REQUEST_URI']; ?>';
                        } else {
                            alert("Por favor intente nuevamente...");
                        }
                    }
                });
            } else {
                window.location = '<?php echo $_SERVER['REQUEST_URI']; ?>';
            }
        }

        function activerestaurant(id) {
            var x = confirm("¿Estás seguro que deseas Activar/Desactivar la Tienda?");
            if (x) {
                $.ajax({
                    type: "POST",
                    url: "ajax/activerestaurant.php",
                    data: {
                        querystring: id
                    },
                    cache: false,
                    success: function(data) {
                        if (data) {
                            window.location = '<?php echo $_SERVER['REQUEST_URI']; ?>';
                        } else {
                            alert("Por favor intente nuevamente...");
                        }
                    }
                });
            } else {
                window.location = '<?php echo $_SERVER['REQUEST_URI']; ?>';
            }
        }

        function closeopenrestaurant(id) {
            var x = confirm("¿Estás seguro que deseas Cerrar o Abrir la Tienda?");
            if (x) {
                $.ajax({
                    type: "POST",
                    url: "ajax/closeopenrestaurant.php",
                    data: {
                        querystring: id
                    },
                    cache: false,
                    success: function(data) {
                        if (data) {
                            window.location = '<?php echo $_SERVER['REQUEST_URI']; ?>';
                        } else {
                            alert("Por favor intente nuevamente...");
                        }
                    }
                });
            } else {
                window.location = '<?php echo $_SERVER['REQUEST_URI']; ?>';
            }
        }
    </script>
</body>

</html>

<script src="assets/js/select2.js"></script>
<script type="text/javascript">
    var $ = jQuery.noConflict();
    $(document).ready(function() {
        $('#mibuscador').select2();
    });

    $(document).ready(function() {
        $('#filtersub').select2();
    });
</script>