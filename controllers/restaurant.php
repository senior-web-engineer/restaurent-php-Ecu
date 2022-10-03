<?php

// Turn off error reporting
error_reporting(0);

// Report runtime errors
error_reporting(E_ERROR | E_WARNING | E_PARSE);

// Report all errors
error_reporting(E_ALL);

// Same as error_reporting(E_ALL);
ini_set("error_reporting", E_ALL);

// Report all errors except E_NOTICE
error_reporting(E_ALL & ~E_NOTICE);
?> 
<?php

include "application/db_config.php";

class dashboard
{

    public $db;

    public function __construct()
    {
        $this->db = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
        if (mysqli_connect_errno()) {
            echo "Error: Could not connect to database.";
            exit;
        }
    }

    public function addnewboy($city_id, $urlid, $cedula, $name, $birthday, $backpack_code, $phone, $email, $password, $profession, $vehicle_no, $vehicle_type, $imagename, $latitude, $longitude)
    {
        $urlid = 0;
        $db = getDB();
        $time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_delivery_boy`(`city_id`,`res_id`,`dni`,`name`,`birthday`,`backpack_code`,`phone`,`email`,`password`,`profession`,`vehicle_no`,`vehicle_type`,`created_at`,`image`,`latitude`,`longitude`) VALUES (:city_id,:res_id,:cedula,:name,:birthday,:backpack_code,:phone,:email,:password,:profession,:vehicle_no,:vehicle_type,:time,:image,:latitude,:longitude)");
        $stmt->bindParam("image", $imagename, PDO::PARAM_STR);
        $stmt->bindParam("city_id", $city_id, PDO::PARAM_STR);
        $stmt->bindParam("res_id", $urlid, PDO::PARAM_STR);
        $stmt->bindParam("cedula", $cedula, PDO::PARAM_STR);
        $stmt->bindParam("name", $name, PDO::PARAM_STR);
        $stmt->bindParam("birthday", $birthday, PDO::PARAM_STR);
        $stmt->bindParam("backpack_code", $backpack_code, PDO::PARAM_STR);
        $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("password", $password, PDO::PARAM_STR);
        $stmt->bindParam("profession", $profession, PDO::PARAM_STR);
        $stmt->bindParam("vehicle_no", $vehicle_no, PDO::PARAM_STR);
        $stmt->bindParam("vehicle_type", $vehicle_type, PDO::PARAM_STR);
        $stmt->bindParam("latitude", $latitude, PDO::PARAM_STR);
        $stmt->bindParam("longitude", $longitude, PDO::PARAM_STR);
        $stmt->bindParam("time", $time, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
        }
    }

    public function editboydetail($boy_id, $city_id, $dni, $name, $birthday, $backpack_code, $phone, $email, $password, $profession, $vehicle_no, $vehicle_type, $image, $latitude, $longitude)
    {
        if ($image != "none") {
            //echo 'acá';
            $db = getDB();
            $stmt = $db->prepare("
            UPDATE `fooddelivery_delivery_boy` SET
            `city_id`=:city_id,
            `dni`=:dni,
            `name`=:name,
            `birthday`=:birthday,
            `backpack_code`=:backpack_code,
            `phone`=:phone,
            `email`=:email,
            `password`=:password,
            `profession`=:profession,
            `vehicle_no`=:vehicle_no,
            `vehicle_type`=:vehicle_type,
            `latitude`=:latitude,
            `longitude`=:longitude,
            `image`=:image
            WHERE `id`=:id
             ");
            $stmt->bindParam("city_id", $city_id, PDO::PARAM_STR);
            $stmt->bindParam("dni", $dni, PDO::PARAM_STR);
            $stmt->bindParam("name", $name, PDO::PARAM_STR);
            $stmt->bindParam("birthday", $birthday, PDO::PARAM_STR);
            $stmt->bindParam("backpack_code", $backpack_code, PDO::PARAM_STR);
            $stmt->bindParam("image", $image, PDO::PARAM_STR);
            $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
            $stmt->bindParam("email", $email, PDO::PARAM_STR);
            $stmt->bindParam("password", $password, PDO::PARAM_STR);
            $stmt->bindParam("profession", $profession, PDO::PARAM_STR);
            $stmt->bindParam("vehicle_no", $vehicle_no, PDO::PARAM_STR);
            $stmt->bindParam("vehicle_type", $vehicle_type, PDO::PARAM_STR);
            $stmt->bindParam("latitude", $latitude, PDO::PARAM_STR);
            $stmt->bindParam("longitude", $longitude, PDO::PARAM_STR);
            $stmt->bindParam("id", $boy_id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
        } else {
            $db = getDB();
            $stmt = $db->prepare("
            UPDATE `fooddelivery_delivery_boy` SET 
            `city_id`=:city_id,
            `dni`=:dni,
            `name`=:name,
            `birthday`=:birthday,
            `backpack_code`=:backpack_code,
            `phone`=:phone,
            `email`=:email,
            `password`=:password,
            `profession`=:profession,
            `vehicle_no`=:vehicle_no,
            `vehicle_type`=:vehicle_type,
            `latitude`=:latitude,
            `longitude`=:longitude
            WHERE `id`=:id
             ");
            $stmt->bindParam("city_id", $city_id, PDO::PARAM_STR);
            $stmt->bindParam("dni", $dni, PDO::PARAM_STR);
            $stmt->bindParam("name", $name, PDO::PARAM_STR);
            $stmt->bindParam("birthday", $birthday, PDO::PARAM_STR);
            $stmt->bindParam("backpack_code", $backpack_code, PDO::PARAM_STR);
            $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
            $stmt->bindParam("email", $email, PDO::PARAM_STR);
            $stmt->bindParam("password", $password, PDO::PARAM_STR);
            $stmt->bindParam("profession", $profession, PDO::PARAM_STR);
            $stmt->bindParam("vehicle_no", $vehicle_no, PDO::PARAM_STR);
            $stmt->bindParam("vehicle_type", $vehicle_type, PDO::PARAM_STR);
            $stmt->bindParam("latitude", $latitude, PDO::PARAM_STR);
            $stmt->bindParam("longitude", $longitude, PDO::PARAM_STR);
            $stmt->bindParam("id", $boy_id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
        }

        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editboylevels($boy_id, $level_id)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_delivery_boy` SET 
            `level_id`=:level_id
            WHERE `id`=:id
             ");
        $stmt->bindParam("level_id", $level_id, PDO::PARAM_STR);
        $stmt->bindParam("id", $boy_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();

        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editeditMarketProvider($id, $city_id, $name, $representative, $ident, $phone, $address, $email)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_supplier` SET 
            `city_id`=:city_id,
            `name`=:name,
            `representative`=:representative,
            `identification`=:identification,
            `phone`=:phone,
            `address`=:address,
            `email`=:email
            WHERE `id`=:id
             ");
        $stmt->bindParam("city_id", $city_id, PDO::PARAM_STR);
        $stmt->bindParam("name", $name, PDO::PARAM_STR);
        $stmt->bindParam("representative", $representative, PDO::PARAM_STR);
        $stmt->bindParam("identification", $ident, PDO::PARAM_STR);
        $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
        $stmt->bindParam("address", $address, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();

        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function getboybyid($id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function editenableboy($id, $enable, $attendance)
    {

        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_delivery_boy` SET 
            `status`=:status,
            `attendance`=:attendance
            WHERE `id`=:id
             ");
        $stmt->bindParam("status", $enable, PDO::PARAM_STR);
        $stmt->bindParam("attendance", $attendance, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editdeliveryprice($id, $delivery_price, $total_general, $user_id, $today)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_bookorder` SET 
            `delivery_price`=:delivery_price,
            `total_general`=:total_general,
            `edit_id`=:user_id,
            `edit_date_time`=:today
            WHERE `id`=:id
             ");
        $stmt->bindParam("delivery_price", $delivery_price, PDO::PARAM_STR);
        $stmt->bindParam("total_general", $total_general, PDO::PARAM_STR);
        $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $stmt->bindParam("today", $today, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editdeliveryboy($id, $is_assigned, $user_id, $today)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_bookorder` SET 
            `is_assigned`=:is_assigned,
            `edit_id`=:user_id,
            `edit_date_time`=:today
            WHERE `id`=:id
             ");
        $stmt->bindParam("is_assigned", $is_assigned, PDO::PARAM_STR);
        $stmt->bindParam("user_id", $user_id, PDO::PARAM_STR);
        $stmt->bindParam("today", $today, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function cancelorder($id, $status, $reject_date_time, $reject_status, $reason_reject, $edit_id, $edit_date_time)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_bookorder` SET 
            `status`=:status,
            `reject_date_time`=:reject_date_time,
            `reject_status`=:reject_status,
            `reason_reject`=:reason_reject,
            `edit_id`=:edit_id,
            `edit_date_time`=:edit_date_time
            WHERE `id`=:id
             ");
        $stmt->bindParam("status", $status, PDO::PARAM_STR);
        $stmt->bindParam("reject_date_time", $reject_date_time, PDO::PARAM_STR);
        $stmt->bindParam("reject_status", $reject_status, PDO::PARAM_STR);
        $stmt->bindParam("reason_reject", $reason_reject, PDO::PARAM_STR);
        $stmt->bindParam("edit_id", $edit_id, PDO::PARAM_STR);
        $stmt->bindParam("edit_date_time", $edit_date_time, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    function random_color_part()
    {
        return str_pad(dechex(mt_rand(0, 255)), 2, '0', STR_PAD_LEFT);
    }

    function random_color()
    {
        return $this->random_color_part() . $this->random_color_part() . $this->random_color_part();
    }

    function encrypt_decrypt($action, $string)
    {
        $output = false;
        //$admin = new dashboard();
        //$getKey = $admin->getkey();
        //$keyRandom = $getKey->notes;
        //$randomString = $this->generateRandomString();
        //echo($res->id . "<br>");
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

    public function unlinkimage($icon, $path)
    {
        if (file_exists("$path/$icon")) {
            unlink("$path/$icon");
        } else {
            return false;
        }
    }

    public function get_session()
    {

        $uid = $_SESSION['uid'];
        $role = $_SESSION['role'];
        $check = $this->checksession($uid, $role);
        if ($check) {
            return $_SESSION['login'];
        } else {
            return false;
        }
    }

    public function checksession($uid)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_adminlogin WHERE id=:id");
        $stmt->bindParam("id", $uid, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function user_logout()
    {
        $_SESSION['login'] = FALSE;
        session_destroy();
    }

    public function getuserinfo($uid)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_adminlogin WHERE id=:id");
        $stmt->bindParam("id", $uid, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $db = null;
        if ($count) {
            return $data;
        } else {
            return false;
        }
    }

    public function addnewcategory($cname, $imagename)
    {
        $db = getDB();
        $time = time();
        if ($GLOBALS['demo'] != "YES") {
            $stmt = $db->prepare("INSERT INTO `fooddelivery_category`(`cname`,`image`,`created_at`) VALUES (:cname,:image,:time)");
            $stmt->bindParam("cname", $cname, PDO::PARAM_STR);
            $stmt->bindParam("image", $imagename, PDO::PARAM_STR);
            $stmt->bindParam("time", $time, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return true;
            } else {
            }
        } else {
        }
    }

    public function addnewtypestore($name, $observation, $status)
    {
        $db = getDB();
        $time = time();
        if ($GLOBALS['demo'] != "YES") {
            $stmt = $db->prepare("INSERT INTO `fooddelivery_type_store`(`name`,`observation`,`created_at`,`status`) VALUES (:name,:observation,:time,:status)");
            $stmt->bindParam("name", $name, PDO::PARAM_STR);
            $stmt->bindParam("observation", $observation, PDO::PARAM_STR);
            $stmt->bindParam("time", $time, PDO::PARAM_STR);
            $stmt->bindParam("status", $status, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return true;
            } else {
            }
        } else {
        }
    }

    public function addnewcity($cname, $radio, $country)
    {
        $db = getDB();
        $time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_city`(`cname`,`created_at`,`radio`,`country`) VALUES (:cname,:time,:radio,:country)");
        $stmt->bindParam("cname", $cname, PDO::PARAM_STR);
        $stmt->bindParam("time", $time, PDO::PARAM_STR);
        $stmt->bindParam("radio", $radio, PDO::PARAM_STR);
        $stmt->bindParam("country", $country, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
        }
    }

    public function checkcategoryisnow()
    {
        $db = getDB();
        $stmt = $db->prepare("select * from `fooddelivery_category`");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            foreach ($stmt as $row) {
                $array[] = $row;
            }
            return $array;
        } else {
            return false;
        }
    }

    public function getcategory()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT id,cname FROM fooddelivery_category");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            foreach ($stmt as $val) {
                $array[] = $val;
            }
            return $array;
        } else {
            return false;
        }
    }

    public function getsubcategoryname($id)
    {
        $db = getDB();
        $stmt = $db->prepare("Select `id`,`name` from `fooddelivery_subcategory` where cat_id=:id ");
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

    public function addrestaurantdetail($name, $address, $desc, $email, $phone, $website, $del_time, $open_time, $close_time, $category, $city, $location, $latitude, $longitude, $imagename, $currency, $dcharge, $ally, $monday, $tuesday, $wednesday, $thursday, $friday, $saturday, $sunday)
    {

        if ($monday == 'YES') {
            $monday = 'YES';
        } else {
            $monday = 'NO';
        }
        if ($tuesday == 'YES') {
            $tuesday = 'YES';
        } else {
            $tuesday = 'NO';
        }
        if ($wednesday == 'YES') {
            $wednesday = 'YES';
        } else {
            $wednesday = 'NO';
        }
        if ($thursday == 'YES') {
            $thursday = 'YES';
        } else {
            $thursday = 'NO';
        }
        if ($friday == 'YES') {
            $friday = 'YES';
        } else {
            $friday = 'NO';
        }
        if ($saturday == 'YES') {
            $saturday = 'YES';
        } else {
            $saturday = 'NO';
        }
        if ($sunday == 'YES') {
            $sunday = 'YES';
        } else {
            $sunday = 'NO';
        }
        $db = getDB();
        $timestamp = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_restaurant`(`name`,`address`,`open_time`,`close_time`,`delivery_time`,
`timestamp`,`currency`,`photo`,`phone`,`lat`,`lon`,`desc`,`email`,`website`,`city`,`location`,`del_charge`,`ally`,monday,tuesday,wednesday,thursday,friday,saturday,sunday)
 VALUES (:rname,:address,:open_time,:close_time,:delivery_time,:ctimestamp,
 :currency,:photo,:phone,:lat,:lon,:description,:email,:website,:city,:location,:dcharge,:ally,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday)");
        $stmt->bindParam("monday", $monday, PDO::PARAM_STR);
        $stmt->bindParam("tuesday", $tuesday, PDO::PARAM_STR);
        $stmt->bindParam("wednesday", $wednesday, PDO::PARAM_STR);
        $stmt->bindParam("thursday", $thursday, PDO::PARAM_STR);
        $stmt->bindParam("friday", $friday, PDO::PARAM_STR);
        $stmt->bindParam("saturday", $saturday, PDO::PARAM_STR);
        $stmt->bindParam("sunday", $sunday, PDO::PARAM_STR);

        $stmt->bindParam("rname", $name, PDO::PARAM_STR);
        $stmt->bindParam("ally", $ally, PDO::PARAM_STR);
        $stmt->bindParam("address", $address, PDO::PARAM_STR);
        $stmt->bindParam("open_time", $open_time, PDO::PARAM_STR);
        $stmt->bindParam("close_time", $close_time, PDO::PARAM_STR);
        $stmt->bindParam("delivery_time", $del_time, PDO::PARAM_STR);
        $stmt->bindParam("ctimestamp", $timestamp, PDO::PARAM_STR);
        $stmt->bindParam("currency", $currency, PDO::PARAM_STR);
        $stmt->bindParam("photo", $imagename, PDO::PARAM_STR);
        $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
        $stmt->bindParam("lat", $latitude, PDO::PARAM_STR);
        $stmt->bindParam("lon", $longitude, PDO::PARAM_STR);
        $stmt->bindParam("description", $desc, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("website", $website, PDO::PARAM_STR);
        $stmt->bindParam("city", $city, PDO::PARAM_STR);
        $stmt->bindParam("location", $location, PDO::PARAM_STR);
        $stmt->bindParam("dcharge", $dcharge, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $stmt1 = $db->prepare("SELECT * FROM fooddelivery_restaurant where email=:email && name=:name && photo=:photo ");
        $stmt1->bindParam("name", $name, PDO::PARAM_STR);
        $stmt1->bindParam("email", $email, PDO::PARAM_STR);
        $stmt1->bindParam("photo", $imagename, PDO::PARAM_STR);
        $stmt1->execute();
        $data = $stmt1->fetch(PDO::FETCH_OBJ);
        $res_id = $data->id;
        foreach ($category as $rows) {
            $stmt2 = $db->prepare("INSERT INTO fooddelivery_category_res(res_id,cat_id) VALUES (:res_id,:cat_id)");
            $stmt2->bindParam("res_id", $res_id, PDO::PARAM_STR);
            $stmt2->bindParam("cat_id", $rows, PDO::PARAM_STR);
            $stmt2->execute();
        }
        if ($count) {
            return true;
        } else {
            return true;
        }
        /*
          $name=mysql_real_escape_string(trim($name));
          $address=mysql_real_escape_string(trim($address));
          $desc=mysql_real_escape_string(trim($desc));
          $email=mysql_real_escape_string(trim($email));
          $location=mysql_real_escape_string(trim($location));
          $timestamp=time();
          $sql4="
          INSERT INTO `fooddelivery_restaurant` SET `name`='$name',`address`='$address',`open_time`='$open_time',
          `close_time`='$close_time',`delivery_time`='$del_time',`timestamp`='$timestamp',
          `currency`='$currency',`photo`='$imagename',`phone`='$phone',
          `lat`='$latitude',`lon`='$longitude',`desc`='$desc',`email`='$email',`website`='$website',`location`='$location' ";
          $result = mysqli_query($this->db,$sql4);

          $sql5="Select * from fooddelivery_restaurant where email='$email' && name='$name' && photo='$imagename'";
          $result12 = mysqli_query($this->db,$sql5);
          $res_detail = mysqli_fetch_array($result12);
          $res_id=$res_detail['id'];
          foreach($category as $value){
          $sql6="insert into fooddelivery_category_res SET res_id='$res_id',cat_id='$value' ";
          mysqli_query($this->db,$sql6);
          }
          return $result;
         */
    }

    public function getrestaurant($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT *, restaurant_restaurant_get_presence(fooddelivery_restaurant.id) as day_open_closed FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 ORDER BY day_open_closed DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "filter") {
            $stmt = $db->prepare("SELECT * FROM view_store WHERE city=:search OR CAT_ID=:search AND is_active=0 ORDER BY commission DESC LIMIT $start,$per_page");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "filtertotal") {
            $stmt = $db->prepare("SELECT * FROM view_store WHERE city=:search OR CAT_ID=:search AND is_active=0 ORDER BY commission DESC");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 and name LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 and name LIKE '%" . $search . "%' ORDER BY id DESC");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT *, restaurant_restaurant_get_presence(fooddelivery_restaurant.id) as day_open_closed FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 ORDER BY day_open_closed DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getfreedelivery($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 and ally='Gratis' ORDER BY city DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "filter") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant WHERE city=:search and ally='Gratis' ORDER BY city DESC LIMIT $start,$per_page");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "filtertotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant WHERE city=:search and ally='Gratis' ORDER BY city DESC");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 and ally='Gratis' and name LIKE '%" . $search . "%' ORDER BY city DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 and name LIKE '%" . $search . "%' ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=0 and ally='Gratis' ORDER BY city DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getlockedshop($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=1 ORDER BY enable DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=1 and name LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=1 and name LIKE '%" . $search . "%' ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where type_store<>'Publicidad' and is_active=1 ORDER BY enable DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getadvertising($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant WHERE type_store = 'Publicidad' ORDER BY sequence");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where name LIKE '%" . $search . "%' AND type_store = 'Publicidad' ORDER BY sequence LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where name LIKE '%" . $search . "%' AND type_store = 'Publicidad' ORDER BY sequence");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant WHERE type_store = 'Publicidad' ORDER BY sequence LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getcategory_passid($res_id, $cat_id, $check)
    {
        $db = getDB();
        if ($check == "getrescat") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_category_res where res_id=:res_id && cat_id=:cat_id");
            $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
            $stmt->bindParam("cat_id", $cat_id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            $data = $stmt->fetch(PDO::FETCH_OBJ);
            $array = $data;
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } else {

            $stmt = $db->prepare("SELECT * FROM fooddelivery_category_res where res_id=:res_id");
            $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
            $stmt->execute();
            foreach ($stmt as $rows1) {
                //echo '<pre>'; print_r($rows1); exit();
                //print_r($rows1);
                $stmt1 = $db->prepare("SELECT id,name FROM fooddelivery_subcategory where id='" . $rows1['cat_id'] . "'");
                //print_r($stmt1);
                $stmt1->execute();
                $data = $stmt1->fetch(PDO::FETCH_OBJ);
                $cdata[] = array("cname" => $data->name);
            }
            //print_r($cdata);
            return @$cdata;
        }
    }

    public function getrestaurantdetail($id)
    {

        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
        /* $sql10 = "SELECT * FROM fooddelivery_restaurant where id='$id'";
          $res3 = mysqli_query($this->db, $sql10);
          $fetchdetail=mysqli_fetch_array($res3);
          return $fetchdetail; */
    }

    public function getresowner($id)
    {

        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_res_owner where res_id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
        /* $sql10 = "SELECT * FROM fooddelivery_restaurant where id='$id'";
          $res3 = mysqli_query($this->db, $sql10);
          $fetchdetail=mysqli_fetch_array($res3);
          return $fetchdetail; */
    }

    public function deletemultiplecategory($id)
    {

        $db = getDB();
        $stmt = $db->prepare("DELETE FROM fooddelivery_category_res where res_id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editoptions($id, $open_time, $close_time, $commission, $ally, $monday, $tuesday, $wednesday, $thursday, $friday, $saturday, $sunday, $edit_id, $edit_date_time)
    {
        if ($monday == 'YES') {
            $monday = 'YES';
        } else {
            $monday = 'NO';
        }
        if ($tuesday == 'YES') {
            $tuesday = 'YES';
        } else {
            $tuesday = 'NO';
        }
        if ($wednesday == 'YES') {
            $wednesday = 'YES';
        } else {
            $wednesday = 'NO';
        }
        if ($thursday == 'YES') {
            $thursday = 'YES';
        } else {
            $thursday = 'NO';
        }
        if ($friday == 'YES') {
            $friday = 'YES';
        } else {
            $friday = 'NO';
        }
        if ($saturday == 'YES') {
            $saturday = 'YES';
        } else {
            $saturday = 'NO';
        }
        if ($sunday == 'YES') {
            $sunday = 'YES';
        } else {
            $sunday = 'NO';
        }
        $db = getDB();

        $stmt = $db->prepare("
        UPDATE `fooddelivery_restaurant` SET 
        `commission`=:commission,
        `open_time`=:open_time,
        `close_time`=:close_time,
        `ally`=:ally,
        monday=:monday,
        tuesday=:tuesday,
        wednesday=:wednesday,
        thursday=:thursday,
        friday=:friday,
        saturday=:saturday,
        sunday=:sunday,
        edit_id=:edit_id,
        edit_date_time=:edit_date_time
        WHERE `id`=:id
         ");
        $stmt->bindParam("monday", $monday, PDO::PARAM_STR);
        $stmt->bindParam("tuesday", $tuesday, PDO::PARAM_STR);
        $stmt->bindParam("wednesday", $wednesday, PDO::PARAM_STR);
        $stmt->bindParam("thursday", $thursday, PDO::PARAM_STR);
        $stmt->bindParam("friday", $friday, PDO::PARAM_STR);
        $stmt->bindParam("saturday", $saturday, PDO::PARAM_STR);
        $stmt->bindParam("sunday", $sunday, PDO::PARAM_STR);
        $stmt->bindParam("edit_id", $edit_id, PDO::PARAM_STR);
        $stmt->bindParam("edit_date_time", $edit_date_time, PDO::PARAM_STR);
        $stmt->bindParam("open_time", $open_time, PDO::PARAM_STR);
        $stmt->bindParam("close_time", $close_time, PDO::PARAM_STR);
        $stmt->bindParam("commission", $commission, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->bindParam("ally", $ally, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editrestaurantdetail($id, $name, $cedula, $city_id, $type_store, $address, $desc, $email, $phone, $website, $del_time, $open_time, $close_time, $category, $commission, $store_owner, $city, $location, $latitude, $longitude, $imagename, $currency, $dcharge, $ally, $monday, $tuesday, $wednesday, $thursday, $friday, $saturday, $sunday, $edit_id, $edit_date_time)
    {
        if ($monday == 'YES') {
            $monday = 'YES';
        } else {
            $monday = 'NO';
        }
        if ($tuesday == 'YES') {
            $tuesday = 'YES';
        } else {
            $tuesday = 'NO';
        }
        if ($wednesday == 'YES') {
            $wednesday = 'YES';
        } else {
            $wednesday = 'NO';
        }
        if ($thursday == 'YES') {
            $thursday = 'YES';
        } else {
            $thursday = 'NO';
        }
        if ($friday == 'YES') {
            $friday = 'YES';
        } else {
            $friday = 'NO';
        }
        if ($saturday == 'YES') {
            $saturday = 'YES';
        } else {
            $saturday = 'NO';
        }
        if ($sunday == 'YES') {
            $sunday = 'YES';
        } else {
            $sunday = 'NO';
        }
        $db = getDB();
        if ($imagename != "none") {
            $stmt = $db->prepare("
            UPDATE `fooddelivery_restaurant` SET 
            `name`=:rname,
            `dni`=:cedula,
            `city_id`=:city_id,
            `type_store`=:type_store,
            `ally`=:ally,
            `address`=:address,
            `delivery_time`=:delivery_time,
            `commission`=:commission,
            `store_owner`=:store_owner,
            `currency`=:currency,
            `lat`=:lat,
            `lon`=:lon,
            `desc`=:description,
            `email`=:email,
            `website`=:website,
            `city`=:city,
            `location`=:location,
            `open_time`=:open_time,
            `close_time`=:close_time,
            `phone`=:phone,
            `photo`=:photo,
            `del_charge`=:dcharge,
             monday=:monday,
            tuesday=:tuesday,
            wednesday=:wednesday,
            thursday=:thursday,
            friday=:friday,
            saturday=:saturday,
            sunday=:sunday,
            edit_id=:edit_id,
            edit_date_time=:edit_date_time          
            WHERE `id`=:id
             ");
            $stmt->bindParam("monday", $monday, PDO::PARAM_STR);
            $stmt->bindParam("tuesday", $tuesday, PDO::PARAM_STR);
            $stmt->bindParam("wednesday", $wednesday, PDO::PARAM_STR);
            $stmt->bindParam("thursday", $thursday, PDO::PARAM_STR);
            $stmt->bindParam("friday", $friday, PDO::PARAM_STR);
            $stmt->bindParam("saturday", $saturday, PDO::PARAM_STR);
            $stmt->bindParam("sunday", $sunday, PDO::PARAM_STR);
            $stmt->bindParam("edit_id", $edit_id, PDO::PARAM_STR);
            $stmt->bindParam("edit_date_time", $edit_date_time, PDO::PARAM_STR);
            $stmt->bindParam("rname", $name, PDO::PARAM_STR);
            $stmt->bindParam("cedula", $cedula, PDO::PARAM_STR);
            $stmt->bindParam("city_id", $city_id, PDO::PARAM_STR);
            $stmt->bindParam("type_store", $type_store, PDO::PARAM_STR);
            $stmt->bindParam("address", $address, PDO::PARAM_STR);
            $stmt->bindParam("open_time", $open_time, PDO::PARAM_STR);
            $stmt->bindParam("close_time", $close_time, PDO::PARAM_STR);
            $stmt->bindParam("delivery_time", $del_time, PDO::PARAM_STR);
            $stmt->bindParam("commission", $commission, PDO::PARAM_STR);
            $stmt->bindParam("store_owner", $store_owner, PDO::PARAM_STR);
            $stmt->bindParam("currency", $currency, PDO::PARAM_STR);
            $stmt->bindParam("photo", $imagename, PDO::PARAM_STR);
            $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
            $stmt->bindParam("lat", $latitude, PDO::PARAM_STR);
            $stmt->bindParam("lon", $longitude, PDO::PARAM_STR);
            $stmt->bindParam("description", $desc, PDO::PARAM_STR);
            $stmt->bindParam("email", $email, PDO::PARAM_STR);
            $stmt->bindParam("website", $website, PDO::PARAM_STR);
            $stmt->bindParam("city", $city, PDO::PARAM_STR);
            $stmt->bindParam("location", $location, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->bindParam("dcharge", $dcharge, PDO::PARAM_STR);
            $stmt->bindParam("ally", $ally, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            $this->deletemultiplecategory($id);
            foreach ($category as $rows) {
                $stmt2 = $db->prepare("INSERT INTO fooddelivery_category_res(res_id,cat_id) VALUES (:res_id,:cat_id)");
                $stmt2->bindParam("res_id", $id, PDO::PARAM_STR);
                $stmt2->bindParam("cat_id", $rows, PDO::PARAM_STR);
                $stmt2->execute();
            }
            if ($count) {
                return true;
            } else {
                return false;
            }
        } else {

            $stmt = $db->prepare("
            UPDATE `fooddelivery_restaurant` SET 
            `name`=:rname,
            `dni`=:cedula,
            `city_id`=:city_id,
            `type_store`=:type_store,
            `address`=:address,
            `delivery_time`=:delivery_time,
            `commission`=:commission,
            `store_owner`=:store_owner,
            `currency`=:currency,
            `lat`=:lat,
            `lon`=:lon,
            `desc`=:description,
            `email`=:email,
            `website`=:website,
            `city`=:city,
            `location`=:location,
            `open_time`=:open_time,
            `close_time`=:close_time,
            `phone`=:phone,
            `del_charge`=:dcharge,
            `ally`=:ally,
            monday=:monday,
            tuesday=:tuesday,
            wednesday=:wednesday,
            thursday=:thursday,
            friday=:friday,
            saturday=:saturday,
            sunday=:sunday,
            edit_id=:edit_id,
            edit_date_time=:edit_date_time
            WHERE `id`=:id
             ");
            $stmt->bindParam("monday", $monday, PDO::PARAM_STR);
            $stmt->bindParam("tuesday", $tuesday, PDO::PARAM_STR);
            $stmt->bindParam("wednesday", $wednesday, PDO::PARAM_STR);
            $stmt->bindParam("thursday", $thursday, PDO::PARAM_STR);
            $stmt->bindParam("friday", $friday, PDO::PARAM_STR);
            $stmt->bindParam("saturday", $saturday, PDO::PARAM_STR);
            $stmt->bindParam("sunday", $sunday, PDO::PARAM_STR);
            $stmt->bindParam("edit_id", $edit_id, PDO::PARAM_STR);
            $stmt->bindParam("edit_date_time", $edit_date_time, PDO::PARAM_STR);
            $stmt->bindParam("rname", $name, PDO::PARAM_STR);
            $stmt->bindParam("cedula", $cedula, PDO::PARAM_STR);
            $stmt->bindParam("city_id", $city_id, PDO::PARAM_STR);
            $stmt->bindParam("type_store", $type_store, PDO::PARAM_STR);
            $stmt->bindParam("address", $address, PDO::PARAM_STR);
            $stmt->bindParam("open_time", $open_time, PDO::PARAM_STR);
            $stmt->bindParam("close_time", $close_time, PDO::PARAM_STR);
            $stmt->bindParam("delivery_time", $del_time, PDO::PARAM_STR);
            $stmt->bindParam("commission", $commission, PDO::PARAM_STR);
            $stmt->bindParam("store_owner", $store_owner, PDO::PARAM_STR);
            $stmt->bindParam("currency", $currency, PDO::PARAM_STR);
            $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
            $stmt->bindParam("lat", $latitude, PDO::PARAM_STR);
            $stmt->bindParam("lon", $longitude, PDO::PARAM_STR);
            $stmt->bindParam("description", $desc, PDO::PARAM_STR);
            $stmt->bindParam("email", $email, PDO::PARAM_STR);
            $stmt->bindParam("website", $website, PDO::PARAM_STR);
            $stmt->bindParam("city", $city, PDO::PARAM_STR);
            $stmt->bindParam("location", $location, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->bindParam("dcharge", $dcharge, PDO::PARAM_STR);
            $stmt->bindParam("ally", $ally, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            $this->deletemultiplecategory($id);
            foreach ($category as $rows) {
                $stmt2 = $db->prepare("INSERT INTO fooddelivery_category_res(res_id,cat_id) VALUES (:res_id,:cat_id)");
                $stmt2->bindParam("res_id", $id, PDO::PARAM_STR);
                $stmt2->bindParam("cat_id", $rows, PDO::PARAM_STR);
                $stmt2->execute();
            }
            if ($count) {
                return true;
            } else {
                return false;
            }
        }
    }

    public function editreowndetalis($id, $pwd, $email, $phone)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_res_owner` SET 
            `password`=:pwd,
            `phone`=:phone,
            `email`=:email
            WHERE `id`=:id
             ");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->bindParam("pwd", $pwd, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("phone", $phone, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function getcategoryall($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_category ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_category where cname LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_category where cname LIKE '%" . $search . "%' ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_category ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getscheduleall($search, $check, $start, $per_page)
    {
        $db = getDB();
        $today = date("Y-m-d");
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_working_schedule WHERE w_date>='" . $today . "' GROUP BY rider_name ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_working_schedule WHERE w_date>='" . $today . "' AND rider_name LIKE '%" . $search . "%' GROUP BY rider_name ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            $array1 = array();
            if ($count > 0) {
                foreach ($array as $row) {
                    $stmt = $db->prepare("SELECT * FROM fooddelivery_working_schedule WHERE w_date>='" . $today . "' AND rider_name LIKE '" . $row['rider_name'] . "' ORDER BY id DESC LIMIT $start, $per_page");
                    $stmt->execute();
                    $row1 = $row;
                    $row1['dt'] = array();
                    foreach ($stmt as $row2) {
                        $row1['dt'][] = $row2['w_date'] . " | <font color='#242A30'> " . $row2['working_start'] . " ~ " . $row2['working_end'] . '</font>';
                    }
                    $array1[] = $row1;
                }
            }
            if ($count) {
                return $array1;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_working_schedule WHERE w_date>='" . $today . "' AND rider_name LIKE '%" . $search . "%' GROUP BY rider_name ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_working_schedule WHERE w_date>='" . $today . "' GROUP BY rider_name ORDER BY rider_name LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            $array1 = array();
            if ($count > 0) {
                foreach ($array as $row) {
                    $stmt = $db->prepare("SELECT * FROM fooddelivery_working_schedule WHERE w_date>='" . $today . "' AND rider_name LIKE '" . $row['rider_name'] . "' ORDER BY rider_name");
                    $stmt->execute();
                    $row1 = $row;
                    $row1['dt'] = array();
                    foreach ($stmt as $row2) {
                        $row1['dt'][] = $row2['w_date'] . " | <font color='#242A30'> " . $row2['working_start'] . " ~ " . $row2['working_end'] . '</font>';
                    }
                    $array1[] = $row1;
                }
            }
            if ($count) {
                return $array1;
            } else {
                return false;
            }
        }
    }

    public function getlockdetails($search, $check, $start, $per_page)
    {
        $db = getDB();
        $today = date("Y-m-d");
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_lock WHERE `status` = 'active' GROUP BY RIDER ORDER BY registered asc");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_lock WHERE `status` = 'active' AND RIDER LIKE '%" . $search . "%' GROUP BY RIDER ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            $array1 = array();
            if ($count > 0) {
                foreach ($array as $row) {
                    $stmt = $db->prepare("SELECT * FROM view_delivery_boy_lock WHERE `status` = 'active' AND RIDER LIKE '" . $row['RIDER'] . "' ORDER BY registered DESC");
                    $stmt->execute();
                    $row1 = $row;
                    $row1['dt'] = array();
                    foreach ($stmt as $row2) {
                        $date = date_create($row2['registered']);
                        $row1['dt'][] = date_format($date, "d-m-Y H:i:s") . " | <font color='#242A30'> " . $row2['type'] . " ~ " . $row2['details'] . '</font>';
                    }
                    $array1[] = $row1;
                }
            }
            if ($count) {
                return $array1;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_lock WHERE `status` = 'active' AND RIDER LIKE '%" . $search . "%' GROUP BY RIDER ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_lock WHERE `status` = 'active' GROUP BY RIDER ORDER BY RIDER LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            $array1 = array();
            if ($count > 0) {
                foreach ($array as $row) {
                    $stmt = $db->prepare("SELECT * FROM view_delivery_boy_lock WHERE `status` = 'active' AND RIDER LIKE '" . $row['RIDER'] . "' ORDER BY registered DESC");
                    $stmt->execute();
                    $row1 = $row;
                    $row1['dt'] = array();
                    foreach ($stmt as $row2) {
                        if ($row2['type'] == 'Bloqueo') {
                            $status = "<font color='#ff3333'>Bloqueo</font>";
                        } else {
                            $status = "<font color='#00aa17'><strong>Desbloqueo</strong></font>";
                        }
                        $date = date_create($row2['registered']);
                        $row1['dt'][] = date_format($date, "d-m-Y H:i:s") . " | " . $status . " ~ <font color='#242A30'>" . $row2['details'] . '</font>';
                    }
                    $array1[] = $row1;
                }
            }
            if ($count) {
                return $array1;
            } else {
                return false;
            }
        }
    }

    // Inicio funcion Historial de Acciones 
    public function getHistory($search, $check, $start, $per_page)
    {
        $db = getDB();
        $today = date("Y-m-d");
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_history WHERE `status` = 'active' GROUP BY RIDER ORDER BY registered asc");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_history WHERE `status` = 'active' AND RIDER LIKE '%" . $search . "%' GROUP BY RIDER ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            $array1 = array();
            if ($count > 0) {
                foreach ($array as $row) {
                    $stmt = $db->prepare("SELECT * FROM view_delivery_boy_history WHERE `status` = 'active' AND RIDER LIKE '" . $row['RIDER'] . "' ORDER BY registered DESC");
                    $stmt->execute();
                    $row1 = $row;
                    $row1['dt'] = array();
                    foreach ($stmt as $row2) {
                        if ($row2['type_action'] == 'Negativa') {
                            $status = "<font color='#ff3333'>Negativa</font>\t";
                        } elseif ($row2['type_action'] == 'Positiva') {
                            $status = "<font color='#00aa17'><strong>Positiva</strong></font>";
                        } elseif ($row2['type_action'] == 'Justificación') {
                            $status = "<font color='#ffe933'><strong>Justificación</strong></font>";
                        }
                        $date = date_create($row2['registered']);
                        $row1['dt'][] = date_format($date, "d-m-Y H:i:s") . " | " . $status . " | <font color='#242A30'>" . $row2['observation'] . '</font>';
                    }
                    $array1[] = $row1;
                }
            }
            if ($count) {
                return $array1;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_history WHERE `status` = 'active' AND RIDER LIKE '%" . $search . "%' GROUP BY RIDER ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM view_delivery_boy_history WHERE `status` = 'active' GROUP BY RIDER ORDER BY RIDER LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            $array1 = array();
            if ($count > 0) {
                foreach ($array as $row) {
                    $stmt = $db->prepare("SELECT * FROM view_delivery_boy_history WHERE `status` = 'active' AND RIDER LIKE '" . $row['RIDER'] . "' ORDER BY registered DESC");
                    $stmt->execute();
                    $row1 = $row;
                    $row1['dt'] = array();
                    foreach ($stmt as $row2) {
                        if ($row2['type_action'] == 'Negativa') {
                            $status = "<font color='#ff3333'>Negativa</font>\t";
                        } elseif ($row2['type_action'] == 'Positiva') {
                            $status = "<font color='#00aa17'><strong>Positiva</strong></font>";
                        } elseif ($row2['type_action'] == 'Justificación') {
                            $status = "<font color='#ffe933'><strong>Justificación</strong></font>";
                        }
                        $date = date_create($row2['registered']);
                        $row1['dt'][] = date_format($date, "d-m-Y H:i:s") . " | " . $status . " | <font color='#242A30'>" . $row2['observation'] . '</font>';
                    }
                    $array1[] = $row1;
                }
            }
            if ($count) {
                return $array1;
            } else {
                return false;
            }
        }
    }
    // Fin funcion Historial de Acciones 

    public function getsubschedule($search, $check, $start, $per_page, $id)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_working_schedule` WHERE `rider_name`=:id ORDER BY w_date DESC");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_working_schedule` WHERE `rider_name`=:id AND `w_date` LIKE '%" . $search . "%' ORDER BY w_date DESC LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $row1 = $rows;
                $row1['dt'] = $rows['w_date'] . " : <font color='#242A30'> " . substr($rows['working_start'], 0, 5) . " ~ " . substr($rows['working_end'], 0, 5) . '</font>';
                $array[] = $row1;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM  `fooddelivery_working_schedule` WHERE `rider_name`=:id AND `w_date` LIKE '%" . $search . "%'");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM  `fooddelivery_working_schedule` WHERE `rider_name`=:id ORDER BY w_date DESC LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $row1 = $rows;
                $row1['dt'] = $rows['w_date'] . " : <font color='#242A30'> " . substr($rows['working_start'], 0, 5) . " ~ " . substr($rows['working_end'], 0, 5) . '</font>';
                $array[] = $row1;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function addnewsubschedule($rname, $rdate, $working_start, $working_end)
    {
        $db = getDB();
        $time = date("Y-m-d H:i:s");
        $stmt = $db->prepare("INSERT INTO `fooddelivery_working_schedule`(`rider_name`,`w_date`,`working_start`,`working_end`,`state`,`register_date`) VALUES ('" . $rname . "', '" . $rdate . "', '" . $working_start . "', '" . $working_end . "', 1, '" . $time . "')");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editsubscheduledetail($subcat_id, $working_start, $working_end)
    {

        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_working_schedule` SET 
            `working_start`=:working_start,
            `working_end`=:working_end
            WHERE `id`=:subcat_id
             ");
        $stmt->bindParam("subcat_id", $subcat_id, PDO::PARAM_STR);
        $stmt->bindParam("working_start", $working_start, PDO::PARAM_STR);
        $stmt->bindParam("working_end", $working_end, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function getcityall($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_city ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_city where cname LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_city where cname LIKE '%" . $search . "%' ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_city ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getcategorydetail($id)
    {

        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_category where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function getcitydetail($id)
    {

        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_city where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function editcategorydetail($id, $cname, $imagename)
    {

        $db = getDB();
        if ($imagename != "none") {
            $stmt = $db->prepare("
            UPDATE `fooddelivery_category` SET 
            `cname`=:cname,
            `image`=:image
            WHERE `id`=:id
             ");
            $stmt->bindParam("cname", $cname, PDO::PARAM_STR);
            $stmt->bindParam("image", $imagename, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return true;
            } else {
                return false;
            }
        } else {

            $stmt = $db->prepare("
            UPDATE `fooddelivery_category` SET 
            `cname`=:cname
            WHERE `id`=:id
             ");
            $stmt->bindParam("cname", $cname, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return true;
            } else {
                return false;
            }
        }
    }

    public function editcitydetail($id, $cname)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_city` SET 
            `cname`=:cname
            WHERE `id`=:id
             ");
        $stmt->bindParam("cname", $cname, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function edittypestore($id, $name, $observation)
    {
        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_type_store` SET 
            `name`=:name
            `observation`=:observation
            WHERE `id`=:id
             ");
        $stmt->bindParam("name", $name, PDO::PARAM_STR);
        $stmt->bindParam("observation", $observation, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function addnewmenu($id, $mname, $status)
    {
        $db = getDB();
        $time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_menu`(`res_id`,`name`,`created_at`,`status`) VALUES (:res_id,:mname,:time,:status)");
        $stmt->bindParam("res_id", $id, PDO::PARAM_STR);
        $stmt->bindParam("mname", $mname, PDO::PARAM_STR);
        $stmt->bindParam("time", $time, PDO::PARAM_STR);
        $stmt->bindParam("status", $status, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
        }
    }

    public function adduserstore($store_id, $fullname, $phone_no, $email, $password, $referal_code, $image, $notify, $login_with, $status, $verify_count)
    {
        $db = getDB();
        $time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_users`(`store_id`,`fullname`,`phone_no`,`email`,`password`,`referal_code`,`image`,`created_at`,`notify`,`login_with`,`status`,`verify_count`) VALUES (:store_id, :fullname, :phone_no, :email, :password, :referal_code, :image, :created_at, :notify, :login_with, :status, :verify_count)");
        $stmt->bindParam("store_id", $store_id, PDO::PARAM_STR);
        $stmt->bindParam("fullname", $fullname, PDO::PARAM_STR);
        $stmt->bindParam("phone_no", $phone_no, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("password", $password, PDO::PARAM_STR);
        $stmt->bindParam("referal_code", $referal_code, PDO::PARAM_STR);
        $stmt->bindParam("image", $image, PDO::PARAM_STR);
        $stmt->bindParam("created_at", $time, PDO::PARAM_STR);
        $stmt->bindParam("notify", $notify, PDO::PARAM_STR);
        $stmt->bindParam("login_with", $login_with, PDO::PARAM_STR);
        $stmt->bindParam("status", $status, PDO::PARAM_STR);
        $stmt->bindParam("verify_count", $verify_count, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
        }
    }

    public function getallmenu($search, $check, $start, $per_page, $id)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_menu` WHERE `res_id`=:id ORDER BY sequence ASC");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_menu` WHERE `res_id`=:id AND `name` LIKE '%" . $search . "%' ORDER BY sequence ASC LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM  `fooddelivery_menu` WHERE `res_id`=:id AND `name` LIKE '%" . $search . "%'");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM  `fooddelivery_menu` WHERE `res_id`=:id ORDER BY sequence ASC LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function editmenudetail($mid, $mname)
    {

        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_menu` SET 
            `name`=:mname
            WHERE `id`=:id
             ");
        $stmt->bindParam("mname", $mname, PDO::PARAM_STR);
        $stmt->bindParam("id", $mid, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function addnewsubmenu($id, $smname, $price, $desc, $image, $status)
    {

        $price = str_replace(',', '.', $price);

        $container = 0;
        $db = getDB();
        //$time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_submenu`(`menu_id`,`name`,`price`,`desc`,`created_at`,`image`,`container`,`status`) VALUES (:menu_id,:smname,:price,:desc,NOW(),:image,:container,:status)");
        $stmt->bindParam("status", $status, PDO::PARAM_STR);
        $stmt->bindParam("container", $container, PDO::PARAM_STR);
        $stmt->bindParam("menu_id", $id, PDO::PARAM_STR);
        $stmt->bindParam("smname", $smname, PDO::PARAM_STR);
        $stmt->bindParam("price", $price, PDO::PARAM_STR);
        $stmt->bindParam("desc", $desc, PDO::PARAM_STR);
        $stmt->bindParam("image", $image, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function addNewProd($id, $supplier_id, $unit_measure, $tax_id, $smname, $price_purchase, $price, $desc, $serie, $expired_date, $stock, $image, $status)
    {

        $price_purchase = str_replace(',', '.', $price_purchase);
        $price = str_replace(',', '.', $price);

        $container = 0;
        $db = getDB();
        //$time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_submenu`(`menu_id`,`supplier_id`,`unit_id`,`tax_id`,`name`,`price_purchase`,`price`,`desc`,`serie`,`expired_date`,`stock`,`created_at`,`image`,`container`,`status`) VALUES (:menu_id,:supplier_id,:unit_id,:tax_id,:smname,:price_purchase,:price,:desc,:serie,:expired_date,:stock,NOW(),:image,:container,:status)");
        $stmt->bindParam("status", $status, PDO::PARAM_STR);
        $stmt->bindParam("container", $container, PDO::PARAM_STR);
        $stmt->bindParam("menu_id", $id, PDO::PARAM_STR);
        $stmt->bindParam("supplier_id", $supplier_id, PDO::PARAM_STR);
        $stmt->bindParam("unit_id", $unit_measure, PDO::PARAM_STR);
        $stmt->bindParam("tax_id", $tax_id, PDO::PARAM_STR);
        $stmt->bindParam("smname", $smname, PDO::PARAM_STR);
        $stmt->bindParam("price_purchase", $price_purchase, PDO::PARAM_STR);
        $stmt->bindParam("price", $price, PDO::PARAM_STR);
        $stmt->bindParam("desc", $desc, PDO::PARAM_STR);
        $stmt->bindParam("serie", $serie, PDO::PARAM_STR);
        $stmt->bindParam("expired_date", $expired_date, PDO::PARAM_STR);
        $stmt->bindParam("stock", $stock, PDO::PARAM_STR);
        $stmt->bindParam("image", $image, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function addnewsubcategory($id, $cname, $created_at)
    {
        $db = getDB();
        $time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_subcategory`(`cat_id`,`name`,`created_at`) VALUES (:cat_id,:cname,:time)");
        $stmt->bindParam("cat_id", $id, PDO::PARAM_STR);
        $stmt->bindParam("cname", $cname, PDO::PARAM_STR);
        $stmt->bindParam("time", $created_at, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function getsubmenubyid($search, $check, $start, $per_page, $id)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_submenu` WHERE `menu_id`=:id ORDER BY id DESC");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM `view_product_catalog_store` WHERE `serie` LIKE '%" . $search . "%' OR `name` LIKE '%" . $search . "%' AND `STORE_ID`=:id ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM  `view_product_catalog_store` WHERE `serie` LIKE '%" . $search . "%' OR `name` LIKE '%" . $search . "%' AND `STORE_ID`=:id");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM  `fooddelivery_submenu` WHERE `menu_id`=:id LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getsubcategory($search, $check, $start, $per_page, $id)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_subcategory` WHERE `cat_id`=:id ORDER BY id DESC");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_subcategory` WHERE `cat_id`=:id AND `name` LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM  `fooddelivery_subcategory` WHERE `cat_id`=:id AND `name` LIKE '%" . $search . "%'");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM  `fooddelivery_subcategory` WHERE `cat_id`=:id  LIMIT $start,$per_page");
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function editsubmenudetail($id, $menu_id, $smname, $price, $desc, $image, $container)
    {
        $price = str_replace(',', '.', $price);
        $container = 0;
        $db = getDB();
        if ($image != "none") {
            $stmt = $db->prepare("
            UPDATE `fooddelivery_submenu` SET 
            `menu_id`=:menu_id,
            `name`=:smname,
            `price`=:price,
            `desc`=:desc,
            `image`=:image,
            `container`=:container
            WHERE `id`=:id");
            $stmt->bindParam("container", $container, PDO::PARAM_STR);
            $stmt->bindParam("menu_id", $menu_id, PDO::PARAM_STR);
            $stmt->bindParam("smname", $smname, PDO::PARAM_STR);
            $stmt->bindParam("price", $price, PDO::PARAM_STR);
            $stmt->bindParam("desc", $desc, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->bindParam("image", $image, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
        } else {
            $stmt = $db->prepare("
            UPDATE `fooddelivery_submenu` SET 
            `menu_id`=:menu_id,
            `name`=:smname,
            `price`=:price,
            `desc`=:desc
            WHERE `id`=:id
             ");
            $stmt->bindParam("menu_id", $menu_id, PDO::PARAM_STR);
            $stmt->bindParam("smname", $smname, PDO::PARAM_STR);
            $stmt->bindParam("price", $price, PDO::PARAM_STR);
            $stmt->bindParam("desc", $desc, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
        }

        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editsubmenuProd($id, $menu_id, $supplier_id, $unit_measure, $tax_id, $smname, $price_purchase, $price, $desc, $serie, $expired_date, $stock, $image, $container)
    {
        $price_purchase = str_replace(',', '.', $price_purchase);
        $price = str_replace(',', '.', $price);
        $container = 0;
        $db = getDB();
        if ($image != "none") {
            $stmt = $db->prepare("
            UPDATE `fooddelivery_submenu` SET 
            `menu_id`=:menu_id,
            `supplier_id`=:supplier_id,
            `unit_id`=:unit_id,
            `tax_id`=:tax_id,
            `name`=:smname,
            `price_purchase`=:price_purchase,
            `price`=:price,
            `desc`=:desc,
            `serie`=:serie,
            `expired_date`=:expired_date,
            `stock`=:stock,
            `image`=:image,
            `container`=:container
            WHERE `id`=:id");
            $stmt->bindParam("container", $container, PDO::PARAM_STR);
            $stmt->bindParam("menu_id", $menu_id, PDO::PARAM_STR);
            $stmt->bindParam("supplier_id", $supplier_id, PDO::PARAM_STR);
            $stmt->bindParam("unit_id", $unit_measure, PDO::PARAM_STR);
            $stmt->bindParam("tax_id", $tax_id, PDO::PARAM_STR);
            $stmt->bindParam("smname", $smname, PDO::PARAM_STR);
            $stmt->bindParam("price_purchase", $price_purchase, PDO::PARAM_STR);
            $stmt->bindParam("price", $price, PDO::PARAM_STR);
            $stmt->bindParam("desc", $desc, PDO::PARAM_STR);
            $stmt->bindParam("serie", $serie, PDO::PARAM_STR);
            $stmt->bindParam("expired_date", $expired_date, PDO::PARAM_STR);
            $stmt->bindParam("stock", $stock, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->bindParam("image", $image, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
        } else {
            $stmt = $db->prepare("
            UPDATE `fooddelivery_submenu` SET 
            `menu_id`=:menu_id,
            `supplier_id`=:supplier_id,
            `unit_id`=:unit_id,
            `tax_id`=:tax_id,
            `name`=:smname,
            `price_purchase`=:price_purchase,
            `price`=:price,
            `desc`=:desc,
            `serie`=:serie,
            `expired_date`=:expired_date,
            `stock`=:stock
            WHERE `id`=:id
             ");
            $stmt->bindParam("menu_id", $menu_id, PDO::PARAM_STR);
            $stmt->bindParam("supplier_id", $supplier_id, PDO::PARAM_STR);
            $stmt->bindParam("unit_id", $unit_measure, PDO::PARAM_STR);
            $stmt->bindParam("tax_id", $tax_id, PDO::PARAM_STR);
            $stmt->bindParam("smname", $smname, PDO::PARAM_STR);
            $stmt->bindParam("price_purchase", $price_purchase, PDO::PARAM_STR);
            $stmt->bindParam("price", $price, PDO::PARAM_STR);
            $stmt->bindParam("desc", $desc, PDO::PARAM_STR);
            $stmt->bindParam("serie", $serie, PDO::PARAM_STR);
            $stmt->bindParam("expired_date", $expired_date, PDO::PARAM_STR);
            $stmt->bindParam("stock", $stock, PDO::PARAM_STR);
            $stmt->bindParam("id", $id, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
        }

        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function editsubcategorydetail($subcat_id, $cname)
    {

        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_subcategory` SET 
            `name`=:cname
            WHERE `id`=:subcat_id
             ");
        $stmt->bindParam("subcat_id", $subcat_id, PDO::PARAM_STR);
        $stmt->bindParam("cname", $cname, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function getappusers($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users WHERE login_with='appuser' AND store_id IS NULL ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users where fullname LIKE '%" . $search . "%' OR email LIKE '%" . $search . "%' OR phone_no LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users where fullname LIKE '%" . $search . "%' OR email LIKE '%" . $search . "%' OR phone_no LIKE '%" . $search . "%' ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users WHERE login_with='appuser' AND store_id IS NULL ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getwebusers($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users WHERE login_with='webuser' ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users where fullname LIKE '%" . $search . "%' OR email LIKE '%" . $search . "%' OR phone_no LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users where fullname LIKE '%" . $search . "%' OR email LIKE '%" . $search . "%' OR phone_no LIKE '%" . $search . "%' ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_users WHERE login_with='webuser' ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getuserreview($search, $check, $start, $per_page, $res_id, $yes)
    {
        $db = getDB();
        if ($yes == "yes") {
            if ($check == "total") {
                $stmt = $db->prepare("SELECT * FROM  fooddelivery_reviews WHERE res_id=:res_id ORDER BY id DESC");
                $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                if ($count) {
                    return $count;
                } else {
                    return false;
                }
            } elseif ($check == "search") {
                $stmt = $db->prepare("SELECT * FROM  fooddelivery_reviews where review_text LIKE '%" . $search . "%' AND res_id=:res_id ORDER BY id DESC LIMIT $start,$per_page");
                $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            } elseif ($check == "searchtotal") {
                $stmt = $db->prepare("SELECT * FROM fooddelivery_reviews where review_text LIKE '%" . $search . "%' AND res_id=:res_id ORDER BY id DESC ");
                $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $total = $stmt->rowCount();
                if ($total) {
                    return $total;
                } else {
                    return false;
                }
            } else {
                $stmt = $db->prepare("SELECT * FROM fooddelivery_reviews WHERE res_id=:res_id ORDER BY id DESC LIMIT $start,$per_page");
                $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            }
        } else {
            if ($check == "total") {
                $stmt = $db->prepare("SELECT * FROM  fooddelivery_reviews ORDER BY id DESC");
                $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                if ($count) {
                    return $count;
                } else {
                    return false;
                }
            } elseif ($check == "search") {
                $stmt = $db->prepare("SELECT * FROM  fooddelivery_reviews where review_text LIKE '%" . $search . "%'   ORDER BY id DESC LIMIT $start,$per_page");

                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            } elseif ($check == "searchtotal") {
                $stmt = $db->prepare("SELECT * FROM fooddelivery_reviews where review_text LIKE '%" . $search . "%'  ORDER BY id DESC ");

                $stmt->execute();
                $total = $stmt->rowCount();
                if ($total) {
                    return $total;
                } else {
                    return false;
                }
            } else {
                $stmt = $db->prepare("SELECT * FROM fooddelivery_reviews ORDER BY id DESC LIMIT $start,$per_page");
                $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            }
        }
    }

    //delivery boy
    public function getdeliveryboyreview($search, $check, $start, $per_page, $res_id, $yes)
    {
        $db = getDB();
        if ($yes == "yes") {
            if ($check == "total") {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys WHERE RIDER_ID=:id ORDER BY id DESC");
                $stmt->bindParam("id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                if ($count) {
                    return $count;
                } else {
                    return false;
                }
            } elseif ($check == "search") {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys where order_id LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");
                $stmt->bindParam("id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            } elseif ($check == "searchtotal") {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys where order_id LIKE '%" . $search . "%' ORDER BY id DESC ");
                $stmt->bindParam("id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $total = $stmt->rowCount();
                if ($total) {
                    return $total;
                } else {
                    return false;
                }
            } else {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys WHERE RIDER_ID=:id ORDER BY id DESC LIMIT $start,$per_page");
                $stmt->bindParam("id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            }
        } else {
            if ($check == "total") {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys ORDER BY id DESC");
                $stmt->bindParam("id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                if ($count) {
                    return $count;
                } else {
                    return false;
                }
            } elseif ($check == "search") {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys where order_id LIKE '%" . $search . "%' ORDER BY id DESC LIMIT $start,$per_page");

                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            } elseif ($check == "searchtotal") {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys where order_id LIKE '%" . $search . "%' ORDER BY id DESC ");

                $stmt->execute();
                $total = $stmt->rowCount();
                if ($total) {
                    return $total;
                } else {
                    return false;
                }
            } else {
                $stmt = $db->prepare("SELECT * FROM view_reviews_deliveryboys ORDER BY id DESC LIMIT $start,$per_page");
                $stmt->bindParam("id", $res_id, PDO::PARAM_STR);
                $stmt->execute();
                $count = $stmt->rowCount();
                foreach ($stmt as $rows) {
                    $array[] = $rows;
                }
                if ($count) {
                    return $array;
                } else {
                    return false;
                }
            }
        }
    }

    public function getusername($id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT fullname,id,image,login_with FROM fooddelivery_users where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function restaurantname($id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT id,name FROM fooddelivery_restaurant where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function bookorderdeliveryboy($id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `RIDER`, `STORE`, `orig_id`, `record`, `order_name` FROM `view_bookorder_statistics` where `id`=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function getallrestaurantbyfilter()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT name,id FROM fooddelivery_restaurant WHERE is_active=0 ORDER BY name ASC");
        $stmt->execute();
        $count = $stmt->rowCount();
        foreach ($stmt as $rows) {
            $array[] = $rows;
        }
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function getdelivery_boyfilter()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT name,id FROM fooddelivery_delivery_boy WHERE status='active' ORDER BY name ASC");
        $stmt->execute();
        $count = $stmt->rowCount();
        foreach ($stmt as $rows) {
            $array[] = $rows;
        }
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function getallcityfilter()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT cname,id FROM fooddelivery_city ORDER BY cname ASC");
        $stmt->execute();
        $count = $stmt->rowCount();
        foreach ($stmt as $rows) {
            $array[] = $rows;
        }
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function editprofile($id, $fullname, $username, $email, $imagename)
    {
        $db = getDB();
        if ($imagename == "none") {
            $stmt = $db->prepare("Update `fooddelivery_adminlogin` Set
        `username`=:username,`email`=:email,`fullname`=:fullname where id=:id");
        } else {
            $stmt = $db->prepare("Update `fooddelivery_adminlogin` Set
        `username`=:username,`email`=:email,`icon`=:icon,`fullname`=:fullname  where id=:id");
            $stmt->bindParam("icon", $imagename, PDO::PARAM_STR);
        }
        $stmt->bindParam("username", $username, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("fullname", $fullname, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function updatepassword($id, $newpass)
    {

        $db = getDB();
        $stmt = $db->prepare("
            UPDATE `fooddelivery_adminlogin` SET 
            `password`=:password
            WHERE `id`=:id
             ");
        $stmt->bindParam("password", $newpass, PDO::PARAM_STR);
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function countnewusers()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_users where notify=1");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countnewreviews()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_reviews where notify=1 ");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function clearnotifyreview()
    {

        $db = getDB();
        $stmt = $db->prepare("UPDATE fooddelivery_reviews SET notify=0  where notify=1 ");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function clearuserscount()
    {
        $db = getDB();
        $stmt = $db->prepare("UPDATE fooddelivery_users SET notify=0  where notify=1 ");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function clearordernotify()
    {
        $db = getDB();
        $stmt = $db->prepare("UPDATE fooddelivery_bookorder SET notify=0  where notify=1 ");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
            return false;
        }
    }

    public function getadminaccess($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM  fooddelivery_adminlogin ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM  fooddelivery_adminlogin  ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_adminlogin ORDER BY id DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_adminlogin ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function checkadminaccess($email, $username)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_adminlogin where username=:username OR email=:email");
        $stmt->bindParam("username", $username, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function addnewadminaccess($username, $fullname, $password, $email, $imagename)
    {
        $db = getDB();
        $gg = "America/Bogota - (GMT-05:00) Bogota";
        $stmt = $db->prepare("INSERT INTO `fooddelivery_adminlogin`(`username`,`fullname`,`password`,`email`,`icon`,`timezone`) VALUES (:username,:fullname,:password,:email,:image,:timezone)");
        $stmt->bindParam("username", $username, PDO::PARAM_STR);
        $stmt->bindParam("fullname", $fullname, PDO::PARAM_STR);
        $stmt->bindParam("password", $password, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->bindParam("image", $imagename, PDO::PARAM_STR);
        $stmt->bindParam("timezone", $gg, PDO::PARAM_STR);

        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
        }
    }

    public function checkresowneraccess($email, $name)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where name=:name OR email=:email");
        $stmt->bindParam("name", $name, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function addnewresowneraccess($name, $password, $time, $mobile, $email)
    {
        $db = getDB();
        $time = time();
        $stmt = $db->prepare("INSERT INTO `fooddelivery_res_owner`(`username`,`password`,`timestamp`,`phone`,`email`,`role`) VALUES (:name,:password,:time,:mobile,:email,'2')");
        $stmt->bindParam("name", $name, PDO::PARAM_STR);
        $stmt->bindParam("password", $password, PDO::PARAM_STR);
        $stmt->bindParam("time", $time, PDO::PARAM_STR);
        $stmt->bindParam("mobile", $mobile, PDO::PARAM_STR);
        $stmt->bindParam("email", $email, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return true;
        } else {
        }
    }

    public function getratting($id)
    {
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

    public function res_openandclose($res_id, $time_open, $time_close)
    {
        $db = getDB();
        $time = date('H:i:s');

        $stmt = $db->prepare("SELECT id, restaurant_restaurant_get_presence($res_id) as day_open_closed FROM fooddelivery_restaurant WHERE id=:res_id AND '" . $time . "' >= :open_time and '" . $time . "' <= :close_time");
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->bindParam("open_time", $time_open, PDO::PARAM_STR);
        $stmt->bindParam("close_time", $time_close, PDO::PARAM_STR);
        $stmt->execute();
        /*$count = $stmt->rowCount();
        if ($count) {
           return "open";
        } else {
            return "closed";
        }*/
        foreach ($stmt as $row) {
            if ($row['day_open_closed'] == '1') {
                return "open";
            } elseif ($row['day_open_closed'] == '0') {
                return "closed";
            }
        }
    }

    public function totalresreview($res_id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM  fooddelivery_reviews  WHERE res_id=:res_id");
        $stmt->bindParam("res_id", $res_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function getfoodorder($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT `id`, `status` FROM `fooddelivery_bookorder` ORDER BY `id` DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "filter") {
            $stmt = $db->prepare("SELECT `id`, `created_at`, `user_id`, `CITY`, `res_id`, `RIDER`, `status`, `time_arrive`, `picked_date_time`, `total_price`, `delivery_price`, `orig_id`, `record`, `address`, `order_name` FROM `view_bookorder_statistics` WHERE `res_id`=:search OR `CITY_RIDER`=:search ORDER BY `id` DESC LIMIT $start,$per_page");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "filtertotal") {
            $stmt = $db->prepare("SELECT `id`, `created_at`, `user_id`, `CITY`, `res_id`, `RIDER`, `status`, `time_arrive`, `picked_date_time`, `total_price`, `delivery_price`, `orig_id`, `record`, `address`, `order_name` FROM `view_bookorder_statistics` WHERE `res_id`=:search OR `CITY_RIDER`=:search ORDER BY `id` DESC");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT `id`, `created_at`, `user_id`, `CITY`, `res_id`, `RIDER`, `status`, `time_arrive`, `picked_date_time`, `total_price`, `delivery_price`, `orig_id`, `record`, `address`, `order_name` FROM `view_bookorder_statistics` WHERE `id` LIKE '%" . $search . "%' or `CLIENT` LIKE '%" . $search . "%' OR `RIDER` LIKE '%" . $search . "%' OR `STORE` LIKE '%" . $search . "%' OR `order_name` LIKE '%" . $search . "%' OR `order_phone` LIKE '%" . $search . "%' ORDER BY `id` DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT `id`, `created_at`, `user_id`, `CITY`, `res_id`, `RIDER`, `status`, `time_arrive`, `picked_date_time`, `total_price`, `delivery_price`, `orig_id`, `record`, `address`, `order_name` FROM `view_bookorder_statistics` WHERE `id` LIKE '%" . $search . "%' OR `CLIENT` LIKE '%" . $search . "%' OR `RIDER` LIKE '%" . $search . "%' OR `STORE` LIKE '%" . $search . "%' OR `order_name` LIKE '%" . $search . "%' OR `order_phone` LIKE '%" . $search . "%' ORDER BY `id` DESC ");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT `id`, `created_at`, `user_id`, `CITY`, `res_id`, `RIDER`, `status`, `time_arrive`, `picked_date_time`, `total_price`, `delivery_price`, `orig_id`, `record`, `address`, `order_name` FROM `view_bookorder_statistics` ORDER BY `id` DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getdeliveryboy($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy WHERE status='active' ORDER BY attendance='yes' desc, level_id desc");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "filter") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy WHERE city_id=:search and status='active' ORDER BY attendance='yes' desc, level_id desc LIMIT $start,$per_page");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "filtertotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy WHERE city_id=:search and status='active' ORDER BY attendance='yes' desc, level_id desc");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy where name LIKE '%" . $search . "%' OR phone LIKE '%" . $search . "%' OR backpack_code LIKE '%" . $search . "%' OR vehicle_no LIKE '%" . $search . "%' ORDER BY attendance='yes' desc, level_id desc LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy where name LIKE '%" . $search . "%' OR phone LIKE '%" . $search . "%' OR backpack_code LIKE '%" . $search . "%' OR vehicle_no LIKE '%" . $search . "%' ORDER BY attendance='yes' desc, level_id desc");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_delivery_boy WHERE status='active' ORDER BY attendance='yes' desc, level_id desc LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getautoaccept($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_auto_accept ORDER BY `id`");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_auto_accept` ORDER BY `id` LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getMarketProvider($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_supplier` ORDER BY `name`");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } elseif ($check == "filter") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_supplier` WHERE city_id=:search ORDER BY `name` DESC LIMIT $start,$per_page");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "filtertotal") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_supplier` WHERE city_id=:search ORDER BY `name` DESC");
            $stmt->bindParam("search", $search, PDO::PARAM_STR);
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } elseif ($check == "search") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_supplier` WHERE `name` LIKE '%" . $search . "%' OR `phone` LIKE '%" . $search . "%' OR `identification` LIKE '%" . $search . "%' OR `email` LIKE '%" . $search . "%' ORDER BY `name` DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        } elseif ($check == "searchtotal") {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_supplier` WHERE `name` LIKE '%" . $search . "%' OR `phone` LIKE '%" . $search . "%' OR `identification` LIKE '%" . $search . "%' OR `email` LIKE '%" . $search . "%' ORDER BY `name` DESC");
            $stmt->execute();
            $total = $stmt->rowCount();
            if ($total) {
                return $total;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM `fooddelivery_supplier` ORDER BY `name` DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getliveorders($search, $check, $start, $per_page)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics ORDER BY id DESC LIMIT 30");
        $stmt->execute();
        $count = $stmt->rowCount();
        foreach ($stmt as $rows) {
            $array[] = $rows;
        }
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function getfoodorderwait($search, $check, $start, $per_page)
    {
        //pendiente de guardar
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT id, status FROM view_bookorder_statistics WHERE status=3 ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics WHERE status=3 ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getfoodorderwaitstore($search, $check, $start, $per_page)
    {
        //pendiente de aceptar por la tienda
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics WHERE status=5 ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics WHERE status=5 ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getfoodorderwaitrider($search, $check, $start, $per_page)
    {
        //pendiente de aceptar por la rider
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_bookorder WHERE status=0 ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_bookorder WHERE status=0 ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getfoodorderwaitpickup($search, $check, $start, $per_page)
    {
        //pendiente recoger orden
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics WHERE status=1 ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics WHERE status=1 ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getfoodorderrejected($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_bookorder WHERE status=2 or status=6 or status=7 ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM fooddelivery_bookorder WHERE status=2 or status=6 or status=7 ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function getfoodorderdelivered($search, $check, $start, $per_page)
    {
        $db = getDB();
        if ($check == "total") {
            $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics WHERE status=4 ORDER BY id DESC");
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count) {
                return $count;
            } else {
                return false;
            }
        } else {
            $stmt = $db->prepare("SELECT * FROM view_bookorder_statistics WHERE status=4 ORDER BY id DESC LIMIT $start,$per_page");
            $stmt->execute();
            $count = $stmt->rowCount();
            foreach ($stmt as $rows) {
                $array[] = $rows;
            }
            if ($count) {
                return $array;
            } else {
                return false;
            }
        }
    }

    public function countnotifyorder()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_bookorder` where `notify`=1");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countdeliveredorder()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_bookorder` WHERE `status`=4");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countwaitorder()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_bookorder` WHERE `status`=3");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countwaitorderstore()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_bookorder` WHERE `status`=5");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countwaitorderrider()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_bookorder` WHERE `status`=0");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countwaitpickuporder()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_bookorder` WHERE `status`=1");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countrejectedorder()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_bookorder` WHERE `status`=2");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countdeliveryboylocked()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_delivery_boy` WHERE `status`='disable'");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countdeliveryboyyes()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_delivery_boy` WHERE `attendance`='yes' AND `status`='active'");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function countdeliveryboyno()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_delivery_boy` WHERE `attendance`='no' AND `status`='active'");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function userblocked()
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `id` FROM `fooddelivery_users` WHERE `status`='inactive'");
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($count) {
            return $count;
        } else {
            return false;
        }
    }

    public function getresid($id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_menu where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function getcurrencybyid($id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM fooddelivery_restaurant where id=:id");
        $stmt->bindParam("id", $id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        $array = $data;
        if ($count) {
            return $array;
        } else {
            return false;
        }
    }

    public function getresname($res_id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `name` FROM fooddelivery_restaurant where id=:id");
        $stmt->bindParam("id", $res_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        if ($count) {
            return $data->name;
        } else {
            return false;
        }
    }

    public function getUserAdmin($user_id)
    {
        $db = getDB();
        $stmt = $db->prepare("SELECT `fullname` FROM `fooddelivery_adminlogin` WHERE `id`=:id");
        $stmt->bindParam("id", $user_id, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->rowCount();
        $data = $stmt->fetch(PDO::FETCH_OBJ);
        if ($count) {
            return $data->fullname;
        } else {
            return false;
        }
    }
}

?>