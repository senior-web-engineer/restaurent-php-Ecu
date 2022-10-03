<?php

include "../application/db_config.php";
include "../application/fcm.php";

class apicontroller {

    function encrypt_decrypt($action, $string) {
        $output = false;
        $encrypt_method = "AES-256-CBC";
        $secret_key = SECRET_KEY;
        $secret_iv = SECRET_IV;
        $key = hash('sha256', $secret_key);
        $iv = substr(hash('sha256', $secret_iv), 0, 16);
        if ($action == 'encrypt') {
            $output = openssl_encrypt($string, $encrypt_method, $key, 0, $iv);
            $output = base64_encode($output);
        } else if ($action == 'decrypt') {
            $output = openssl_decrypt(base64_decode($string), $encrypt_method, $key, 0, $iv);
        }
        return $output;
    }

    public function userupdate($fullname, $email, $password, $phone_no, $referral_code, $created_at, $login_with, $imagename) {
        $db = getDB();
        if ($login_with == 'Facebook') {
            $img = "https://graph.facebook.com/$imagename/picture?type=large";
        } elseif ($login_with == 'Google') {
            $img = "https://$imagename";
        } else {
            $img = $imagename;
        }

        $stmt = $db->prepare("update  fooddelivery_users set `fullname`=:fullname,`phone_no`=:phone_no,`email`=:email,`referal_code`=:ref_code,`image`=:image where `phone_no`=:phone_no;");
        $stmt->bindParam("fullname", $fullname, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("phone_no", $phone_no, PDO::PARAM_STR);
        $stmt->bindParam("ref_code", $referral_code, PDO::PARAM_STR);
        $stmt->bindParam("image", $img, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            $stmt1 = $db->prepare("Select * from fooddelivery_users where `phone_no`=:vphone;");
            $stmt1->bindParam("vphone", $phone_no, PDO::PARAM_STR);
            $stmt1->execute();
            $data = $stmt1->fetch(PDO::FETCH_OBJ);
            if ($data->login_with == "appuser") {
                $image = $data->image;
            } else {
                $image = $data->image;
            }
            $arr = array
                (
                "id" => $data->id,
                "fullname" => $data->fullname,
                "email" => $data->email,
                "phone_no" => $data->phone_no,
                "referal_code" => $data->referal_code,
                "image" => $image,
                "created_at" => $data->created_at,
                "login_with" => $data->login_with
            );
            return $arr;
        } else {
            return false;
        }
    }

    public function userregister($fullname, $email, $password, $phone_no, $referral_code, $created_at, $login_with, $imagename) {
        $db = getDB();
        $notify = 1;

        if ($login_with == 'Facebook') {
            $img = "https://graph.facebook.com/$imagename/picture?type=large";
        } elseif ($login_with == 'Google') {
            $img = "https://$imagename";
        } else {
            $img = $imagename;
        }

        $stmt = $db->prepare("insert into fooddelivery_users 
                  (`fullname`, `phone_no`, `email`, `password`, `referal_code`, `created_at`, `notify`, `login_with`,`image`)
                   values (:fullname,:phone_no,:email,:password,:ref_code,:created_at,:notify,:login_with,:image ) ");
        $stmt->bindParam("fullname", $fullname, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("password", $password, PDO::PARAM_STR);
        $stmt->bindParam("created_at", $created_at, PDO::PARAM_STR);
        $stmt->bindParam("phone_no", $phone_no, PDO::PARAM_STR);
        $stmt->bindParam("ref_code", $referral_code, PDO::PARAM_STR);
        $stmt->bindParam("login_with", $login_with, PDO::PARAM_STR);
        $stmt->bindParam("notify", $notify, PDO::PARAM_STR);
        $stmt->bindParam("image", $img, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            $stmt1 = $db->prepare("Select * from fooddelivery_users where `phone_no`=:vphone;");
            $stmt1->bindParam("vphone", $phone_no, PDO::PARAM_STR);
            $stmt1->execute();
            $data = $stmt1->fetch(PDO::FETCH_OBJ);
            if ($data->login_with == "appuser") {
                $image = $data->image;
            } else {
                $image = $data->image;
            }
            $arr = array
                (
                "id" => $data->id,
                "fullname" => $data->fullname,
                "email" => $data->email,
                "phone_no" => $data->phone_no,
                "referal_code" => $data->referal_code,
                "image" => $image,
                "created_at" => $data->created_at,
                "login_with" => $data->login_with
            );
            return $arr;
        } else {
            return false;
        }
    }

    public function checkuseremail($email) {
        $db = getDB();
        $stmt = $db->prepare("Select id from fooddelivery_users where email=:email");
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function checkphoneno($phone) {
        $db = getDB();
        $stmt = $db->prepare("Select id from fooddelivery_users where phone_no=:phone");
        $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function userlogin($uname, $pass, $email) {
        if ($uname == "non" && $pass == "non") {
            $db = getDB();
            $stmt = $db->prepare("Select * from fooddelivery_users where email=:email OR phone_no=:email");
            $stmt->bindParam("email", $email, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            $data = $stmt->fetch(PDO::FETCH_OBJ);
            if ($count) {
                if ($data->login_with == "appuser") {
                    $image = $data->image;
                } else {
                    $image = $data->image;
                }
                $arr = array
                    (
                    "id" => $data->id,
                    "fullname" => $data->fullname,
                    "email" => $data->email,
                    "phone_no" => $data->phone_no,
                    "referal_code" => $data->referal_code,
                    "image" => $image,
                    "created_at" => $data->created_at,
                    "login_with" => $data->login_with
                );
                return $arr;
            } else {
                return false;
            }
        } else {
            $db = getDB();
            $stmt = $db->prepare("Select * from fooddelivery_users where email=:email AND password=:password");
            $stmt->bindParam("email", $uname, PDO::PARAM_STR);
            $stmt->bindParam("password", $pass, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            $data = $stmt->fetch(PDO::FETCH_OBJ);
            if ($count) {
                if ($data->login_with == "appuser") {
                    $image = $data->image;
                } else {
                    $image = $data->image;
                }
                $arr = array
                    (
                    "id" => $data->id,
                    "fullname" => $data->fullname,
                    "email" => $data->email,
                    "phone_no" => $data->phone_no,
                    "referal_code" => $data->referal_code,
                    "image" => $image,
                    "created_at" => $data->created_at,
                    "login_with" => $data->login_with
                );
                return $arr;
            } else {
                return false;
            }
        }
    }

    public function phoneVerify($phone) {
        echo $phone;
        $db = getDB();

        $stmt = $db->prepare("Select * from fooddelivery_users where phone_no=:phone");
        $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        if ($count) {
            $arr = array
                (
                "id" => $data->id,
                "status" => $data->status,
                "fullname" => $data->fullname,
                "email" => $data->email,
                "phone_no" => $data->phone_no,
                "referal_code" => $data->referal_code,
                "image" => $data->image,
                "created_at" => $data->created_at,
                "login_with" => $data->login_with
            );
            return $arr;
        } else {
            return false;
        }
    }

    public function getratting($id) {
        $db = getDB();
        //$stmt = $db->prepare("SELECT max (ratting) from (select id, avg(ratting) AS ratavg from fooddelivery_reviews WHERE res_id=:id");
        $stmt = $db->prepare("SELECT id, AVG(ratting) AS ratavg FROM fooddelivery_reviews WHERE res_id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $avg = $data['ratavg'];
                $vg1 = (string) round($avg, 1);
            }
            return $vg1;
        } else {
            return false;
        }
    }

    public function locatemerestarant($location, $lat, $lon, $when, $offset, $page_result, $radius) {

        $db = getDB();
        if ($when == "location") {
            $stmt = $db->prepare("SELECT DISTINCT fooddelivery_restaurant.id as id,
	fooddelivery_restaurant.name as name,
	fooddelivery_restaurant.address as address,
	fooddelivery_restaurant.open_time as open_time,
	fooddelivery_restaurant.close_time as close_time,
	fooddelivery_restaurant.delivery_time as delivery_time,
	fooddelivery_restaurant.timestamp as timestamp,
	fooddelivery_restaurant.currency as currency,
	fooddelivery_restaurant.photo as photo,
	fooddelivery_restaurant.phone as phone,
	fooddelivery_restaurant.lat as lat,
	fooddelivery_restaurant.lon as lon,
	fooddelivery_restaurant.desc ,
	fooddelivery_restaurant.email as email,
	fooddelivery_restaurant.website as website,
	fooddelivery_restaurant.city as city,
	fooddelivery_restaurant.location as location,
	fooddelivery_restaurant.is_active as is_active,
	fooddelivery_restaurant.del_charge as del_charge,
	fooddelivery_restaurant.enable ,fooddelivery_restaurant.enable ,
        restaurant_verify_open_noenable(fooddelivery_restaurant.id) as openclosehorario,
        restaurant_get_distance(fooddelivery_restaurant.id,'$lat','$lon') AS distance
                FROM fooddelivery_restaurant,fooddelivery_menu,fooddelivery_submenu
                WHERE fooddelivery_menu.id=fooddelivery_submenu.menu_id
                AND fooddelivery_menu.res_id=fooddelivery_restaurant.id
                AND `is_active`=0   HAVING distance <= {$radius}
                ORDER BY  openclosehorario desc,enable DESC,distance ASC limit $offset, $page_result");
        } elseif ($when == "category") {
            $stmt = $db->prepare("SELECT *,fooddelivery_restaurant.enable ,
        restaurant_verify_open_noenable(fooddelivery_restaurant.id) as openclosehorario,restaurant_get_distance(fooddelivery_restaurant.id,'$lat','$lon') AS distance 
                from fooddelivery_restaurant 
                FROM fooddelivery_restaurant,fooddelivery_menu,fooddelivery_submenu
                WHERE fooddelivery_menu.id=fooddelivery_submenu.menu_id
                AND fooddelivery_menu.res_id=fooddelivery_restaurant.id 
                AND is_active=0 HAVING distance <= {$radius}
ORDER BY  openclosehorario desc,enable DESC,distance ASC limit $offset, $page_result");
        } else {
            $stmt = $db->prepare("SELECT DISTINCT fooddelivery_restaurant.id as id,
	fooddelivery_restaurant.name as name,
	fooddelivery_restaurant.address as address,
	fooddelivery_restaurant.open_time as open_time,
	fooddelivery_restaurant.close_time as close_time,
	fooddelivery_restaurant.delivery_time as delivery_time,
	fooddelivery_restaurant.timestamp as timestamp,
	fooddelivery_restaurant.currency as currency,
	fooddelivery_restaurant.photo as photo,
	fooddelivery_restaurant.phone as phone,
	fooddelivery_restaurant.lat as lat,
	fooddelivery_restaurant.lon as lon,
	fooddelivery_restaurant.desc ,
	fooddelivery_restaurant.email as email,
	fooddelivery_restaurant.website as website,
	fooddelivery_restaurant.city as city,
	fooddelivery_restaurant.location as location,
	fooddelivery_restaurant.is_active as is_active,
	fooddelivery_restaurant.del_charge as del_charge,
	fooddelivery_restaurant.enable ,
        restaurant_verify_open_noenable(fooddelivery_restaurant.id) as openclosehorario,restaurant_get_distance(fooddelivery_restaurant.id,'$lat','$lon') AS distance
                FROM fooddelivery_restaurant,fooddelivery_menu,fooddelivery_submenu
                WHERE fooddelivery_menu.id=fooddelivery_submenu.menu_id
                AND fooddelivery_menu.res_id=fooddelivery_restaurant.id
                AND (lower(fooddelivery_submenu.NAME) LIKE LOWER('%$location%') OR   lower(fooddelivery_restaurant.NAME) LIKE LOWER('%$location%') )
                AND `is_active`=0   HAVING distance <= {$radius}
                ORDER BY  openclosehorario desc,enable DESC,distance limit $offset, $page_result");
        }

        $stmt->execute();

        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                if ($when == "category") {
                    $categoryid = $this->getcategoryid($location);
                    $is_display = $this->is_displayornot($categoryid, $data->id);
                    $currency = $data->currency;
                    $dollar = explode('-', $currency);
                    $val = $dollar[1];

                    if ($is_display) {
                        $ratting = $this->getratting($data->id);
                        $category = $this->getrestaurantcategorybyid($data->id);
                        $openclose = $data->openclosehorario == "1" ? 'open' : 'closed';
                        $openclosemanual = $data->enable == "1" ? 'open' : 'closed';
                        $array[] = array
                            (
                            "enable" => $data->enable,
                            "name" => $data->name,
                            "delivery_time" => $data->delivery_time,
                            "currency" => "$val",
                            "image" => $data->photo,
                            "lat" => $data->lat,
                            "lon" => $data->lon,
                            "Category" => $category,
                            "ratting" => $ratting,
                            "res_status" => $openclose,
                            "res_status_manual" => $openclosemanual,
                            "distance" => $data->distance,
                            "open_time" => $data->open_time,
                            "close_time" => $data->close_time
                        );
                    }
                } else {
                    $ratting = $this->getratting($data->id);
                    $category = $this->getrestaurantcategorybyid($data->id);
                    $currency = $data->currency;
                    $dollar = explode('-', $currency);
                    $val = $dollar[1];

                    $openclose = $data->openclosehorario == "1" ? 'open' : 'closed';
                    $openclosemanual = $data->enable == "1" ? 'open' : 'closed';
                    $array[] = array(
                        "id" => $data->id,
                        "name" => $data->name,
                        "delivery_time" => $data->delivery_time,
                        "currency" => "$val",
                        "image" => $data->photo,
                        "lat" => $data->lat,
                        "lon" => $data->lon,
                        "Category" => $category,
                        "ratting" => $ratting,
                        "res_status" => $openclose,
                        "res_status_manual" => $openclosemanual,
                        "distance" => $data->distance,
                        "open_time" => $data->open_time,
                        "close_time" => $data->close_time
                    );
                }
            }
            if (isset($array)) {

                return $array;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    public function variablesDistance() {
        $arranque = 0.50;
        $tarifaMinima = 1.00;
        $incrementoKilometro = 0.35;
        $array[] = array
            (
            "arranque" => $arranque,
            "tarifaminima" => $tarifaMinima,
            "incrementokilometro" => $incrementoKilometro
        );
        return $array;
    }

    public function getrattingnew($id) {
        $db = getDB();

        $stmt = $db->prepare("SELECT id, AVG(ratting) AS ratavg FROM fooddelivery_reviews WHERE res_id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $avg = $data['ratavg'];
                $vg1 = (string) round($avg, 1);
            }
            return $vg1;
        } else {
            return false;
        }
    }
    
    public function getdeliveryboyname($id){
        $db = getDB();
        $rname = "";
        $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy WHERE id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $rname = $data['name'];
            }
            return $rname;
        } else {
            return false;
        }
    }

    public function getdeliveryboytoken($id)
    {
        $db = getDB();
        $rtoken = "";
        $stmt = $db->prepare("SELECT token FROM fooddelivery_tokendata WHERE delivery_boyid=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $rtoken = $data['token'];
            }
            return $rtoken;
        } else {
            return false;
        }
    }

    public function registerWorkingTime($rname, $dt, $tp){
    	try {
          $db = getDB();
          //$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
          $db->beginTransaction();
          $tmp = explode(" - ", $tp);
          $tmp_st = explode(" ", $tmp[0]);
          $tmp_ed = explode(" ", $tmp[1]);
          $tmp_st_time = explode(":", $tmp_st[0]);
          $start_hour = $tmp_st_time[0];
          if($tmp_st[1] == 'PM') $start_hour += 12;
          $st = date("H:i:s", mktime($start_hour, $tmp_st_time[1], 0, 5, 3, 2020));
          $tmp_ed_time = explode(":", $tmp_ed[0]);
          $end_hour = $tmp_ed_time[0];
          if ($tmp_ed[1] == 'PM') $end_hour += 12;
          $ed = date("H:i:s", mktime($end_hour, $tmp_ed_time[1], 0, 5, 3, 2020));
          $curday = date("N");
          if ($curday < 4) {
            $rdate = date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 4 - $curday, date('Y')));
            $rday = 4;
          } elseif($curday<7) {
            $rdate = date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 7 - $curday, date('Y')));
            $rday = 7;
          } else{
            $rdate = date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 4, date('Y')));
            $rday = 4;
          }
          $stmt = $db->prepare("INSERT INTO fooddelivery_working_schedule(`rider_name`, `w_date`, `working_start`, `working_end`, `state`, `register_date`) VALUES('".$rname. "', '" . $dt . "', '" . $st . "', '" . $ed . "', '1', '" . date('Y-m-d H:i:s') . "')");
          if($stmt->execute()) echo json_encode(array("success" => true, "week" => $rday, "date" => $rdate));
          $db->commit();
        } catch (Exception $e) {
          $db->rollBack();
          echo "Fallo: " . $e->getMessage();
        }
    }

    public function CanRegister($rname){
        $db = getDB();
        $curday = date('N');
        $stmt = $db->prepare("SELECT * FROM `fooddelivery_working_schedule` WHERE w_date > '" . date('Y-m-d') . "' AND rider_name LIKE '" . $rname . "'");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return false;
        } else {
            if($curday == 7 || $curday == 4) return true;
            return false;
        }
    }

    public function getRegisterData(){
        $curday = date("N");
        $result = array();
        if($curday == 7){
            $result[] = array("week" => 1, "date" => date("Y-m-d", mktime(0,0,0,date('n'), date('j')+1, date('Y'))), "time"=>"7:00 AM - 10:00 PM");
            $result[] = array("week" => 2, "date" => date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 2, date('Y'))), "time"=>"7:00 AM - 10:00 PM");
            $result[] = array("week" => 3, "date" => date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 3, date('Y'))), "time"=>"7:00 AM - 10:00 PM");
            $result[] = array("week" => 4, "date" => date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 4, date('Y'))), "time"=>"7:00 AM - 10:00 PM");
            return array("success" => true, "data" => $result);
        }
        elseif($curday == 4){
            $result[] = array("week" => 5, "date" => date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 1, date('Y'))), "time"=>"7:00 AM - 10:00 PM");
            $result[] = array("week" => 6, "date" => date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 2, date('Y'))), "time"=>"7:00 AM - 10:00 PM");
            $result[] = array("week" => 7, "date" => date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 3, date('Y'))), "time"=>"7:00 AM - 10:00 PM");
            return array("success" => true, "data" => $result);
        }
        if($curday<4){
            $rdate = date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 4 - $curday, date('Y')));
            $rday = 4;
        }
        elseif($curday<7) {
            $rdate = date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 7 - $curday, date('Y')));
            $rday = 7;
        }
        else {
            $rdate = date("Y-m-d", mktime(0, 0, 0, date('n'), date('j') + 4, date('Y')));
            $rday = 4;
        }
        return array("success" => false,"week" => $rday, "date" => $rdate);
    }

    public function getRegisteredData($rname)
    {
        $db = getDB();
        $curday = date("N");
        //$st = ($curday>=4)?date("Y-m-d",mktime(0, 0, 0, date("n"), date("j")-$curday+4,date('Y'))): date("Y-m-d", mktime(0, 0, 0, date("n"), date("j") - $curday + 0, date('Y')));
        $st = ($curday>=4)?date("Y-m-d",mktime(0, 0, 0, date("n"), date("j")-$curday+4,date('Y'))): date("Y-m-d", mktime(0, 0, 0, date("n"), (date("j") - $curday) + 1, date('Y')));
        $stmt = $db->prepare("SELECT *, HOUR(working_start) AS hws, HOUR(working_end) AS hwe FROM `fooddelivery_working_schedule` WHERE w_date > '" . $st . "' AND rider_name='".$rname."' ORDER BY w_date");
        $stmt->execute();
        $count = $stmt->rowCount();
        $result = array();
        if ($count) {
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $day = new DateTime($row['w_date']);
                $st_ampm = ($row['hws'] > 12) ? "PM" : "AM";
                $st_hour = ($row['hws'] > 12) ? $row['hws']-12 : $row['hws'];
                $ed_ampm = ($row['hwe'] > 12) ? "PM" : "AM";
                $ed_hour = ($row['hwe'] > 12) ? $row['hwe'] - 12 : $row['hwe'];
                $st_tmp = explode(":", $row['working_start']);
                $ed_tmp = explode(":", $row['working_end']);
                $str = $st_hour.":".$st_tmp[1]." ".$st_ampm." - ".$ed_hour.":".$ed_tmp[1]." ".$ed_ampm;
                date_default_timezone_set('UTC');
                date_default_timezone_set("America/Quito");
                setlocale(LC_TIME, 'spanish');
                $date_format = utf8_encode(strftime("%a. %d de %b, %Y", strtotime($row['w_date'])));
                $result[] = array("week" => $day->format("N"), "date"=>$date_format, "time" => $str);
            }
            return (array("success"=>true, "data"=>$result, "date" => date("Y-m-d")));
        } else {
            return (array("success"=>false,"data"=>array()));
        }
    }
    
    public function getAdvertisingList($lat, $lon, $city, $search)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM `fooddelivery_restaurant` WHERE LOWER(name) LIKE  LOWER('%" . $search . "%') AND type_store='Publicidad' AND is_active='0' AND LOWER(city)=LOWER('" . $city . "') ORDER BY sequence");
        $stmt->execute();
        $count = $stmt->rowCount();
        $result = array();
        if ($count) {
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
     			$result[] = $row;
            }
            return (array("success"=>1, "restaurant_list"=>$result, "date" => date("Y-m-d"), "message"=>"Success"));
        }
        return array("success"=>0, "message"=>"Blank");
        
    }

    public function sendPush($regId)
    {

        $notification = array();
        $arrNotification = array();
        $arrData = array();
        $arrNotification["body"] = "Se registro exitosamente";
        $arrNotification["title"] = "Éxito";
        $arrNotification["sound"] = "default";
        $arrNotification["type"] = 1;

        $fcm = new FCM();
        $result = $fcm->send_notification($regId, $arrNotification, "Android");
    }
  
  	public function registerDeliverboyPosition($deliverboy_id, $lat, $lon){
      	$db = getDB();
      	$stmt = $db->prepare("UPDATE fooddelivery_delivery_boy SET lat=:lat, lon=:lon, update_coordinates=now() WHERE id=:id");
      	$stmt->bindParam("lat", $lat, PDO::PARAM_STR);
      	$stmt->bindParam("lon", $lon, PDO::PARAM_STR);
      	$stmt->bindParam("id", $deliverboy_id, PDO::PARAM_INT);
      	$stmt->execute();
    }
    
    public function locatemerestarantrat($location, $lat, $lon, $when, $radius) {
        $db = getDB();
        if ($when == "location") {
            $stmt = $db->prepare("SELECT *,restaurant_get_distance(fooddelivery_restaurant.id,'$lat','$lon') AS distance
                from fooddelivery_restaurant where is_active=0 && city RLIKE '[[:<:]]" . $location . "[[:>:]]' HAVING distance <= {$radius}");
        }

        $stmt->execute();

        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {

                $ratting = $this->getrattingnew($data->id);
                $category = $this->getrestaurantcategorybyid($data->id);

                $openclose = $data->openclosehorario == "1" ? 'open' : 'closed';
                $openclosemanual = $data->enable == "1" ? 'open' : 'closed';
                $array[] = array(
                    "id" => $data->id,
                    "name" => $data->name,
                    "delivery_time" => $data->delivery_time,
                    "currency" => $data->currency,
                    "image" => $data->photo,
                    "lat" => $data->lat,
                    "lon" => $data->lon,
                    "Category" => $category,
                    "ratting" => $ratting,
                    "res_status" => $openclose,
                    "res_status_manual" => $openclosemanual,
                    "distance" => $data->distance,
                    "open_time" => $data->open_time,
                    "close_time" => $data->close_time
                );
            }

            if ($_GET['short_by'] == 'ratting') {
                usort($array, function ($a, $b) {
                    return $a['ratting'] < $b['ratting'];
                });
            }

            $offset = 0;
            $page_result = $_GET['noofrecords'];

            if ($_GET['pageno']) {
                $page_value = $_GET['pageno'];
                if ($page_value > 1) {
                    $offset = ($page_value - 1) * $page_result;
                }
            }

            $sortby_rate = array_slice($array, $offset, $page_result);

            $pagecount = count($stmt);

            $num = $pagecount / $page_result;


            if (isset($sortby_rate)) {
                return $sortby_rate;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    public function getsubcategoryname($id) {
        $db = getDB();
        $stmt = $db->prepare("select `id`,`name` from `fooddelivery_subcategory` where cat_id=:id ");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                $arr[] = $data;
            }
            return $arr;
        } else {
            return false;
        }
    }

    public function restaurantcategory() {
        $db = getDB();
        $stmt = $db->prepare("select * from fooddelivery_category ORDER BY id DESC");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                unset($sub);
                unset($subcategory);
                $sub = $this->getsubcategoryname($data->id);
                if ($sub) {
                    $subcategory = $sub;
                } else {
                    $subcategory[] = array("id" => "Not Found");
                }
                $array[] = array("id" => $data->id, "name" => $data->cname, "subcategory" => $subcategory);
            }
            return $array;
        } else {
            return false;
        }
    }

    public function restaurantmenu($res_id) {
        $db = getDB();
        $stmt = $db->prepare("select id,name,created_at from fooddelivery_menu WHERE res_id=:res_id AND status='active' ORDER BY sequence ASC");
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                $array[] = $data;
            }
            return $array;
        } else {
            return false;
        }
    }

    public function restaurantsubmenu($menucategory_id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT `res_id` FROM fooddelivery_menu WHERE `id`='$menucategory_id' LIMIT 1");
        $stmt->execute();
        //$count = $stmt->rowCount();
        foreach ($stmt as $row) {
            $res_id = $row['res_id'];
            if (in_array($res_id, ['1358', '1370', '615'])){
                $stmt = $db->prepare("SELECT `id`,`name`,`price`,`desc`,`created_at`,`image` FROM `fooddelivery_submenu` WHERE `menu_id`=:menucat_id AND `stock`>=1 AND `status`='active' ORDER BY ABS(`price`) ASC");
                $stmt->bindParam("menucat_id", $menucategory_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                if ($count) {
                    while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                        $array[] = $data;
                    }
                    return $array;
                } else {
                    return false;
                }
            } else {
                $stmt = $db->prepare("SELECT `id`,`name`,`price`,`desc`,`created_at`,`image` FROM `fooddelivery_submenu` WHERE `menu_id`=:menucat_id AND `status`='active' ORDER BY ABS(`price`) ASC");
                $stmt->bindParam("menucat_id", $menucategory_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                if ($count) {
                    while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                        $array[] = $data;
                    }
                    return $array;
                } else {
                    return false;
                }
            }
        }

        
    }

    public function getrestaurantcategorybyid($id) {
        $db = getDB();
        $stmt = $db->prepare("select * from fooddelivery_category_res where res_id=:res_id ");
        $stmt->bindParam("res_id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                $category = $this->getcategoryname($data->cat_id);
                $array[] = $category;
            }
            return $array;
        } else {
            return false;
        }
    }

    public function getcategoryname($cat_id) {
        $db = getDB();
        $stmt = $db->prepare("select `name` from `fooddelivery_subcategory` where id=:cat_id");
        $stmt->bindParam("cat_id", $cat_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        if ($count) {
            return $data->name;
        } else {
            return false;
        }
    }

    public function res_openandclose($res_id, $time_open, $time_close) {
        $db = getDB();
        $time = date('H:i:s');
        $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant WHERE id=:res_id AND '" . $time . "' >= :open_time and '" . $time . "' <= :close_time ");
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->bindParam("open_time", $time_open, PDO::PARAM_STR);
        $stmt->bindParam("close_time", $time_close, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return "open";
        } else {
            return "closed";
        }
    }

    public function getcategoryid($search) {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_subcategory WHERE name like CONCAT( '%','" . $search . "','%');");
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);



        if ($count) {
            return $data->id;
        } else {
            return false;
        }
    }

    public function is_displayornot($categoryid, $res_id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_category_res WHERE res_id=:res_id AND cat_id=:cat_id ");
        $stmt->bindParam("cat_id", $categoryid, PDO::PARAM_STR);
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function publishreview($res_id, $user_id, $review_text, $ratting, $created_at) {
        $db = getDB();
        $notify = 1;
        $stmt = $db->prepare("INSERT INTO fooddelivery_reviews (`user_id`, `res_id`, `review_text`, `ratting`, `created_at`,`notify`) VALUES (:user_id,:res_id,:review_text,:ratting,:created_at,:notify)");
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $stmt->bindParam("review_text", $review_text, PDO::PARAM_STR);
        $stmt->bindParam("ratting", $ratting, PDO::PARAM_STR);
        $stmt->bindParam("created_at", $created_at, PDO::PARAM_STR);
        $stmt->bindParam("notify", $notify, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function getreviews($res_id) {
        // Report all errors except E_NOTICE
        error_reporting(E_ALL & ~E_NOTICE);
        $db = getDB();
        $stmt = $db->prepare("Select * from fooddelivery_reviews as fr inner join fooddelivery_users as fu on fu.id=fr.user_id where fr.res_id='" . $_REQUEST['res_id'] . "'  ORDER BY fr.id DESC");
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                $username = $this->getusername($data->user_id);
                //$username=$this->getusername($data->res_id);
                $array[] = array("id" => $data->id, "username" => $username->fullname, "image" => $username->image, "review_text" => $data->review_text, "ratting" => $data->ratting, "created_at" => $data->created_at, "login_with" => $data->login_with);
            }
            return $array;
        } else {
            return false;
        }
    }

    public function getusername($user_id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT fullname,image FROM fooddelivery_users WHERE id=:user_id ");
        $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        if ($count) {
            return $data;
        } else {
            return false;
        }
    }

    public function getrestaurantfulldetail($res_id, $lat, $lon) {
        $db = getDB();
        $stmt = $db->prepare("SELECT *,restaurant_get_distance(fooddelivery_restaurant.id,'$lat','$lon') AS distance
                from fooddelivery_restaurant WHERE is_active=0 AND id=:res_id  ORDER BY distance ASC ");
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        if ($count) {
            $ratting = $this->getratting($data->id);
            $openclose = $this->res_openandclose($data->id, $data->open_time, $data->close_time);
            $openclosemanual = $this->res_openandclose($data->id, $data->open_time, $data->close_time);
            $category = $this->getrestaurantcategorybyid($data->id);
            $currency = $data->currency;
            $dollar = explode('-', $currency);
            $val = $dollar[1];
            $array = array(
                "id" => $data->id,
                "enable" => $data->enable,
                "name" => $data->name,
                "address" => $data->address,
                "time" => $data->open_time . " To " . $data->close_time,
                "delivery_time" => $data->delivery_time,
                "currency" => "$val",
                "photo" => $data->photo,
                "phone" => $data->phone,
                "lat" => $data->lat,
                "lon" => $data->lon,
                "desc" => $data->desc,
                "email" => $data->email,
                //"location"=>$data->location,
                "ratting" => $ratting,
                "res_status" => $openclose,
                "res_status_manual" => $openclosemanual,
                "delivery_charg" => $data->del_charge,
                "distance" => $data->distance,
                "Category" => $category
            );
            return $array;
        } else {
            return false;
        }
    }

    public function bookorder($user_id, $res_id, $address, $lat, $long, $food_desc, $notes, $total_price, $created_at, $notify) {
        $db = getDB();
        $notify = 1;
        $stmt = $db->prepare("INSERT INTO fooddelivery_bookorder 
                              (`user_id`, `res_id`, `address`, `lat`, `long`, `food_desc`, `notes`, `total_price`, `created_at`, `notify`)
                              VALUES (:user_id,:res_id,:address,:lat,:long,:food_desc,:notes,:total_price,:created_at,:notify)
                              ");
        $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->bindParam("address", $address, PDO::PARAM_STR);
        $stmt->bindParam("lat", $lat, PDO::PARAM_STR);
        $stmt->bindParam("long", $long, PDO::PARAM_STR);
        $stmt->bindParam("food_desc", $food_desc, PDO::PARAM_STR);
        $stmt->bindParam("notes", $notes, PDO::PARAM_STR);
        $stmt->bindParam("total_price", $total_price, PDO::PARAM_STR);
        $stmt->bindParam("created_at", $created_at, PDO::PARAM_STR);
        $stmt->bindParam("notify", $notify, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function insertdelivery_address($user_id, $latitude, $longitude, $address, $alias, $phone, $delivery_note, $department_number) {
        $db = getDB();
        $db->query("SET NAMES 'utf8'");

        // insertar y validar duplicados
        $sql = $db->prepare("SELECT * FROM `fooddelivery_delivery_address` WHERE `user_id`=:user_id AND `latitude`=:latitude AND `longitude`=:longitude");
        $sql->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $sql->bindParam("latitude", $latitude, PDO::PARAM_STR);
        $sql->bindParam("longitude", $longitude, PDO::PARAM_STR);
        $sql->execute();
        $rows = $sql->fetchAll(PDO::FETCH_OBJ);
        if (count($rows) > 0) {
            echo '[{"status":"Failed","error_message":"Ya existe una dirección de entrega con estas coordenadas, vuelve a intentar."}]';
        } else {
            $stmt = $db->prepare("INSERT INTO fooddelivery_delivery_address (`user_id`, `date_address`, `latitude`, `longitude`, `address`, `alias`, `phone`, `delivery_note`, `department_number`) VALUES (:user_id, now(), :latitude, :longitude, :address, :alias, :phone, :delivery_note, :department_number);");

            $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
            $stmt->bindParam("latitude", $latitude, PDO::PARAM_STR);
            $stmt->bindParam("longitude", $longitude, PDO::PARAM_STR);
            $stmt->bindParam("address", htmlspecialchars_decode($address), PDO::PARAM_STR);
            $stmt->bindParam("alias", htmlspecialchars_decode($alias), PDO::PARAM_STR);
            $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
            $stmt->bindParam("delivery_note", htmlspecialchars_decode($delivery_note), PDO::PARAM_STR);
            $stmt->bindParam("department_number", htmlspecialchars_decode($department_number), PDO::PARAM_STR);
            if ($stmt->execute()) {
                return true;
            } else {
                return false;
            }
        }
    }

    public function getdelivery_address($user_id) {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_address WHERE user_id=:user_id");

        $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            while ($data = $stmt->fetch(PDO::FETCH_OBJ)) {
                $array[] = array("id" => $data->id, "user_id" => $data->user_id, "latitude" => $data->latitude, "longitude" => $data->longitude, "address" => $data->address, "alias" => $data->alias, "phone" => $data->phone, "delivery_note" => $data->delivery_note, "department_number" => $data->department_number);
            }
            return $array;
        } else {
            return false;
        }
    }

    public function updatedelivery_address($id, $user_id, $latitude, $longitude, $address, $alias, $phone, $delivery_note, $department_number) {
        $db = getDB();
        $stmt = $db->prepare("UPDATE fooddelivery_delivery_address SET user_id=:user_id, latitude=:latitude, longitude=:longitude, address=:address, alias=:alias, phone=:phone, delivery_note=:delivery_note, department_number=:department_number WHERE id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_INT);
        $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $stmt->bindParam("latitude", $latitude, PDO::PARAM_STR);
        $stmt->bindParam("longitude", $longitude, PDO::PARAM_STR);
        $stmt->bindParam("address", $address, PDO::PARAM_STR);
        $stmt->bindParam("alias", $alias, PDO::PARAM_STR);
        $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
        $stmt->bindParam("delivery_note", $delivery_note, PDO::PARAM_STR);
        $stmt->bindParam("department_number", $department_number, PDO::PARAM_STR);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function deletedelivery_address($id) {
        $db = getDB();
        $stmt = $db->prepare("DELETE FROM fooddelivery_delivery_address WHERE id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_INT);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

}

?>