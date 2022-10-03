-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 03, 2022 at 04:02 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `bookorder_get_order_automatically_reject_for_deliveryboys` (IN `vfecha` VARCHAR(200))   BEGIN
	DECLARE vid_reject_auto_deliveryboys INT;
	
	SELECT MAX(id_reject_auto_deliveryboys) 
	INTO vid_reject_auto_deliveryboys
	FROM fooddelivery_bookorder;
	
	IF vid_reject_auto_deliveryboys IS NULL THEN 
		SET vid_reject_auto_deliveryboys=1;
	ELSE
		SET vid_reject_auto_deliveryboys=vid_reject_auto_deliveryboys+1;
	END IF;
	
	UPDATE fooddelivery_bookorder
	SET status=6,
	id_reject_auto_deliveryboys=vid_reject_auto_deliveryboys,
	auto_reject_deliveryboys_time=DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:00.000000'),
	auto_reject_deliveryboys_status='active'
	WHERE status=0
	AND TIMESTAMPDIFF(minute,FROM_UNIXTIME(created_at),NOW())>=8;
	
	
	SELECT  * FROM fooddelivery_bookorder
	WHERE id_reject_auto_deliveryboys=vid_reject_auto_deliveryboys;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `bookorder_get_order_automatically_reject_for_restaurant` (IN `vfecha` VARCHAR(200))   BEGIN
	DECLARE vid_reject_auto_restaurant INT;
	
	SELECT MAX(id_reject_auto_restaurant) 
	INTO vid_reject_auto_restaurant
	FROM fooddelivery_bookorder;
	
	IF vid_reject_auto_restaurant IS NULL THEN 
		SET vid_reject_auto_restaurant=1;
	ELSE
		SET vid_reject_auto_restaurant=vid_reject_auto_restaurant+1;
	END IF;
	
	UPDATE fooddelivery_bookorder
	SET STATUS=7,
	id_reject_auto_restaurant=vid_reject_auto_restaurant,
	auto_reject_restaurant_time=DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:00.000000'),
	auto_reject_restaurant_status='active'
	WHERE STATUS=5
	AND TIMESTAMPDIFF(minute,timestamp_assign,NOW())>=8;
	
	
	SELECT  * FROM fooddelivery_bookorder
	WHERE id_reject_auto_restaurant=vid_reject_auto_restaurant;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `category_get_categories_by_restaurant` (IN `vres_id` INT)   BEGIN
	SELECT fooddelivery_subcategory.name 
	from fooddelivery_category_res ,fooddelivery_subcategory
	where fooddelivery_category_res.res_id=vres_id
	 AND fooddelivery_subcategory.id=fooddelivery_category_res.cat_id;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cities_get_cities` ()  NO SQL BEGIN
	SELECT id,cname
    FROM fooddelivery_city
    ORDER BY cname;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delivery_boy_login` (IN `vemail` VARCHAR(250), IN `vpassword` VARCHAR(250), IN `vtoken` VARCHAR(255), IN `vso` VARCHAR(50))  NO SQL BEGIN
	
    DECLARE v_id INT;
	 
	SELECT id
	INTO v_id
    FROM fooddelivery_delivery_boy
    WHERE email=vemail
    AND password=vpassword
    LIMIT 1;
    
    IF v_id IS NULL THEN 
       SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Information invalid';
	END IF;
	 
	DELETE FROM fooddelivery_tokendata
	WHERE delivery_boyid=v_id;
     
	DELETE FROM fooddelivery_tokendata	
	WHERE token=vtoken;
	 
	INSERT INTO fooddelivery_tokendata(delivery_boyid,token,type)
	VALUES(v_id,vtoken,vso);
	
	UPDATE fooddelivery_delivery_boy SET session='yes';
	 
	SELECT id, level_id, name, phone, email, START_DATE, vehicle_no, vehicle_type, image, DESC_LEVELS 
	FROM view_delivery_level
	WHERE id=v_id;
     
	 /*SELECT id, name, phone, email,  vehicle_no, vehicle_type,image 
	 FROM fooddelivery_delivery_boy
	 WHERE id=v_id;*/
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `general_get_information` ()  NO SQL BEGIN
	DECLARE vcities INT;
	DECLARE vdelivery INT;
	DECLARE vusers INT;
	DECLARE vrestauants INT;
	DECLARE vdeliveryboys INT;
	DECLARE vreviews INT;
    DECLARE vadvertising INT;
    DECLARE vlocked_shop INT;
    DECLARE vconcordia INT;
    DECLARE vsantodomingo INT;
    DECLARE vguayaquil INT;
	
	SELECT COUNT(*) INTO vcities
   FROM fooddelivery_city;
   
   SELECT COUNT(*) INTO vdelivery
   FROM fooddelivery_bookorder;
   
   SELECT COUNT(*) INTO vusers
   FROM fooddelivery_users WHERE store_id IS NULL AND id NOT IN (7414, 7415, 7416, 7417, 7418, 7419, 7420, 7421, 7422, 7423, 7424, 7425, 7426, 7427, 7428, 7429, 7430, 7431, 7432, 7433, 7434, 7435, 7436, 7437, 7438, 7439, 7440, 7441, 7442, 7443, 7444, 7445, 7446, 7447, 7448, 7449, 7450, 7451, 7452, 7453, 7454, 7455, 7456, 7457, 7458, 7459, 7460, 7461, 7462, 7463, 9684, 9685, 9686, 9687, 9688, 9694, 9695, 9696, 9697, 9698, 9699, 9700, 9701, 9702, 9703, 9704, 9705, 9706, 9707, 9708, 9782, 9783, 9784, 9785, 9786, 9787, 9788, 9789, 9790, 9791, 9792, 9793, 9794, 9795, 9796, 9797, 9798, 9799, 9800, 9801, 9802, 9803, 9804, 9805, 9806, 9807, 9808, 9809, 9810, 9811, 9812, 9813, 9814, 9815, 9816, 9817, 9818, 9819, 9820, 9821, 9828, 9829, 9830, 9831, 9832, 9833, 9834, 9835, 9836, 9837);
   
   SELECT COUNT(*) INTO vrestauants
   FROM fooddelivery_restaurant
	WHERE is_active=0 AND type_store<>'Publicidad';
   
   SELECT COUNT(*) INTO vdeliveryboys
   FROM fooddelivery_delivery_boy WHERE status='active';
   
   SELECT COUNT(*) INTO vreviews
   FROM fooddelivery_reviews;
   
   SELECT COUNT(*) INTO vadvertising
   FROM fooddelivery_restaurant
	WHERE is_active=0 AND type_store='Publicidad';
   
   SELECT COUNT(*) INTO vlocked_shop
   FROM fooddelivery_restaurant
	WHERE is_active=1 AND type_store<>'Publicidad';
    
    SELECT COUNT(*) INTO vconcordia
   FROM fooddelivery_restaurant
	WHERE is_active=0 AND city='La Concordia' AND type_store<>'Publicidad';
    
    SELECT COUNT(*) INTO vsantodomingo
   FROM fooddelivery_restaurant
	WHERE is_active=0 AND city='Santo Domingo de los Colorados' AND type_store<>'Publicidad';
    
    SELECT COUNT(*) INTO vguayaquil
   FROM fooddelivery_restaurant
	WHERE is_active=0 AND city='Guayaquil' AND type_store<>'Publicidad';
   
   SELECT vcities,vdelivery,vusers,vrestauants,vdeliveryboys,vreviews,vadvertising,vlocked_shop,vconcordia,vsantodomingo,vguayaquil; 
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payments_list_payments` (IN `vsearch` VARCHAR(200), IN `vstart` INT, IN `vlimit` INT)   BEGIN
	IF vsearch='' THEN
		SELECT  fooddelivery_payments.*,fooddelivery_delivery_boy.name
		FROM fooddelivery_payments,fooddelivery_delivery_boy
		 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
		  and fooddelivery_payments.`type`='deliveryboy'
          and fooddelivery_payments.amount<>0.00
		LIMIT vlimit OFFSET vstart;
	
	ELSE
	
		SELECT  fooddelivery_payments.*,fooddelivery_delivery_boy.name
		FROM fooddelivery_payments,fooddelivery_delivery_boy
		 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
	    AND  (fooddelivery_delivery_boy.name  LIKE concat('%',upper(vsearch),'%') )
	     and fooddelivery_payments.`type`='deliveryboy'
         and fooddelivery_payments.amount<>0.00
	     
		LIMIT vlimit OFFSET vstart;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payments_list_paymentsfilter` (IN `vsearch` VARCHAR(200), IN `vstart` INT, IN `vlimit` INT, IN `vstatus` VARCHAR(50))   BEGIN
	IF vsearch='' THEN
		SELECT  fooddelivery_payments.*,fooddelivery_delivery_boy.name
		FROM fooddelivery_payments,fooddelivery_delivery_boy
		 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
		  and fooddelivery_payments.`type`='deliveryboy'
		  and fooddelivery_payments.status=vstatus
          and fooddelivery_payments.amount<>0.00
		LIMIT vlimit OFFSET vstart;
	
	ELSE
	
		SELECT  fooddelivery_payments.*,fooddelivery_delivery_boy.name
		FROM fooddelivery_payments,fooddelivery_delivery_boy
		 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
	    AND  (fooddelivery_delivery_boy.name  LIKE concat('%',upper(vsearch),'%') )
	     and fooddelivery_payments.`type`='deliveryboy'
	     and fooddelivery_payments.status=vstatus
         and fooddelivery_payments.amount<>0.00
		LIMIT vlimit OFFSET vstart;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `restaurants_get_restaurantsbycity` (IN `vcity` VARCHAR(500))  NO SQL BEGIN
	SELECT id,name
    FROM fooddelivery_restaurant
    WHERE is_active=0
    AND city=vcity
    ORDER BY name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `restaurant_get_restaurants_by_city` (IN `vsearch` VARCHAR(500), IN `vlat` VARCHAR(250), IN `vlon` VARCHAR(250), IN `vcity` VARCHAR(250), IN `vrecords` INT, IN `voffset` INT)   BEGIN
	DECLARE v_id INT;
	DECLARE v_active_order INT;
	DECLARE v_radio  DECIMAL(10,0) ;
	

			
	   IF CHAR_LENGTH(vsearch)=0 THEN 
			
	   	SELECT DISTINCT fooddelivery_restaurant.id as id,fooddelivery_restaurant.name as name,fooddelivery_restaurant.address as address,fooddelivery_restaurant.open_time as open_time,fooddelivery_restaurant.close_time as close_time,
	      fooddelivery_restaurant.delivery_time as delivery_time,fooddelivery_restaurant.timestamp as timestamp,fooddelivery_restaurant.currency as currency,fooddelivery_restaurant.photo as photo,fooddelivery_restaurant.phone as phone,
	      fooddelivery_restaurant.lat as lat,fooddelivery_restaurant.lon as lon,fooddelivery_restaurant.desc ,fooddelivery_restaurant.email as email,fooddelivery_restaurant.website as website,fooddelivery_restaurant.city as city,fooddelivery_restaurant.location as location,
	      fooddelivery_restaurant.is_active as is_active,fooddelivery_restaurant.del_charge as del_charge,
		restaurant_restaurant_get_presence(fooddelivery_restaurant.id) as enable, restaurant_verify_open_noenable(fooddelivery_restaurant.id) as openclosehorario,
         restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) AS distance,restaurant_get_ratting(fooddelivery_restaurant.id) AS ratting,
         bookorder_get_deliveryprice_no_validate(fooddelivery_restaurant.id,vlat,vlon,vcity) as delivery_price,
         (ceil(restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) / 40 * 60) + fooddelivery_restaurant.delivery_time +3)as time_order
         FROM fooddelivery_restaurant ,fooddelivery_menu,fooddelivery_submenu
         WHERE fooddelivery_menu.id=fooddelivery_submenu.menu_id
         AND fooddelivery_menu.res_id=fooddelivery_restaurant.id
         AND `is_active`=0   
         AND LOWER(fooddelivery_restaurant.city)=LOWER(vcity)
         ORDER BY  openclosehorario desc,enable DESC,delivery_price,distance ASC limit voffset,vrecords;
	   ELSE
	   	   SELECT DISTINCT fooddelivery_restaurant.id as id,
				fooddelivery_restaurant.name as name,fooddelivery_restaurant.address as address,fooddelivery_restaurant.open_time as open_time,fooddelivery_restaurant.close_time as close_time,
				fooddelivery_restaurant.delivery_time as delivery_time,fooddelivery_restaurant.timestamp as timestamp,fooddelivery_restaurant.currency as currency,
				fooddelivery_restaurant.photo as photo,fooddelivery_restaurant.phone as phone,fooddelivery_restaurant.lat as lat,fooddelivery_restaurant.lon as lon,	fooddelivery_restaurant.desc ,fooddelivery_restaurant.email as email,
				fooddelivery_restaurant.website as website,fooddelivery_restaurant.city as city,fooddelivery_restaurant.location as location,fooddelivery_restaurant.is_active as is_active,
				fooddelivery_restaurant.del_charge as del_charge,
				restaurant_restaurant_get_presence(fooddelivery_restaurant.id) as enable,restaurant_verify_open_noenable(fooddelivery_restaurant.id) as openclosehorario,
				restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) AS distance,restaurant_get_ratting(fooddelivery_restaurant.id) AS ratting,
         bookorder_get_deliveryprice_no_validate(fooddelivery_restaurant.id,vlat,vlon,vcity) as delivery_price,
     (ceil(restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) / 40 * 60) + fooddelivery_restaurant.delivery_time +3)as time_order
            FROM fooddelivery_restaurant,fooddelivery_menu,fooddelivery_submenu
            WHERE fooddelivery_menu.id=fooddelivery_submenu.menu_id
            AND fooddelivery_menu.res_id=fooddelivery_restaurant.id
            AND (
					 lower(fooddelivery_submenu.name) LIKE LOWER(CONCAT('%',vsearch,'%')) 
					 OR   lower(fooddelivery_restaurant.name) LIKE  LOWER(CONCAT('%',vsearch,'%')) 
					 OR   lower(fooddelivery_menu.name) LIKE  LOWER(CONCAT('%',vsearch,'%')) 
					 )
            AND `is_active`=0               
			    AND LOWER(fooddelivery_restaurant.city)=LOWER(vcity)
            ORDER BY  openclosehorario desc,enable DESC,delivery_price,distance ASC limit voffset,vrecords;
	   END IF;
	   
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `restaurant_get_restaurants_by_city_filter` (IN `vsearch` VARCHAR(500), IN `vlat` VARCHAR(250), IN `vlon` VARCHAR(250), IN `vcity` VARCHAR(250), IN `vrecords` INT, IN `voffset` INT, IN `vtype_store` VARCHAR(250))   BEGIN
	DECLARE v_id INT;
	DECLARE v_active_order INT;
	DECLARE v_radio  DECIMAL(10,0) ;
	

			
	   IF CHAR_LENGTH(vsearch)=0 THEN 
			
	   	
	   	SELECT DISTINCT fooddelivery_restaurant.id as id,fooddelivery_restaurant.name as name,fooddelivery_restaurant.address as address,fooddelivery_restaurant.open_time as open_time,fooddelivery_restaurant.close_time as close_time,
	      fooddelivery_restaurant.delivery_time as delivery_time,fooddelivery_restaurant.timestamp as timestamp,fooddelivery_restaurant.currency as currency,fooddelivery_restaurant.photo as photo,fooddelivery_restaurant.phone as phone,
	      fooddelivery_restaurant.lat as lat,fooddelivery_restaurant.lon as lon,fooddelivery_restaurant.desc ,fooddelivery_restaurant.email as email,fooddelivery_restaurant.website as website,fooddelivery_restaurant.city as city,fooddelivery_restaurant.location as location,
	      fooddelivery_restaurant.is_active as is_active,fooddelivery_restaurant.del_charge as del_charge,
		restaurant_restaurant_get_presence(fooddelivery_restaurant.id) as enable, restaurant_verify_open_noenable(fooddelivery_restaurant.id) as openclosehorario,
         restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) AS distance,restaurant_get_ratting(fooddelivery_restaurant.id) AS ratting,
         bookorder_get_deliveryprice_no_validate(fooddelivery_restaurant.id,vlat,vlon,vcity) as delivery_price,
         (ceil(restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) / 40 * 60) + fooddelivery_restaurant.delivery_time +3)as time_order
         FROM fooddelivery_restaurant ,fooddelivery_menu,fooddelivery_submenu
         WHERE fooddelivery_menu.id=fooddelivery_submenu.menu_id
         AND fooddelivery_menu.res_id=fooddelivery_restaurant.id
         AND `is_active`=0   
         AND LOWER(fooddelivery_restaurant.city)=LOWER(vcity)
         AND LOWER(fooddelivery_restaurant.type_store)=LOWER(vtype_store)
         ORDER BY  openclosehorario desc,enable DESC,delivery_price,distance ASC limit voffset,vrecords;
	   ELSE
	   	   SELECT DISTINCT fooddelivery_restaurant.id as id,
				fooddelivery_restaurant.name as name,fooddelivery_restaurant.address as address,fooddelivery_restaurant.open_time as open_time,fooddelivery_restaurant.close_time as close_time,
				fooddelivery_restaurant.delivery_time as delivery_time,fooddelivery_restaurant.timestamp as timestamp,fooddelivery_restaurant.currency as currency,
				fooddelivery_restaurant.photo as photo,fooddelivery_restaurant.phone as phone,fooddelivery_restaurant.lat as lat,fooddelivery_restaurant.lon as lon,	fooddelivery_restaurant.desc ,fooddelivery_restaurant.email as email,
				fooddelivery_restaurant.website as website,fooddelivery_restaurant.city as city,fooddelivery_restaurant.location as location,fooddelivery_restaurant.is_active as is_active,
				fooddelivery_restaurant.del_charge as del_charge,
				restaurant_restaurant_get_presence(fooddelivery_restaurant.id) as enable,restaurant_verify_open_noenable(fooddelivery_restaurant.id) as openclosehorario,
				restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) AS distance,restaurant_get_ratting(fooddelivery_restaurant.id) AS ratting,
         bookorder_get_deliveryprice_no_validate(fooddelivery_restaurant.id,vlat,vlon,vcity) as delivery_price,
     (ceil(restaurant_get_distance(fooddelivery_restaurant.id,vlat,vlon) / 40 * 60) + fooddelivery_restaurant.delivery_time +3)as time_order
            FROM fooddelivery_restaurant,fooddelivery_menu,fooddelivery_submenu
            WHERE fooddelivery_menu.id=fooddelivery_submenu.menu_id
            AND fooddelivery_menu.res_id=fooddelivery_restaurant.id
            AND (
					 lower(fooddelivery_submenu.name) LIKE LOWER(CONCAT('%',vsearch,'%')) 
					 OR   lower(fooddelivery_restaurant.name) LIKE  LOWER(CONCAT('%',vsearch,'%')) 
					 OR   lower(fooddelivery_menu.name) LIKE  LOWER(CONCAT('%',vsearch,'%')) 
					 )
            AND `is_active`=0               
			    AND LOWER(fooddelivery_restaurant.city)=LOWER(vcity)

         		AND LOWER(fooddelivery_restaurant.type_store)=LOWER(vtype_store)
            ORDER BY  openclosehorario desc,enable DESC,delivery_price,distance ASC limit voffset,vrecords;
	   END IF;
	   
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `restaurant_owner_login` (IN `vemail` VARCHAR(250), IN `vpassword` VARCHAR(250), IN `vtoken` VARCHAR(255), IN `vso` VARCHAR(50))  NO SQL BEGIN
	 DECLARE v_id INT;
	 declare v_restaurant_id int;
	 
	 SELECT id,res_id
	 INTO v_id,v_restaurant_id
    FROM fooddelivery_res_owner
    WHERE email=vemail
    AND password=vpassword
    LIMIT 1;
    
    IF v_id IS NULL THEN 
       SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Information invalid';
	
	 END IF;
	 
	 DELETE FROM fooddelivery_tokendata
	 WHERE restaurant_ownerid=v_id;
     
     DELETE FROM fooddelivery_tokendata	
		WHERE token=vtoken;
	 
	 INSERT INTO fooddelivery_tokendata(restaurant_ownerid,token,type)
	 VALUES(v_id,vtoken,vso);
	 
	  UPDATE fooddelivery_restaurant
	   SET session=1 
		where id=v_restaurant_id;
	 
	 SELECT fooddelivery_res_owner.id as restaurant_ownerid,username,fooddelivery_restaurant.id as id,name ,address,
	 open_time,close_time,lat,lon,city,enable,fooddelivery_restaurant.photo    
	 FROM fooddelivery_res_owner,fooddelivery_restaurant 
	 WHERE fooddelivery_restaurant.id=fooddelivery_res_owner.res_id
	 AND  fooddelivery_res_owner.id=v_id;
	 
	 
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_create_or_update_user` (IN `vfullname` VARCHAR(200), IN `vphone_no` VARCHAR(15), IN `vimage` VARCHAR(500), IN `vtoken` VARCHAR(255), IN `voperative_system` VARCHAR(50), IN `vcode` VARCHAR(50))   BEGIN
	DECLARE v_id INT;
	
	DECLARE v_version_id VARCHAR(50);
		
	-- Verificar la versión de la app
	SELECT id 
	INTO v_version_id
	FROM fooddelivery_versions
	WHERE LOWER(operative_system)=LOWER(voperative_system)
	AND LOWER (code)=LOWER(vcode)
	AND status='active'
	and type='user'
	LIMIT 1;
		
	IF v_version_id IS NULL THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Exists a new version of App';
	END IF;
	
	SELECT id
	INTO v_id
	FROM fooddelivery_users
	WHERE phone_no=vphone_no;
	
	-- Verificar si existe actualizarlo.
	IF v_id IS  NULL THEN
	
		SELECT max(id) INTO v_id
		FROM fooddelivery_users;
		
		IF v_id IS NULL THEN
			SET v_id=1;
		ELSE
			SET v_id=v_id+ 1;
		END IF;
		
		INSERT INTO fooddelivery_users (id,fullname,phone_no,email,password,image,created_at)
		VALUES(v_id,vfullname,vphone_no,vphone_no,MD5(vphone_no),vimage,UNIX_TIMESTAMP());
		
		INSERT INTO fooddelivery_tokendata (user_id,token,type)
		VALUES(v_id,vtoken,voperative_system);
		
	ELSE
	-- Si existe eliminar el token anterior .	
		DELETE FROM fooddelivery_tokendata	
		WHERE user_id=v_id;

		DELETE FROM fooddelivery_tokendata	
		WHERE token=vtoken;
		
		UPDATE  fooddelivery_users 
		SET fullname=vfullname,
		image=vimage
		WHERE id=v_id;
		
		INSERT INTO fooddelivery_tokendata (user_id,token,type)
		VALUES(v_id,vtoken,voperative_system);
		
	END IF;
	
	SELECT id,fullname,email,phone_no,referal_code,image,created_at,login_with
	FROM fooddelivery_users
	WHERE id=v_id;	
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_get_user_by_phone` (IN `vphone_no` VARCHAR(15))   BEGIN
	
	
	SELECT fullname,image
	FROM fooddelivery_users
	WHERE phone_no=vphone_no;
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `zone_get_coordinates` (IN `vzone_id` INT)   BEGIN
	
	SELECT lat,fooddelivery_coordinates.long
	FROM fooddelivery_coordinates
	WHERE zone_id=vzone_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `zone_list_zones` (IN `vcity_id` INT)   BEGIN
	
	SELECT id,name,city_id
	FROM fooddelivery_zones
	where city_id=vcity_id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_accept_order_restaurant` (`vrestaurant_id` INT, `vaccept_date_time` VARCHAR(50), `vid` INT, `vtime_prepare` VARCHAR(50)) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vactualizado INT;
	 
	 SELECT COUNT(*) INTO vactualizado
	 FROM fooddelivery_bookorder
	 WHERE id=vid
	 AND res_id=vrestaurant_id;
	 
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'Book order dont exists';
    
	END IF;
	 
	UPDATE fooddelivery_bookorder
	SET STATUS='1',
	accept_date_time=DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') ,
	accept_status='active' ,
	time_prepare=vtime_prepare
	WHERE id=vid;	
        
	 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_assign_order` (`vdeliverboy_id` INT, `vassign_date_time` VARCHAR(50), `vid` INT) RETURNS TINYINT(1) NO SQL BEGIN
	DECLARE vactualizado INT;
	DECLARE vis_assigned INT;
	DECLARE vstatus INT;
	 
	SELECT COUNT(*) INTO vactualizado
	FROM fooddelivery_bookorder
	WHERE id=vid;
     
	SELECT status INTO vstatus
	FROM fooddelivery_bookorder
	WHERE id=vid;
     
    SELECT is_assigned INTO vis_assigned
	FROM fooddelivery_bookorder
	WHERE id=vid;
	
    IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'Book order dont exists';
	END IF;
	 
	IF payments_verify_expired_deliveryboy(vdeliverboy_id)>0 THEN
		SIGNAL SQLSTATE '45010'
 		SET MESSAGE_TEXT = 'Pending Payment';
	END IF;
	
    IF vis_assigned='' OR vstatus=0 THEN
		UPDATE fooddelivery_bookorder
		SET is_assigned=vdeliverboy_id,
		status='5',
		timestamp_assign=DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'),
		assign_date_time=DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') ,
		assign_status='active' 
		WHERE id=vid;
    END IF;

 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_delivered_order` (`vdeliverboy_id` INT, `vdelivered_date_time` VARCHAR(50), `vid` INT) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vactualizado INT;
	 
	 SELECT COUNT(*) INTO vactualizado
	 FROM fooddelivery_bookorder
	 WHERE id=vid;
	 
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'Book order dont exists';
    
	END IF;
	 
	UPDATE fooddelivery_bookorder
	SET is_assigned=vdeliverboy_id,
	STATUS='4',
	delivered_date_time=NOW(),
	delivered_status='active' 
	WHERE id=vid;
	
	
        
	 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_get_deliveryprice` (`vrestaurant_id` BIGINT, `vlat` VARCHAR(50), `vlon` VARCHAR(50), `vcity` VARCHAR(50)) RETURNS DECIMAL(20,2) NO SQL BEGIN
	DECLARE v_radio DECIMAL(40,2);
	DECLARE v_restaurant_lat VARCHAR(50);
	DECLARE v_restaurant_lon VARCHAR(50);
	DECLARE v_delivery_price DECIMAL(40,2);
	DECLARE v_distance DECIMAL(40,20);
	DECLARE v_radius_data DECIMAL(40,20);
	DECLARE v_km DECIMAL(40,2);
	DECLARE vally VARCHAR(50);
	
	/*DECLARE v_start_price DECIMAL(40,2) DEFAULT 1.70;*/
	DECLARE v_start_price DECIMAL(40,2);
	DECLARE v_start_distance DECIMAL(40,2); /*distancia inicial 1km*/
	DECLARE v_increment_distance DECIMAL(20) DEFAULT 1.00;
	DECLARE v_increment_price DECIMAL(40,2); /* incremento por km*/
	DECLARE v_distance_aditional_start DECIMAL(40,2) DEFAULT 0.00;
	DECLARE v_price_aditional_start DECIMAL(40,2) DEFAULT 0.00;
	DECLARE v_restaurant_open tinyint(1);
	DECLARE v_enable tinyint(1);
	DECLARE v_restaurant_id tinyint(1);

   SELECT value INTO v_start_price
	FROM fooddelivery_settings
	WHERE id='INITIAL_DYNAMIC_VALUE';
	
	SELECT value INTO v_increment_price
	FROM fooddelivery_settings
	WHERE id='INCREMENT_PRICE_DELIVERY';
	
	SELECT value INTO v_start_distance
	FROM fooddelivery_settings
	WHERE id='START_DISTANCE_KM';
	
	SELECT id,restaurant_verify_open_noenable(id),enable,city,ally
	INTO v_restaurant_id,v_restaurant_open,v_enable,vcity,vally
	FROM fooddelivery_restaurant
	WHERE id=vrestaurant_id;
	
	SELECT radio 
	INTO v_radio
	FROM fooddelivery_city
	WHERE LOWER(cname)=LOWER(vcity);
	
   IF v_radio IS NULL THEN
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Can´t get distance restaurant';
	ELSEIF v_restaurant_id IS NULL  THEN
		  SIGNAL SQLSTATE '45002'
 		  SET MESSAGE_TEXT = 'The restauran don´t exist';
 	ELSEIF  v_restaurant_open=0 OR v_enable=0 THEN
		   SIGNAL SQLSTATE '45003'
 		  SET MESSAGE_TEXT = 'Restaurant Close';
	ELSE 
		
		SET	v_km=ceil(restaurant_get_distance(vrestaurant_id,vlat,vlon));
		
		IF v_km>v_radio THEN
			SIGNAL SQLSTATE '45004'
 		  SET MESSAGE_TEXT = 'Distance not allowed';
		END IF;
		
		IF v_km < v_start_distance THEN 
		
			SET v_delivery_price= v_start_price;
		ELSE 
			-- calcular cuanto km hay demás, esos redondearlos y multiplicarlos por el factor
			SET v_distance_aditional_start=v_km-v_start_distance;
			SET v_price_aditional_start=v_distance_aditional_start *v_increment_price;	
				
			SET v_delivery_price=v_start_price + v_price_aditional_start ;
		END IF;
        
        IF vally='Gratis' THEN
			set v_delivery_price=v_delivery_price-v_start_price;
		END IF;
        
        IF vally='- 0.10' THEN
            set v_delivery_price=v_delivery_price-0.10;
		END IF;
        
        IF vally='- 0.20' THEN
            set v_delivery_price=v_delivery_price-0.20;
		END IF;
        
        IF vally='- 0.25' THEN
            set v_delivery_price=v_delivery_price-0.25;
		END IF;
        
        IF vally='- 0.30' THEN
            set v_delivery_price=v_delivery_price-0.30;
		END IF;
        
        IF vally='- 0.40' THEN
            set v_delivery_price=v_delivery_price-0.40;
		END IF;
        
        IF vally='- 0.50' THEN
            set v_delivery_price=v_delivery_price-0.50;
		END IF;
        
        IF vally='- 0.60' THEN
            set v_delivery_price=v_delivery_price-0.60;
		END IF;
        
        IF vally='- 0.70' THEN
            set v_delivery_price=v_delivery_price-0.70;
		END IF;
        
        IF vally='- 0.80' THEN
            set v_delivery_price=v_delivery_price-0.80;
		END IF;
        
        IF vally='- 0.90' THEN
            set v_delivery_price=v_delivery_price-0.90;
		END IF;
        
        IF vally='- 1.00' THEN
            set v_delivery_price=v_delivery_price-1.00;
		END IF;
        
        -- estos valores suma el valor total --
        IF vally='+ 0.05' THEN
            set v_delivery_price=v_delivery_price+0.05;
		END IF;
        
        IF vally='+ 0.10' THEN
            set v_delivery_price=v_delivery_price+0.10;
		END IF;
        
        IF vally='+ 0.20' THEN
            set v_delivery_price=v_delivery_price+0.20;
		END IF;
        
        IF vally='+ 0.25' THEN
            set v_delivery_price=v_delivery_price+0.25;
		END IF;
        
        IF vally='+ 0.30' THEN
            set v_delivery_price=v_delivery_price+0.30;
		END IF;
        
        IF vally='+ 0.40' THEN
            set v_delivery_price=v_delivery_price+0.40;
		END IF;
        
        IF vally='+ 0.50' THEN
            set v_delivery_price=v_delivery_price+0.50;
		END IF;
        
        IF vally='+ 0.60' THEN
            set v_delivery_price=v_delivery_price+0.60;
		END IF;
        
        IF vally='+ 0.70' THEN
            set v_delivery_price=v_delivery_price+0.70;
		END IF;
        
        IF vally='+ 0.80' THEN
            set v_delivery_price=v_delivery_price+0.80;
		END IF;
        
        IF vally='+ 0.90' THEN
            set v_delivery_price=v_delivery_price+0.90;
		END IF;
        
        IF vally='+ 1.00' THEN
            set v_delivery_price=v_delivery_price+1.00;
		END IF;
        
		RETURN v_delivery_price;
		
	END IF;
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_get_deliveryprice_no_validate` (`vrestaurant_id` BIGINT, `vlat` VARCHAR(50), `vlon` VARCHAR(50), `vcity` VARCHAR(50)) RETURNS DECIMAL(20,2) NO SQL BEGIN
	DECLARE v_radio DECIMAL(40,2);
	DECLARE v_restaurant_lat VARCHAR(50);
	DECLARE v_restaurant_lon VARCHAR(50);
	DECLARE v_delivery_price DECIMAL(40,2);
	DECLARE v_distance DECIMAL(40,20);
	DECLARE v_radius_data DECIMAL(40,20);
	DECLARE v_km DECIMAL(40,2);
	
	/*DECLARE v_start_price DECIMAL(40,2) DEFAULT 1.70;*/
   DECLARE v_start_price DECIMAL(40,2);
	DECLARE v_start_distance DECIMAL(40,2);
	DECLARE v_increment_distance DECIMAL(20) DEFAULT 1.00;
	DECLARE v_increment_price DECIMAL(40,2); /* incremento por km*/
	DECLARE v_distance_aditional_start DECIMAL(40,2) DEFAULT 0.00;
	DECLARE v_price_aditional_start DECIMAL(40,2) DEFAULT 0.00;
	DECLARE v_restaurant_open tinyint(1);
	DECLARE v_enable tinyint(1);
	DECLARE v_restaurant_id tinyint(1);
	DECLARE vally VARCHAR(40);
	
   SELECT value INTO v_start_price
	FROM fooddelivery_settings
	WHERE id='INITIAL_DYNAMIC_VALUE';
	
	SELECT value INTO v_increment_price
	FROM fooddelivery_settings
	WHERE id='INCREMENT_PRICE_DELIVERY';
	
	SELECT value INTO v_start_distance
	FROM fooddelivery_settings
	WHERE id='START_DISTANCE_KM';
	
	SELECT id,restaurant_verify_open_noenable(id),enable,city,ally
	INTO v_restaurant_id,v_restaurant_open,v_enable,vcity,vally
	FROM fooddelivery_restaurant
	WHERE id=vrestaurant_id;
	
		
		SET	v_km=ceil(restaurant_get_distance(vrestaurant_id,vlat,vlon));
	
		
		IF v_km < v_start_distance THEN 
		
			SET v_delivery_price= v_start_price;
		ELSE 
			-- calcular cuanto km hay demás, esos redondearlos y multiplicarlos por el factor
			SET v_distance_aditional_start=v_km-v_start_distance;
			SET v_price_aditional_start=v_distance_aditional_start *v_increment_price;	
				
			SET v_delivery_price=v_start_price + v_price_aditional_start ;
		END IF;
        
        IF vally='Gratis' THEN
			set v_delivery_price=v_delivery_price-v_start_price;
		END IF;
        
        IF vally='- 0.10' THEN
            set v_delivery_price=v_delivery_price-0.10;
		END IF;
        
        IF vally='- 0.20' THEN
            set v_delivery_price=v_delivery_price-0.20;
		END IF;
        
        IF vally='- 0.25' THEN
            set v_delivery_price=v_delivery_price-0.25;
		END IF;
        
        IF vally='- 0.30' THEN
            set v_delivery_price=v_delivery_price-0.30;
		END IF;
        
        IF vally='- 0.40' THEN
            set v_delivery_price=v_delivery_price-0.40;
		END IF;
        
        IF vally='- 0.50' THEN
            set v_delivery_price=v_delivery_price-0.50;
		END IF;
        
        IF vally='- 0.60' THEN
            set v_delivery_price=v_delivery_price-0.60;
		END IF;
        
        IF vally='- 0.70' THEN
            set v_delivery_price=v_delivery_price-0.70;
		END IF;
        
        IF vally='- 0.80' THEN
            set v_delivery_price=v_delivery_price-0.80;
		END IF;
        
        IF vally='- 0.90' THEN
            set v_delivery_price=v_delivery_price-0.90;
		END IF;
        
        IF vally='- 1.00' THEN
            set v_delivery_price=v_delivery_price-1.00;
		END IF;
        
        -- estos valores suma el valor total --
        IF vally='+ 0.05' THEN
            set v_delivery_price=v_delivery_price+0.05;
		END IF;
        
        IF vally='+ 0.10' THEN
            set v_delivery_price=v_delivery_price+0.10;
		END IF;
        
        IF vally='+ 0.20' THEN
            set v_delivery_price=v_delivery_price+0.20;
		END IF;
        
        IF vally='+ 0.25' THEN
            set v_delivery_price=v_delivery_price+0.25;
		END IF;
        
        IF vally='+ 0.30' THEN
            set v_delivery_price=v_delivery_price+0.30;
		END IF;
        
        IF vally='+ 0.40' THEN
            set v_delivery_price=v_delivery_price+0.40;
		END IF;
        
        IF vally='+ 0.50' THEN
            set v_delivery_price=v_delivery_price+0.50;
		END IF;
        
        IF vally='+ 0.60' THEN
            set v_delivery_price=v_delivery_price+0.60;
		END IF;
        
        IF vally='+ 0.70' THEN
            set v_delivery_price=v_delivery_price+0.70;
		END IF;
        
        IF vally='+ 0.80' THEN
            set v_delivery_price=v_delivery_price+0.80;
		END IF;
        
        IF vally='+ 0.90' THEN
            set v_delivery_price=v_delivery_price+0.90;
		END IF;
        
        IF vally='+ 1.00' THEN
            set v_delivery_price=v_delivery_price+1.00;
		END IF;
        
		RETURN v_delivery_price;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_get_reason_reject` (`vuser_id` INT, `vid` INT) RETURNS VARCHAR(200) CHARSET latin1 NO SQL BEGIN
	 DECLARE vreason VARCHAR(200);
	 
	 SELECT reason_reject
	 INTO vreason
	 FROM fooddelivery_bookorder
	 WHERE id=vid
	 AND user_id=vuser_id;
	 
	
        
	 	RETURN vreason;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_get_seconds_next_show` (`vorder_id` INT) RETURNS BIGINT(20) NO SQL BEGIN
	 DECLARE v_latency BIGINT DEFAULT 0;
	 DECLARE v_restaurant_id INT;
	 DECLARE v_status INT;
	 DECLARE v_time_minutes INT;
	 DECLARE v_time_start BIGINT;
	 DECLARE v_time_final VARCHAR(50);
	  DECLARE vsecondstmp BIGINT;
	  DECLARE vsecondsinitial BIGINT DEFAULT 480;
	 
    	SELECT fooddelivery_bookorder.status,res_id 
	 INTO v_status,v_restaurant_id
	 FROM fooddelivery_bookorder
	 WHERE id=vorder_id;
	 
	 IF v_status=0  THEN 
	 	 
	 	 -- OBTENER LOS SEGUNDOS DE DIFERENCIA ENTRE LA FECHA DEL PEDIDO Y LA ACTUAL.
	    SELECT ceil(TIMESTAMPDIFF(SECOND, NOW(), created_at))
		 INTO v_time_start
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id; 
		 
		 -- OBTENER LA DIFERENCIA QUE HAY ENTRE EL TIEMPO DEFINIDO DEL RELOJ INVERSO Y EL TIEMPO TRANSCURRIDO
		 
		 SET vsecondstmp=vsecondsinitial -abs(v_time_start);
		 
		  SET vsecondstmp=vsecondstmp + v_latency;
		  
		 IF vsecondstmp>0 THEN 
		     RETURN vsecondstmp;
		 ELSE
		 	RETURN 0;
		 END IF;
		 
	 
	 ELSEIF (v_status=7 OR v_status=6 OR v_status=2 )THEN
	   RETURN 0;		 
	 
	 ELSEIF(v_status=1) THEN
		 
		 -- OBTENER LOS SEGUNDOS DE DIFERENCIA ENTRE LA FECHA DEL PEDIDO Y LA ACTUAL.
	    SELECT ceil(TIMESTAMPDIFF(SECOND, NOW(), accept_date_time)),time_prepare * 60
		 INTO v_time_start,vsecondsinitial
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id; 
		 
		 -- OBTENER LA DIFERENCIA QUE HAY ENTRE EL TIEMPO DEFINIDO DEL RELOJ INVERSO Y EL TIEMPO TRANSCURRIDO
		 
		 SET vsecondstmp=vsecondsinitial -abs(v_time_start);
		 
		 SET vsecondstmp=vsecondstmp + v_latency;
		  
		 IF vsecondstmp>0 THEN 
		     RETURN vsecondstmp;
		 ELSE
		 	RETURN 0;
		 END IF;
		 
		 
	 ELSEIF(v_status=3) THEN
		  -- OBTENER LOS SEGUNDOS DE DIFERENCIA ENTRE LA FECHA DEL PEDIDO Y LA ACTUAL.
	    SELECT ceil(TIMESTAMPDIFF(SECOND, NOW(),picked_date_time)),time_arrive * 60
		 INTO v_time_start,vsecondsinitial
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id; 
		 
		 -- OBTENER LA DIFERENCIA QUE HAY ENTRE EL TIEMPO DEFINIDO DEL RELOJ INVERSO Y EL TIEMPO TRANSCURRIDO
		 
		 SET vsecondstmp=vsecondsinitial -abs(v_time_start);
		 
		 SET vsecondstmp=vsecondstmp + v_latency;
		  
		 IF vsecondstmp>0 THEN 
		     RETURN vsecondstmp;
		 ELSE
		 	RETURN 0;
		 END IF;
		 
	 ELSEIF(v_status=5) THEN
	 
		 -- OBTENER LOS SEGUNDOS DE DIFERENCIA ENTRE LA FECHA DEL PEDIDO Y LA ACTUAL.
	    SELECT ceil(TIMESTAMPDIFF(SECOND, NOW(),assign_date_time))
		 INTO v_time_start
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id; 
		 
		 -- OBTENER LA DIFERENCIA QUE HAY ENTRE EL TIEMPO DEFINIDO DEL RELOJ INVERSO Y EL TIEMPO TRANSCURRIDO
		 
		 SET vsecondstmp=vsecondsinitial -abs(v_time_start);
		 
		  SET vsecondstmp=vsecondstmp + v_latency;
		  
		 IF vsecondstmp>0 THEN 
		     RETURN vsecondstmp;
		 ELSE
		 	RETURN 0;
		 END IF;
		
		 
	 END IF;
    
	RETURN 0;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_get_time_order` (`vorder_id` INT) RETURNS DATETIME NO SQL BEGIN
	 DECLARE v_restaurant_id INT;
	 DECLARE v_status INT;
	 DECLARE v_time_minutes INT;
	 DECLARE v_time_start DATETIME;
	 DECLARE v_time_final VARCHAR(50);
	 DECLARE v_distance DECIMAL(20,2);
	DECLARE v_velocity DECIMAL(20,2);
	DECLARE v_minutes INT;
	DECLARE v_return VARCHAR(50);
	 DECLARE vlat VARCHAR(50);
	  DECLARE vlon VARCHAR(50);
	 
	 SELECT status,res_id ,lat,fooddelivery_bookorder.long
	 INTO v_status,v_restaurant_id,vlat,vlon
	 FROM fooddelivery_bookorder
	 WHERE id=vorder_id;
	 
	 IF(v_status=0 OR v_status=7 OR v_status=6 OR v_status=2 OR v_status=5) THEN
	 -- Get restaurant time
		 SELECT  delivery_time	 
		 INTO v_time_minutes
		 FROM fooddelivery_restaurant
		 WHERE  id=v_restaurant_id;
		 
		 SELECT created_at
		 INTO v_time_start
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id; 
		 
	 
	 ELSEIF(v_status=1) THEN
	 -- Aceptada por restaurante
	 	 SELECT  time_prepare	 
		 INTO v_time_minutes
		 FROM fooddelivery_bookorder
		 WHERE  id=vorder_id;
		 
		 SELECT accept_date_time
		 INTO v_time_start
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id; 
		 
		 
	 ELSEIF(v_status=3) THEN
	 -- picked for deliveryboy
	 	 /*SELECT  time_delivered	 
		 INTO v_time_minutes
		 FROM fooddelivery_bookorder
		 WHERE  id=vorder_id;*/
		 
		 SELECT picked_date_time
		 INTO v_time_start
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id;
	 ELSEIF(v_status=4) THEN
	 -- delivered for deliveryboy
		 SET v_time_minutes=0;
		 
		 SELECT delivered_date_time
		 INTO v_time_start
		 FROM fooddelivery_bookorder
		 WHERE id=vorder_id;
		 
	 ELSE
	  RETURN NULL;
	 END IF;
	 
	 SELECT ( 3959 * ACOS( COS( RADIANS( vlat ) ) * COS( RADIANS( `lat` ) ) *
    COS( RADIANS( `lon` ) - RADIANS( vlon ) ) + SIN( RADIANS( vlat ) ) * SIN( RADIANS( `lat` ) ) ) )
    INTO v_distance
    FROM fooddelivery_restaurant
    WHERE id=v_restaurant_id;
    
   
    
    SELECT value
	 INTO v_velocity
    FROM fooddelivery_settings
    WHERE id='VELOCITY_DELIVERYBOY_AVERAGE_KM_H';
    
    
    
    SET v_minutes= ( (v_distance*2)/v_velocity )*60 ;
    
    
    SET v_minutes= v_time_minutes+ v_minutes;
    
    
    SET v_return=DATE_ADD(v_time_start, INTERVAL v_minutes MINUTE);
    
	RETURN v_return;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_pick_order` (`vdeliverboy_id` INT, `vdelivery_date_time` VARCHAR(50), `vid` INT, `vtime_arrive` VARCHAR(50)) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vactualizado INT;
	 DECLARE vdistance NUMERIC (20,2);
	 
	 SELECT COUNT(*) INTO vactualizado
	 FROM fooddelivery_bookorder
	 WHERE id=vid;
	 
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'Book order dont exists';
    
	END IF;
	
	SELECT restaurant_get_distance(fooddelivery_bookorder.res_id,fooddelivery_bookorder.lat,fooddelivery_bookorder.long)
	INTO vdistance
	FROM fooddelivery_bookorder
	WHERE id=vid;
	
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45055'
 		SET MESSAGE_TEXT = 'Go to Restaurant';
    
	END IF;
	 
	UPDATE fooddelivery_bookorder
	SET is_assigned=vdeliverboy_id,
	STATUS='3',
	picked_date_time=NOW(),
	delivery_date_time=NOW(),
	delivery_status='active',
	picked_status='active' ,
	time_arrive=vtime_arrive
	WHERE id=vid;
	
	
        
	 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_ratting_deliveryboy` (`vuser_id` INT, `vorder_id` INT, `vratting` INT, `vreview_text` TEXT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE vexiste INT;
	 DECLARE v_status INT ;
	 DECLARE v_ratting_before INT;
	 
	 SELECT id,status
	 INTO vexiste,v_status
	 FROM fooddelivery_bookorder
	 WHERE id=vorder_id
	 AND user_id=vuser_id;
	 
	 SELECT COUNT(*)
	 INTO v_ratting_before
	 FROM fooddelivery_reviews_deliveryboys
	 WHERE order_id=vorder_id
	 AND user_id=vuser_id;
	 
	 IF v_ratting_before>0 THEN 
		SIGNAL SQLSTATE '45012'
 		SET MESSAGE_TEXT = 'Orde ratting before';
    
	END IF;
	 
	 IF vexiste IS NULL THEN 
		SIGNAL SQLSTATE '45013'
 		SET MESSAGE_TEXT = 'Ratting no allowed';
    
	END IF;
	
	IF v_status<>4 THEN 
		SIGNAL SQLSTATE '45014'
 		SET MESSAGE_TEXT = 'you have not received the order yet';
    
	END IF;
	 
	INSERT INTO fooddelivery_reviews_deliveryboys (user_id,review_text,ratting,created_at,order_id)
	VALUES (vuser_id,vreview_text,vratting,NOW(),vorder_id);
        
	 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_ratting_getstatus` (`vorder_id` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE vexiste INT;
	 DECLARE v_status INT ;
	 DECLARE v_ratting_before INT;
	 
	 
	 SELECT COUNT(*)
	 INTO v_ratting_before
	 FROM fooddelivery_reviews_deliveryboys
	 WHERE order_id=vorder_id;
	 
	 IF v_ratting_before>0 THEN 
		RETURN 1;
 	ELSE 
    	RETURN 0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_reject_order_restaurant` (`vrestaurant_id` INT, `vreject_date_time` VARCHAR(50), `vid` INT, `vreason_reject` VARCHAR(200)) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vactualizado INT;
	 
	 SELECT COUNT(*) INTO vactualizado
	 FROM fooddelivery_bookorder
	 WHERE id=vid
	 AND res_id=vrestaurant_id;
	 
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'Book order dont exists';
    
	END IF;
	 
	UPDATE fooddelivery_bookorder
	SET STATUS='2',
	reject_date_time=DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'),
	reject_status='active' ,
	reason_reject=vreason_reject
	WHERE id=vid;	
        
	 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `bookorder_verify_remember_order` (`vuser_id` INT, `vorder_id` INT, `vdeliveryboy_id` INT) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_user_id INT;
	DECLARE v_order_id INT;
	DECLARE v_deliveryboy_id INT;
	DECLARE v_status VARCHAR(50);
	
	SELECT  user_id,status,is_assigned
	INTO v_user_id,v_status,v_deliveryboy_id
	FROM fooddelivery_bookorder
	WHERE id=vorder_id;
	
	IF v_order_id IS NULL THEN
			SIGNAL SQLSTATE '45034'
 		   SET MESSAGE_TEXT = 'La orden enviada no existe';
	END IF;
	
	IF v_status<> 3 THEN
			SIGNAL SQLSTATE '45035'
 		   SET MESSAGE_TEXT = 'No le puede recordar al cliente ya que entregó o aún no recibe la orden';
	END IF;
	
	IF vuser_id<> v_user_id THEN
			SIGNAL SQLSTATE '45036'
 		   SET MESSAGE_TEXT = 'El usuario enviado no coincide con el de la orden';
	END IF;
	
	IF vdeliveryboy_id<> v_deliveryboy_id THEN
			SIGNAL SQLSTATE '45037'
 		   SET MESSAGE_TEXT = 'La orden no le ha aisdo asignada';
	END IF;
	
	RETURN 1;
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `deliveryboy_qualify_deliveryboy` (`vorder_id` INT, `vuser_id` INT, `vreview_text` TEXT, `vrattingt` VARCHAR(10)) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vactualizado INT;
	 DECLARE vcalificado INT;
	 
	 SELECT COUNT(*) INTO vactualizado
	 FROM fooddelivery_bookorder
	 WHERE id=vorder_id;
	 
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'order dont exists';
    
	END IF;
	 
	SELECT COUNT(*) INTO vcalificado
	FROM fooddelivery_reviews_deliveryboys
	WHERE user_id=vuser_id
	AND order_id=vorder_id;
	
	IF vcalificado >0 THEN
		SIGNAL SQLSTATE '45003'
 		SET MESSAGE_TEXT = 'review qualify before';
	ELSE
		
		INSERT INTO fooddelivery_reviews_deliveryboys(
		`user_id`, `order_id`, `review_text`, `ratting`, `created_at`)
		VALUES(vuser_id,vorder_id,vreview_text,vrattingt,NOW());
	END IF;
	
	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_change_state` (`vrestaurant_id` INT, `vdelivery_boy_id` INT, `vstatus` BOOLEAN) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vexiste INT;
	 
	 SELECT COUNT(*) INTO vexiste
	 FROM fooddelivery_res_delivery_boy
	 WHERE restaurant_id=vrestaurant_id
	 AND delivery_boy_id=vdelivery_boy_id;
	 
	 IF vexiste=0 THEN 
	 	INSERT INTO fooddelivery_res_delivery_boy(restaurant_id,delivery_boy_id)
	 	VALUES(vrestaurant_id,vdelivery_boy_id);
	 ELSE
	 
	 	UPDATE fooddelivery_res_delivery_boy
		SET status= vstatus
		WHERE restaurant_id=vrestaurant_id
	   AND delivery_boy_id=vdelivery_boy_id;	 
	 
	 END IF;
	 
	 RETURN 1;
	
	 
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_check_delivery_boy_token_version` (`vdelivery_boy_id` INT, `vtoken` VARCHAR(255), `vcode` VARCHAR(50), `voperative_system` VARCHAR(50)) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_version_id  INT ;
	DECLARE v_delivery_boy_id  INT ;
	DECLARE v_tokendata_id  INT ;
	DECLARE v_restaurant_id  INT ;
	DECLARE v_city_radio  DECIMAL(10,0) ;
   DECLARE v_pedidos_pendientes INT;
	-- Verificar la versión de la app
	SELECT id 
	INTO v_version_id
	FROM fooddelivery_versions
	WHERE LOWER(operative_system)=LOWER(voperative_system)
	AND LOWER (code)=LOWER(vcode)
	AND status='active'
	and type='delivery_boy'
	LIMIT 1;
		
	IF v_version_id IS NULL THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Exists a new version of App';
	END IF;	
	-- Fin Verificar la versión de la app
	
	-- Verificar si el usuario se encuentra registrado
	SELECT id 
	INTO v_delivery_boy_id
	FROM fooddelivery_delivery_boy
	WHERE id=vdelivery_boy_id
	LIMIT 1;
		
	IF v_delivery_boy_id IS NULL THEN 
		   SIGNAL SQLSTATE '45005'
 		  SET MESSAGE_TEXT = 'delivery_boy no exists';
	END IF;	
	-- Fin Verificar si el usuario se encuentra registrado
	SET v_delivery_boy_id=NULL;
	-- Verificar si el usuario se encuentra activo
	SELECT id 
	INTO v_delivery_boy_id
	FROM fooddelivery_delivery_boy
	WHERE id=vdelivery_boy_id
	AND status='active'
	LIMIT 1;
		
	IF v_delivery_boy_id IS NULL THEN 
		   SIGNAL SQLSTATE '45002'
 		  SET MESSAGE_TEXT = 'delivery_boy Disabled';
	END IF;	
	-- Fin Verificar si el usuario se encuentra activo
	
	-- Verificar si el token enviado se encuentra activo
	SELECT id 
	INTO v_tokendata_id
	FROM fooddelivery_tokendata
	WHERE delivery_boyid=vdelivery_boy_id
	AND lower(type)=lower(voperative_system)
	AND token=vtoken
	LIMIT 1;
		
	IF v_tokendata_id IS NULL THEN 
		   SIGNAL SQLSTATE '45003'
 		  SET MESSAGE_TEXT = 'Invalida Token';
	END IF;	
	-- Fin Verificar si el token enviado se encuentra activo
	
	SELECT COUNT(*) INTO v_pedidos_pendientes
	FROM fooddelivery_bookorder 
	WHERE is_assigned=vdelivery_boy_id
	AND status IN(1,5,3);
	
	IF v_pedidos_pendientes >0 THEN 
		   SIGNAL SQLSTATE '45006'
 		  SET MESSAGE_TEXT = 'Pending Order';
	END IF;
	
	
	IF payments_verify_expired_deliveryboy(vdelivery_boy_id)>0 THEN
		   SIGNAL SQLSTATE '45007'
 		  SET MESSAGE_TEXT = 'Pending Payment';
	END IF;
	--  verificar que no tenga pedidos pendientes
	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_count_bookorders` (`vusuario_id` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE idretorno INT;
	 
	 SELECT COUNT(*) as orders 
	 INTO idretorno
	 FROM fooddelivery_bookorder
	 WHERE is_assigned= vusuario_id
	 AND is_assigned IS NOT NULL
	 and status IN(1,3,5);
	
	 RETURN idretorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_count_bookorders_today` (`vusuario_id` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE idretorno INT;
	 
	 SELECT COUNT(*) as orders 
	 INTO idretorno
	 FROM fooddelivery_bookorder
	 WHERE is_assigned= vusuario_id
	 AND DATE_FORMAT(FROM_UNIXTIME(created_at), '%Y-%m-%d')=CURRENT_DATE
	 AND is_assigned IS NOT NULL;
	
	 RETURN idretorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_get_free_to_asigned` () RETURNS INT(11) NO SQL BEGIN
	 DECLARE idretorno INT;
	 DECLARE pedidos INT;
	 
	 SELECT id, delivery_boy_count_bookorders_today(id) as orders 
	 INTO idretorno,pedidos
	 FROM fooddelivery_delivery_boy 
	 WHERE attendance='yes' 
	 AND id NOT IN(SELECT DISTINCT is_assigned FROM fooddelivery_bookorder where status IN(5,3) )
	 ORDER BY orders ASC
	 LIMIT 1 ;
	
	 RETURN idretorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_get_presence` (`vdeliveryboy_id` INT) RETURNS VARCHAR(50) CHARSET latin1 DETERMINISTIC NO SQL BEGIN
	DECLARE v_attendance VARCHAR(50);
	
	SELECT attendance
	INTO v_attendance
	FROM fooddelivery_delivery_boy
	WHERE id=vdeliveryboy_id;
	
	IF v_attendance IS NULL  THEN 
		SET v_attendance='no';
	END IF;
	 
	RETURN v_attendance;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_presence` (`vdeliveryboy_id` INT, `vattendance` VARCHAR(10)) RETURNS INT(11) NO SQL BEGIN

	UPDATE fooddelivery_delivery_boy
	SET attendance=vattendance
	WHERE id=vdeliveryboy_id;
	
	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_session` (`vdeliveryboy_id` INT, `vsession` VARCHAR(10)) RETURNS INT(11) NO SQL BEGIN

	UPDATE fooddelivery_delivery_boy
	SET session=vsession
	WHERE id=vdeliveryboy_id;
	
	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `delivery_boy_verify_state_in_restaurant` (`vrestaurant_id` INT, `vdelivery_boy_id` INT) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vexiste INT;
	 
	 SELECT COUNT(*) INTO vexiste
	 FROM fooddelivery_res_delivery_boy
	 WHERE restaurant_id=vrestaurant_id
	 AND delivery_boy_id=vdelivery_boy_id
	 AND status;
	 
	 IF vexiste=0 THEN 
	 	 RETURN 0;
	 ELSE
	 
	 	RETURN 1;
	 
	 END IF; 
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `parcel_assign_order` (`vdeliverboy_id` INT, `vassign_date_time` VARCHAR(50), `vid` INT) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vactualizado INT;
	 
	 SELECT COUNT(*) INTO vactualizado
	 FROM fooddelivery_bookorder
	 WHERE id=vid;
	 
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'Book order dont exists';
    
	END IF;
	 
	IF  payments_verify_expired_deliveryboy(vdeliverboy_id)>0 THEN
		SIGNAL SQLSTATE '45010'
 		SET MESSAGE_TEXT = 'Pending Payment';
	END IF;
	
	UPDATE fooddelivery_bookorder
	SET is_assigned=vdeliverboy_id,
	status='5',
	timestamp_assign=now(),
	assign_date_time=NOW(),
	assign_status='active' 
	WHERE id=vid;
	
		UPDATE fooddelivery_bookorder
	SET STATUS='1',
	accept_date_time=NOW(),
	accept_status='active' 
	WHERE id=vid;	
	
        
	 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_complete_payment` (`vid` BIGINT) RETURNS INT(11)  BEGIN
   DECLARE v_status VARCHAR(50);

    SELECT fooddelivery_payments.status INTO
	 v_status 
	 FROM fooddelivery_payments
	 WHERE id=vid;
	 
	 IF v_status IS NULL THEN 
	 	RETURN -1;
	 END IF;
	 
	 IF v_status='completed' THEN 
	 	RETURN -2;
	 END IF;
	 
	 UPDATE fooddelivery_payments
	 SET  status='completed',
	 payment_date=now()
	 where id=vid;
	 
	 RETURN 1;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_countrecordslist` (`vsearch` VARCHAR(200)) RETURNS INT(11)  BEGIN
DECLARE retorno INT;
IF vsearch='' THEN
	SELECT COUNT(*) INTO retorno
    FROM fooddelivery_payments,fooddelivery_delivery_boy
	 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
	 and fooddelivery_payments.`type`='deliveryboy';
ELSE
	SELECT COUNT(*) INTO retorno
	FROM fooddelivery_payments,fooddelivery_delivery_boy
	 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
    AND  (fooddelivery_delivery_boy.name  LIKE concat('%',upper(vsearch),'%') )
     and fooddelivery_payments.`type`='deliveryboy';
END IF;
RETURN retorno;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_countrecordslistfilter` (`vsearch` VARCHAR(200), `vstatus` VARCHAR(50)) RETURNS INT(11)  BEGIN
DECLARE retorno INT;
IF vsearch='' THEN
	SELECT COUNT(*) INTO retorno
    FROM fooddelivery_payments,fooddelivery_delivery_boy
	 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
	 and fooddelivery_payments.`type`='deliveryboy'
	 and fooddelivery_payments.status=vstatus;
ELSE
	SELECT COUNT(*) INTO retorno
	FROM fooddelivery_payments,fooddelivery_delivery_boy
	 WHERE fooddelivery_payments.deliveryboy_id=fooddelivery_delivery_boy.id
    AND  (fooddelivery_delivery_boy.name  LIKE concat('%',upper(vsearch),'%') )
     and fooddelivery_payments.`type`='deliveryboy'
     and fooddelivery_payments.status=vstatus;
END IF;
RETURN retorno;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_count_bookorders_deliveryboy` (`vpayment_id` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE idretorno INT;
	 
	 SELECT COUNT(*) as orders 
	 INTO idretorno
	 FROM fooddelivery_bookorder
	 WHERE status IN(2,4,7)
	 
	 AND id IN(SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id =(SELECT id FROM fooddelivery_payments WHERE id=vpayment_id AND type='deliveryboy'));
	
	 RETURN idretorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_count_bookorders_restaurant` (`vpayment_id` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE idretorno INT;
	 
	 SELECT COUNT(*) as orders 
	 INTO idretorno
	 FROM fooddelivery_bookorder
	 WHERE status IN(2,4,7,3)
	 
	 AND id IN(SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id =(SELECT id FROM fooddelivery_payments WHERE id=vpayment_id AND type='restaurant'));
	
	 RETURN idretorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_create_payments_deliveryboys` () RETURNS TINYINT(1) NO SQL BEGIN
	DECLARE vpayment_group INT;
	DECLARE vpayment_id INT;
	DECLARE fecha_hora_actual datetime DEFAULT NOW();
	DECLARE vcurrent_deliveryboy_id INT;
	DECLARE v_limitdays INT;  
	DECLARE findelbucle INTEGER DEFAULT 0; 
  	DECLARE cursor_deliveryboys CURSOR FOR 
   
/* Estos son los muchachos del deliery, los empleados*/

  SELECT id FROM fooddelivery_delivery_boy ; 
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET findelbucle=1;  

/* este es el seteo en dias para los pagos default 365*/
  SELECT value INTO v_limitdays
	 FROM fooddelivery_settings
	 WHERE id='LIMIT_DAYS_BILL_DELIVERYBOY';

/*Selecciona el valor maximo payment_group en la tabla fooddelivery_payments
es la tabla qe buscamos 
*/
  
		SELECT MAX(payment_group) 
		INTO vpayment_group
		FROM fooddelivery_payments;

  	IF vpayment_group IS NULL THEN 
			SET vpayment_group=1;
	ELSE
/*  aqui aumenta en uno el vpayment_group*/
			SET vpayment_group=vpayment_group+1;
	END IF;
  
 
/* abrimos los ID con los chicos dl delivery almacenamos el ID en vcurrent_deliveryboy_id*/
  OPEN cursor_deliveryboys;
  bucle: LOOP
    FETCH cursor_deliveryboys INTO vcurrent_deliveryboy_id;
    IF findelbucle = 1 THEN
       LEAVE bucle;
    END IF;
 
  		SELECT MAX(id) 
		INTO vpayment_id
		FROM fooddelivery_payments;
		
		
		IF vpayment_id IS NULL THEN 
			SET vpayment_id=1;
		ELSE
			SET vpayment_id=vpayment_id+1;
		END IF;
				
		
INSERT fooddelivery_payments(id,create_date,payment_date,
		max_payment_date,status,description,type,restaurant_id,
		deliveryboy_id,percentage,base ,payment_group ,amount,comision,base_use_aplication)
		VALUES(vpayment_id,fecha_hora_actual,null,date_add(CURDATE(),interval 24*60*60 - 1 second) + INTERVAL 1 DAY,'pending','Pago','deliveryboy',null,vcurrent_deliveryboy_id,25,0,vpayment_group,
		payment_create_detail_payment_deliveryboy(vpayment_id,vcurrent_deliveryboy_id),	payment_get_comision_use_aplication(vpayment_id),
		payment_get_base_use_aplication(vpayment_id)
	);

 	/*UPDATE fooddelivery_payments
	set status='completed',
	payment_date=now()
	WHERE amount<=0;*/
    
  	DELETE FROM fooddelivery_payments 
    WHERE amount<=0 AND comision<=0;
		
  END LOOP bucle;
 
  CLOSE cursor_deliveryboys;
	
	 	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_get_amount_bookorder_deliveryboy` (`vbookorder_id` INT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	 DECLARE retorno DECIMAL(20,2);
	 
	 SELECT SUM(amount) INTO retorno
	 FROM fooddelivery_payment_details 
	 WHERE bookorder_id=vbookorder_id
	 AND payment_id IN(SELECT id FROM fooddelivery_payments  WHERE type='deliveryboy');
	 
	 IF retorno IS NULL THEN
	 	SET retorno=0;
	 END IF;
	
	 RETURN retorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_get_amount_bookorder_restaurant` (`vbookorder_id` INT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	 DECLARE retorno DECIMAL(20,2);
	 
	 SELECT SUM(amount) INTO retorno
	 FROM fooddelivery_payment_details 
	 WHERE bookorder_id=vbookorder_id
	 AND payment_id IN(SELECT id FROM fooddelivery_payments  WHERE type='restaurant');
	 
	 IF retorno IS NULL THEN
	 	SET retorno=0;
	 END IF;
	
	 RETURN retorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_get_base_bookorder_deliveryboy` (`vbookorder_id` INT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	 DECLARE retorno DECIMAL(20,2);
	 
	 SELECT SUM(base_use_aplication) INTO retorno
	 FROM fooddelivery_payment_details 
	 WHERE bookorder_id=vbookorder_id
	 AND payment_id IN(SELECT id FROM fooddelivery_payments  WHERE type='deliveryboy');
	 
	 IF retorno IS NULL THEN
	 	SET retorno=0;
	 END IF;
	
	 RETURN retorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_get_comision_bookorder_deliveryboy` (`vbookorder_id` INT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	 DECLARE retorno DECIMAL(20,2);
	 
	 SELECT SUM(comision) INTO retorno
	 FROM fooddelivery_payment_details 
	 WHERE bookorder_id=vbookorder_id
	 AND payment_id IN(SELECT id FROM fooddelivery_payments  WHERE type='deliveryboy');
	 
	 IF retorno IS NULL THEN
	 	SET retorno=0;
	 END IF;
	
	 RETURN retorno;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_get_seconds_max_date_payment` (`vpayment_id` INT) RETURNS BIGINT(20) NO SQL BEGIN
	  DECLARE v_time_start BIGINT;
	  
	    SELECT ceil(TIMESTAMPDIFF(SECOND,NOW(), max_payment_date))
		 INTO v_time_start
		 FROM fooddelivery_payments
		 WHERE id=vpayment_id; 
		 
		 IF v_time_start>0 THEN 
		     RETURN v_time_start;
		 ELSE
		 	RETURN 0;
		 END IF;
		
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_verify_bookorder_exist` (`vbookorder_id` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE v_pendientes INT;
	 
	 SELECT COUNT(*) 
	 INTO  v_pendientes
	 FROM fooddelivery_payment_details
	 WHERE fooddelivery_payment_details.bookorder_id=vbookorder_id;
	
	 IF v_pendientes=0 THEN
	 	RETURN 0;
	 ELSE
	 	RETURN 1;
	 END IF;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payments_verify_expired_deliveryboy` (`vdeliveryboy_id` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE v_pendientes INT;
	 
	 SELECT COUNT(*) 
	 INTO  v_pendientes
	 FROM fooddelivery_payments 
	 WHERE deliveryboy_id=vdeliveryboy_id
	 AND type='deliveryboy'
	 AND STATUS='pending'
	 AND max_payment_date<now();
	
	 IF v_pendientes=0 THEN
	 	RETURN 0;
	 ELSE
	 	RETURN 1;
	 END IF;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payment_create_detail_payment_deliveryboy` (`vpayment_id` BIGINT, `vdeliveryboy_id` INT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	DECLARE vvaluepercentagecomision DECIMAL(25,3);
	DECLARE vbase_use_aplication DECIMAL(25,3);
	DECLARE vtotalamount DECIMAL(25,3);
	
	 SELECT value INTO vvaluepercentagecomision
	 FROM fooddelivery_settings
	 WHERE id='PERCENTAGE_COMISION_DELIVERYBOY';
	 
	 SELECT value INTO vbase_use_aplication
	 FROM fooddelivery_settings
	 WHERE id='BASE_USE_APLICATION_DELIVERY_BOY';
	 
	INSERT INTO fooddelivery_payment_details(payment_id,bookorder_id,comision,base_use_aplication,amount)
	SELECT  vpayment_id,fooddelivery_bookorder.id,
	(CAST((((delivery_price-vbase_use_aplication ) / 100)*vvaluepercentagecomision ) as decimal(25,3)) )	
	,vbase_use_aplication,(( CAST((((delivery_price-vbase_use_aplication ) / 100)*vvaluepercentagecomision ) as decimal(25,3))) +vbase_use_aplication)
	FROM fooddelivery_bookorder
	WHERE fooddelivery_bookorder.is_assigned=vdeliveryboy_id 
	AND fooddelivery_bookorder.id NOT IN (SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id IN 
	(SELECT id FROM fooddelivery_payments WHERE deliveryboy_id=vdeliveryboy_id))
	AND status=4
    AND DATE(created_at)>DATE(NOW()) - INTERVAL 9 DAY
	GROUP BY fooddelivery_bookorder.id;
	
	/*INSERT INTO fooddelivery_payment_details(payment_id,amount,base_use_aplication,comision,bookorder_id)
	SELECT  vpayment_id,0,0 ,0,fooddelivery_bookorder.id
	FROM fooddelivery_bookorder
	WHERE fooddelivery_bookorder.is_assigned=vdeliveryboy_id 
	AND fooddelivery_bookorder.id NOT IN (SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id IN 
	(SELECT id FROM fooddelivery_payments WHERE deliveryboy_id=vdeliveryboy_id))
	AND status IN(2,7)
	GROUP BY  fooddelivery_bookorder.id;*/
	
	SELECT SUM(amount) INTO vtotalamount
	FROM fooddelivery_payment_details
	WHERE payment_id=vpayment_id;
    
    DELETE FROM fooddelivery_payment_details 
    WHERE amount<=0 AND comision<=0;
	
	IF vtotalamount IS NULL THEN
		SET vtotalamount=0;
	END IF;
        
	RETURN vtotalamount;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payment_create_detail_payment_restaurant` (`vpayment_id` BIGINT, `vrestaurant_id` INT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	DECLARE vvaluepercentagecomision DECIMAL(20,2);
	DECLARE vtotalamount DECIMAL(20,2);
	
	 SELECT value INTO vvaluepercentagecomision
	 FROM fooddelivery_settings
	 WHERE id='PERCENTAGE_COMISION_RESTAURANT';
	 
	INSERT INTO fooddelivery_payment_details(payment_id,amount,bookorder_id)
	SELECT  vpayment_id,cast(((total_price / 100)*vvaluepercentagecomision ) as decimal(20,2)) AS amount,fooddelivery_bookorder.id
	FROM fooddelivery_bookorder
	WHERE fooddelivery_bookorder.res_id=vrestaurant_id
	AND fooddelivery_bookorder.id NOT IN (SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id IN (SELECT id FROM fooddelivery_payments WHERE restaurant_id=vrestaurant_id))
	AND status IN(3,4)
	GROUP BY  fooddelivery_bookorder.id;
	
	INSERT INTO fooddelivery_payment_details(payment_id,amount,bookorder_id)
	SELECT  vpayment_id,0 AS amount,fooddelivery_bookorder.id
	FROM fooddelivery_bookorder
	WHERE fooddelivery_bookorder.res_id=vrestaurant_id
	AND fooddelivery_bookorder.id NOT IN (SELECT bookorder_id FROM fooddelivery_payment_details WHERE payment_id IN (SELECT id FROM fooddelivery_payments WHERE restaurant_id=vrestaurant_id))
	AND status IN(2,7)
	GROUP BY  fooddelivery_bookorder.id;
	
	SELECT SUM(amount) INTO vtotalamount
	FROM fooddelivery_payment_details
	WHERE payment_id=vpayment_id;
	
	IF vtotalamount IS NULL THEN
		SET vtotalamount=0;
	END IF;
        
	RETURN vtotalamount;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payment_get_base_use_aplication` (`vpayment_id` BIGINT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	DECLARE vtotalbase DECIMAL(20,2);
	
	SELECT SUM(base_use_aplication) INTO vtotalbase
	FROM fooddelivery_payment_details
	WHERE payment_id=vpayment_id;
	
	IF vtotalbase IS NULL THEN
		SET vtotalbase=0;
	END IF;
        
	RETURN vtotalbase;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `payment_get_comision_use_aplication` (`vpayment_id` BIGINT) RETURNS DECIMAL(20,2) NO SQL BEGIN
	DECLARE vtotalbase DECIMAL(20,2);
	
	SELECT SUM(comision) INTO vtotalbase
	FROM fooddelivery_payment_details
	WHERE payment_id=vpayment_id;
	
	IF vtotalbase IS NULL THEN
		SET vtotalbase=0;
	END IF;
        
	RETURN vtotalbase;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_check_restaurant_owner_token_version` (`vrestaurant_ownerid` INT, `vtoken` VARCHAR(255), `vcode` VARCHAR(50), `voperative_system` VARCHAR(50)) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_version_id  INT ;
	DECLARE v_restaurant_ownerid  INT ;
	DECLARE v_tokendata_id  INT ;
	DECLARE v_restaurant_id  INT ;
		DECLARE v_restaurant_idr  INT ;
	DECLARE v_restaurant_is_active  int ;
	DECLARE v_city_radio  DECIMAL(10,0) ;
   DECLARE v_pedidos_pendientes INT;
	-- Verificar la versión de la app
	SELECT id 
	INTO v_version_id
	FROM fooddelivery_versions
	WHERE LOWER(operative_system)=LOWER(voperative_system)
	AND LOWER (code)=LOWER(vcode)
	AND status='active'
	and type='restaurant'
	LIMIT 1;
		
	IF v_version_id IS NULL THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Exists a new version of App';
	END IF;	
	-- Fin Verificar la versión de la app
	
	-- Verificar si el usuario se encuentra registrado
	SELECT id 
	INTO v_restaurant_ownerid
	FROM fooddelivery_res_owner
	WHERE id=vrestaurant_ownerid
	LIMIT 1;
			
	IF v_restaurant_ownerid IS NULL THEN 
		   SIGNAL SQLSTATE '45002'
 		  SET MESSAGE_TEXT = 'restaurant owner no exists';
	END IF;	
	-- Fin Verificar si el usuario se encuentra registrado	
	
	SET v_restaurant_ownerid=NULL;
	-- Verificar si el usuario se encuentra activo
	SELECT res_id 
	INTO v_restaurant_ownerid
	FROM fooddelivery_res_owner
	WHERE id=vrestaurant_ownerid
	AND status='active'
	LIMIT 1;
		
	IF v_restaurant_ownerid IS NULL THEN 
		   SIGNAL SQLSTATE '45003'
 		  SET MESSAGE_TEXT = 'restaurant owner not active';
	END IF;	
	-- Fin Verificar si el usuario se encuentra activo
	
	-- Verificar si el restaurante existe
	SELECT res_id 
	INTO v_restaurant_id
	FROM fooddelivery_res_owner
	WHERE id=vrestaurant_ownerid
	LIMIT 1;
	
	IF v_restaurant_id IS NULL THEN 
		   SIGNAL SQLSTATE '45004'
 		  SET MESSAGE_TEXT = 'restaurant no exists';
	END IF;	
	-- Fin Verificar si el restaurante existe
	-- Verificar si el restaurante está activo
	SELECT id 
	INTO v_restaurant_idr
	FROM fooddelivery_restaurant
	WHERE id=v_restaurant_id
	AND is_active=0
	LIMIT 1;
	
	IF v_restaurant_idr IS NULL THEN 
		   SIGNAL SQLSTATE '45005'
 		  SET MESSAGE_TEXT = 'restaurant is not active';
	END IF;	
	-- Fin Verificar si el restaurante está activo
	
	-- Verificar si el token enviado se encuentra activo
	SELECT id 
	INTO v_tokendata_id
	FROM fooddelivery_tokendata
	WHERE restaurant_ownerid=vrestaurant_ownerid
	AND lower(type)=lower(voperative_system)
	AND token=vtoken
	LIMIT 1;
		
	IF v_tokendata_id IS NULL THEN 
		   SIGNAL SQLSTATE '45006'
 		  SET MESSAGE_TEXT = 'Invalida Token';
	END IF;	
	-- Fin Verificar si el token enviado se encuentra activo
	
	SELECT COUNT(*) INTO v_pedidos_pendientes
	FROM fooddelivery_bookorder 
	WHERE res_id =v_restaurant_idr
	AND status IN(1);
	
	IF v_pedidos_pendientes >0 THEN 
		   SIGNAL SQLSTATE '45007'
 		  SET MESSAGE_TEXT = 'Pending Order';
	END IF;
	
	IF false THEN
	-- IF payments_verify_expired_deliveryboy(vrestaurant_ownerid)>0 THEN
		   SIGNAL SQLSTATE '45008'
 	  SET MESSAGE_TEXT = 'Pending Payment';
	 END IF;
	--  verificar que no tenga pedidos pendientes
	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_create_menu` (`vrestaurant_id` INT, `vname` VARCHAR(100)) RETURNS INT(11) NO SQL BEGIN
	 DECLARE idretorno INT;
	 
	 INSERT INTO fooddelivery_menu(res_id,NAME,created_at)
	 VALUES(vrestaurant_id,vname,UNIX_TIMESTAMP());
	
	 RETURN 1;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_create_restaurant` (`vname` VARCHAR(200), `vdni` VARCHAR(15), `vcity_id` VARCHAR(11), `vtype_store` VARCHAR(50), `vaddress` VARCHAR(500), `vdesc` TEXT, `vemail` VARCHAR(150), `vphone` VARCHAR(50), `vwebsite` VARCHAR(200), `vdelivery_time` VARCHAR(50), `vopen_time` VARCHAR(50), `vclose_time` VARCHAR(50), `vcommission` VARCHAR(10), `vstore_owner` VARCHAR(100), `vcity` VARCHAR(50), `vlocation` VARCHAR(300), `vlat` VARCHAR(50), `vlon` VARCHAR(50), `vphoto` VARCHAR(100), `vcurrency` VARCHAR(50), `vdel_charge` VARCHAR(50), `vally` VARCHAR(50), `vmonday` VARCHAR(50), `vtuesday` VARCHAR(50), `vwednesday` VARCHAR(50), `vthursday` VARCHAR(50), `vfriday` VARCHAR(50), `vsaturday` VARCHAR(50), `vsunday` VARCHAR(50), `vusernameowner` VARCHAR(50), `vpasswordowner` VARCHAR(50), `phoneowner` VARCHAR(50), `vemailowner` VARCHAR(150), `vroleowner` VARCHAR(50), `vtimestampowner` VARCHAR(50)) RETURNS VARCHAR(15) CHARSET utf8 NO SQL BEGIN
	 DECLARE verifica int;
	 DECLARE vidnext int;
	 -- Verificar que no exista como admin con respecto al email	 
	 select count(*) 
	 into verifica
	 from fooddelivery_adminlogin
	 where lower(fooddelivery_adminlogin.email)=lower(vemailowner);
	 
	 if verifica>0 then
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Existe un administrador del sistema con el email enviado';
	 end if;
	 set verifica=0;
	 
	 	 
-- Verificar que no exista como owner con respecto al email 
	 select count(*) 
	 into verifica
	 from fooddelivery_res_owner
	 where lower(fooddelivery_res_owner.email)=lower(vemailowner);
	 
	 if verifica>0 then
			SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Existe un administrador de restaurante con el codigo enviado';
	 end if;
	 
	 
-- Coger el maximo id del restaurante y sumarle 1, en caso
	 select max(fooddelivery_restaurant.id) 
	 into vidnext
	 from fooddelivery_restaurant;
	 
 -- que sea nulo setearlo a 1
  IF vidnext IS NULL THEN 
		SET vidnext=1;
	ELSE
			SET vidnext=vidnext+1;	
	END IF;	
	   set verifica=0;
	 -- Verificar que no exista el mail del restaurante con respecto al email enviado
	 select count(*) 
	 into verifica
	 from fooddelivery_restaurant
	 where lower(fooddelivery_restaurant.email)=lower(vemailowner);
	 
	 
 -- que sea nulo setearlo a 1
  IF vidnext IS NULL THEN 
		SET vidnext=1;
	ELSE
			SET vidnext=vidnext+1;	
	END IF;	

	 
INSERT INTO fooddelivery_restaurant(id,fooddelivery_restaurant.name,dni,city_id,type_store,address,open_time,close_time,delivery_time,commission,store_owner,
fooddelivery_restaurant.timestamp,currency,photo,phone,fooddelivery_restaurant.lat,fooddelivery_restaurant.lon,fooddelivery_restaurant.desc,email,website,city,location,
del_charge,ally,monday,tuesday,wednesday,thursday,friday,saturday,sunday)
 VALUES (vidnext,vname,vdni,vcity_id,vtype_store,vaddress,vopen_time,vclose_time,vdelivery_time,vcommission,vstore_owner,vtimestampowner,
 vcurrency,vphoto,vphone,vlat,vlon,vdesc,vemail,vwebsite,vcity,vlocation,vdel_charge,
 vally,vmonday,vtuesday,vwednesday,vthursday,vfriday,vsaturday,vsunday);
 
 
INSERT INTO fooddelivery_res_owner(username,fooddelivery_res_owner.password,phone,email,role,res_id,fooddelivery_res_owner.timestamp)
 VALUES (vusernameowner,vpasswordowner,phoneowner,vemailowner,vroleowner,vidnext,vtimestampowner);
											 
 return vidnext;
 end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_get_distance` (`vrestaurant_id` BIGINT, `vlat` VARCHAR(50), `vlon` VARCHAR(50)) RETURNS DECIMAL(20,1) NO SQL BEGIN
	DECLARE v_restaurant_lat VARCHAR(50);
	DECLARE v_restaurant_lon VARCHAR(50);
	DECLARE v_km DECIMAL(40,1);
	DECLARE v_distance DECIMAL(40,20);
	
	SELECT fooddelivery_restaurant.lat,fooddelivery_restaurant.lon
	INTO v_restaurant_lat,v_restaurant_lon
	FROM fooddelivery_restaurant
	WHERE id=vrestaurant_id;
	
		SET v_distance= 1.609344 *( 3959 * ACOS( COS( RADIANS( vlat ) ) * COS( RADIANS( v_restaurant_lat ) ) *COS( RADIANS( v_restaurant_lon )
		 - RADIANS( vlon ) ) + SIN( RADIANS( vlat ) ) * SIN( RADIANS( v_restaurant_lat ) ) ) ) ;
		
		IF v_distance<=1 THEN
			SET v_km=(v_distance * 1.50) ;
		ELSE
			SET v_km=(v_distance * 2) -1;
		END IF;
		
			
	    RETURN v_km;
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_get_name` (`vid` INT) RETURNS VARCHAR(500) CHARSET latin1 NO SQL BEGIN
	 DECLARE v_name VARCHAR(500);
	 
	 SELECT name INTO v_name
	 FROM fooddelivery_restaurant
	 WHERE id=vid;
	 
	 RETURN v_name;
	 
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_get_normal_orders_pending` (`vid` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE vpendings int;
	 
	 SELECT COUNT(*) INTO vpendings
	 FROM 	 fooddelivery_bookorder 
	 WHERE status=5 and 
	 user_id<>-1
	 AND res_id=vid;
	 
	 if vpendings>1 then
	  set vpendings=1;
	 end if;
	 
	 RETURN vpendings;
	 
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_get_ratting` (`vid` INT) RETURNS INT(11) NO SQL BEGIN
	 DECLARE vratting INT;
	 
	 SELECT AVG(ratting) AS ratavg
	 INTO  vratting
	 FROM fooddelivery_reviews
	 WHERE res_id=vid;
	 
	 IF vratting IS NULL THEN 
	 	SET vratting=0;
	 END IF;
	 
	 SET vratting=ROUND(vratting);
	 
	 RETURN vratting;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_owner_get_presence` (`vrestaurant_ownerid` INT) RETURNS VARCHAR(50) CHARSET latin1 DETERMINISTIC NO SQL BEGIN
	DECLARE v_attendance VARCHAR(50);
	
	SELECT enable
	INTO v_attendance
	FROM fooddelivery_restaurant
	WHERE id IN(select res_id FROM fooddelivery_res_owner WHERE id=vrestaurant_ownerid);
	
	IF v_attendance IS NULL  THEN 
		SET v_attendance='0';
	END IF;
	 
	RETURN v_attendance;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_owner_presence` (`vrestaurant_ownerid` INT, `vattendance` VARCHAR(10)) RETURNS INT(11) NO SQL BEGIN

	UPDATE fooddelivery_restaurant  SET  
	enable=vattendance  
	WHERE id IN(select res_id FROM fooddelivery_res_owner WHERE id=vrestaurant_ownerid);
	
	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_qualify_restaurant` (`vrestaurant_id` INT, `vuser_id` INT, `vreview_text` VARCHAR(350) CHARSET utf8mb4, `vrattingt` VARCHAR(10)) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vactualizado INT;
	 DECLARE vcalificado INT;
	 
	 SELECT COUNT(*) INTO vactualizado
	 FROM fooddelivery_restaurant
	 WHERE id=vrestaurant_id;
	 
	 IF vactualizado=0 THEN 
		SIGNAL SQLSTATE '45002'
 		SET MESSAGE_TEXT = 'Restaurante dont exists';
    
	END IF;
	 
	SELECT COUNT(*) INTO vcalificado
	FROM fooddelivery_reviews
	WHERE user_id=vuser_id
	AND res_id=vrestaurant_id;
	
	IF vcalificado >0 THEN
			UPDATE fooddelivery_reviews
			SET `review_text`=vreview_text,
			`ratting`=vrattingt,
			created_at=UNIX_TIMESTAMP()
			WHERE user_id=vuser_id
			AND res_id=vrestaurant_id;
	ELSE
		
		INSERT INTO fooddelivery_reviews(
		`user_id`,	`res_id` ,	`review_text`,`ratting`,
		`created_at`)
		VALUES(vuser_id,vrestaurant_id,vreview_text,vrattingt,UNIX_TIMESTAMP());
	END IF;
	
	
	RETURN 1;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_restaurant_get_presence` (`vrestaurant_id` INT) RETURNS VARCHAR(50) CHARSET latin1 DETERMINISTIC NO SQL BEGIN
	DECLARE v_attendance VARCHAR(50);
		 DECLARE vmonday VARCHAR(50);
	 DECLARE vtuesday VARCHAR(50);
	 DECLARE vwednesday VARCHAR(50);
	 DECLARE vthursday VARCHAR(50);
	 DECLARE vfriday VARCHAR(50);
	 DECLARE vsaturday VARCHAR(50);
	 DECLARE vsunday VARCHAR(50);
	 DECLARE vdiaactual INT;
	
	SELECT enable,	`monday`,`tuesday`,`wednesday`,`thursday`,`friday`,`saturday` ,`sunday`,
	 DAYOFWEEK(CURRENT_DATE)
	INTO v_attendance,vmonday,vtuesday,vwednesday,vthursday,vfriday,vsaturday ,vsunday,
	 vdiaactual
	FROM fooddelivery_restaurant
	WHERE id =vrestaurant_id;
	
	 IF vdiaactual=1 AND vsunday<>'YES' THEN 
	 	return 0;
	 ELSEIF vdiaactual=2 AND vmonday<>'YES' THEN
	 	return 0;
	 ELSEIF vdiaactual=3 AND vtuesday<>'YES' THEN
	 	return 0;
	 ELSEIF vdiaactual=4 AND vwednesday<>'YES' THEN
		 	return 0;
	 ELSEIF vdiaactual=5 AND vthursday<>'YES' THEN
		 	return 0;
	 ELSEIF vdiaactual=6 AND vfriday<>'YES' THEN
	 	return 0;
	 ELSEIF vdiaactual=7 AND vsaturday<>'YES' THEN
	 	return 0;
	 END IF;
	 
	IF v_attendance IS NULL  THEN 
		SET v_attendance='0';
	END IF;
	 
	RETURN v_attendance;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_update_menu` (`vid` INT, `vrestaurant_id` INT, `vname` VARCHAR(100)) RETURNS INT(11) NO SQL BEGIN
	 DECLARE idretorno INT;
	 
	 UPDATE fooddelivery_menu
	 SET res_id=vrestaurant_id,
	 name=vname
	 WHERE id=vid;
	
	 RETURN 1;
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_verify_open` (`vrestaurant_id` INT) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vexiste INT;
	 DECLARE v_open_time TIME;
	 DECLARE v_close_time TIME;
	 DECLARE v_enable TINYINT(1);
	 
	 SELECT open_time,close_time,fooddelivery_restaurant.enable
	 INTO v_open_time,v_close_time,v_enable
	 FROM  fooddelivery_restaurant	 
	 WHERE id=vrestaurant_id;
	 
	 IF v_enable<>1 THEN 
	 	RETURN 0;
	 ELSE
	 
	 	 IF v_close_time>v_open_time THEN 
		 	 SELECT COUNT(*) INTO  vexiste
			 FROM  fooddelivery_restaurant	 
			 WHERE id=vrestaurant_id
			 AND CURRENT_TIME >=  cast(open_time as time)
			 AND CURRENT_TIME <= cast(close_time as time)
			 AND enable=1 ;
			 
			 IF vexiste=0 THEN 
			 	RETURN 0;
			 ELSE
			 
			 	RETURN 1;	 
			 
			 END IF;
		 ELSE
		 
		 	SELECT COUNT(*) INTO  vexiste
			 FROM  fooddelivery_restaurant	 
			 WHERE id=vrestaurant_id
			 AND now() >=  concat(CURRENT_DATE,' ' ,open_time)
			 AND now() <=  DATE_ADD(concat(CURRENT_DATE,' ' ,close_time), INTERVAL 1 DAY)
			 AND enable=1 ;
			 
			 IF vexiste=0 THEN 
			 	RETURN 0;
			 ELSE
			 
			 	RETURN 1;	 
			 
			 END IF;	 
		 
		 END IF;
		  
		 
		 IF vexiste=0 THEN 
		 	RETURN 0;
		 ELSE
		 
		 	RETURN 1;	 
		 
		 END IF;
		 	 	 
	 
	 END IF;
	 
	 
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `restaurant_verify_open_noenable` (`vrestaurant_id` INT) RETURNS TINYINT(1) NO SQL BEGIN
	 DECLARE vexiste INT;
	 DECLARE v_open_time TIME;
	 DECLARE v_close_time TIME;
	 
	 SELECT open_time,close_time
	 INTO v_open_time,v_close_time
	 FROM  fooddelivery_restaurant	 
	 WHERE id=vrestaurant_id;
	 
	
		 	 SELECT COUNT(*) INTO  vexiste
			 FROM  fooddelivery_restaurant	 
			 WHERE id=vrestaurant_id
			 AND CURRENT_TIME >=  cast(open_time as time)
			 AND CURRENT_TIME <= cast(close_time as TIME);
			 
			 IF vexiste=0 THEN 
			 	RETURN 0;
			 ELSE
			 
			 	RETURN 1;	 
			 
			 END IF;
	 
		 
		 	 	 
	 
	 
	 
	 
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `submenu_get_name` (`vid` INT) RETURNS VARCHAR(250) CHARSET latin1 DETERMINISTIC NO SQL BEGIN
	DECLARE v_name VARCHAR(250);
	
	SELECT name
	INTO v_name
	FROM fooddelivery_submenu
	WHERE id=vid;
	
	 
	RETURN v_name;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `user_check_restaurant_location` (`vlat` VARCHAR(50), `vlon` VARCHAR(50), `vcity` VARCHAR(50)) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_restaurant_id  INT ;
	DECLARE v_city_radio  DECIMAL(10,0) ;
	
	
	SELECT radio 
	INTO v_city_radio
	FROM fooddelivery_city
	WHERE lower(trim(cname))=lower(trim(vcity))
	LIMIT 1;
	
	IF v_city_radio IS NULL THEN 
		   SIGNAL SQLSTATE '45004'
 		  SET MESSAGE_TEXT = 'No get Restaurants in your city';
	END IF;	
	
	SELECT id 
	INTO v_restaurant_id
	FROM fooddelivery_restaurant
	WHERE restaurant_get_distance(id,vlat,vlon) <=v_city_radio
	LIMIT 1;
		
	IF v_restaurant_id IS NULL THEN 
		   SIGNAL SQLSTATE '45005'
 		  SET MESSAGE_TEXT = 'No get Restaurants';
	END IF;	
	-- Verificar si existe por lo menos un restaurante cercano
	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `user_check_restaurant_location_city` (`vlat` VARCHAR(50), `vlon` VARCHAR(50)) RETURNS VARCHAR(200) CHARSET latin1 NO SQL BEGIN
	DECLARE v_city_name VARCHAR(200) ;
	DECLARE v_point TEXT DEFAULT CONCAT('Point(',vlat,' ' ,vlon,')');
	
	 SELECT fooddelivery_city.cname
	 INTO v_city_name
	 FROM fooddelivery_zones,fooddelivery_city
	 WHERE st_contains(ST_GEOMFROMTEXT(fooddelivery_zones.polygon),   
	 POINTFROMTEXT(v_point)) 
	 AND fooddelivery_city.id=fooddelivery_zones.city_id
	 LIMIT 1; 
	 
	 
	 IF v_city_name IS NULL THEN 
		   SIGNAL SQLSTATE '45004'
 		  SET MESSAGE_TEXT = 'No get Restaurants in your city';
	 
	END IF;
	
	RETURN v_city_name;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `user_check_token` (`vtoken` VARCHAR(255)) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_user_id  INT ;
	DECLARE v_tokendata_id  INT ;
	
	
	-- Verificar si el token enviado se encuentra activo
	SELECT id ,user_id
	INTO v_tokendata_id,v_user_id
	FROM fooddelivery_tokendata
	WHERE token=vtoken
	LIMIT 1;
		
	IF v_tokendata_id IS NULL THEN 
		   SIGNAL SQLSTATE '45003'
 		  SET MESSAGE_TEXT = 'Invalida Token';
	END IF;	
	-- Fin Verificar si el token enviado se encuentra activo
	
	
	-- Verificar si el usuario se encuentra registrado
	SELECT id 
	INTO v_user_id
	FROM fooddelivery_users
	WHERE id=v_user_id
	LIMIT 1;
		
	IF v_user_id IS NULL THEN 
		   SIGNAL SQLSTATE '45005'
 		  SET MESSAGE_TEXT = 'User no exists';
	END IF;	
	-- Fin Verificar si el usuario se encuentra registrado
	SET v_user_id=NULL;
	
	-- Verificar si el usuario se encuentra activo
	SELECT id 
	INTO v_user_id
	FROM fooddelivery_users
	WHERE id=v_user_id
	AND status='active'
	LIMIT 1;
		
	IF v_user_id IS NULL THEN 
		   SIGNAL SQLSTATE '45002'
 		  SET MESSAGE_TEXT = 'User Disabled';
	END IF;	
	-- Fin Verificar si el usuario se encuentra activo
	

	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `user_check_user_token_version` (`vuser_id` INT, `vtoken` VARCHAR(255), `vcode` VARCHAR(50), `voperative_system` VARCHAR(50)) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_version_id  INT ;
	DECLARE v_user_id  INT ;
	DECLARE v_tokendata_id  INT ;
	DECLARE v_restaurant_id  INT ;
	DECLARE v_city_radio  DECIMAL(10,0) ;
   DECLARE v_pedidos_pendientes INT;
	
	-- Verificar la versión de la app
	SELECT id 
	INTO v_version_id
	FROM fooddelivery_versions
	WHERE LOWER(operative_system)=LOWER(voperative_system)
	AND LOWER (code)=LOWER(vcode)
	AND status='active'
	and type='user'
	LIMIT 1;
		
	IF v_version_id IS NULL THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Exists a new version of App';
	END IF;	
	-- Fin Verificar la versión de la app
	
	-- Verificar si el usuario se encuentra registrado
	SELECT id 
	INTO v_user_id
	FROM fooddelivery_users
	WHERE id=vuser_id
	LIMIT 1;
		
	IF v_user_id IS NULL THEN 
		   SIGNAL SQLSTATE '45005'
 		  SET MESSAGE_TEXT = 'User no exists';
	END IF;	
	-- Fin Verificar si el usuario se encuentra registrado
	SET v_user_id=NULL;
	-- Verificar si el usuario se encuentra activo
	SELECT id 
	INTO v_user_id
	FROM fooddelivery_users
	WHERE id=vuser_id
	AND status='active'
	LIMIT 1;
		
	IF v_user_id IS NULL THEN 
		   SIGNAL SQLSTATE '45002'
 		  SET MESSAGE_TEXT = 'User Disabled';
	END IF;	
	-- Fin Verificar si el usuario se encuentra activo
	
	-- Verificar si el token enviado se encuentra activo
	SELECT id 
	INTO v_tokendata_id
	FROM fooddelivery_tokendata
	WHERE user_id=vuser_id
	AND lower(type)=lower(voperative_system)
	AND token=vtoken
	LIMIT 1;
		
	IF v_tokendata_id IS NULL THEN 
		   SIGNAL SQLSTATE '45003'
 		  SET MESSAGE_TEXT = 'Invalida Token';
	END IF;	
	-- Fin Verificar si el token enviado se encuentra activo
	
	SELECT COUNT(*) INTO v_pedidos_pendientes
	FROM fooddelivery_bookorder 
	WHERE user_id=vuser_id
	AND status IN(0,1,5,3);
	
	IF v_pedidos_pendientes >0 THEN 
		   SIGNAL SQLSTATE '45006'
 		  SET MESSAGE_TEXT = 'Pending Order';
	END IF;
	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `user_check_version` (`vcode` VARCHAR(255), `voperative_system` VARCHAR(255)) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_version_id  INT ;
	
	
		-- Verificar la versión de la app
	SELECT id 
	INTO v_version_id
	FROM fooddelivery_versions
	WHERE LOWER(operative_system)=LOWER(voperative_system)
	AND LOWER (code)=LOWER(vcode)
	AND status='active'
	and type='user'
	LIMIT 1;
		
	IF v_version_id IS NULL THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Exists a new version of App';
	END IF;	
	-- Fin Verificar la versión de la app

	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `zone_create_coordinates` (`vzone_id` INT, `vlat` VARCHAR(50), `vlong` VARCHAR(50)) RETURNS INT(11) NO SQL BEGIN
	
	
	INSERT INTO fooddelivery_coordinates(zone_id,lat,fooddelivery_coordinates.long)
	VALUES(vzone_id,vlat,vlong);
	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `zone_create_zone` (`vname` VARCHAR(500), `vcity_id` INT, `vpolygon` TEXT) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_next_id INT ;
	DECLARE v_existe INT ;
	
	-- Verificar si existe una zona en la misma ciudad con el mismo nombre
	SELECT COUNT(*)
	INTO v_existe
	FROM fooddelivery_zones
	WHERE LOWER(name)=LOWER(vname);
	
	IF v_existe>0 THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Ya existe una zona con el nombre enviado para la ciudad seleccionada';
	END IF;
	
	SELECT MAX(id) 
	INTO v_next_id
	FROM fooddelivery_zones;
		
	IF v_next_id IS NULL THEN 
		   SET v_next_id=1;
	ELSE
		   SET v_next_id=v_next_id+ 1;
	END IF;
	
	INSERT INTO fooddelivery_zones(id,NAME,city_id,polygon)
	VALUES(v_next_id,vname,vcity_id,vpolygon);
	
	RETURN v_next_id;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `zone_delete_zone` (`vzone_id` INT) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_next_id INT ;
	DECLARE v_existe INT ;
	
	-- Verificar si existe una zona en la misma ciudad con el mismo nombre
	SELECT COUNT(*)
	INTO v_existe
	FROM fooddelivery_zones
	WHERE  id=vzone_id;
	
	IF v_existe=0 THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'La zona enviada no existe';
	END IF;
	
	
	
	DELETE FROM fooddelivery_coordinates
	WHERE zone_id=vzone_id;
	
	DELETE FROM  fooddelivery_zones
	WHERE id=vzone_id;
	
	RETURN 1;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `zone_edit_zone` (`vname` VARCHAR(500), `vzone_id` INT, `vpolygon` TEXT) RETURNS INT(11) NO SQL BEGIN
	DECLARE v_next_id INT ;
	DECLARE v_existe INT ;
	
	-- Verificar si existe una zona en la misma ciudad con el mismo nombre
	SELECT COUNT(*)
	INTO v_existe
	FROM fooddelivery_zones
	WHERE LOWER(name)=LOWER(vname)
	AND id<>vzone_id;
	
	IF v_existe>0 THEN 
		   SIGNAL SQLSTATE '45001'
 		  SET MESSAGE_TEXT = 'Ya existe una zona con el nombre enviado para la ciudad seleccionada';
	END IF;
	
	update fooddelivery_zones
	set NAME=vname,
	polygon=vpolygon
	WHERE id=vzone_id;
	
	DELETE FROM fooddelivery_coordinates
	WHERE zone_id=vzone_id;
	
	RETURN v_next_id;
	
	
	
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `fooddelivery_adminlogin`
--

CREATE TABLE `fooddelivery_adminlogin` (
  `id` int(11) NOT NULL,
  `fullname` varchar(30) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `email` varchar(120) NOT NULL,
  `currency` varchar(12) NOT NULL DEFAULT 'USD - $',
  `timezone` text NOT NULL,
  `role` varchar(11) NOT NULL DEFAULT '1',
  `icon` varchar(100) NOT NULL,
  `is_delete` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fooddelivery_adminlogin`
--

INSERT INTO `fooddelivery_adminlogin` (`id`, `fullname`, `username`, `password`, `email`, `currency`, `timezone`, `role`, `icon`, `is_delete`) VALUES
(1, 'Rubén', 'Borja', '123', 'test@hotmail.com', 'USD - $', 'America/Bogota - (GMT-05:00) Bogota', '1', 'admin_1590830987.png', 0);

-- --------------------------------------------------------

--
-- Table structure for table `fooddelivery_allies`
--

CREATE TABLE `fooddelivery_allies` (
  `id` int(11) NOT NULL,
  `ruc` varchar(15) DEFAULT NULL,
  `name` varchar(250) NOT NULL DEFAULT '0',
  `web` varchar(80) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `telephone` varchar(13) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `facebook` varchar(100) DEFAULT NULL,
  `instagram` varchar(100) DEFAULT NULL,
  `twitter` varchar(100) DEFAULT NULL,
  `tiktok` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fooddelivery_allies`
--

INSERT INTO `fooddelivery_allies` (`id`, `ruc`, `name`, `web`, `email`, `telephone`, `address`, `facebook`, `instagram`, `twitter`, `tiktok`) VALUES
(1, '2390625971001', 'Faster', 'www.faster.com.ec', 'servicio@faster.com.ec', '0985494782', 'Calle Arroyo Robelly 359 y Peralta', 'https://www.facebook.com/FasterEcuador', 'https://www.instagram.com/fasterec/', 'https://twitter.com/Faster593', 'https://www.tiktok.com/@fasterec');

-- --------------------------------------------------------

--
-- Table structure for table `fooddelivery_city`
--

CREATE TABLE `fooddelivery_city` (
  `id` int(11) NOT NULL,
  `cname` varchar(50) NOT NULL,
  `created_at` varchar(20) NOT NULL,
  `radio` decimal(10,0) NOT NULL DEFAULT 0,
  `country` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fooddelivery_city`
--

INSERT INTO `fooddelivery_city` (`id`, `cname`, `created_at`, `radio`, `country`) VALUES
(1, 'Santo Domingo de los Colorados', '1550618210', '2000', 'Ecuador'),
(4, 'Quito', '1589585909', '2000', 'Ecuador'),
(5, 'La Concordia', '1591647559', '2000', 'Ecuador'),
(6, 'Guayaquil', '1594884225', '2000', 'Ecuador'),
(7, 'El Carmen', '1594884428', '2000', 'Ecuador'),
(8, 'Patricia Pilar', '1595083535', '2000', 'Ecuador'),
(9, 'Manta', '1606836290', '2000', 'Ecuador'),
(10, 'Santa Elena', '1607303059', '2000', 'Ecuador'),
(12, 'Quevedo', '1623268879', '2000', 'Ecuador');

-- --------------------------------------------------------

--
-- Table structure for table `fooddelivery_restaurant`
--

CREATE TABLE `fooddelivery_restaurant` (
  `id` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `dni` varchar(15) DEFAULT NULL,
  `city_id` int(11) NOT NULL DEFAULT 0,
  `type_store` varchar(50) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `open_time` varchar(30) DEFAULT NULL,
  `close_time` varchar(30) DEFAULT NULL,
  `delivery_time` varchar(30) DEFAULT NULL,
  `commission` varchar(10) DEFAULT NULL,
  `store_owner` varchar(100) DEFAULT NULL,
  `timestamp` varchar(20) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `photo` varchar(100) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `lat` varchar(30) DEFAULT NULL,
  `lon` varchar(30) DEFAULT NULL,
  `desc` text DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `location` varchar(300) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `del_charge` varchar(50) DEFAULT NULL,
  `enable` tinyint(4) NOT NULL DEFAULT 1,
  `session` tinyint(4) DEFAULT 1,
  `status` varchar(50) DEFAULT 'active',
  `ally` varchar(50) DEFAULT 'NO',
  `monday` varchar(50) DEFAULT 'YES',
  `tuesday` varchar(50) DEFAULT 'YES',
  `wednesday` varchar(50) DEFAULT 'YES',
  `thursday` varchar(50) DEFAULT 'YES',
  `friday` varchar(50) DEFAULT 'YES',
  `saturday` varchar(50) DEFAULT 'YES',
  `sunday` varchar(50) DEFAULT 'YES',
  `sequence` int(11) NOT NULL DEFAULT 0,
  `edit_id` int(11) DEFAULT NULL,
  `edit_date_time` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fooddelivery_restaurant`
--

INSERT INTO `fooddelivery_restaurant` (`id`, `name`, `dni`, `city_id`, `type_store`, `address`, `open_time`, `close_time`, `delivery_time`, `commission`, `store_owner`, `timestamp`, `currency`, `photo`, `phone`, `lat`, `lon`, `desc`, `email`, `website`, `city`, `location`, `is_active`, `del_charge`, `enable`, `session`, `status`, `ally`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`, `sequence`, `edit_id`, `edit_date_time`) VALUES
(15, 'Chifa Asia', '1723149850', 0, 'Restaurante', 'Av. Abraham Calazacón', '11:30', '22:00', '15', '0', 'Pendiente', '1558154534', 'USD - $', 'resto_1602866001.jpg', '0993378231', '-0.254871922934549', '-79.16150581870194', 'Chifa', 'leleychen28@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-08-11 09:00:01'),
(17, 'Señora Pizza', '1723866149', 0, 'Restaurante', 'Cooperativa 9 De Diciembre, Manzana H Calles Londres Y Damasco Esquina, Santo Domingo, Ecuador', '15:30', '23:00', '25', '10', 'Pendiente', '1558154895', 'USD - $', 'resto_1603391607.jpg', '0981008935', '-0.24436', '-79.15499', 'Pizza', 'senorapizza@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Cooperativa 9 De Diciembre, Manzana H Calles Londres Y Damasco Esquina, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '30-07-2022 01:01:06'),
(20, 'A La Mexicana', '1721387213', 0, 'Restaurante', 'Calle Santa Rosa Y Pedro Schumacher', '17:30', '21:00', '10', '0', 'Prueba', '1558359920', 'USD - $', 'resto_1603811828.jpg', '0985870686', '-0.250401', '-79.18057', 'Comida Mexicana', 'mexicana@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Obispo P. Schumacher 502, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 4, 5, '10-03-2022 17:00:20'),
(21, 'Santo Manaba', '1723108583001', 0, 'Restaurante', 'Av. Quevedo Y Juan Leon Mera', '08:30', '16:00', '20', '15', 'Diana Alcivar Jimenez', '1558459713', 'USD - $', 'resto_1603811866.jpg', '0984868224', '-0.2603', '-79.18369999999999', 'Comida Manabita', 'santomanaba@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quevedo Km 1 1/2 Entre Juan Leon Mera Y, Jacinto Cortez Jaya, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '11-07-2022 09:53:45'),
(23, 'Alitas Del Cadillac', '1721387213', 0, 'Restaurante', 'Av. Rio Lelia Y Av. Los Anturios', '17:30', '23:00', '20', '0', 'Diana Velastegui', '1558974060', 'USD - $', 'resto_1603915001.jpg', '0998109111', '-0.248706', '-79.150505', 'Alitas', 'cadillac@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Puruhaes 202, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '10-03-2022 16:50:54'),
(25, 'Krosty Comidas Rápidas', '1723866149', 0, 'Restaurante', 'Ciudad Nueva ', '14:30', '21:00', '10', '10', 'Pendiente', '1558992045', 'USD - $', 'resto_1603915076.jpg', '0985708789', '-0.253094', '-79.196996', 'Comidas Rapidas', 'krosty@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Marco Gonzalez 201, Santo Domingo, Ecuador', 1, 'Motorizado', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-07-28 07:45:29'),
(26, 'Pizza Focaccia', '1723866149', 0, 'Restaurante', 'Rosales, Avenida Venezuela', '15:00', '22:45', '20', '5', 'Pendiente', '1559138399', 'USD - $', 'resto_1603399383.jpg', '0997639482', '-0.249372', '-79.182021', 'Pizzeria', 'focaccia@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr29+762, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '26-07-2022 10:59:25'),
(27, 'Restaurante Quito1', '1723149850001', 0, 'Licorería', 'Quito Avenida Universitaria', '07:00', '21:00', '50', '0', 'Xxxxxx', '1559168671', 'USD - $', 'resto_1599695383.jpg', '0989652128', '-0.2143', '-78.5017', 'Salchipapas, Almuerzos.', 'restaurantequito@gmail.com', 'www.faster.com.ec', 'Quito', 'Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 4, 1, '2021-07-28 07:45:29'),
(29, 'La Paz Chifa China', '1723187413', 0, 'Restaurante', 'Abraham Calazacon', '11:00', '22:00', '15', '0', 'Pendiente', '1560386979', 'USD - $', 'resto_1603811681.jpg', '0985372611', '-0.26517', '-79.17118', 'Comida China', 'qinghao1979@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prmh+wgm, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '07-07-2022 13:01:06'),
(30, 'Don Pollo 2', '1723866149', 0, 'Restaurante', 'Avenida Abraham Calazacón Y Guayaquil Esquina', '12:00', '22:00', '10', '0', 'Sebastian Lara', '1560394929', 'USD - $', 'resto_1603982460.jpg', '0969990890', '-0.24950483441352844', '-79.1629409790039', 'Pollo Asado', 'donpollo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Guayaquil 102, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '31-03-2022 14:17:45'),
(32, 'Ch Farina', '1723866149', 0, 'Restaurante', 'Av. Quito', '12:00', '22:00', '15', '0', 'Falta', '1560476070', 'USD - $', 'resto_1603982496.jpg', '0981956413', '-0.248865', '-79.159394', 'Pizzeria', 'chfarina@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito 1444, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 2, 8, '13-05-2022 15:07:43'),
(33, 'Camarón Reventado', '1723866149', 0, 'Restaurante', 'Abraham Calazacón Entrada A Rio Verde Frete Al Chifa Internacional ', '11:00', '20:30', '7', '0', 'Yuliana Lara', '1560481283', 'USD - $', 'resto_1604345364.jpg', '0989283979', '-0.2636944', '-79.16349430000002', 'Camarón Reventado Por Libras La Revancha', 'camaron@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Camino A Rio Verde 104, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(35, 'Ceviches De Wacho', '1723866149', 0, 'Restaurante', 'Las Palmeras', '09:30', '14:30', '5', '0', 'Pendiente', '1560533877', 'USD - $', 'resto_1605196554.jpg', '0994916372', '-0.25932', '-79.17737870000002', 'Ceviches', 'wacho@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prrf+64f, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '10-03-2022 17:31:48'),
(36, 'Panadería D\'nelly', NULL, 0, 'Panadería', 'Av Chone', '07:30', '21:00', '10', '0', 'Pendiente', '1560539429', 'USD - $', 'resto_1560567528.jpg', '023700705', '-0.25505', '-79.18493869999998', 'Panadería', 'valeri_mora@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Juan José Flores 312, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(37, 'Pizzería Los Tíos', '1721387213', 0, 'Restaurante', 'Av Quito Y Av Abraham Calazacon', '11:00', '22:00', '10', '0', 'Pendiente', '1560551802', 'USD - $', 'resto_1603982565.jpg', '022751200', '-0.250385', '-79.163122', 'Pizzería', 'tios@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prxp+vq2, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-04-2022 13:13:07'),
(39, 'El Café De Nena', '1723866149', 0, 'Restaurante', 'Avenida Quito', '08:00', '21:00', '20', '10', 'Delia Maria ', '1561049534', 'USD - $', 'resto_1603982596.jpg', '0939068778', '-0.24407', '-79.15437359999999', 'Café', 'nenas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito 100, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '03-09-2022 17:05:11'),
(40, 'La Cueva Del Oso Lelia', NULL, 0, 'Restaurante', 'Av. Rio Lelia', '18:00', '23:30', '15', '0', 'Pendiente', '1561175532', 'USD - $', 'resto_1561175532.jpg', '0983958236', '-0.25178', '-79.15235999999999', 'Hamburguesas Y Papas Fritas', 'alvarocalero26@gmail.com', 'www.onepinpon.com', 'Santo Domingo de los Colorados', 'Av. Río Lelia 142, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(44, 'Esquina De Ales Av Quito', '1723866149', 0, 'Restaurante', 'Av. Abraham Calazacon Y Via Quito', '14:00', '22:30', '20', '0', 'Javier Veliz', '1565765020', 'USD - $', 'resto_1603395496.jpg', '0994465112', '-0.25094', '-79.16189', 'Moto', 'ales@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón 2516, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 15:35:47'),
(46, 'Ela - Brownie Artesanal', '1721387213', 0, 'Panadería', 'Urb. Los Pambiles Av.rios Toachi', '09:00', '19:00', '5', '0', 'Pendiente ', '1565812658', 'USD - $', 'resto_1604596087.jpg', '0996644857', '-0.261529', '-79.165418', 'Ok', 'ela@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Río Toachi 601, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 15:44:39'),
(48, 'D\'kaviedes', '1715940076', 0, 'Restaurante', 'Av. Quito Y Río Chimbo A Lado De Cholados', '14:00', '22:00', '25', '10', 'Xavier Gonzalo Benalcazar Kabiedes', '1569542745', 'USD - $', 'resto_1639063730.jpeg', '0990695883', '-0.2478289', '-79.1666163', 'Papas Y Hamburguesas', 'kaviedes@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Cocaniguas 107, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '23-03-2022 07:28:26'),
(49, 'Kfc Sd', '2300459548', 0, 'Restaurante', 'Av Esmeraldas', '10:00', '21:45', '20', '0', 'Pendiente', '1571379183', 'USD - $', 'resto_1614202315.jpg', '0969764774', '-0.24533188943651477', '-79.17365473686218', 'Pollo Broaster', 'kfc@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3g+vgh, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', '+ 0.10', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '20-08-2022 19:18:08'),
(50, 'Mayflower', NULL, 0, 'Restaurante', 'Shopping Santo Domingo', '11:00', '21:00', '10', '0', 'Pendiente', '1571387061', 'USD - $', 'resto_1571387061.jpg', '0963089525', '-0.25021', '-79.16256', 'Ok', 'mayflower@gmail.com', 'www.mayflower.com', 'Santo Domingo de los Colorados', 'Paseo Shopping', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(51, 'Mexican Food', '1721387213', 0, 'Restaurante', 'Av. Rio Lelia', '17:00', '21:00', '10', '0', 'Pendiente', '1572757408', 'USD - $', 'resto_1610293198.jpg', '0996517218', '-0.24857', '-79.15208', 'Ok', 'mexican@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 114, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '11-03-2022 16:01:35'),
(52, 'El Chuzazo', '1723866149', 0, 'Restaurante', 'Av. La Lorena Y Calle Jose De Caldas ', '17:00', '22:30', '25', '10', 'Pendiente', '1572759153', 'USD - $', 'resto_1604698302.jpg', '0999128667', '-0.25566867040921565', '-79.1575013624573', 'Ok', 'chuzazo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. José De Caldas 205, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-07-2022 17:46:19'),
(53, 'Menestras Del Negro', '1721387213', 0, 'Restaurante', 'Shopping', '10:00', '20:45', '15', '0', 'Pendiente', '1572761209', 'USD - $', 'resto_1604384194.jpg', '0969764774', '-0.248818', '-79.161445', 'Ok', 'negro@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 16:12:28'),
(56, 'The Grill Yard', NULL, 0, 'Restaurante', 'Cortes De Carne A La Parrilla', '12:00', '23:00', '25', '0', 'Pendiente', '1579123349', 'USD - $', 'resto_1579123349.jpg', '0978944838', '-0.250805', '-79.163087', 'The Grill Yard', 'nod-dan@hotmil.com', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Av Quito Y Abrahan Calazacon', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(58, 'Shawarma Ralla', '1758257362', 0, 'Restaurante', 'Calle Venezuela 137, Santo Domingo', '15:00', '23:59', '5', '5', 'Pendiente', '1579131319', 'USD - $', 'resto_1579131319.jpg', '0995906302', '-0.249299', '-79.182608', 'Almoazi Ahmed', 'abusaidah@hotmail.com', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Venezuela 122, Santo Domingo, Ecuador', 0, 'Moto', 1, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 0, '12-09-2022 00:45:01'),
(62, 'Parrillada El Cubano', '1723866149', 0, 'Restaurante', 'Restaurante', '16:00', '18:30', '15', '0', 'Pendiente', '1579216291', 'USD - $', 'resto_1605196608.jpg', '0994958422', '-0.259196', '-79.161135', 'Parrilla Y Asados', 'cubano@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón &, Santo Domingo, Ecuador', 0, 'Av Abrahan Calazacon', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '11-03-2022 16:19:51'),
(68, 'American Corner', '1724715220', 0, 'Restaurante', 'Av. Venezuela (calle Del Colesterol)', '16:00', '22:00', '15', '10', 'Pendiente', '1579297440', 'USD - $', 'resto_1603396887.jpg', '0980015587', '-0.2495213', '-79.1820042', 'Alitas ', 'corner@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr29+762, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-08-2022 01:13:41'),
(70, 'Mr Pincho', '1723866149', 0, 'Restaurante', 'Grill A La Parrilla', '12:00', '22:50', '20', '10', 'Paulo Morales', '1579301029', 'USD - $', 'resto_1602467464.jpg', '0994090233', '-0.259565', '-79.164787', 'Grill A La Parrilla', 'mrpincho@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av Río Toachi 382, Santo Domingo, Ecuador', 0, 'Av Abrahan Calazacon Y Rio Toachi', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '02-09-2022 22:32:42'),
(74, 'Stav Pollo Horneado', '1723866149', 0, 'Restaurante', 'Via Quevedo Y Puereto Ila', '09:00', '23:00', '10', '0', 'Pendiente ', '1581369584', 'USD - $', 'resto_1602461450.jpg', '0996483903', '-0.26244', '-79.187471', 'Stav Pollo Horenado', 'stav@faster.com.ec', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Av. Quevedo 1136, Santo Domingo, Ecuador', 0, 'Av Quevedo Y Calle 1', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '18-03-2022 16:54:06'),
(76, 'Santo Moro', '1723866149', 0, 'Restaurante', 'Calle La Tacunga, Diagonal A Calle Puyo', '15:00', '21:30', '15', '0', 'Dario Piedra', '1581442354', 'USD - $', 'resto_1604698392.jpg', '0963666114', '-0.25072774625780336', '-79.1704850804392', 'Griller', 'santomoro@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Puyo 701, Santo Domingo, Ecuador', 1, 'Rio Volcan Y Yanuncay', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-03-2022 10:52:20'),
(78, 'Sweet Land Esmeraldas', '0702996299001', 0, 'Panadería', 'Av. Esmeraldas Y De Las Provincias', '10:00', '19:30', '10', '15', 'Fernando Romero', '1581523962', 'USD - $', 'resto_1604698495.jpg', '0939785765', '-0.251779', '-79.175826', 'Pasteleria', 'sweetland@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prxf+6p3, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '30-07-2022 01:01:49'),
(80, 'Kiwilimón', '1723149850', 0, 'Restaurante', 'Kiwilimón Av Chimbo', '11:00', '22:00', '10', '10', 'Hugo Luna', '1581549649', 'USD - $', 'resto_1603393037.jpg', '0963190023', '-0.252359', '-79.163891', 'Heladería', 'kiwilimon@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'C. Rio Chimbo 118y, Santo Domingo 230101, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '08-07-2022 23:56:20'),
(82, 'Gelatomix Av Quito', '1721387213', 0, 'Restaurante', 'Av. Quito', '13:00', '22:00', '6', '0', 'Pendiente', '1581560141', 'USD - $', 'resto_1648609573.png', '0994733536', '-0.25495', '-79.173942', 'Heladería', 'gelatomix_sd@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito 209, Santo Domingo, Ecuador', 0, 'Av Quito Entre Loja Y Cuenca', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '29-03-2022 22:06:13'),
(84, 'Sra Empanada', '1723187413', 0, 'Restaurante', 'Río Zamora Entre Zeus Spa Y Funeraria Jardines Del Eden ', '08:00', '21:00', '20', '10', 'Pendiente', '1581600124', 'USD - $', 'resto_1639063807.jpeg', '0998101170', '-0.24543578236412514', '-79.16533095821623', 'Sra Empanada', 'bautistacarmen0819@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3m+xj6, Rio Zamora, Santo Domingo, Ecuador', 0, 'Coop 30 De Julio', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-08-2022 01:13:11'),
(88, 'Gus', '1723866149', 0, 'Restaurante', 'Av. Latacunga Y 29 De Mayo', '09:20', '22:45', '10', '10', 'Pendiente ', '1582049724', 'USD - $', 'resto_1602466314.jpg', '022751770', '-0.253982', '-79.170867', 'Asadero', 'gus@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prwh+cmf, Av. 29 De Mayo, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '06-09-2022 11:18:44'),
(90, 'La Casa Del Hornado', '1723866149', 0, 'Restaurante', 'Hornado', '08:00', '17:00', '10', '0', 'Pendiente', '1582051618', 'USD - $', 'resto_1603646776.jpg', '0981147881', '-0.24160008216557308', '-79.16333533282535', 'Hornado', 'hornado@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr5p+wj5, Santo Domingo, Ecuador', 0, ' Abraham Calazacón Y Río Onzole (2.07 Km) Santo Do', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '25-06-2022 18:54:33'),
(92, 'Tio Jr Wings', '2300209257001', 0, 'Restaurante', 'Av Quito Y Saturno', '14:30', '22:00', '20', '0', 'Luis Sarmiento Lopez', '1582151992', 'USD - $', 'resto_1605537280.jpg', '0960133829', '-0.2470426938952976', '-79.15143935673291', 'Alitas', 'tiojrwings@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3x+4c4, Santo Domingo, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '17-07-2022 19:32:20'),
(94, '100% Chonero', '1721387213', 0, 'Restaurante', 'Av. Quito 1234, Santo Domingo, Ecuador', '18:30', '23:59', '10', '5', 'Pendiente', '1582326362', 'USD - $', 'resto_1635951647.jpg', '0988484731', '-0.25184419866122243', '-79.16462123394012', 'Comida Rápida', 'chonero@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Rio Chimbo 103, Santo Domingo, Ecuador', 0, 'Av Quito Y Rio Chimbo', 1, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 0, '12-09-2022 01:00:01'),
(96, 'Boli Gourmet', '1721387213', 0, 'Restaurante', 'Juan Tenorio', '09:00', '20:00', '5', '10', 'Pendiente', '1582328423', 'USD - $', 'resto_1605537322.jpg', '0993739616', '-0.26224', '-79.162217', 'Boli Gourmet', 'boligourmet@faster.com.ec', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Via Quito Y Abraham Calazacon', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-07-28 07:45:29'),
(98, 'Esquina De Ales Av Chone', '1723866149', 0, 'Restaurante', 'Asadero', '14:00', '22:30', '10', '0', 'Javier Veliz', '1582330988', 'USD - $', 'resto_1603395475.jpg', '0988527380', '-0.254914', '-79.18024', 'Asadero', 'aleschone@faster.com.ec', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Prw9+2wg, Santo Domingo, Ecuador', 0, 'Av Chone Y Shumager', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 15:35:43'),
(100, 'Mooi', NULL, 0, 'Restaurante', 'Cafeteria', '08:00', '22:00', '10', '0', 'Pendiente', '1582393975', 'USD - $', 'resto_1582393975.jpg', '0969764774', '-0.248441', '-79.150516', 'Cafeteria', 'mooi@faster.com.ec', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Calle Los Anturios N-6 Y Puruhaes. Urb. Banco Fomento (2.39 Km) 230150 Santo Domingo (ecuador)', 1, 'Calle Los Anturios N-6 Y Puruhaes. Urb. Banco Fome', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(102, 'Embobate', '1721387213', 0, 'Restaurante', 'Embobate', '12:00', '22:00', '5', '0', 'Pendiente', '1582410543', 'USD - $', 'resto_1605537361.jpg', '0985941785', '-0.248735', '-79.150353', 'Jugos Encapsulados', 'embobate@faster.com.ec', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Qv22+p42, Santo Domingo, Ecuador', 0, ' Av. Los Anturios D-60 Y Puruhaes (2.40 Km) Santo ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 17:03:56'),
(104, 'Auto Pollo', '1723866149', 0, 'Restaurante', 'Av Quito Entre Rio Pove Y Rio Cocaniguas', '10:00', '20:30', '10', '0', 'Lucio Campoverde', '1582911345', 'USD - $', 'resto_1605537394.jpg', '0979948711', '-0.254188', '-79.167314', 'Restaurante Asadero', 'autopollo@faster.com.ec', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Prwm+837, Santo Domingo, Ecuador', 1, 'Av Quito  Entre Rio Pove Y Rio Cocaniguas', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 17:09:39'),
(106, 'San Andrés', '1723866149', 0, 'Restaurante', 'Calle Tiputini Y Pedro Vicente Maldonado ', '07:15', '12:30', '10', '0', 'Pendiente ', '1583253460', 'USD - $', 'resto_1603723080.jpg', '0969764774', '-0.247016', '-79.176697', 'Restaurante', 'sanandres@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Río Cajones 213, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 17:17:58'),
(108, 'Marisqueria Los Popeyitos ', '1721560215', 0, 'Restaurante', 'Av Venezuela ', '10:30', '22:00', '20', '0', 'Sandra Suares', '1583257297', 'USD - $', 'resto_1605537421.jpg', '0980967332', '-0.24937', '-79.181366', 'Restaurant', 'popeyitos@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 114, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 17:35:00'),
(110, 'Prueba Quito', '1723149850', 12, 'Farmacia', 'Restaurant', '00:01', '23:59', '20', '10', 'Elver', '1598985591', 'USD - $', 'resto_1612236338.jpg', '0980145405', '-1.0329147695857204', '-79.4593682508545', 'Quito Test', 'quito@gmail.com', 'faster.com.ec', 'Quevedo', '120301 1, Quevedo 120302, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 13, 1, '24-05-2022 22:49:57'),
(112, 'Max Pollo', '1723866149', 0, 'Restaurante', 'Av. Rio Toachi Y 10 De Agosto', '12:00', '21:30', '10', '0', 'Falta', '1583542567', 'USD - $', 'resto_1603661040.jpg', '0981077359', '-0.262064', '-79.165163', 'Asadero', 'maxpollo@faster.com.ec', 'www.onepinpon.com', 'Santo Domingo de los Colorados', 'Av Río Toachi 601, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '07-04-2022 09:55:30'),
(114, 'Pizza En Cono', '1724715220', 0, 'Restaurante', 'Santha Martha Por Cnt', '17:00', '22:00', '10', '0', 'Pendiente', '1583545672', 'USD - $', 'resto_1583545672.jpg', '0999814446', '-0.265769', '-79.183457', 'Pizzeria', 'pizzaencono@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prm8+mj Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 17:45:05'),
(116, 'El Sr. Bolón', '2300459548', 0, 'Restaurante', 'Av. Chone Y Rio Chila', '07:00', '13:00', '10', '0', 'Pendiente', '1583949994', 'USD - $', 'resto_1603734394.jpeg', '0980716299', '-0.254675', '-79.18684', 'Cafeteria', 'srbolon@faster.com.ec', 'www.onepinpon.com', 'Santo Domingo de los Colorados', 'Prw7+37m, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '18-04-2022 10:40:14'),
(120, 'Pide Lo Que Sea', '1723866149', 0, 'Lo Que Sea', 'Santo Domingo', '00:01', '23:59', '25', '0', 'Faster', '1585623333', 'USD - $', 'resto_1603139479.jpg', '0985494782', '-0.259384', '-79.170022', 'Domicilios', 'loqueseastodgo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '06-06-2022 18:48:00'),
(124, 'Supermercado Proint', '1723866149', 0, 'Supermercado', 'Calle Guayaquil Y Loja', '07:30', '18:30', '30', '0', 'Hugo Intriago', '1585881089', 'USD - $', 'resto_1605537657.jpg', '0969764774', '-0.251543', '-79.174089', 'Supermercado', 'proint@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Loja 157, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 17:58:20'),
(126, 'Agachaditos', '1723866149', 0, 'Restaurante', 'Y Del Indio Colorado', '09:00', '23:59', '30', '0', 'Pendiente ', '1585933596', 'USD - $', 'resto_1603662068.jpg', '0994047707', '-0.253351', '-79.176467', 'Restaurante', 'agachaditos@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Esmeraldas 113, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:04:10'),
(128, 'Más Que Alitas', '1720712536001', 0, 'Restaurante', 'Av La Lorena Y Quitumbes Frente A La Cevicheria Loluca ', '14:00', '23:00', '30', '15', 'Marcia Guevara Maldonado', '1585935607', 'USD - $', 'resto_1654188055.jpeg', '0999696114', '-0.2576748033758594', '-79.15056757318878', 'Alitas Bbq', 'masquealitas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prrx+wp8, Av. La Lorena, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '16-06-2022 14:39:42'),
(130, 'Ferretería Carlin', '1723149850', 0, 'Supermercado', 'Av. Los Colonos Y Río Verde', '08:00', '17:00', '10', '10', 'Pendiente ', '1585945629', 'USD - $', 'resto_1609864990.jpg', '0985523648', '-0.2633771', '-79.2024096', 'Productos De Ferreteria', 'ferreteriacarlin@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Pqpx+c4f, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '06-06-2022 18:40:38'),
(132, 'Pinchos De La Pio', '1719075077', 0, 'Restaurante', 'Rio Toachi', '16:00', '23:15', '30', '10', 'Gustavo Albán ', '1585967200', 'USD - $', 'resto_1600815826.png', '0982733560', '-0.256825', '-79.165147', 'Parrilladas', 'pinchosdelapio@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Río Toachi 305, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '30-07-2022 01:02:11'),
(134, 'Doña Bella', '1724715220', 0, 'Restaurante', 'Av. Quito Y Ambato', '08:00', '16:00', '30', '10', 'Joel Rivas', '1586047924', 'USD - $', 'resto_1603377838.jpg', '0963921064', '-0.255244', '-79.171881', 'Caldo De Manguera Y Encebollado', 'donabella@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Galapagos, Quito, Prvh+w6q, C. Ambato, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '11-07-2022 09:06:27'),
(136, 'Pollo Colorado', '1723187413', 0, 'Restaurante', 'Circulo De Los Continentes', '10:00', '21:00', '10', '0', 'Pendiente ', '1586054774', 'USD - $', 'resto_1610298695.jpg', '0981185053', '-0.249722', '-79.163014', 'Asadero', 'pollocolorado@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Guayaquil 102, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(138, 'Panadería Porta Venezia', '1723866149', 0, 'Panadería', 'Loja Entre Quito Y Galapagos', '07:30', '18:00', '10', '0', 'Pendiente ', '1586065067', 'USD - $', 'resto_1604353753.jpg', '0982807974', '-0.255073', '-79.174437', 'Panaderia Y Pasteleria', 'portavenecia@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Loja 211, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:20:20'),
(140, 'La Cevichería', '1723149850', 0, 'Restaurante', 'Av Rio Lelia Frente A Plaza Toure', '09:00', '17:00', '20', '0', 'Pendiente ', '1586194764', 'USD - $', 'resto_1610289011.jpg', '0969764774', '-0.251436', '-79.152615', 'Cevicheria', 'lacevicheria@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 142, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:24:51'),
(142, 'Pronaca', '1723149850', 0, 'Supermercado', 'Av Venezuela Y Rio Chila', '08:00', '14:00', '15', '0', 'Pendiente ', '1586254144', 'USD - $', 'resto_1586944571.jpg', '0969764774', '-0.249184', '-79.186794', 'Madeli S. A. Distribuidor Autorizado Pronaca', 'madeli@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Chila 238, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '11-03-2022 18:26:50'),
(146, 'Santas Alitas', '2300459548', 0, 'Restaurante', 'Av. Venezuela Y Av. Monseñor Shumager', '12:30', '23:10', '30', '10', 'Nurys Montaño', '1586354874', 'USD - $', 'resto_1610491862.jpg', '0989821823', '-0.249375', '-79.180868', 'Venta De Alitas Con Papas De Diferentes Salsas ', 'santasalitas@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr29+7pj, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '03-07-2022 13:02:11'),
(148, 'Marisquería Los Delfines ', '1723187413', 0, 'Restaurante', 'Vía Quevedo Km 1 1/2  Coop. 17 De Diciembre ', '09:00', '13:30', '30', '0', 'Pendiente', '1586393406', 'USD - $', 'resto_1610291629.jpg', '0997610235', '-0.258504', '-79.183059', 'Venta De Comida ', 'delfines@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quevedo 836, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:34:27'),
(150, 'D\'bam-bam', '1721387213', 0, 'Restaurante', 'Avenida  Calle Venezuela  (calle Colesterol) ', '14:00', '21:45', '20', '0', 'Pendiente', '1586439780', 'USD - $', 'resto_1609860068.jpg', '0981362680', '-0.249351', '-79.181628', 'Hamburguesas & Papas', 'bambam@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr29+785, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:31:36'),
(152, 'Taco & Nacho', '1721372975', 0, 'Restaurante', 'Calle Ibarra Entre, Machala Y Babahoyo', '18:00', '23:00', '30', '15', 'William Oswaldo  Remache', '1586475536', 'USD - $', 'resto_1655997081.jpeg', '099 938 4729', '-0.25302989493269773', '-79.1699948691864', 'Comida Mexicana', 'nacho@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Prwh+qxh, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '22-07-2022 22:40:20'),
(154, 'Pizzería El Hornero', '1723187413', 0, 'Restaurante', ' Km 5,5 Via Quito Frente A Kfc', '07:30', '22:00', '25', '0', 'Pendiente', '1586486163', 'USD - $', 'resto_1610298034.jpg', '096 976 4774', '-0.262855', '-79.114792', 'Pizzas , Desayunos, Sánduches, Postres, Ensaladas Y Bebidas ', 'hornero@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Pvpp+v3 Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:38:17'),
(156, 'Marisqueria Albacora', '1721387213', 0, 'Restaurante', 'Tsafiqui', '08:00', '13:45', '10', '0', 'Pendiente', '1586699964', 'USD - $', 'resto_1586699964.jpg', '0992121613', '-0.261203', '-79.171179', 'Marisqueria', 'albacora@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Ibarra 1502, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(158, 'Bariloche La Parrillada D\'mario', '1724715220', 0, 'Restaurante', 'Calle Gonzalo Diaz De Pineda Entre 6 De Noviembre Y Tsafiqui.', '16:00', '21:30', '30', '0', 'Pendiente', '1586814681', 'USD - $', 'resto_1602467020.jpg', '098 067 4871', '-0.25806', '-79.163678', 'Parrillada ', 'bariloche@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'G. Diaz De Pineda 112, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:38:24'),
(160, 'Ala Carga - Alitas Express', '1718880253', 0, 'Restaurante', 'Rosales Cuarta Etapa, Junto Al Estadio Del Fonta ', '15:00', '21:00', '30', '0', 'Pendiente', '1586829169', 'USD - $', 'resto_1609854796.jpg', '0987053055', '-0.245389', '-79.1839', 'Alitas Express', 'alacarga@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr38+rc Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '12-10-2021 16:51:59'),
(162, 'Helados Cosecha Gourmet', '1723866149', 0, 'Restaurante', 'Cesar Vallejo Y Arturo Ulsar', '08:00', '20:00', '10', '10', 'Pendiente', '1586831751', 'USD - $', 'resto_1603661517.jpg', '0998417857', '-0.259378', '-79.162775', 'Heladeria', 'cosecha@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Cesar Vallejo 109, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(164, 'La Cava', '1723866149', 1, 'Licorería', 'Av. Esmeraldas Gasolinera Primax', '09:00', '21:00', '1', '5', 'Juan Aguirre', '1586865851', 'USD - $', 'resto_1638563876.png', '0997200170', '-0.251289', '-79.175716', 'Licorería', 'superlicores@faster.com.ec', 'www.lacava.com.ec', 'Santo Domingo de los Colorados', 'Av. Esmeraldas 221, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '13-08-2022 01:02:39'),
(166, 'Shawarma Said Dubai', '2390043328001', 0, 'Restaurante', 'Calle Venezuela Y Padre Germán Maya', '15:00', '23:59', '10', '0', 'Al Dubai Saeed Rihadh Saeed Ghanem', '1586950788', 'USD - $', 'resto_1593035421.jpg', '0989515981', '-0.2492626195534573', '-79.18161630422973', 'Shawarma', 'dubai@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 119, Santo Domingo, Ecuador', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '04-07-2022 17:45:37'),
(168, 'El Pájaro Rojo', '1723866149', 0, 'Restaurante', 'Av.quevedo Km.3 1/2 Bajo El Hotel El Marquez ', '07:00', '12:00', '20', '0', 'Juan Carlos Quiñones Bravo ', '1587138391', 'USD - $', 'resto_1603313143.jpg', '0992079561', '-0.2725838', '-79.1984557', 'Venta De Encebollados ', 'pajarorojo@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quevedo 3, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 19:01:56'),
(170, 'Cangrejadas Del Guayas ', '1718964172', 0, 'Restaurante', 'Av. 6 De Noviembre Y Juan Eguess', '11:00', '21:45', '20', '0', 'Vanesa Zabala', '1587147237', 'USD - $', 'resto_1587147237.jpg', '0939747147', '-0.256926', '-79.167926', 'Cangrejadas ', 'guayas@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'C. Gomez De La Torre 25, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-04-2022 13:13:50'),
(172, 'Restaurante Laura', '1723187413', 0, 'Restaurante', 'Cooperativa 24 De Septiembre Y Rio Lelia Mz A Lote 14', '07:45', '17:00', '15', '0', 'Laura Andrade ', '1587423005', 'USD - $', 'resto_1610491167.jpg', '0987506204', '-0.2335465', '-79.1794644', 'Bolones, Tigrillo, Café Y Algo Más ', 'laura@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr8c+h6 Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '02-01-2022 22:14:16'),
(174, 'Cafetería Costa Café', '1723149850', 0, 'Restaurante', 'Calle Machala Entre Ibarra Y Túlcan', '07:30', '17:30', '10', '10', 'José Luis Cedeño', '1587428585', 'USD - $', 'resto_1603379674.jpg', '0991591666', '-0.2550821354647504', '-79.16847646446652', 'Desayunos, Bolones ', 'costacafe@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '16-07-2022 01:09:40'),
(176, 'Costa Norte # 2', '2300459548', 0, 'Restaurante', 'Calle Monseñor  Schumacher Y Venezuela ', '10:00', '23:30', '15', '0', 'Rubén Marquinas  ', '1587509609', 'USD - $', 'resto_1604381569.jpg', '0939910523', '-0.249335', '-79.180291', 'Venta De Comida Asados ', 'costanorte2@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr29+7vq, C. Obispo P. Schumacher, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '14-08-2022 14:00:44'),
(180, 'Al Costo', '1723866149', 0, 'Lo Que Sea', 'Av Quito Y Rio Toachi', '08:00', '18:00', '10', '5', 'Milton Bosquez', '1587527148', 'USD - $', 'resto_1587527148.png', '0997888885', '-0.253689', '-79.166843', 'Celulares Y Tecnología', 'alcosto@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Los Tsáchilas 208 Y Padres Dominicos Esquina Teléfonos: (02) 2751-012 / 2751-737, Av. De Los Tsáchilas, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(182, 'Supermercados Don Luis', '1723866149', 0, 'Supermercado', 'Coop 29 De Diciembre', '07:30', '18:00', '10', '0', 'Don Luis', '1587619711', 'USD - $', 'resto_1619732466.jpeg', '0969764774', '-0.258553', '-79.170027', 'Supermercado', 'donluis@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Jose H. Frandin 310, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 19:41:16'),
(184, 'Moros En La Costa ', NULL, 0, 'Restaurante', 'Av. Abraham Calazacón Y Calle La Paz ', '08:00', '20:00', '10', '10', 'Edison De La Cueva', '1587680047', 'USD - $', 'resto_1587680047.png', '0993950909', '-0.251428', '-79.161286', 'Marisquería Y Asados', 'moros@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Cerca De La Escuela Rumiñahui', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(186, 'Mojitos- Resto- Bar', '1723187413', 0, 'Restaurante', ' Av. Rio Lelia Y Calle Los Eucaliptos, Junto A Los Laboratorios Zurita Y Zurita', '17:00', '23:30', '15', '10', 'Gloria Martinez', '1587686605', 'USD - $', 'resto_1610294059.jpg', '0963483518', '-0.2516851744355937', '-79.15232707040575', ' Picadas, Mix De Carnes, Hamburguesas, Alas, Costillas, Nachos, Carnes Rojas, Como Lomo Fino, Chuleta, Y Pollo A La Plancha.', 'restobar@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Pimampiro 208, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '02-10-2021 16:36:35'),
(188, 'Lunettes', '1723866149', 0, 'Lo Que Sea', 'Av Rio Lelia Y Av Quito', '08:00', '18:00', '5', '0', 'Walter Tapia', '1587743204', 'USD - $', 'resto_1587743204.jpg', '0981116075', '-0.247813', '-79.152045', 'Óptica', 'lunette@faster.com.ec', 'onepinpon.com', 'Santo Domingo de los Colorados', 'Qr2x+v5 Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 8, '10-03-2022 19:45:06'),
(190, 'Quinta Campestre', '1723187413', 0, 'Restaurante', 'Via Quininde Km 2', '08:00', '16:00', '15', '10', 'Marina Paz Miniño', '1587744866', 'USD - $', 'resto_1610490222.jpg', '0978907105', '-0.21855', '-79.17205', 'Comida Criolla', 'quinta@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'E20 205, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-07-28 07:45:29'),
(192, 'Chori Dogs', '1723187413', 0, 'Restaurante', 'Aturios Y Lelia', '18:00', '21:30', '10', '0', 'Paul Egas', '1587762352', 'USD - $', 'resto_1609859409.jpg', '0987590954', '-0.248481', '-79.152908', 'Comida Rapida', 'choridogs@faster.com.ec', 'www.choridog.com', 'Santo Domingo de los Colorados', 'Av. Los Anturios 131, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-05-2022 08:25:02'),
(194, 'Chaoping Food', '1722847926001', 0, 'Restaurante', 'Calle 7 Y Rio Zamora', '10:00', '21:30', '15', '10', 'Chaoping David Lo Chávez', '1587932478', 'USD - $', 'resto_1609856906.jpg', '0996438209', '-0.24499999999998476', '-79.15669300859832', 'Comida China', 'chaoping@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Rio Tanti, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '2021-09-01 09:00:02'),
(196, 'El Mundo De Las Carnes ', '1723149850', 0, 'Supermercado', 'Ambato Y Cayambe ', '06:30', '18:30', '10', '10', 'Azucena Larrea ', '1588080552', 'USD - $', 'resto_1609863670.jpg', '0958753544', '-0.25021751936406134', '-79.17148573547364', 'Frigorífico Venta De Cárnicos ', 'mundodelascarnes@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Cayambe &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '13-08-2022 01:20:21'),
(198, 'Santo Pollo', '1707269054', 0, 'Restaurante', '3 De Julio 442 Y Riobamba', '08:00', '18:00', '5', '15', 'Pablo Aurelio Alava Moreira ', '1588100521', 'USD - $', 'resto_1657225852.jpeg', '0967575333', '-0.2525852', '-79.1726656', ' Pollo Asado Al Carbón', 'picho2966@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Carihuarazo Y Babahoyo, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '06-09-2022 10:48:38'),
(200, 'Cheesecake', NULL, 0, 'Panadería', 'Rosales Cuarta Etapa ', '09:00', '18:30', '5', '10', 'Aldahir Valdiviezo', '1588113305', 'USD - $', 'resto_1588113305.jpg', '0960135727', '-0.243791', '-79.182925', 'Postres ', 'cheesecake@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Rosales Cuarta Etapa ', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-07-28 07:45:29'),
(202, 'Cerveza Artesanal Alderete ', '1723866149', 0, 'Licorería', 'Av Yamboya Y Calle 2', '08:00', '17:00', '10', '10', 'Abelardo Alderete', '1588192706', 'USD - $', 'resto_1609855824.jpg', '0986880730', '-0.237191', '-79.158716', 'Cerveza Artesanal', 'alderete@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Coop. 9 De Diciembre, Calle Jerusalen, Entre Estocolmo Y Varsovia, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '22-05-2022 04:33:41'),
(204, 'Rustik', '1723866149', 0, 'Restaurante', 'Direccion: Calle Venezuela Y Padre German Maya Diagonal Al Greenfrost', '15:00', '23:30', '15', '10', 'Mayra Trujilo', '1588200748', 'USD - $', 'resto_1613494761.jpg', '0960137783', '-0.249361', '-79.181759', ' Resto Bar', 'rustik@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 119, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '13-08-2022 01:19:52'),
(208, 'Happy Landia', '1723187413', 0, 'Regalo', 'Quito Entre Ibarra Y Latacunga', '09:00', '18:00', '15', '10', 'Tania Ferrin Moreira', '1588286607', 'USD - $', 'resto_1609867340.jpg', '0997749545', '-0.2414097', '-79.1808815', 'Decoraciones Para Fiestas ', 'happylandia@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Monsenor Shumager, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(210, 'Siafu', '1723866149', 0, 'Licorería', 'Av Jacinto Cortez Jaya', '10:00', '23:59', '10', '10', 'Lisseth Zambrano', '1588349205', 'USD - $', 'resto_1588349205.jpg', '0993622985', '-0.268622', '-79.18299', 'Licoreria', 'siafu@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prj8+qmq, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '29-11-2021 11:19:06'),
(212, 'Bolos Gourmet De Esparta ', '1723866149', 0, 'Restaurante', 'Av La Lorena En Calle Rómulo Betancourt Casa 313', '08:00', '23:00', '5', '10', 'Karina Monar ', '1588366244', 'USD - $', 'resto_1609855208.jpg', '0996017947', '-0.256927', '-79.1596254', 'Michelados Naturales Y De Cerveza\r\nBolos Gourmet\r\nChocobananas\r\nChoco Piña', 'bolosesparta@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. La Lorena 210, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '13-08-2022 01:01:55'),
(214, 'Greenfrost Rosales', '1723866149', 0, 'Restaurante', 'Av Venezuela Y Shumager ', '11:00', '22:30', '5', '0', 'Roberto Jaramillo', '1588440315', 'USD - $', 'resto_1602235998.png', '0969764774', '-0.249277', '-79.181766', 'Heladeria', 'greenfrost@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 119, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 19:44:05'),
(216, 'Guacamole  ', '1721387213', 0, 'Restaurante', ' Avda Quito Y Rio Lelia', '10:00', '21:45', '20', '10', 'Dario Quiroz', '1588555990', 'USD - $', 'resto_1588555990.jpeg', '0987420045', '-0.247412', '-79.15125', 'Comida Mexicana', 'guacamole@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(218, 'La Cueva Del Oso', '1725210270', 0, 'Restaurante', 'Av. Venezuela Y Enrique Tabara, Urbanizacion Los Rosales 1era Etapa Mz1 Casa 4', '16:30', '22:00', '20', '10', 'Paul  Zambrano ', '1588628071', 'USD - $', 'resto_1610289306.jpg', '0984740828', '-0.2489769', '-79.1812913', 'Hot Dog ', 'cuevaoso@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 119, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '02-08-2022 17:39:53'),
(220, 'Frigorifico De Torres', '1723149850', 0, 'Supermercado', 'Calle Cuenca Y 29 De Mayo ', '07:00', '18:00', '20', '10', 'Blanca Enith Quezada Rivas', '1588642171', 'USD - $', 'resto_1609865453.jpg', '0991672871', '-0.253343', '-79.173381', 'Frigorífico', 'torres@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Cuenca 191, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 7, '2021-07-28 07:45:29'),
(222, 'Grill Fest ', '1723187413', 0, 'Restaurante', 'Calle El Porton', '13:00', '20:00', '20', '0', 'Gabriel Suarez ', '1588723938', 'USD - $', 'resto_1609865856.jpg', '0984172275', '-0.23120611098305996', '-79.16482201795196', 'Costillas Bbq ', 'grill@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr9m+fwm, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '11-03-2022 19:49:14'),
(224, 'Parrillada Brasero', '1723866149', 0, 'Restaurante', 'Av Venezuela Y Shumager', '15:00', '22:30', '20', '0', 'Luis Jaramillo', '1588724717', 'USD - $', 'resto_1588724717.jpg', '0981066110', '-0.249371', '-79.182096', 'Parrillada', 'brasero@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 120, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-03-2022 10:52:40'),
(226, 'Pollo Papi Pura Lisa ', '1723866149', 0, 'Restaurante', 'Av.venezuela ', '17:00', '22:30', '20', '10', 'Jorge Cardenas ', '1588731792', 'USD - $', 'resto_1610489434.jpg', '0999581999', '-0.24933428656324144', '-79.18315977784701', 'Papi Pollos ', 'puralisa@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr28+8p5, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '17-07-2022 16:44:09');
INSERT INTO `fooddelivery_restaurant` (`id`, `name`, `dni`, `city_id`, `type_store`, `address`, `open_time`, `close_time`, `delivery_time`, `commission`, `store_owner`, `timestamp`, `currency`, `photo`, `phone`, `lat`, `lon`, `desc`, `email`, `website`, `city`, `location`, `is_active`, `del_charge`, `enable`, `session`, `status`, `ally`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`, `sequence`, `edit_id`, `edit_date_time`) VALUES
(228, 'Viva Parrilla', '1723149850', 0, 'Restaurante', 'Av Río Lelia Y Galo Luzuriaga Esq', '15:00', '23:00', '20', '10', 'Silvana Rosero', '1588785893', 'USD - $', 'resto_1588785893.jpg', '0994830161', '-0.248526', '-79.152707', 'Resto  Bar  Grill', 'viva@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2w+jw4, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '30-07-2022 01:03:15'),
(230, 'Artesano Gourmet', '1723187413', 0, 'Restaurante', 'Calle Guayaquil', '11:00', '22:00', '10', '10', 'Raquel Bermudez', '1588803395', 'USD - $', 'resto_1609854972.jpg', '0996860624', '-0.252106', '-79.207363', 'Empanadas Y Platos Fuertes ', 'artesanogourmet@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Ernesto Pinto, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(232, 'Restaurant La Hueca 3', '1723866149', 0, 'Restaurante', 'Avenida Venezuela Y Schumajer ', '11:50', '22:00', '20', '10', 'Javier Ramirez', '1588976782', 'USD - $', 'resto_1604347210.jpg', '0994640259', '-0.249282', '-79.180457', 'Asados \r\nPollos Apanados\r\nPescado Frito Y Al Vapor \r\nCamaron Apanado', 'hueca3@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Obispo P. Schumacher 735y, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '13-03-2022 11:54:23'),
(234, 'La Taberna', '1723866149', 0, 'Licorería', 'Av Quito Y Pallatanga', '13:30', '21:30', '10', '0', 'Ricardo Burbano', '1588984163', 'USD - $', 'resto_1610289969.jpg', '0982035304', '-0.25115', '-79.163693', 'Licoreria', 'taberna@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '11-03-2022 19:49:50'),
(236, 'Super Paco', '1723149850', 0, 'Lo Que Sea', 'Av Quito Y Abrahan Calazacon', '08:30', '20:00', '10', '0', 'Diego', '1589227419', 'USD - $', 'resto_1602316200.png', '0986854916', '-0.248786', '-79.161821', 'Papelería Y Tecnología', 'superpaco@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2q+f7 Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 14:45:07'),
(238, 'Papas D\'bronkis', '1721387213001', 0, 'Restaurante', 'Coop :29 De Diciembre ', '16:00', '23:59', '20', '10', 'Katherine Aguirre', '1589322317', 'USD - $', 'resto_1601598963.jpg', '0939330243', '-0.2592542', '-79.1705299', 'Papi Pollos ', 'bronkis@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Federico Gonzalez Suarez 100, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(240, 'Comida Rápida 3 Hermanos', '1723866149', 0, 'Restaurante', 'Av. Quito Y Río Mulaute', '17:00', '23:59', '20', '10', 'Jorge Noblecilla', '1589324726', 'USD - $', 'resto_1604380148.jpg', '0980793833', '-0.2504480557195397', '-79.16317676673667', 'Comidas Rapidas ', '3hermanos@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 0, '12-09-2022 02:30:02'),
(242, 'La Castellana', '1723187413', 0, 'Restaurante', 'Av Guayaquil Y Av Abrahan Calazacon', '11:00', '14:30', '10', '0', 'Pendiente', '1589382386', 'USD - $', 'resto_1610288835.jpg', '0985494782', '-0.249507', '-79.163227', 'Restaurante Gourmet', 'castellana@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Guayaquil 102, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 14:47:20'),
(244, 'Jeffer\'s Burger', '1721387213', 0, 'Restaurante', 'Cerca Centenario', '15:00', '21:30', '20', '10', 'Jefferson Alava', '1589392864', 'USD - $', 'resto_1610288583.jpg', '0997600539', '-0.2366647', '-79.1654101', 'Hamburguesas', 'burger@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-07-28 07:45:29'),
(246, 'Shushu Tenka ', '1723866149', 0, 'Lo Que Sea', 'Av. Esmeraldas Y Zamora', '09:00', '18:00', '15', '10', 'Dapne Barros', '1589407995', 'USD - $', 'resto_1589407995.jpg', '0983388227', '-0.2431944', '-79.1717483', 'Mascotas', 'tenka@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Rio Zamora 103, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'NO', 'YES', 'NO', 'NO', 0, 6, '2021-09-01 09:00:02'),
(248, 'Costa Norte # 5', '1723866149', 0, 'Restaurante', 'Av. Abraham Calazacon Y Río Toachi.', '10:30', '23:00', '20', '0', 'Denisse Vinueza', '1589413197', 'USD - $', 'resto_1604380907.jpg', '0994986939', '-0.2631171', '-79.1643494', 'Asados ', 'costanorte5@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', '1 De Mayo 206, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '16-06-2022 13:58:07'),
(250, 'Mega Empanada', '1724715220', 0, 'Restaurante', 'Calle Cocaniguas Y Ruilova', '10:00', '22:00', '20', '0', 'Cristina Tapia', '1589423512', 'USD - $', 'resto_1610292425.jpg', '0994879587', '-0.25037198894052937', '-79.16724343839266', 'Empanadas', 'empanada@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Cocaniguas 105, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '24-03-2022 23:03:46'),
(252, 'Esquina De Ales Pambiles ', '1721387213', 0, 'Restaurante', 'Pambiles ', '14:00', '22:30', '20', '0', 'Javier Veliz', '1589482616', 'USD - $', 'resto_1603395392.jpg', '022763756', '-0.2631044', '-79.1647121', 'Venta De Pollo Asado ', 'esquinaales@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón 2910, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:00:34'),
(254, 'Chifa Central', '1723866149', 0, 'Restaurante', 'Av. Venezuela ', '11:00', '23:00', '20', '8', 'Liu Genwei', '1589844134', 'USD - $', 'resto_1609858872.jpg', '0968666688', '-0.249311', '-79.182223', 'Chaulafan ', 'central@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr29+843, Venezuela, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '31-08-2022 18:34:23'),
(256, 'Kiwilimón Av Chone', '1723866149', 0, 'Restaurante', 'Av Chone Y Av Jacinto Cortez', '11:00', '21:00', '5', '10', 'Hugo Luna', '1589847880', 'USD - $', 'resto_1603392787.jpg', '0963190016', '-0.255258', '-79.185592', 'Heladeria', 'kiwichone@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Jacinto Cortéz Jhayya 100, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '08-07-2022 23:53:27'),
(258, 'Rincon Del Cuy ', '1718638099', 0, 'Restaurante', 'Calle Ambato Y Cayambe ', '08:00', '22:00', '20', '10', 'Jenny Bautista', '1590026523', 'USD - $', 'resto_1602865411.jpg', '0960444567', '-0.2502578', '-79.1717109', 'Cuy Asado', 'rincondelcuy@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Ambato 806, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(260, 'La Casa De Las Ofertas ', '1721387213', 0, 'Lo Que Sea', 'Avda Quito ', '08:30', '18:00', '15', '10', 'Luis Moncayo ', '1590029172', 'USD - $', 'resto_1602519293.jpg', '0986380434', '-0.2456469', '-79.1523752', 'Ropa Bebes,niños,niñas,damas, Caballeros', 'ofertas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Satelite, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 6, '2021-09-01 09:00:02'),
(262, 'Panadería La Mejor ', '1723866149', 0, 'Restaurante', 'Abraham Calazacón Y 6 De Noviembre', '07:00', '22:00', '10', '8', 'Leydi Duque', '1590181803', 'USD - $', 'resto_1602865577.jpg', '0999345198', '-0.2577287', '-79.1612784', 'Panadería ', 'lamejor@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '23-07-2022 03:51:36'),
(264, 'Piki Sabroso Y Divertido', '1723149850', 0, 'Restaurante', 'Avda Abrahan Calazacon Y La Chone ', '10:00', '20:00', '20', '0', 'Sulay Lozano ', '1590282747', 'USD - $', 'resto_1610297633.jpg', '0999590591', '-0.2549634277820587', '-79.18401336669922', 'Pollo', 'piki@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Chone, Km 1 Y Medio Y, Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '29-12-2021 16:19:41'),
(266, 'Luigi Electric', NULL, 0, 'Publicidad', 'Santa Maria', '07:00', '22:00', '10', '0', 'Luigi Bermeo', '1590441562', 'USD - $', 'resto_1590441562.jpg', '0993560275', '-0.264132', '-79.175160', 'Electricidad Y Seguridad', 'luigi@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Santa Maria', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 20, NULL, NULL),
(268, 'Scanner Express', NULL, 0, 'Publicidad', 'Luis Cordero Y Antonio Ante', '08:00', '20:00', '10', '0', 'Cristian Palma', '1590442146', 'USD - $', 'resto_1590442146.jpg', '0999194590', '-0.258041', '-79.177247', 'Implementación De Sistemas De Seguridad. Análisis De Riesgo, Asistencia Técnica', 'palma@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Luis Cordero Y Antonio Ante', 0, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 24, NULL, NULL),
(270, 'Natubrak', '1721387213', 0, 'Restaurante', 'Abraham Calazacón', '12:00', '22:00', '20', '0', 'Patricio Ayala', '1590593625', 'USD - $', 'resto_1602865769.jpg', '0962629262', '-0.248244', '-79.163431', 'Yogur Y Helado', 'natubrak@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Rio Cochambi 94, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(272, 'Pizza Napoli', '1716571979', 0, 'Restaurante', 'Calle Pallatanga Y Echandía', '11:00', '22:30', '20', '0', 'Luis Romero Gutiérrez', '1590603058', 'USD - $', 'resto_1607002066.jpg', '0992432257', '-0.2521726', '-79.1624627', 'Pizzería ', 'pizzanapoli@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prxq+33f, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:00:48'),
(274, 'Blue Dreams ', '1723187413', 0, 'Restaurante', 'Urb. Banco De Fomento ', '10:00', '20:00', '20', '0', 'Lilette Lugo', '1590614926', 'USD - $', 'resto_1605196526.jpg', '0994546323', '-0.248607', '-79.151449', 'Sanduches ', 'bluedreams@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Los Anturios Y Río Lelia, Av. Río Lelia, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 5, '14-03-2022 15:14:40'),
(276, 'Chuzo Loco', '1718761842001', 0, 'Restaurante', 'Calla Abdón Calderón Y C.j. Pio Montufar ', '17:00', '23:00', '10', '0', 'Belen Villavicencio', '1590619775', 'USD - $', 'resto_1603757601.jpg', '0979810275', '-0.25666318465170246', '-79.17985786184978', 'Asados ', 'chuzoloco@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. J. De Salinas 102, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 15:15:52'),
(278, 'Cafetería El Goloso', '1708817562001', 0, 'Restaurante', 'Urb. Banco De Fomento Y Av. Río Lelia', '08:30', '21:30', '20', '10', 'Maribella Navarrete ', '1590626083', 'USD - $', 'resto_1603758091.jpg', '022710992', '-0.248529', '-79.152196', 'Cafetería', 'goloso@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 114, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-07-28 07:45:29'),
(280, 'Lagarto Burgers', '1723866149', 0, 'Restaurante', 'Av. Chone Frente A Hosteria Mi Cuchito', '17:00', '23:59', '20', '15', 'Mario Mantilla Muñoz', '1590696368', 'USD - $', 'resto_1603915033.jpg', '0991154019', '-0.254514', '-79.194944', 'Hamburguesas Y Papas ', 'lagarto@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prw4+62p, Av. Chone, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 0, '12-09-2022 00:30:01'),
(282, 'Wafles Y Crepes Lorena', '1724715220', 0, 'Restaurante', 'Avda La Lorena ', '12:00', '22:00', '20', '10', 'Luis Alberto Muñoz', '1590704049', 'USD - $', 'resto_1603733218.jpeg', '0963519916', '-0.2557898', '-79.1567016', 'Wafles Y Crepes ', 'wafles@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prvv+m9j, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '23-07-2022 19:33:30'),
(284, 'Cafeteria Tamal Lojano', '1104535792001', 0, 'Restaurante', 'Avda Rio Lelia', '17:00', '22:00', '10', '0', 'Andres Poma ', '1590770992', 'USD - $', 'resto_1603915107.jpg', '0998138166', '-0.24941115081310272', '-79.15231323242188', 'Desayunos ', 'tamal@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2x+53w, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:20:56'),
(288, 'Restaurante 5ta Avenida', '1723866149', 0, 'Restaurante', 'Lapaz Y Avenida Río\r\nYamboya. Urbanización Coromoto. Diagonal A La Gallera De Santo\r\nDomingo ', '18:00', '21:00', '15', '0', 'Jorge Santana ', '1590783565', 'USD - $', 'resto_1603982516.jpg', '0988395048', '-0.2494249', '-79.1588586', 'Empanadas, Corviches, Torta De Choclo, Tostones, Alitas De Pollo, Papas Fritas Artesanales ', 'avenida@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2r+998, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '08-06-2022 15:58:54'),
(290, 'La Flaca', '1723866149', 0, 'Restaurante', 'Calle Venezuela, Junto A La Piedra ', '15:00', '23:00', '20', '5', 'Emily Uvidia', '1590799175', 'USD - $', 'resto_1590799175.jpg', '0986764349', '-0.24928254953835774', '-79.18134255692101', 'Comidas Rápidas', 'laflaca@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 114, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(292, 'Wafles Y Crepes  Rosales', '1723866149', 0, 'Restaurante', 'Av. Venezuela Los Rosales Primera Etapa', '15:00', '23:00', '20', '10', 'Luis Alberto Muñoz', '1590858132', 'USD - $', 'resto_1603733250.jpeg', '0963519916', '-0.249295', '-79.181149', 'Wafles Y Crepes ', 'waflesrosales@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 114, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '23-07-2022 19:33:03'),
(294, 'Don Pollo', '1723866149', 0, 'Restaurante', 'Juan León Mera, Av. Quevedo', '11:50', '22:00', '10', '0', 'Sebastian Lara', '1590858740', 'USD - $', 'resto_1603982441.jpg', '0969990890', '-0.26010051369667053', '-79.18340301513672', 'Pollo Asado ', 'donpolloquevedo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quevedo 888, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:29:33'),
(296, 'Wafles Y Crepes Sucursal 2', '1723866149', 0, 'Restaurante', 'Av, Quito, Diagonal A Green Frots', '12:00', '22:00', '20', '10', 'Luis Alberto Muñoz', '1590883426', 'USD - $', 'resto_1590883426.jpeg', '0963519916', '-0.24731920531656684', '-79.15140687811754', 'Wafles Y Creppes', 'waffleszonarosa@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '23-07-2022 19:32:11'),
(298, 'American Deli', '1721387213', 0, 'Restaurante', 'Paseo Shopping Santo Domingo', '10:00', '22:00', '20', '0', 'Whelter Cañizalez', '1590968496', 'USD - $', 'resto_1603722778.jpg', '0986866675', '-0.248488', '-79.161123', 'Comida Tradicional Americana', 'americandeli@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2q+gp4, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:30:18'),
(300, 'Sherwin Williams', NULL, 0, 'Publicidad', 'Av Chone Y Av Shumager', '08:00', '18:00', '10', '0', 'Carlos Gaibor', '1591032078', 'USD - $', 'resto_1591032078.jpg', '0985425580', '-0.254894', '-79.179762', 'Ejecutivo De Cuentas Claves ', 'cgaibor@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Chone Y Av Shumager', 0, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 23, NULL, NULL),
(302, 'Taurus Security', NULL, 0, 'Publicidad', 'Av Jacinto Cortez Jhayya', '08:00', '18:00', '10', '0', 'Luis Zambrano', '1591033531', 'USD - $', 'resto_1591033531.jpg', '0997732985', '-0.277167', '-79.183476', 'Istalacion De Alarmas, Cctv, Cercos Electricos', 'taurusmatriz13@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Jacinto Cortez Jhayya', 0, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 25, NULL, NULL),
(304, 'Server', NULL, 0, 'Publicidad', 'Av Quevedo Y De Los Araucanos', '08:00', '18:00', '15', '0', 'Santiago Samaniego', '1591040436', 'USD - $', 'resto_1591136137.jpg', '0959271082', '-0.268440', '-79.194373', 'Servicio Publicitario', 'info@agenciaserver.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Quevedo Frente Ambacar', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 21, NULL, NULL),
(308, 'Encebollados Poseidon ', '1723187413', 0, 'Restaurante', 'Avda Venezuela ', '07:00', '12:30', '15', '0', 'Melany Jaramillo ', '1591132369', 'USD - $', 'resto_1604698370.jpg', '0995104034', '-0.2493331879377365', '-79.18463134765625', 'Encebollados ', 'poseidon@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 217, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:46:17'),
(310, 'Frank Vera', NULL, 0, 'Publicidad', 'Av 29 De Mayo Y Tulcán', '08:00', '19:00', '10', '0', 'Francisco Vera', '1591136973', 'USD - $', 'resto_1591136973.jpg', '0989253288', '-0.253926', '-79.169373', 'Producciones & Eventos', 'frank@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av 29 De Mayo Y Tulcán', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 22, NULL, NULL),
(312, 'Verduras Martha Y  Chivita ', '1723866149', 0, 'Supermercado', 'Mercado 29 De Diciembre ', '07:00', '17:00', '20', '5', 'Martha Tulpa ', '1591196759', 'USD - $', 'resto_1629389397.jpg', '0981048822', '-0.25832', '-79.170102', 'Frutas Y Verduras ', 'verduraschivita@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Tulcán Y Jose Frandin 308, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '13-09-2021 10:24:34'),
(314, 'Rotu Mark ', NULL, 0, 'Publicidad', 'Calle Pedro Saad Herreria Y Os', '08:00', '18:00', '10', '0', 'Ricardo Sanchez', '1591204324', 'USD - $', 'resto_1591204324.jpg', '0980975540', '-0.272335', '-79.183180', 'Diseñador Grafico', 'rotu@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Pedro Saad Herreria Y Os', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 19, NULL, NULL),
(316, 'Lynda Store', '1723149850', 0, 'Lo Que Sea', 'Calle Simón Bolívar Y Benito Juárez', '07:00', '22:00', '10', '5', 'Erika Tipan', '1591248866', '', 'resto_1602228149.png', '0939641160', '-0.2621204', '-79.1610098', 'Cosmeticos Y Más', 'lynda@faster.com.ec', 'lynda.com.ec', 'Santo Domingo de los Colorados', 'Miguel Asturias, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-08-11 09:00:01'),
(320, 'Costa Norte 4 ', '0909402323001', 0, 'Restaurante', 'Calle Pedro Vicente Maldonado Y Antonio José De Sucre', '07:30', '21:30', '20', '10', 'Ruben Marquines', '1591393422', 'USD - $', 'resto_1605196637.jpg', '0960002103', '-0.2554495', '-79.1776344', 'Asados ', 'costanorte4@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Antonio José De Sucre 115-107, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 6, '2021-07-28 07:45:29'),
(322, 'Fruits Y Coffe', '1723866149', 0, 'Restaurante', 'Av.quito Y Calle Pallatanga Frente Al Banco Machala', '10:00', '19:00', '15', '10', 'Xavier Cardenas', '1591478727', 'USD - $', 'resto_1603380380.jpg', '0980472032', '-0.2550828153485285', '-79.16832424040602', 'Helados ', 'fruitscoffe@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '16-07-2022 01:12:52'),
(324, 'Conchal Chabelita', '1724715220', 0, 'Restaurante', 'Calle Latacunga Y Av.29 De Mayo', '08:30', '15:00', '20', '0', 'Ángel Rodríguez', '1591498085', 'USD - $', 'resto_1603380893.jpg', '0958961202', '-0.253514', '-79.171065', 'Ceviches Y Encebollados', 'conchal@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. 29 De Mayo 606, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:49:40'),
(326, 'Rosapastel', '1724715220', 0, 'Regalo', 'Av. Clemencia De Mora Y Río Puyango', '10:00', '17:00', '20', '10', '10', '1591582306', 'USD - $', 'resto_1605196662.jpg', '0993210860', '-0.245415', '-79.171308', 'Regalos', 'rosapastel@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Clemencia De Mora 222, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(328, 'La Negra', '1759779752', 0, 'Restaurante', 'Calle Río Yanuncay Y Av. Las Delicias Detras Del Hospital Gustavo Dominguez', '15:00', '22:30', '20', '0', 'Yosmari García', '1591725384', 'USD - $', 'resto_1605220212.jpg', '0978817213', '-0.2464445', '-79.1606725', 'Tacos, Burritos, Botanas ,quesadillas,burritos Tijuanas.', 'lanegra@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3q+9p, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '16-08-2022 14:59:56'),
(330, 'Hornado 5 Delicias ', '1723187413', 0, 'Restaurante', 'Av. Tsachila Y Portoviejo', '08:30', '17:00', '20', '0', 'Olinda Quishpi', '1591743877', 'USD - $', 'resto_1605536856.jpg', '0989988122', '-0.25081', '-79.168226', 'Hornados ', '5delicias@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. De Los Tsáchilas 545, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:54:50'),
(332, 'Todo Bb Be', '1723187413', 0, 'Farmacia', ' Coop. 9 De Diciembre, Calle Londres Y Jerusalén', '08:00', '18:00', '10', '5', 'Diana Pilay', '1591823235', 'USD - $', 'resto_1604698424.jpg', '0992452919', '-0.244207', '-79.159429', 'Pañaleria ', 'todobb@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Jerusalén, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(334, 'Loex', '1723866149', 0, 'Restaurante', 'Av Abrahan Calazacon Y Av Esmeraldas', '07:00', '19:00', '10', '0', 'Israel Tejada', '1591834898', 'USD - $', 'resto_1603746816.jpg', '0980460496', '-0.239006', '-79.167244', 'Loja Express Cafeteria', 'loex@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Sector Zona Rosa Frente A Banco Pichincha, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 15:54:55'),
(338, 'Crepes De Casa Nutella', '1759073156001', 0, 'Restaurante', 'Av. Clemencia De Mora Y Río Puyango', '11:00', '22:00', '20', '10', 'Saleh', '1591976754', 'USD - $', 'resto_1591976754.png', '0212098701', '-0.245561', '-79.171254', 'Creppes', 'crepesnutella@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Clemencia De Mora 222, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(340, 'Deli Kitchen ', '1723187413', 0, 'Supermercado', 'Calle Tiputini Y Av. Esmeraldas', '08:00', '20:00', '20', '10', 'Jorge Anibal Flores Taco', '1592014124', 'USD - $', 'resto_1605537087.jpg', '0987275679', '-0.247169', '-79.175137', 'Parrilladas (listas Para Realizar El Asado)', 'delikitchen@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Esmeraldas 465, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(342, 'Ibrandi', '1723866149', 0, 'Farmacia', 'Rio Toachi Y Rio Pilaton', '08:00', '22:00', '15', '0', 'Adriana Ormaza', '1592234007', 'USD - $', 'resto_1605537113.jpg', '0969764774', '-0.254146', '-79.165922', 'Medicina', 'ibrandi@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Río Toachi 200, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '10-03-2022 19:42:35'),
(344, 'Licorería Alcalu', '1724715220', 0, 'Licorería', 'Ciudad Nueva Calle Vicente Espinoza', '07:00', '23:59', '15', '5', 'Luis Fidel Palacios BarragÁn', '1592240403', 'USD - $', 'resto_1605537205.jpg', '0959507381', '-0.249574565013865', '-79.19738604836273', 'Licores', 'alcalu@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. BombolÍ 1603, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '27-05-2022 09:27:42'),
(346, 'Choclo Mix D\'jaime', NULL, 0, 'Restaurante', 'Av Zamora Y Av Esmeraldas', '16:00', '22:30', '10', '10', 'Jaime', '1592252826', 'USD - $', 'resto_1592252826.jpg', '0969696900', '-0.243589', '-79.170911', 'Comida Rapida', 'jaime@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Zamora Y Av Esmeraldas', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(348, 'Quality', '0952322451', 0, 'Lo Que Sea', 'Av. Arroyo Robelly  Y Peralta ', '07:00', '22:00', '15', '10', 'Pablo Aguirre', '1592420910', 'USD - $', 'resto_1610489922.jpg', '0985494782', '-0.2594343', '-79.1700559', 'Productos De Limpieza ', 'quality@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(350, 'The Old Bike', '1723866149', 0, 'Transporte', 'Av Quito Y Lelia', '08:30', '18:15', '15', '0', 'Bryan Tamayo', '1592432786', 'USD - $', 'resto_1592432786.jpg', '0994532904', '-0.246953', '-79.150309', 'Alquiler De Bicicletas', 'bike@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito 113, Santo Domingo, Ecuador', 0, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 15:58:45'),
(352, 'Servi - Alum', NULL, 0, 'Publicidad', 'Asistencia Municipal', '08:00', '18:00', '30', '0', 'Luis Chuquilla', '1592436716', 'USD - $', 'resto_1592436716.jpeg', '0985501019', '-0.267240', '-79.162672', 'Tecnología En Aluminio Y Vidrio', 'servi@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Asistencia Municipal', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 18, NULL, NULL),
(356, 'Sophymell', '2350344301', 0, 'Regalo', 'Urb. Senya\r\nAv. La Lorena', '06:00', '18:00', '20', '5', 'Johanna Holguin', '1592439516', 'USD - $', 'resto_1592439516.jpg', '0994540042', '-0.256539', '-79.141795', 'Desayunos Personalizados Pedidos Con 1 Día De Anticipación', 'sophymell@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(360, 'Encomienda Local', '1723866149001', 0, 'Transporte', 'Coop 29 De Diciembre', '07:00', '23:30', '20', '0', 'Jose Luis Baque Burgos', '1592442881', 'USD - $', 'resto_1595040472.jpg', '0989595926', '-0.259391', '-79.16995', 'Mensajeria Express Todos Los Dias', 'mensajeria@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '01-09-2022 14:48:24'),
(362, 'Pide Lo Que Sea', '1723866149001', 0, 'Lo Que Sea', 'La Concordia', '07:30', '22:00', '15', '0', 'Faster', '1592622424', 'USD - $', 'resto_1603139430.jpg', '0989595926', '0.005202', '-79.397828', 'Puedes Pedir Lo Que Tu Quieras', 'loqueseaconcor@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'E20 7-24, La Concordia, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(364, 'Kiwilimón', '1706476726001', 0, 'Restaurante', 'La Concordia Av. Simon Plata Torres Y Calle Guayas ', '11:00', '20:00', '15', '10', 'Alba Roa Huertas', '1592661629', 'USD - $', 'resto_1592870000.jpg', '0982037832', '0.007381', '-79.39834', 'Helados ', 'kiwiconcordia@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'E20 940, La Concordia, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(366, 'Rincon De Alex', '0801915992', 0, 'Restaurante', 'Av Simon Plata Torres Y Calle Paris', '10:30', '21:15', '15', '0', 'Patricio Rojas', '1592689289', 'USD - $', 'resto_1592689289.jpg', '0980415387', '0.008571', '-79.398948', 'Asaderos De Pollo', 'rincondealex@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'Av Simon Plata Torres Y Calle Paris', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(368, 'Mundo Del Pañal ', '2300551377', 0, 'Farmacia', 'Av. Abrahan Calazacon ', '08:00', '18:00', '15', '5', 'Joann Israel Villarreal Sanchez ', '1592692186', 'USD - $', 'resto_1605537595.jpg', '0967097522', '-0.263212', '-79.163032', 'Pañaleria ', 'mundo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Camino A Rio Verde 104, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 9, '2021-09-01 09:00:02'),
(370, 'La Tablita Express', '1711537231001', 0, 'Restaurante', 'Av Simon Plata Torres', '08:00', '21:00', '10', '0', 'Alicia Salinas', '1592860477', 'USD - $', 'resto_1592860477.jpg', '0983252325', '0.004890', '-79.397365', 'Asados', 'tablitaexpress@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'Av Simon Plata Torres', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(372, 'Sweet Land Río Lelia', '0702996299001', 0, 'Panadería', 'Av. Río Lelia ', '10:00', '19:30', '20', '15', 'Fernando Romero', '1593015164', 'USD - $', 'resto_1646440650.jpg', '0959834993', '-0.247965', '-79.152156', 'Cafetería Y Pastelería', 'sweetlandlelia@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '30-07-2022 01:01:27'),
(374, 'Pizzeria D\'rubens', '1720500105001', 0, 'Restaurante', 'Direccion: Av. 10 De Agosto Y Manabi', '10:00', '22:00', '15', '0', 'Ruben Eduardo Macias Gaibor ', '1593018739', 'USD - $', 'resto_1593018739.jpg', '0993464570', '0.004725', '-79.398528', 'Pizzas', 'rubens@faster.com.ec', 'www.faster.com.ec', 'La Concordia', '10 De Agosto Y Manabi', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(376, 'Monalisa', '1720394269001', 0, 'Lo Que Sea', ' Av Quito Y Oranzonas Diagonal A La Clinica Santiago', '09:00', '18:00', '15', '5', 'Gabriela Estefania Zenteno Freire ', '1593124582', 'USD - $', 'resto_1605537626.jpg', '0939174190', '-0.254757', '-79.175257', 'Cosmeticos ', 'monalisa@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito 123, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 6, '2021-09-01 09:00:02'),
(380, 'Restaurante Chachita', '1313020529001', 0, 'Restaurante', 'Av. Simon Plata Torres Y Martinica', '08:00', '17:00', '20', '0', 'David Lopez Vargas', '1593444821', 'USD - $', 'resto_1593444821.jpg', '0991395551', '0.0003026', '-79.3951878', 'Mariscos', 'chachita@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'Av. Simon Plata Torres Y Martinica', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(382, 'Manaos', '1759081225', 0, 'Restaurante', 'Av. Abraham Calazacón Zona Rosa', '16:00', '23:59', '20', '0', 'Jessica  Campos', '1593538495', 'USD - $', 'resto_1605219532.jpg', '0979131581', '-0.239183', '-79.165312', 'Comida Colombiana, Shawaermas Y Más', 'manaos@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr6m+9xh, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 16:10:19'),
(384, 'Encomienda', '1723866149', 0, 'Publicidad', 'Arrollo Robelly 359 Y Peralta', '06:00', '22:00', '30', '0', 'Faster Logistica Y Courier', '1593547062', 'USD - $', 'resto_1593547062.jpg', '0985494782', '-0.259451', '-79.169976', 'Paqueteria Pequeña Y Mediana', 'encomienda@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Coop 29 De Diciembre', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 13, NULL, NULL),
(386, 'Los Encebollados De Jessy ', '1718794421', 0, 'Restaurante', 'Los Rosales 4ta Etapa Pasaje Leonardo Tejada Y Río Chila', '07:00', '13:00', '10', '10', 'Jessica Castro', '1593610800', 'USD - $', 'resto_1593610800.jpg', '0997159714', '-0.2426525', '-79.1852586', 'Encebollados ', 'jessy@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Anillo Vial, Los Rosales, Redondel De La Virgen Calle Fray Pedro Bedón Y, Av. Rio Chila, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(388, 'Nápoles Pizza ', '1718794421', 0, 'Restaurante', ' Los Rosales 4ta Etapa Pasaje Leonardo Tejada Y Río Chila', '15:00', '21:30', '10', '10', 'Jessica Castro', '1593617355', 'USD - $', 'resto_1610295393.jpg', '0997159714', '-0.2426525', '-79.1852586', 'Pizza', 'napoles@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Luis Moscoso 12, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-07-28 07:45:29'),
(390, 'El Mañanero', '1722849484001', 0, 'Restaurante', 'Av. Abraham Calazacón Y Jaime Andrade Marín ', '07:00', '18:15', '20', '10', 'Shirley Vargas ', '1593620671', 'USD - $', 'resto_1593620671.jpg', '0990371169', '-0.242702', '-79.183132', 'Desayunos, Almuerzos Y Meriendas', 'desayunos@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Jaime Andrade Marin, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-07-28 07:45:29'),
(392, 'Mio Detalles', '1723866149', 0, 'Publicidad', 'Carlos Arroyo Del Rio E Isidro Ayora', '09:00', '19:00', '30', '0', 'Mio Detalles', '1593709300', 'USD - $', 'resto_1593709300.jpeg', '0987163546', '-0.259292', '-79.183248', 'Detalles Y Reposteria', 'mio@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Via Quevedo Km 1', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 15, NULL, NULL),
(394, 'Importadora Cellmax', '0802189639', 0, 'Lo Que Sea', 'Calle Tulcan Y Machala ', '08:00', '18:00', '20', '0', 'Diego Sampedro', '1593821210', 'USD - $', 'resto_1610287452.jpg', '0985863633', '-0.2531', '-79.169153', 'Repuestos, Accesorios Y Telefonia', 'cellmax@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Tulcán 1016, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 8, '10-03-2022 19:43:19'),
(396, 'Dolupa', '0923275051001', 0, 'Panadería', 'Av. Quito: 12-36 Y Río Chimbo', '09:00', '17:00', '15', '0', 'Tatiana Lisseth Alvarez Meregildo', '1593874937', 'USD - $', 'resto_1593874937.jpg', '022713445', '-0.251198', '-79.163845', 'Pasteleria ', 'dolupa@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prxp+ffv, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 17:14:27'),
(398, 'Rollis Heladeria', '0801455163', 0, 'Restaurante', ' Primero De Mayo Y Eloy Alfaro', '15:00', '20:00', '20', '0', 'Marlene Loaiza', '1594142081', 'USD - $', 'resto_1594142081.jpg', '0994653839', '0.005017', '-79.399007', 'Helados ', 'rollis@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'Esquinero, Frente A La Iglesia Católica Matriz Santa Teresita, Por El Parque', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-09-01 09:00:02'),
(400, 'La Pollería ', '1314645274001', 0, 'Restaurante', 'Pasaje Antonio Bellolio, Santo Domingo', '10:00', '20:00', '40', '10', 'Jesús Alfredo Giler Moncayo  ', '1594156023', 'USD - $', 'resto_1594156023.jpg', '0958708093', '-0.2445712', '-79.1841178', 'Pollos Y Pavos  Al Horno \r\n', 'polleria@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Pasaje Antonio Bellolio, Santo Domingo', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(402, 'Greenfrost', '2100040175', 0, 'Restaurante', '10 De Agosto Y 1 De Mayo ', '10:30', '21:00', '15', '0', 'Pendiente', '1594225518', 'USD - $', 'resto_1594225518.jpg', '0980426906', '0.00463', '-79.398421', 'Helados ', 'frost@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'Manabi, La Concordia, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 0, '2021-09-01 09:00:02'),
(404, 'Chef Danny', '1720714268', 0, 'Restaurante', 'Coop. Ierac 69. José Martín Y Simón Bolívar', '16:30', '22:30', '20', '10', 'Danny Palomino', '1594301961', '', 'resto_1648173770.png', '0939815253', '-0.2640455442048254', '-79.15995201653288', 'Comida Rápida: Alitas, Hamburguesas, Pinchos Y Mas', 'chefdanny@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Jose Marti 501, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'NO', 'YES', 'YES', 'NO', 'YES', 0, 10, '30-03-2022 07:28:27'),
(406, 'Panas Burguer', '1721387213', 0, 'Restaurante', 'Los Unificados ', '16:00', '22:00', '19', '10', 'Mayerling Faudito', '1594311564', 'USD - $', 'resto_1610295844.jpg', '0984084220', '-0.2619938', '-79.1586069', 'Papi Pollos ', 'burguer@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Jorge Luis Borges 419, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 16, '2021-09-01 09:00:02'),
(408, 'Iqueza', '1720619764001', 0, 'Lo Que Sea', 'Av. Puyo Y Loja', '08:00', '18:00', '15', '0', 'Intriago Quezada Hugo Jose', '1594318042', 'USD - $', 'resto_1594318042.jpg', '0967132154', '-0.25055', '-79.173532', 'Varios', 'iqueza@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Puyo 547, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 17:14:52'),
(410, 'Café Vilbaque', '1723866149', 0, 'Supermercado', 'Calle Arrollo Robelly Y Peralta', '07:00', '22:00', '5', '0', 'Javier Baque', '1594334421', 'USD - $', 'resto_1594334421.jpg', '0969764774', '-0.259697', '-79.170004', 'Café', 'cafe@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 420, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(412, 'Calzado Carlín', '2390010845001', 0, 'Supermercado', ' Av. 29 De Mayo Y Tulcán ', '09:00', '18:00', '15', '0', ' Karla Oñate Mera', '1594336829', 'USD - $', 'resto_1609855566.jpg', '0988804804', '-0.254048', '-79.169196', 'Zapatos ', 'carlin@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prwj+986, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '06-06-2022 17:58:55'),
(414, 'Comercial Marthita', '1708907769001', 0, 'Publicidad', '3 De Julio Y Riobamba', '09:30', '18:00', '15', '0', 'Martha  Mendoza', '1594672560', 'USD - $', 'resto_1595363002.jpg', '0984691531', '-0.254631', '-79.172728', 'Telas ', 'marthita@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', '3 De Julio Y Riobamba', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 16, NULL, NULL),
(416, 'Liquor Box', '1718501339001', 0, 'Licorería', 'Calle Venezuela Y, Calle Guatemala', '13:00', '23:59', '5', '5', 'Macas Vera Nathaly Carolina', '1594840673', 'USD - $', 'resto_1613494679.jpg', '0980352290', '-0.249311', '-79.183034', 'Licores ', 'licor@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr28+7rj, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '19-06-2022 20:31:23'),
(418, 'Pide Lo Que Sea', '1723866149', 0, 'Lo Que Sea', 'Sur Av. 25 De Julio', '07:30', '22:00', '10', '0', 'Jose Baque', '1594925143', 'USD - $', 'resto_1603138648.jpg', '0969764774', '-2.2391528404074226', '-79.89643699179076', 'Aqui Puedes Pedir Lo Que Sea', 'loqueseasur@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. 25 De Julio, Guayaquil 090102, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(420, '3er Festival Gastronómico', '1723100515', 0, 'Restaurante', 'Av. Rio Toachi Y Galapagos ', '09:00', '17:00', '10', '0', 'Carlos Cordero', '1595001956', 'USD - $', 'resto_1656615351.jpg', '0999332065', '-0.24714126871888475', '-79.1485093150139', 'Platos Gastronomicos', 'feria@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qv32+8g2, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'NO', 0, 14, '08-07-2022 16:28:01'),
(422, 'Encomienda', '1723866149', 0, 'Transporte', 'Simón Plata Torres Y Manabi', '07:00', '22:00', '60', '0', 'José Baque', '1595040437', 'USD - $', 'resto_1595040437.jpg', '0989595926', '0.005219', '-79.397748', 'Envío De Paquetes Livianos', 'encomiendaconcoria@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'Parque Central', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(424, 'Encomienda', '1721387213', 0, 'Transporte', 'Patricia Pilar ', '08:30', '18:30', '15', '0', 'Jose Baque', '1595083216', 'USD - $', 'resto_1595083216.jpg', '0969764774', '-0.572941', '-79.369649', 'Paqueteria ', 'paqueteria@faster.com.ec', 'www.faster.com.ec', 'Patricia Pilar', 'Cjgj+r4x, Av. 1, Patricia Pilar, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '01-09-2022 15:10:33'),
(426, 'La Cuadra Steakhouse', '0901889089001', 0, 'Restaurante', 'Av Guillermo Pareja Rolando Y 9 Pasaje 1', '10:00', '22:00', '15', '0', 'Vera Sanchez Carlos Ernesto', '1595286544', 'USD - $', 'resto_1603119810.jpg', '0969345477', '-2.152057', '-79.893954', 'Parrilla', 'cuadra@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Avenidad 2 Ne (guillermo Pareja Rolando) Y 9no Pasaje 1 Ne (n172), Guayaquil 090513, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '04-06-2022 16:46:51'),
(428, 'The House Como Hecho En Casa', '2300723836001', 0, 'Restaurante', 'Zona Del Colesterol, Calle Venezuela Y Padre Germán Maya, Frente A Heladería Greenfrost', '15:30', '23:59', '20', '10', 'Víctor José Mora García', '1595293617', 'USD - $', 'resto_1611002082.png', '0978672766', '-0.249327', '-79.181848', 'Comidas Y Bebidas', 'thehouse@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 119, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-07-28 07:45:29'),
(430, 'Sari Flowers', '1714524749', 0, 'Publicidad', 'Via Quevedo Km 4.5 Por El Kfc', '09:00', '20:00', '15', '0', 'Diana Gonzales', '1595362719', 'USD - $', 'resto_1595362719.jpg', '0996914683', '-0.280346', '-79.204264', 'Detalles Con: Flores Frutas Y Globos.\r\nRosas Preservadas.\r\nFresas Con Chocolate \r\nDesayunos Personalizados Y Mas...', 'sari@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Por El Kfc De La Quevedo', 0, 'Moto O Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 17, NULL, NULL),
(432, 'La Casa Del Bolón', '1722840293001', 0, 'Restaurante', 'Av. Pedro Schumacher Y Abraham Calazacón. Frente A Farmacia Comunitaria', '07:00', '13:00', '15', '10', 'La Casa Del Bolón', '1595517203', 'USD - $', 'resto_1658531040.jpeg', '0967570025', '-0.24026225942166596', '-79.18215559507837', 'Cafetería', 'bryan@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr58+vw8, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 0, '11-09-2022 22:01:01'),
(434, 'Chicken Box', '1722358585', 0, 'Restaurante', 'Vía Quevedo Km 2 1/2 Y Calle Atabascos', '13:00', '13:05', '15', '0', ' Paulo César Galarza Sánchez', '1595620361', 'USD - $', 'resto_1609858360.jpg', '0980228166', '-0.2665267545523115', '-79.19176154232788', 'Pollo Broaster', 'chicken@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'De Los Atabascos 622, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 17:52:10'),
(436, 'La Corvina De Sauces 8', '1723866149', 0, 'Restaurante', 'Isidro Ayora Cueva & Av 2ne', '11:00', '22:00', '15', '0', 'Pendiente', '1595686594', 'USD - $', 'resto_1602536721.jpg', '0979821152', '-2.126322', '-79.900538', 'Pescado', 'corvina@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Paradero Alimentador Isidro Ayora, Guayaquil 090507, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(438, 'A Lo Mero Mero', '1715398754', 0, 'Restaurante', 'Sector Zona Rosa Frente Al Hotel Golden Vista', '16:00', '22:00', '15', '10', 'Maritza Arcos', '1595688205', 'USD - $', 'resto_1613494485.jpg', '0986057257', '-0.239428', '-79.164249', 'Comida Mexicana', 'mero@faster.com.ec', 'wwwfaster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Moto O Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 6, '2021-07-28 07:45:29'),
(440, 'Morocho Express', '1717894867', 0, 'Restaurante', 'Av. Tsafiqui Y Abraham Calazacon ', '08:30', '18:00', '15', '10', 'Vanessa Taipe ', '1595690567', 'USD - $', 'resto_1595690567.jpg', '0990897359', '-0.258388', '-79.161331', 'Morocho ', 'morocho@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Tsafiqui, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(442, 'Vimar-vi Pizza Artesanal', '0921034526001', 0, 'Restaurante', 'Duran Ccdla Los Helechos. Sector 5 Mz \"o\"4 Villa 5', '12:00', '22:00', '15', '0', 'Eric Marco Auria Oseguera', '1595695955', 'USD - $', 'resto_1603120722.jpg', '0967795029', '-2.182928', '-79.844661', 'Pizza Artesanal', 'vimar@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '6, Los Helechos Sector 5 092408, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 17:50:23');
INSERT INTO `fooddelivery_restaurant` (`id`, `name`, `dni`, `city_id`, `type_store`, `address`, `open_time`, `close_time`, `delivery_time`, `commission`, `store_owner`, `timestamp`, `currency`, `photo`, `phone`, `lat`, `lon`, `desc`, `email`, `website`, `city`, `location`, `is_active`, `del_charge`, `enable`, `session`, `status`, `ally`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`, `sequence`, `edit_id`, `edit_date_time`) VALUES
(444, 'Laboratorios Marquez', '1723357800', 0, 'Farmacia', 'Avda Arroyo Robelly Y Peralta ', '07:00', '22:00', '10', '10', 'Eduardo Vera ', '1595880453', 'USD - $', 'resto_1595880453.jpg', '0969764774', '-0.259431', '-79.169969', 'Medicina ', 'marquez@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-07-28 07:45:29'),
(446, 'Deli Crepes', '0703400895001', 0, 'Restaurante', 'Av. Abraham Calazacón Y Tsafiqui Frente Al Arbolito De Navidad', '11:00', '19:00', '20', '10', 'Diana Terreros', '1595889903', 'USD - $', 'resto_1609862768.jpg', '0988786650', '-0.258121', '-79.16117', 'Venta De Crepes Con Relleno De Frutas Y Nutella O Manjar', 'delicrepes@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-07-28 07:45:29'),
(448, 'Laboratorio Laherborz', '1721387213', 0, 'Farmacia', 'Av. Arroyo Robelly  Y Peralta ', '07:00', '22:00', '15', '10', 'Cristian Velasco ', '1596033141', 'USD - $', 'resto_1596036442.jpg', '0969764774', '-0.259558', '-79.169993', 'Medicina', 'cavnet@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(450, 'Lomo A Lo Pobre ', '0201014990001', 0, 'Restaurante', 'Cdla.alborada 11ava Etapa Cc.albocentro ', '08:00', '21:45', '20', '0', 'Edison Cabezas ', '1596035105', 'USD - $', 'resto_1603120130.jpg', '0980001474', '-2.170149', '-79.899993', 'Lomo Y Algo Mas ', 'lomo@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Avenida 12 No 65, Guayaquil 090512, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 'YES', 0, 7, '2021-09-01 09:00:02'),
(452, 'Go Burgers', '1706545710', 0, 'Restaurante', 'Urbanización María Del Carmen Calle 10 De Agosto Y 9 De Octubre Esquina Sector Campuesa', '16:00', '22:00', '30', '10', 'Silvana Valencia', '1596063062', 'USD - $', 'resto_1615077979.jpg', '0982896824', '-0.261249', '-79.163327', 'Hamburguesas', 'goburguers@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', '2 De Agosto 136, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-12-2021 16:48:12'),
(454, 'Delizie', '2390041015001', 0, 'Panadería', 'Calle Cuicocha Esquina Río Sucua', '09:00', '20:00', '15', '10', 'Enyer Peña ', '1596136704', 'USD - $', 'resto_1596136704.jpg', '0978675785', '-0.249831', '-79.167235', 'Postres ', 'delizie@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Cuicocha Esquina Río Sucua', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(456, 'Piu Pizza Norte', '0908141229001', 0, 'Restaurante', 'Av. 25 De Julio Y Pedro Bolaño', '16:00', '22:00', '20', '0', ' Christian Rodriguez ', '1596223229', 'USD - $', 'resto_1603119631.jpg', '0961705851', '-2.116667', '-79.890134', 'Pizza', 'piupizza@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '5to Pa 4a Ne 18, Guayaquil 090502, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(458, 'Moyo Heladería Y Cafetería', '1724092067001', 0, 'Restaurante', 'Av. Quito ', '09:00', '20:00', '20', '10', 'Marcelo Javier Quiñonez Castellano', '1596473320', 'USD - $', 'resto_1610294966.jpg', '0996902887', '-0.26610397822458454', '-79.18262346772003', 'Cafetería Y Heladería', 'moyo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Jacinto Cortéz Jhayya 1090, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '07-09-2021 06:44:46'),
(460, 'Chamito Burger', '1724715220', 0, 'Restaurante', 'Calle Venezuela / C. Francisco  Durini', '18:00', '22:30', '20', '15', 'Alejandra Zavala', '1596639184', 'USD - $', 'resto_1609856637.jpg', '0962915114', '-0.2492676681897941', '-79.1833107465582', 'Hamburguesas', 'chamito@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr28+8p5, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '06-09-2022 10:50:10'),
(462, 'Hueca 81 Wings', '1310211667001', 0, 'Restaurante', ' Lote 2 Etapa Mz.2688 Villa 9', '17:00', '22:00', '20', '0', 'Karina Moreira Peñarrieta', '1597068699', 'USD - $', 'resto_1603119787.jpg', '0978721454', '-2.085864', '-79.922443', 'Alitas ', 'alitas@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Tpc928-calle 25 No Y Proyeccion A 8 Callejon 25 No, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(464, 'Delta Vip Car', '1002806402', 0, 'Publicidad', 'Santo Domingo ', '12:00', '23:59', '15', '0', 'Francisco Cisneros ', '1597160659', 'USD - $', 'resto_1597160659.jpg', '0959063757', '-0.253319', '-79.186178', 'Servicio Puerta A Puerta ', 'deltavip@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Republica Del Ecuador 366, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 14, NULL, NULL),
(466, 'Delta Vip Car Sto Dgo', '1002806402', 0, 'Transporte', 'Honduras 309 Y Av Rio Chila ', '00:01', '23:59', '20', '10', 'Francisco Cisneros ', '1597180678', 'USD - $', 'resto_1597180678.jpeg', '0959063757', '-0.253319', '-79.186178', 'Servicio Puerta A Puerta ', 'vipcar@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Honduras 309, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-10-2021 12:35:30'),
(468, 'Delta Vip Car', '1002806402', 0, 'Transporte', 'Guayaquil - Francisco Falquez Ampuero 807', '00:15', '23:59', '25', '10', 'Francisco Cisneros ', '1597333222', 'USD - $', 'resto_1597333222.jpeg', '0959063757', '-2.1585', '-79.900167', 'Servicio Puerta A Puerta', 'delta@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Francisco Falquez Ampuero 807, Guayaquil 090512, Ecuador', 1, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(470, 'Los Pinchos De Metro ', '0691777812001', 0, 'Restaurante', 'Av. Los Anturios Y Puruahes Esquina  ', '16:00', '21:30', '15', '10', 'Fabian Ricardo Rivera Rivera ', '1597443349', 'USD - $', 'resto_1597443349.jpg', '0999012623', '-0.248938', '-79.151192', 'Pinchos De Metro, Parillada ', 'lospinchosdemetro@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Puruhaes 202, Santo Domingo, Ecuador', 1, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-07-28 07:45:29'),
(472, 'Elys Sweet', '1716790900001', 0, 'Panadería', 'Av. Lorena  Urbanización Senya Mz10 Casa 16', '08:00', '20:00', '15', '0', 'Eliana Aviles', '1597508421', 'USD - $', 'resto_1650063294.jpeg', '0992443741', '-0.25881066073547615', '-79.14258279262505', 'Pasteles ', 'elianaavilesf1980@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Pvr4+frf, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '04-06-2022 16:47:46'),
(474, 'Papitas De La 30 Nro 2', '0705779304', 0, 'Restaurante', 'Av. Venezuela Y Haití', '17:15', '21:30', '20', '5', 'Florbina Pereira Almeida', '1597793437', 'USD - $', 'resto_1597793437.jpg', '0992658766', '-0.249076', '-79.185029', 'Papi Pollo Y Salchipapa', 'papitas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 217, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '07-05-2022 15:26:26'),
(476, 'Servicio De Incubación ', '1721387213', 0, 'Publicidad', 'Coop. Nuevo Santo Domingo, Calle Pablo  Neruda Y Ernesto Cardenal ', '08:00', '18:00', '15', '0', 'Ana María Gaibor', '1597847788', 'USD - $', 'resto_1597847788.jpg', '0987148122', '-0.258416', '-79.157386', 'Servicio De Incubación De Toda Clase De Aves', 'servicioincubación@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Coop. Nuevo Santo Domingo', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 10, NULL, NULL),
(478, 'Trans Colorado Express', '1721387213', 0, 'Publicidad', 'Santa Martha ', '08:00', '18:00', '10', '10', 'Ricardo Vaca', '1597853920', 'USD - $', 'resto_1597853920.jpg', '0989721196', '-0.2700116', '-79.1824938', 'Transporte', 'transcolorado@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Santa Martha', 0, 'Carro', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 12, NULL, NULL),
(480, 'Trans Colorado Express', '1721387213', 0, 'Transporte', 'Santa Martha ', '08:00', '23:00', '15', '0', 'Ricardo Vaca', '1597855446', 'USD - $', 'resto_1597855446.jpg', '0989721196', '-0.2700116', '-79.1824938', 'Servicio De Transporte ', 'colorado@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prh8+wxw, Santo Domingo, Ecuador', 1, 'Carro', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '04-06-2022 16:50:23'),
(482, 'Siscont', '1723149850', 0, 'Publicidad', 'Av. Tsáchila Entre Río Zamora Y Río Upano', '08:00', '18:00', '11', '0', 'Lenin Chavez', '1597866901', 'USD - $', 'resto_1597866901.png', '0968227906', '-0.2453259', '-79.167617', 'Contabilidad', 'siscont@faster.com.ec', 'siscont.com', 'Santo Domingo de los Colorados', 'Urb. Escorpio', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 11, NULL, NULL),
(484, 'Humitas De Guillita', '0702762261', 0, 'Restaurante', 'Calles Machala Y Tulcan (esquina) ', '08:00', '18:00', '15', '0', 'Guillermina Herrera Quevedo', '1597938087', 'USD - $', 'resto_1603379222.jpg', '0939315055', '-0.253082', '-79.169164', 'Humitas, Tortillas,tamales', 'guillita@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Machala 202, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 17:58:19'),
(486, 'Parrilladas Donosti', '1713683421', 0, 'Restaurante', 'Av Río Lelia Diagonal A Vista Hermosa', '12:00', '21:00', '20', '10', 'Digna Isabel Benavidrs Ardila', '1598454026', 'USD - $', 'resto_1610296215.jpg', '0959798148', '-0.254137', '-79.152706', 'Asados Parrilladas ', 'donosti@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 142, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '2021-09-01 09:00:02'),
(488, 'Container Parrilla Moya ', '1716733314', 0, 'Restaurante', 'Av, Abraham Calazacon Y Quito', '17:00', '22:00', '20', '0', 'Edwin Moya ', '1598477834', 'USD - $', 'resto_1598477834.jpg', '0993215230', '-0.258214', '-79.148996', 'Parilladas ', 'container@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Pvr2+pc Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 18:01:59'),
(490, 'Picantería Pedacito De Esmeraldas ', '1304736752', 0, 'Restaurante', 'Av De Los Colonos Frente A Gasolinera Petrolios Y Servicios  A Pocos Metros Del Sueño De Bolivar', '07:00', '21:00', '15', '0', 'Jorge Cando ', '1598478931', 'USD - $', 'resto_1598478931.jpg', '0988192707', '-0.23450976116462455', '-79.16823728737648', 'Encebollados   Asados ', 'esmeraldas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr8m+52j, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 18:01:53'),
(492, 'Donde Pao Lasaña Y Algo Más', '1721387213', 0, 'Restaurante', 'Coop 9  De Diciembre Calle Las Delicias Av Yambucay Edif Cardim', '19:00', '23:00', '19', '10', 'Paola Izaguirre ', '1598888269', 'USD - $', 'resto_1598888269.jpg', '0998451570', '-0.2462404996574459', '-79.16045970153047', 'Lasaña Y Algo Mas ', 'dondepao@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Las Delicias, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(494, 'Yucafé', '1717144917', 0, 'Restaurante', 'Calle 6 De Noviembre Y Calle Gonzalez Diaz De Pineda Atrás Del Estadio Obando Pacheco Y Frente Al Colegio Madre Laura', '07:30', '15:00', '10', '10', 'Tito David Rey Bravo ', '1598913381', 'USD - $', 'resto_1603378214.jpg', '0992453857', '-0.2574788468323007', '-79.16436231564714', 'Bolones, Tigrillos Y Desayunos..', 'yucafe@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prrp+r9w, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '24-07-2022 08:10:52'),
(496, 'Arepas Gloria ', '1713065280', 0, 'Restaurante', ' Urb. María Del Carmen', '18:00', '21:00', '25', '10', 'Gloria Pulido', '1598914137', 'USD - $', 'resto_1604351446.jpg', '0986583612', '-0.2606411389360041', '-79.16341549586488', 'Arepas Rellenas', 'arepas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', '2 De Agosto 1, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '16-08-2022 16:08:45'),
(498, 'Floristeria Juanito ', '1715320204001', 0, 'Regalo', 'Coop Juan  Eulogio ', '07:30', '21:00', '30', '0', 'Juan Jimenez Reyes ', '1598915570', 'USD - $', 'resto_1609865176.jpg', '0994837502', '-0.21944545310571842', '-79.19642812442018', 'Floristeria ', 'juanito@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 18:03:31'),
(500, 'Chifa Central norte', '1721387213', 0, 'Restaurante', 'Av. Abrahan Calazacon Y Pallatanga', '11:00', '23:00', '15', '8', 'Liu Genwei', '1599075493', 'USD - $', 'resto_1616798282.jpg', '0988888212', '-0.2538418076165785', '-79.16110879611207', 'Chaulafan ', 'centralnorte@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Rio Chimbo 150, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '28-08-2022 11:16:11'),
(503, 'Promociones', '1723866149', 0, 'Restaurante', 'Campuesa', '16:00', '22:00', '24', '3', 'Jose Baque', '1599086319', 'USD - $', 'resto_1599086319.jpeg', '0969764774', '-0.2612446297055709', '-79.1633833093567', 'Hamburguesas', 'promo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', '2 De Agosto 136, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(505, 'Faster Business', '1723866149', 0, 'Lo Que Sea', 'Arroyo Robelly Y Peralta', '07:00', '18:00', '13', '0', 'José Baque', '1599274258', 'USD - $', 'resto_1606928843.jpg', '0969764774', '-0.2593563740459092', '-79.16986352633668', 'Suscripciones Aliados Premium\r\nPagos Mensuales', 'premium@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-09-01 09:00:02'),
(507, 'Servicios De Enfermeria', '1724715220', 0, 'Publicidad', 'Urb. Senya Mz 26 Lt11', '13:00', '17:00', '19', '0', 'Jael Lopez', '1599751597', 'USD - $', 'resto_1599751597.jpeg', '0987197810', '-0.25693168170648906', '-79.14160377215578', 'Servicios De Enfermería', 'ajlopez@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 9, NULL, NULL),
(509, 'El Sombrero De Jabalí', '2300313752', 0, 'Restaurante', 'Av. Lorena  Y Calle Atacames ', '16:00', '22:00', '20', '0', 'Nathaly Nicolle Dulcey Morales ', '1599838087', 'USD - $', 'resto_1609863941.jpg', '0997761250', '-0.2576505064747635', '-79.15172642897798', 'Comida Gurmet ', 'jabali@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prrx+w8 Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '01-03-2022 12:02:33'),
(513, 'Barbecue Y Algo Más', '1722953492', 1, 'Restaurante', ' Calle Venezuela', '16:00', '23:59', '20', '10', 'Angelica Simbaña', '1600198358', 'USD - $', 'resto_1602865230.jpg', '0999058976', '-0.24928477842574923', '-79.18168938588335', 'Costillas Y Alitas', 'barbecue@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 119, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '30-07-2022 14:25:17'),
(515, 'Froita', '1721502357', 0, 'Panadería', 'Urb. Mutuslista Benalcazar Calle Los Helechos C. 310.', '10:00', '20:00', '25', '0', 'Elizabeth Moreno ', '1600377308', 'USD - $', 'resto_1602518716.jpg', '0987820746', '-0.24981048640635867', '-79.15302193593217', 'Arreglos Frutales ', 'froita@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 120, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 5, '14-03-2022 18:04:48'),
(517, 'Encebollados El Colorado', '2300465677', 0, 'Restaurante', 'Coop Villa Florida \r\nDiagonal Al Estadio Esquina', '07:00', '14:00', '10', '10', 'Romel Encalada', '1600650202', 'USD - $', 'resto_1602519997.jpg', '0999379167', '-0.2593563740459092', '-79.16986352633668', 'Encebollados', 'elcolorado@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(519, 'Pide Lo Que Sea', '1723866149', 0, 'Lo Que Sea', 'Santo Domingo', '00:01', '23:59', '25', '0', 'Faster', '1600742198', 'USD - $', 'resto_1603138564.jpg', '0985494782', '-0.2593563740459092', '-79.16986352633668', 'Domicilios', 'loqueseanoche@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 18:01:55'),
(521, 'Doña Bety Rosales', '1718880253', 0, 'Restaurante', 'Rosales ', '07:00', '16:00', '10', '0', 'Gabriel Lucas Bautista ', '1600874564', 'USD - $', 'resto_1603487092.jpeg', '0990378542', '-0.24040942984509447', '-79.18194419573976', 'Caldo De Maguera, Guatita Y Encebollados ', 'bety@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr58+jxx, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 18:09:31'),
(523, 'Nenes Burgers', '1759341355', 0, 'Restaurante', 'Coop 9 Diciembre ', '16:00', '22:30', '21', '0', 'Jose Luis Hernandez', '1600966643', 'USD - $', 'resto_1602522182.jpg', '0979303307', '-0.2444783044927251', '-79.15650076102449', 'Comida Rapida ', 'nenes@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr4v+9h6, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '11-03-2022 13:52:05'),
(525, 'Codiec', '0605402734001', 0, 'Publicidad', 'Av. Yamboya Y Av. Río Yanuncay Diagonal Al Chluis ', '08:30', '18:30', '20', '0', 'Jose Silva ', '1600987007', 'USD - $', 'resto_1600987007.jpeg', '0989309687', '-0.24692445662218215', '-79.1582468790932', 'El Giro De Negocio Va Orientado A Servicios Tecnológicos Y Productos.', 'codiec@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'San Juan 3, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 8, NULL, NULL),
(527, 'Chef Pescao', '1309615449001', 0, 'Restaurante', 'Av.jacinto Cortez Y Aurelio Mosquera ', '07:30', '16:00', '20', '0', 'Fernando Rizo Obando ', '1601048781', 'USD - $', 'resto_1602876642.jpg', '0999149800', '-0.2617864302828898', '-79.18440646361543', 'Mariscos ', 'pescao@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Juan De Dios Martinez 313, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 18:12:24'),
(529, 'Gordiscos Burger', '1758614273001', 0, 'Restaurante', 'Av. Tsafiqui Frente Al Chifa Jardín', '09:00', '23:00', '20', '10', 'Megan Campos', '1601567208', 'USD - $', 'resto_1603756936.jpg', '0983205161', '-0.25999205105379614', '-79.16658519636823', 'Comida Rapida ', 'gordiscos@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Los Clavellines 102, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-07-28 07:45:29'),
(531, 'Restaurante D Jenny', '1718109935', 0, 'Restaurante', 'Av. Clemencia De Mora A Pocos Pasos Del Registro Civil', '08:00', '14:00', '10', '10', 'Luis Eduardo Anchundia Macias', '1601671331', 'USD - $', 'resto_1610490688.jpg', '0998570077', '-0.24536610756514504', '-79.171000782959', 'Desayunos ', 'jenny@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Clemencia De Mora 522, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 9, '2021-07-28 07:45:29'),
(533, 'La Gran Pesca ', '1309615449001', 0, 'Supermercado', 'Ciudadela Universitaria Etapa 2, Departamentos Universitarios', '10:00', '20:00', '10', '0', 'Adryan Suarez', '1601677587', 'USD - $', 'resto_1603811606.jpg', '0985835550', '-0.2592705442364904', '-79.19187909793092', 'Venta De Camarones ', 'granpesca@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Ciudadela Universitaria, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 0, 8, '2021-07-28 07:45:29'),
(535, 'Chifa Yong Xing', '1723187413', 0, 'Restaurante', 'Urdesa, Av, Emilio Estrada#304 Y Cedros', '10:30', '22:00', '15', '0', 'Li Yujuan', '1601926758', 'USD - $', 'resto_1603119736.jpg', '0968427223', '-2.174005071080475', '-79.90608430337141', 'Chaulafan ', 'yon@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Victor Emilio Estrada 304, Guayaquil 090511, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(537, 'Los Secos De Paupau', '0915820278', 0, 'Restaurante', 'Urdesa. Calle 9 No Y Av.26', '10:00', '15:00', '14', '0', 'Karina Fernandez', '1602012507', 'USD - $', 'resto_1603120157.jpg', '0991038078', '-2.1728927551175246', '-79.90623182486726', 'Secos ', 'paupau@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '*avenida 26- 212, Guayaquil 090511, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 7, '2021-09-01 09:00:02'),
(539, 'Delta Vip Car', '1002806402', 0, 'Publicidad', 'Guayaquil - Francisco Falquez Ampuero 807', '08:00', '18:00', '24', '0', 'Francisco Cisneros', '1602047680', 'USD - $', 'resto_1602055114.png', '0959063757', '-2.1584298928866725', '-79.9001512570305', 'Servicio Puerta A Puerta', 'deltapublicidad@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Francisco Falquez Ampuero 807, Guayaquil 090512, Ecuador', 1, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 5, NULL, NULL),
(541, 'La Tonga Manaba ', '1314645274001', 0, 'Restaurante', 'Ucom 1 Cerca Del Hospital General Santo Domingo ', '08:00', '14:30', '15', '10', 'Jesus Alfredo Giler Moncayo', '1602082020', 'USD - $', 'resto_1603915147.jpg', '0983839722', '-0.23231995629852883', '-79.17681581210329', 'Tongas Manabas', 'tongamanaba@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 6, '2021-07-28 07:45:29'),
(543, 'Pizza Express', '0941770109', 0, 'Restaurante', 'Vergeles Mz 139 S.30 A', '10:00', '22:00', '25', '0', 'Cinthya Lopez', '1602083272', 'USD - $', 'resto_1602433903.jpg', '0961033199', '-2.0923782049972304', '-79.90399922513963', 'Pizza Y Hamburguesas', 'pizzaexpress@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '31a, Los Vergeles 090703, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '04-06-2022 16:51:30'),
(545, 'Lubricentro El Doctor', '0923881874', 0, 'Publicidad', 'Urdesa.3 Callejon 14 No', '08:30', '18:00', '20', '0', 'Pendiente ', '1602088591', 'USD - $', 'resto_1602088591.jpg', '0983685950', '-2.1564947107223826', '-79.89502555560304', 'Cambios De Aceites ', 'lubricentro@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '2do Callejon 14 No 11, Guayaquil 090506, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 6, NULL, NULL),
(547, 'Mangiamo', '0930689831', 0, 'Restaurante', 'Av. Samborondon Calle Cuarta Y Av. Rio Vinces ', '07:00', '11:00', '15', '0', 'Angel Bermeo ', '1602102810', 'USD - $', 'resto_1603120194.jpg', '0962895193', '-2.147563893589116', '-79.86657804679109', 'Almuerzos Italianos ', 'mangiamo@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'V43m+39c, C. Cuarta, Samborondón 092301, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 8, '01-07-2022 16:03:00'),
(549, 'Quality', '0952322451001', 0, 'Publicidad', 'Guayaquil', '08:00', '18:00', '9', '10', 'Pablo Aguirre ', '1602346360', 'USD - $', 'resto_1602346360.jpeg', '0969764774', '-2.172088670778643', '-79.90774995516969', 'Productos De Limpieza', 'qualitygye@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Victor Emilio Estrada 410, Guayaquil 090511, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 7, NULL, NULL),
(551, 'Parrilladas De Wacho', '1721387213', 0, 'Restaurante', 'Las Palmeras Av.san Antonio', '17:00', '22:00', '25', '0', 'Pendiente', '1602363902', 'USD - $', 'resto_1605196583.jpg', '0969764774', '-0.25930004823354647', '-79.17520916890336', 'Parrilladas De Mariscos ', 'parrillada@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prrf+7wf, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '24-06-2022 07:36:41'),
(553, 'Pollo Stav', '1723866149', 0, 'Restaurante', 'Urdesa Guayaquil', '10:00', '21:00', '10', '0', 'José Santillán', '1602535329', 'USD - $', 'resto_1602535329.jpg', '042610492', '-2.1618204029057853', '-79.91500215394464', 'Pollo Asado', 'stavurdesa@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Victor Emilio Estrada 1114, Guayaquil 090511, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(555, 'Pide Lo Que Sea', '1723866149', 0, 'Lo Que Sea', 'Centro Av. 9 De Octubre', '07:30', '22:00', '10', '0', 'Jose Baque', '1602550240', 'USD - $', 'resto_1603138464.jpg', '0989595926', '-2.1900357310955068', '-79.88766557406618', 'Comunicate Con Un Repartidor El Llevara Lo Que Tu Quieras', 'loqueseacentro@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Y, Pedro Moncayo & Avenida 9 De Octubre, Guayaquil 090312, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(557, 'Pide Lo Que Sea', '1723866149', 0, 'Lo Que Sea', 'Samborondón', '07:30', '22:00', '10', '0', 'Jose Baque', '1602552766', 'USD - $', 'resto_1603138382.jpg', '0989595926', '-2.112134947770957', '-79.87230188082887', 'Comunícate Con Un Repartidor', 'loqueseasambo@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Unnamed Road, Samborondón, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(559, 'Pide Lo Que Sea', '1723866149', 0, 'Lo Que Sea', 'Sector La Garzota', '07:30', '22:00', '10', '0', 'Jose Baque', '1602556289', 'USD - $', 'resto_1603138237.jpg', '0989595926', '-2.1550634248234832', '-79.89521867465211', 'Comunícate Con Un Repartidor Y Pide Lo Que Tu Quieras', 'loqueseagarzota@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. Juan Tanca Marengo, Guayaquil 090512, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(561, 'Pide Lo Que Sea', '1723866149', 0, 'Lo Que Sea', 'Av Camilo Ponce Enrique', '07:30', '22:00', '10', '0', 'Jose Baque', '1602608447', 'USD - $', 'resto_1603137826.jpg', '0989595926', '-2.1298039564691433', '-79.93272668551637', 'Comunícate Con Un Repartidor Y Pide Lo Que Tu Quieras', 'loqueseacamilo@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. Camilo Ponce Enríquez, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(563, 'Pollo  D Gus Tar', '0916311483', 0, 'Restaurante', 'Urb.  Florida Av.eduardo Sola Franco', '09:00', '22:00', '20', '0', 'Gustavo Rodriguez', '1602619725', 'USD - $', 'resto_1603120304.jpg', '0978902523', '-2.128788883084212', '-79.9410191769036', 'Pollo Asado ', 'gustar@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Eduardo Solá Franco, Guayaquil 090609, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(565, 'Pollo Campero Gye', '1723866149', 0, 'Restaurante', 'Mall Del Sol Local 13\r\n', '10:00', '21:00', '10', '0', 'Luiggy Orozco', '1602634117', 'USD - $', 'resto_1651696848.jpg', '0995358433', '-2.1553636197302817', '-79.89157087039186', 'Pollo Asado Al Carbon', 'camperogye@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Joaquín José Orrantia González 100y, Guayaquil 090513, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '05-05-2022 12:21:10'),
(567, 'Panaderia', '1723866149', 0, 'Panadería', 'Guayquil', '07:00', '10:00', '10', '0', 'Jose Baque', '1602697716', 'USD - $', 'resto_1602697716.jpg', '0989595926', '-2.1705691759533514', '-79.89745080944425', 'Registra Tu Panadería O Pasteleria', 'panaderiagye@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. Fco De Orellana Y 6to Pasaje 9 No, Guayaquil 090512, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(569, 'Licoreria', '1723866149', 0, 'Licorería', 'Guayaquil', '07:00', '23:00', '10', '0', 'Jose Baque', '1602701753', 'USD - $', 'resto_1602701753.jpg', '0989595926', '-2.186240492477541', '-79.89530450534059', 'Registra Tu Licorería', 'licoresgye@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. 9 No 604, Guayaquil 090514, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(571, 'Supermercado', '1723866149', 0, 'Supermercado', 'Guayaquil', '08:00', '22:00', '15', '0', 'Jose Baque', '1602702991', 'USD - $', 'resto_1602702991.jpg', '0989595926', '-2.1622252014440817', '-79.90045434664918', 'Registra Tu Supermercado', 'supermercadogye@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Pablo Aníbal Vela 41, Guayaquil 090512, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(573, 'Doña Melbita', '0926585423001', 0, 'Restaurante', 'Frente Al Mercado De Sauces 9', '07:00', '14:00', '13', '0', 'Gilda Echeverria', '1602713888', 'USD - $', 'resto_1602713888.jpeg', '0993776185', '-2.1286004760933053', '-79.89195979069902', 'Mariscos', 'melbita@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '*callejon C- 19, Guayaquil 090505, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(575, 'Ruedas De Camion', '1721387213', 0, 'Restaurante', 'Mucho Lote 1 4 Paseo 24b N O', '17:00', '22:00', '15', '0', 'Jesus Hoyo', '1603118356', 'USD - $', 'resto_1603118356.jpg', '0989848625', '-2.0903874781820466', '-79.92274283301069', 'Comida Rapida ', 'ruedas@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Avenida 37 N-o- 2384, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:03:35'),
(577, 'La Paisa', '0951710714', 0, 'Restaurante', 'Mucho Lote Villa España 1 Barcelona Mz 2284 Villa 25', '17:00', '22:00', '10', '0', 'Valeria Quevedo Quintero', '1603150402', 'USD - $', 'resto_1603150402.jpg', '0963192389', '-2.083229389378712', '-79.91877919863893', 'Empanadas Colombianas', 'lapaisa@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'W38j+m9q, 3 Pasaje 25a No, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'NO', 0, 8, '01-07-2022 16:03:51'),
(579, 'Ruedas De Camion 2', '1721387213', 0, 'Restaurante', 'Alborada : Av 2 N-e', '17:00', '22:00', '15', '0', 'Jesús Enrique Hoyo Galindez', '1603207551', 'USD - $', 'resto_1603207551.jpg', '0989848625', '-2.133702529535983', '-79.90372127722932', 'Hamburguesas ', 'ruedacamion@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'V38w+gg7, Av. 2 N-e, Guayaquil 090501, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:04:07'),
(581, 'Dra Paola Rivas', '1723866149', 0, 'Publicidad', 'Florida Norte ', '09:00', '20:00', '20', '0', 'Paola Rivas', '1603287099', 'USD - $', 'resto_1603287099.jpg', '0993061589', '-2.1289301601204586', '-79.93466860484315', 'Especialista En Cirugía General Y Laparoscóoica', 'privas@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Eduardo Solá Franco Mz 101 Solar 32, Guayaquil 090602, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 4, NULL, NULL),
(583, 'Tiendas Purpure', '1722231477', 0, 'Supermercado', 'Florida Norte', '08:00', '20:00', '10', '0', 'Paola Villota', '1603287564', 'USD - $', 'resto_1603290151.jpg', '0998993859', '-2.1289033565436486', '-79.93467933367921', 'Tienda De Prendas De Vestir', 'purpure@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Eduardo Solá Franco, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-09-01 09:00:02'),
(585, 'Burger Express', '0927178939', 0, 'Restaurante', 'Los Vergeles  Mz.139 S.30 ', '08:00', '21:30', '25', '0', 'Carlos Peñaherrera', '1603298965', 'USD - $', 'resto_1603298965.jpg', '0961033199', '-2.0924313002108303', '-79.9040458245201', 'Hamburguesas', 'burgerexpress@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '31a, Los Vergeles 090703, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:04:18'),
(587, 'El Pájaro Rojo 2', '1311950883001', 0, 'Restaurante', 'Tras Del Terminal Terrestre Av Los Colonos Y Julio Cesar Bermeo.', '07:00', '16:00', '10', '0', 'Lucía Elizabeth Laz Cedeño ', '1603299336', 'USD - $', 'resto_1603313017.jpg', '0999328459', '-0.23628959244720615', '-79.17194492053221', 'Bar Picabtería ', 'pajaro@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr7h+jfq, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 19:01:46'),
(589, 'El Pájaro Rojo 3', '1311950883001', 0, 'Restaurante', 'Plaza Kasama Km 1/2 Via Quito Junto A La Agencia Nacional De Tránsito', '07:00', '16:00', '10', '0', 'Lucía Elizabeth Laz Cedeño ', '1603378496', 'USD - $', 'resto_1603378496.jpg', '0991644544', '-0.24820385837934741', '-79.14324528407289', 'Bar Picantería ', 'pajaro3@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qv24+pp7, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '11-03-2022 19:02:03'),
(591, 'Sushi Matsuri', '0925206492', 0, 'Restaurante', 'Samanes 7 ', '11:00', '21:30', '20', '0', 'Alex  Ibarra', '1603386435', 'USD - $', 'resto_1603386435.jpg', '0981472211', '-2.114295337988838', '-79.9158542497082', 'Shushi', 'shushi@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'V3pm+5qx, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:04:31'),
(593, 'Super Pollo', '1711829091001', 0, 'Restaurante', 'Av. Chone ', '10:30', '21:00', '8', '5', 'Cedeño Alban José Willian ', '1603394866', 'USD - $', 'resto_1603398117.png', '0996787539', '-0.2551828988926428', '-79.18221241664125', 'Pollo Asado', 'superpollo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prv9+w3w, Av. Abraham Calazacón, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-08-2022 01:14:39'),
(595, 'Pizzaditas', '1717583403001', 0, 'Restaurante', 'Calle Pallatanga Frente Al Diario La Hora', '14:00', '23:00', '19', '0', 'Wilmer Yanes', '1603406794', 'USD - $', 'resto_1603815965.jpeg', '0988522327', '-0.2507452273301118', '-79.16404045056535', 'Pizza', 'pizzaditas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Guayaquil 210, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '18-03-2022 17:13:50'),
(597, 'Doña Bety 1', '1718880253', 0, 'Restaurante', 'Av. Quito Y Latacunga Frente Al Hospital Agusto Egas', '08:00', '16:30', '10', '0', 'Gabriel Lucas Bautista ', '1603488121', 'USD - $', 'resto_1603488121.jpeg', '0990378542', '-0.25549403204873566', '-79.17178935240938', 'Caldo De Maguera', 'bety1@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito 417, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-07-28 07:45:29'),
(599, 'Ruedas De Camión 1', '1724715220', 0, 'Restaurante', 'Isidro Ayora 12 Paseo 24b No, Guayaquil', '17:00', '22:00', '15', '0', 'Jesús Enrique Hoyo Galindez', '1603570935', 'USD - $', 'resto_1603570935.jpg', '0989848625', '-2.088102414992565', '-79.92357498835756', 'Hamburguesas', 'ruedacamion3@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'W36g+qhp, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:04:50'),
(601, 'Boca Quente Pizzería', '1724715220', 0, 'Restaurante', 'Alborada 12 Ava Etapa Mz 18 Solar 15, Guayaquil, Ecuador 090150', '15:45', '22:00', '20', '0', 'Manuel David Torres Freitez', '1603724523', 'USD - $', 'resto_1603724523.jpg', '0963250964', '-2.1369524496859453', '-79.90434086751176', 'Pizzería', 'bocaquente@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'V37w+66q, Guayaquil 090507, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:05:03'),
(603, 'Pollo Stav 2', '0993251194001', 0, 'Restaurante', 'Orellana ', '11:00', '21:00', '15', '0', 'Alvaro Cobo', '1603814963', 'USD - $', 'resto_1603814963.jpg', '043951513', '-2.1640156403225412', '-79.89626205395896', 'Pollo Asado', 'stavorellana@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. Francisco De Orellana &, Guayaquil 090512, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(605, 'Pollo Stav 3', '0993251194001', 0, 'Restaurante', 'Sanborondón', '11:00', '21:00', '13', '0', 'Alvaro Cobo', '1603832321', 'USD - $', 'resto_1603832321.jpg', '0439012850', '-2.1490648749139485', '-79.86518866252138', 'Pollo Horneado', 'stavsanborondon@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. Río Vinces 3536, Samborondón 092301, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(607, 'Kfc', '1723866149', 0, 'Restaurante', 'Santa Elena, Libertad, Av Carlos Espinoza ', '11:00', '21:00', '10', '0', 'Jose Baque', '1603837810', 'USD - $', 'resto_1614202294.jpg', '0989595926', '-2.2262669083175965', '-80.92112070750426', 'Pollo Broaster', 'kfcse@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Libertad, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(609, 'Yummy Wings', '0926588906', 0, 'Restaurante', 'Alborada 3era Etapa Mz Cc Villa 9', '12:00', '21:00', '20', '0', 'Jennifer Astudillo', '1603838403', 'USD - $', 'resto_1603838403.jpg', '0989184047', '-2.144586049490065', '-79.90056834053237', 'Alitas', 'yummy@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Calle 16a Ne 7, Guayaquil 090509, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '2021-09-01 09:00:02'),
(611, 'Moon Garden ', '0703203307001', 0, 'Restaurante', 'Mucho Lote 1 Mz 2311 Solar 14 \r\nDetrás Del Tía (diagonal A Villa España Valencia)', '15:00', '22:00', '15', '0', 'Martha Dalinda Zea Barreto', '1603911530', 'USD - $', 'resto_1603911530.jpg', '0997974180', '-2.084763938401542', '-79.9209410591049', 'Comida Rápida', 'garden@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'W37h+wg9, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:05:15'),
(613, 'D Saul Corviches', '1723866149', 0, 'Restaurante', 'Abrahan Calazacon Y Julio Cesar Bermeo Junto Al Torre Azul', '14:00', '20:00', '10', '0', 'Saul', '1604423373', 'USD - $', 'resto_1604423373.jpg', '0997358836', '-0.2391595313899069', '-79.17242235373689', 'Corviches Y Bollos', 'saul@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr6g+9x3, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 17, '18-03-2022 17:13:25'),
(615, 'Faster Market', '1723866149', 0, 'Market', 'Calle Arroyo Robelly 359 Y Peralta', '00:00', '23:59', '1', '3', 'Jose Luis Baque Burgos', '1604619301', 'USD - $', 'resto_1648780575.png', '0980008742', '-0.2593563740459092', '-79.16986352633668', 'Snacks, Bebidas', 'market@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto', 1, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '08-05-2022 02:25:40'),
(617, 'Don Chuzo', '1724715220', 0, 'Restaurante', 'Av. Dr. Adolfo Alvear Ordoñez 311, Guayaquil 090601', '08:00', '21:00', '20', '0', 'Jael Lopez', '1605044064', 'USD - $', 'resto_1605044064.jpg', '0990355899', '-2.1638504474737266', '-79.92002798118958', 'Desayunos Y Platos A La Carta', 'donchuzo@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. Dr. Adolfo Alvear Ordoñez 311, Guayaquil 090601, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(619, 'Encebollados Tu Pana', '0940615875001', 0, 'Restaurante', 'Orquideas Calle 24 A 2pasje 9 No', '07:00', '15:00', '15', '0', 'Jonathan Gomez', '1605154599', 'USD - $', 'resto_1605154599.jpg', '0978736874', '-2.0894443036761547', '-79.91527288090421', 'Encebollados', 'pana@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '2 Pje 9 No 54, Guayaquil, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(621, 'Pañalera Madeleine ', '1726449869', 0, 'Farmacia', 'Av Ibarra Y La Niña En El Mercado 29 De Diciembre Local #11 ', '08:00', '18:30', '12', '0', 'Jesica  Paucar Cuenca ', '1605203587', 'USD - $', 'resto_1605203587.jpg', '0990072662', '-0.2583156875674898', '-79.17011565398408', ' Productos De Aseo Y Limpieza', 'madeleine@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Tulcán Y Jose Frandin 308, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-07-28 07:45:29'),
(623, 'La Bodeguita', '1718564428001', 0, 'Supermercado', 'Av Bomboli Diagonal A La Iglesia Catolica, Coop Ciudad Nueva', '06:30', '22:00', '10', '0', 'Intriago Navarrete Anyelo Giancarlo', '1605281693', 'USD - $', 'resto_1605281693.jpg', '0992361013', '-0.251266911977342', '-79.17441255282594', 'Productos De Consumo Masivo', 'bodeguita@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Guayaquil 738, Santo Domingo, Ecuador', 1, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(625, 'Quedepingaec', '0962091344001', 0, 'Restaurante', 'Albonor Mz 12 S13', '12:00', '23:59', '35', '0', 'Carlos Enrique Sequera Martinii', '1605387064', 'USD - $', 'resto_1606367705.png', '0985328443', '-2.1245370476630128', '-79.90080303382112', 'Hamburguesas, Sandwich, Pizza, Lasagna, Postres Y Mucho Mas', 'quedepingaec@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. 1c 7, Guayaquil 090507, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:05:48'),
(627, 'Encomienda Nacional ', '1721387213', 0, 'Transporte', 'Coop 29 Diciembre ', '07:00', '23:59', '13', '0', 'Pendiente', '1605559258', 'USD - $', 'resto_1605559258.jpg', '0969764774', '-0.2593563740459092', '-79.16986352633668', 'Paquetería ', 'nacional@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '18-03-2022 17:38:21'),
(629, 'Liquor Box', '1718501339001', 0, 'Licorería', 'Abraham  Calazacon Entre Rio Mataje Y Rio Zamora ', '13:00', '23:59', '15', '5', 'Macas Vera Nathaly Carolina', '1605715712', 'USD - $', 'resto_1613494646.jpg', '0980352290', '-0.24548412367910313', '-79.16549689006044', 'Licores', 'box@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3m+rr Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '19-06-2022 20:31:05'),
(631, 'Liquor Box', '1718501339001', 0, 'Licorería', 'Av Rio Lelia  Y Los Anturios ', '13:00', '23:59', '15', '5', 'Macas Vera Nathaly Carolina', '1605716535', 'USD - $', 'resto_1613494573.jpg', '0980352290', '-0.2490621571827484', '-79.15242782663537', 'Licores', 'liquorbox@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 114, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '19-06-2022 20:30:49'),
(633, 'La Canasta De Yogui', '2300403140001', 0, 'Restaurante', 'Coop Las Palmas, Calle Colombia #114, Y Padre German Maya', '08:00', '23:00', '15', '10', 'Joselin Benavides', '1605899618', 'USD - $', 'resto_1651067981.jpeg', '0982510273', '-0.2498185329569123', '-79.18156868647768', 'Papas Fritas, Hamburguesas, Sanduches, Bolones, Bebidas.', 'canasta@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Colombia 114, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '23-07-2022 03:53:14'),
(635, 'King Kono', '1721387213', 0, 'Restaurante', ' Portete 5209 Y La 25ava', '15:00', '21:00', '15', '0', 'Charlie Ovalles', '1606144703', 'USD - $', 'resto_1606252866.jpg', '0999830768', '-2.2002313668504954', '-79.92259866427614', 'Pizza En Cono', 'kono@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Portete De Tarqui 5219, Guayaquil 090409, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:06:04'),
(637, 'Kiwilimón La Lorena', '1723866149', 0, 'Restaurante', 'Av. Lorena Y José De Caldas', '11:00', '23:30', '20', '10', 'Hugo Luna', '1606507878', 'USD - $', 'resto_1606507878.jpg', '0963190017', '-0.2558708786630533', '-79.15764204096033', 'Heladeria', 'kiwilorena@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. José De Caldas 205, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '08-07-2022 23:53:06'),
(639, 'Coronel Fast Food And Beer', '1202502967', 0, 'Restaurante', 'Av. La Lorena Y Calle Andoas A 100 Metros De La Iglesia De Los Mormones', '17:00', '22:30', '20', '10', 'Freddy Balcazar', '1606683144', 'USD - $', 'resto_1606683144.jpg', '0994015366', '-0.257159667178426', '-79.15227359961702', 'Alitas & Fast Food', 'coronel@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. La Lorena &, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '01-09-2022 13:54:07'),
(641, 'Grill House', '1723395008001', 0, 'Restaurante', 'Rosales 3ra Etapa, Calle Eduardo Kigmang Y Theo Constante, Pasaje Bernardo De Legarda', '16:00', '22:30', '25', '10', 'Xavier Valdiviezo', '1606828662', 'USD - $', 'resto_1623716093.jpg', '0969078988', '-0.24370059866973626', '-79.18286023392395', 'Hamburguesas Artesanales Y Cortes De Carne Premium.', 'grillhouse@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr48+gv Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '30-11-2021 17:46:02');
INSERT INTO `fooddelivery_restaurant` (`id`, `name`, `dni`, `city_id`, `type_store`, `address`, `open_time`, `close_time`, `delivery_time`, `commission`, `store_owner`, `timestamp`, `currency`, `photo`, `phone`, `lat`, `lon`, `desc`, `email`, `website`, `city`, `location`, `is_active`, `del_charge`, `enable`, `session`, `status`, `ally`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`, `sequence`, `edit_id`, `edit_date_time`) VALUES
(643, 'Delta Vip Car', '1002806402', 0, 'Transporte', 'Quito', '00:15', '23:59', '7', '10', 'Francisco Cisneros ', '1606839315', 'USD - $', 'resto_1606839315.jpeg', '0959063757', '-0.2581175043865912', '-78.52501160284713', 'Servicio Puerta A Puerta ', 'deltaquito@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Pinllopata 1, Quito 170111, Ecuador', 1, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(645, 'KALIJAMA', '1724889645001', 0, 'Restaurante', 'Calle Severino Fioroni Y Av . Bomboli', '17:00', '22:30', '20', '5', 'Carlos Andres López Vega', '1607115850', 'USD - $', 'resto_1607115850.jpeg', '0984039246', '-0.2704445075868802', '-79.19739371966551', 'Hamburguesa ', 'kalijama@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'By Pass Quevedo Y, Severino Fiorini, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '2021-09-01 09:00:02'),
(647, 'El Buen Sabor', '1312345919', 0, 'Restaurante', 'Av Quito Y Pallatanga  Diagonal A Diario La Hora ', '16:00', '23:59', '13', '8', 'Geovanny Mejia ', '1607205218', 'USD - $', 'resto_1607205218.jpeg', '0985443985', '-0.2508645844877261', '-79.16393047999574', 'Comida Rapida ', 'sabor@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prxp+f8g, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '30-08-2022 18:22:39'),
(649, 'El Rincón De Génova', '1723866149', 0, 'Restaurante', 'Avenida Malecón Y A Vei 15', '10:00', '23:59', '10', '0', 'Marcon Genova', '1607350135', 'USD - $', 'resto_1607350135.jpg', '0995693881', '-2.205902726094929', '-80.95800108145906', 'Pizzeria', 'genova@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 15, Salinas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-07-28 07:45:29'),
(651, 'Big Birger', '1721387213', 0, 'Restaurante', 'Santa Elena Av Lupercio Bazan Malavu Y General Enriquez Gallo', '16:00', '23:59', '15', '0', 'Camilo Castillo ', '1607388734', 'USD - $', 'resto_1607454424.jpeg', '0983827193', '-2.2057043896995365', '-80.97311264704894', 'Comida Rapida ', 'bigbirger@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q2vg+mpp, Gral. Enríquez Gallo, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:57:39'),
(653, 'Se Lo Que Sea', '2450867623', 0, 'Lo Que Sea', 'Salinas Av 22 De Diciembre', '07:30', '23:59', '10', '0', 'Javier Velastegui', '1607407561', 'USD - $', 'resto_1607407561.jpg', '0989595926', '-2.2136217436197985', '-80.95724469851686', 'Comunícate Con Un Repartidor Y Pídele Que Te Lleve Lo Que Tu Quieras', 'loqueseasalinas@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Avenida 22 De Diciembre, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(655, 'Pide Un Repartidor', '2450867623', 0, 'Lo Que Sea', 'Salinas Av 22 De Diciembre', '07:30', '23:59', '10', '0', 'Javier Velastegui', '1607407787', 'USD - $', 'resto_1607407787.jpg', '0989595926', '-2.213471651995122', '-80.95754510592653', 'Solicita Un Repartidor Para Enviar Un Producto', 'pidesalinas@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Avenida 22 De Diciembre, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(657, 'Bolon De La Sra Mero', '2450849894', 0, 'Restaurante', 'La Libertad  Ciudadela Virgen Del Carmen', '07:30', '23:30', '15', '0', 'Luiggi Pozo Mero', '1607454359', 'USD - $', 'resto_1607454359.jpg', '0982854960', '-2.2419244629042008', '-80.91682380866243', 'Desayunos  Asados Y Parrilladas ', 'mejorbolon@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q35m+67 La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '15-03-2022 17:55:35'),
(659, 'Mr Puffin', '0915397806001', 0, 'Restaurante', 'Salinas Ciudadela Sevilla 2 Entre El Callejon A1  Y Peat B', '10:00', '22:00', '13', '0', 'Norka Vergara ', '1607526769', 'USD - $', 'resto_1607526769.jpeg', '0983795470', '-2.2196468377058673', '-80.95096832942201', 'Helados Y Bolos Artesanales ', 'mrpuffin@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q2jx+3qg, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:58:04'),
(661, 'Babys Wings', '1721387213', 0, 'Restaurante', 'Santa Paula ', '17:00', '23:30', '30', '0', 'Marco Solorzano', '1607530220', 'USD - $', 'resto_1607530220.jpeg', '0987395614', '-2.232704697455242', '-80.92621154021455', 'Alitas ', 'babys@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q38f+wgf, C. 31, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:58:19'),
(663, 'Pasteles Y Algo Más ', '0922868781', 0, 'Panadería', 'Salinas  Av Jaime Roldos Aguilera ', '08:00', '18:00', '15', '0', 'Andres Sanchez ', '1607533184', 'USD - $', 'resto_1607533184.jpeg', '0997210804', '-2.207272318589882', '-80.9699503226204', 'Pasteles', 'pasteles@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Salinas Tercera Av Calle Armando Barreto Atrás Del Bco Pch De Salinas, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:58:39'),
(665, 'Tamara Spa', '2450179789', 0, 'Publicidad', 'La Libertad, Sector 7 Esquinas Av. 7ma Entre Calles 14 Y 15', '09:00', '19:00', '10', '0', 'Tamara Espinosa', '1607713997', 'USD - $', 'resto_1607713997.jpg', '0983843523', '-2.224235327053402', '-80.91542905997468', 'Establecimiento Dotado De Instalaciones Apropiadas Para Someterse A Tratamientos Medicinales Con Agua, Que Generalmente Ofrece Otros Servicios Como Alojamiento O Instalaciones Deportivas.', 'spa@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Avenida Sexta 1212, La Libertad 240350, Ecuador', 0, 'Moto Auto O Motocicleta', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 1, NULL, NULL),
(667, 'Restaurante El Dorado', '0905031605001', 0, 'Restaurante', 'Salinas Av Lupercio Bazan Malavu', '07:00', '22:00', '15', '0', 'Maria Gonzambay', '1607714983', 'USD - $', 'resto_1607714983.jpg', '0984688388', '-2.205386783389653', '-80.97298121880723', 'Asados', 'eldorado@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Avenida Malecón 313, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(669, 'Chifa Guang Cai', '0923828271', 0, 'Restaurante', 'Santa Elena', '10:00', '22:00', '20', '0', 'Isis Chang', '1607719191', 'USD - $', 'resto_1607728673.jpg', '0959175206', '-2.2243432046249283', '-80.91444334816171', 'Comida China', 'guang@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Diagonal A 1032, La Libertad 240350, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(671, 'Plops Pizza', '0502727449001', 0, 'Restaurante', ' Malecon De La Libertad ', '14:30', '23:00', '15', '0', 'Santiago Yerovi', '1607726203', 'USD - $', 'resto_1610400892.jpg', '0969060419', '-2.2210271382786138', '-80.9113976998253', 'Pizza', 'plops@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q3hq+hfm, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:57:10'),
(673, 'Dsi', '0922868724001', 0, 'Supermercado', 'Barrio Mariscal Sucre Calle Guayaquil  S N Quinta Av ', '09:00', '18:00', '13', '0', 'Dennisse Sanchez', '1607791088', 'USD - $', 'resto_1607791088.jpg', '0969094564', '-2.224121087511727', '-80.90982809862972', 'Tegnologia ', 'dsi@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Patio De Comidas Cc Buena Aventura Moreno, Calle Guayaquil, La Libertad 240350, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-07-28 07:45:29'),
(675, 'Amor En La Piel', '1720667110001', 0, 'Supermercado', 'Av 22 De Diciembre Y Octavio Peña Davila ', '17:30', '17:30', '15', '0', 'Melanie Benitez', '1607814102', 'USD - $', 'resto_1607814102.jpg', '0983616970', '-2.2105502227037634', '-80.96298999022676', 'Ropa', 'piel@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Octavio Peña Davila, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-09-01 09:00:02'),
(677, 'Carnicos Sweet', '1721387213', 0, 'Supermercado', 'Sector Las Plameras Diagonal A Comisariatos Salinas', '10:00', '12:00', '15', '0', 'Caricos', '1607817745', 'USD - $', 'resto_1607817745.jpg', '0995577921', '-2.204924150068157', '-80.97468715019109', 'Carnes ', 'carnicos@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'El Alcazar, Avenida Malecón, Salinas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(679, 'Cevicheria Lojanita', '0904555299001', 0, 'Restaurante', 'Av. Gral. Enriquez Gallo Y Calle Leonardo Aviles Salinas, 241550', '10:00', '19:00', '10', '0', 'Hugo Perero González', '1607818669', 'USD - $', 'resto_1607818669.jpg', '0994492121', '-2.2041927438713107', '-80.97614622544481', 'Cevicheria', 'lojanita@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'General Enrique Gallo Y Fidón Tomalá, General Enríquez Gallo, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(681, 'Green S Restaurante', '0927089698', 0, 'Restaurante', 'Green S Esta Ubicado En La Libertad En La Av. Eleodoro Solorzano A Un Lado Del Estadio Deportivo, Frente A Prilabsa.', '08:00', '21:00', '18', '0', 'Angie Del Pezo', '1607977884', 'USD - $', 'resto_1607977884.jpeg', '0989665574', '-2.2271513689430154', '-80.9014547510071', 'Comida Vegetariana ', 'greens@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Eleodoro Solorzano, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(682, 'Soporte Logistics', '1723149850', 1, 'Supermercado', 'Santo Domingo - Matriz', '00:00', '23:59', '15', '0', 'Soporte', '1558154534', 'USD - $', 'store_1607950770.png', '0969764774', '-0.259384', '-79.170022', 'Soporte Store', 'servicio@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Santo Domingo, Ecuador - Matriz', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(683, 'Soporte Logistics', '1723149850', 10, 'Supermercado', 'Santa Elena - Sucursal', '00:00', '23:59', '15', '0', 'Soporte', '1558154534', 'USD - $', 'store_1607950770.png', '0969764774', '-2.2268766', '-80.856664', 'Soporte Store', 'servicio@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Santa Elena, Ecuador - Surcursal', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(684, 'Soporte Logistics', '1723149850', 6, 'Supermercado', 'Guayaquil - Sucursal', '00:00', '23:59', '15', '0', 'Soporte', '1558154534', 'USD - $', 'store_1607950770.png', '0969764774', '-2.1889152', '-79.8892503', 'Soporte Store', 'servicio@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Centro Av. 9 De Octubre', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(686, ' Chichos Asados', '0919221192', 0, 'Restaurante', 'Calle Enrique Gallos Plaza Marvento Local 4 Al Lado Del Cuerpo De Bomberos De Salinas', '16:00', '23:45', '14', '0', 'Christian Francisco Gonzalez Molina', '1608153585', 'USD - $', 'resto_1608217340.jpg', '0963128713', '-2.2064655724784124', '-80.97146040629579', 'Asados', 'chichos@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Avenida Malecón 237, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(688, 'La Gustosa- Pizzeria', '1715321657001', 0, 'Restaurante', 'Calle Luis Tamayo Y Jacinto Cortez', '16:00', '21:00', '20', '10', 'Raúl Francisco Tandazo Vélez', '1608154565', 'USD - $', 'resto_1608154565.jpg', '0967098450', '-0.25931882350435526', '-79.1857153816147', 'Pizzería', 'gustosa@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'L. Garcia 101, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-07-28 07:45:29'),
(690, 'Dulce Factoria ', '1721387213', 0, 'Restaurante', 'La Libertad Barrio La Esperanza Calle 24 Av 13 Casa Esquinera De Dos Pisos  Al Frente  De Probelic ', '10:00', '22:00', '14', '0', 'Gabriela Menoscal Santillan ', '1608157047', 'USD - $', 'resto_1608217381.jpg', '0925802126', '-2.2329512733315675', '-80.86670136880113', 'Helados ', 'dulce@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Calle S-1, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(692, 'Licores Bodegón', '0919146019', 0, 'Licorería', 'Av. Carlos Espinoza Larrea', '10:00', '20:00', '10', '0', 'Franklin Macias', '1608237682', 'USD - $', 'resto_1608237682.jpeg', '0993951525', '-2.2060166354992647', '-80.95814860295488', 'Licores ', 'bodegon@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Malecón &, Salinas, Ecuador', 0, 'Moto  ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '22-05-2022 17:30:46'),
(694, 'Waffel Kuchen', '0918896317', 0, 'Panadería', 'Avenida Malecón Sector San Lorenzo Edificio Ancona (esquinero) A Una Cuadra De La Perrada De Raúl', '10:00', '20:00', '20', '0', 'Ammy Pazmiño', '1608324633', 'USD - $', 'resto_1608324633.jpg', '0991165877', '-2.204429943717185', '-80.96061757635309', 'Dulces Y Tortas Artesanales De Barquillos Personalizadas.', 'waffel@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Avenida Malecón 864, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(696, 'La Piedra', '1717564429001', 0, 'Restaurante', 'Calle Venezuela  Frente Al Neumane', '13:00', '23:00', '50', '0', 'Fernando Cevallos', '1608413774', 'USD - $', 'resto_1608413774.jpg', '0939185318', '-0.24942559306547551', '-79.18110734652711', 'Asados', 'lapiedra@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Colombia 108, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-04-2022 13:13:34'),
(698, 'New West Bbq And Carryout ', '0550256135', 0, 'Restaurante', 'Av. Shchumacher A Pocos Metros Del Colegio Antonio Neuman Junto A Farmacia Económica', '17:00', '23:00', '20', '10', ' Evelyn Estefanía Viteri Villamarin', '1608640363', 'USD - $', 'resto_1608640363.jpg', '0987635993', '-0.24978232347935742', '-79.18034023474885', 'Hamburguesas', 'new@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Obispo P. Schumacher 502, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(700, 'Mercadito Todito', '1391918585001', 0, 'Supermercado', 'La Libertad Calle Robles Bordero Y Av. Tercera', '07:00', '23:59', '20', '0', 'Coellar Gonzalez Pedro Daniel', '1609098881', 'USD - $', 'resto_1609722116.png', '0982913902', '-2.222585670287708', '-80.90890458654593', 'Supermecado', 'todito@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Tercera 520, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(702, 'Baruc Burgers', '1721387213', 0, 'Restaurante', 'Carchi ', '16:00', '22:30', '10', '0', 'Fraimer Javier Tarazona', '1609276204', 'USD - $', 'resto_1610051782.jpg', '0963697425', '-2.1885991164773686', '-79.89569074343873', 'Hamburguesas , Apanados Y Mas  ', 'baruc@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Carchi 901, Guayaquil 090310, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(704, ' Nikys Salt Y Sweet', '0953808623001', 0, 'Panadería', 'Alborada 9na Etapa Mz 914 Villa 12', '08:00', '21:00', '10', '0', 'Nicole Cañarte Falcones', '1609358245', 'USD - $', 'resto_1609358245.jpeg', '0996309684', '-2.1357221714438936', '-79.8996818704529', 'Alfajores, Brownie, Cake, Cupcakes ', 'nikys@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', '34, Flor De Bastion 090502, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(706, 'Rodri Food ', '0923569404', 0, 'Restaurante', 'Salinas 22 De Diciembre ', '18:00', '23:00', '13', '0', 'Guillermo Vera ', '1610124162', 'USD - $', 'resto_1610124162.jpg', '0988393062', '-2.208481096827752', '-80.96625423859788', 'Comida Mexicana ', 'rodrifood@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', '22 De Diciembre, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'NO', 0, 5, '2021-09-01 09:00:02'),
(708, 'Gelatomix 29 De Mayo', '1721387213', 0, 'Restaurante', 'Av. 29 De Mayo Y Loja ', '11:00', '20:00', '20', '0', 'Pendiente', '1611525459', 'USD - $', 'resto_1648609533.png', '0994214728', '-0.2531316997295472', '-79.17362130116655', 'Heladeria', 'gelatomix@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. 29 De Mayo 805, Santo Domingo, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '02-04-2022 09:30:43'),
(712, 'Papa Johns', '1724715220', 0, 'Restaurante', 'Av. Río Lelia, Santo Domingo 230103', '12:00', '22:00', '25', '0', 'Pendiente', '1611670569', 'USD - $', 'resto_1611670569.jpg', '0969764774', '-0.24975416055229252', '-79.15237552355958', 'Pizzeria', 'jhons@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2x+43g, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '16-04-2022 22:12:42'),
(714, 'La Jama De Luana ', '0923313399', 0, 'Restaurante', 'Libertad Entre La Calle 38 Y Av 20', '08:00', '22:30', '15', '0', 'Cristian Pluas ', '1611672160', 'USD - $', 'resto_1611672160.jpg', '0992333521', '-2.2328869491939005', '-80.89700228404237', 'Desayunos Almuerzos Meriendas  Y Platos Especiales ', 'jama@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 20, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(716, 'Naturissimo', '1721387213', 0, 'Restaurante', 'Shooping Santo Domingo ', '10:00', '22:00', '12', '0', 'Liliana Gallegos', '1611692429', 'USD - $', 'resto_1611692429.jpeg', '0969764774', '-0.24768351470264607', '-79.16308290194704', 'Yogufit,frusty, Jugos Naturales', 'naturissimo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Rio Cochambi 94, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(718, 'Carl\'s Jr', '1724715220', 0, 'Restaurante', 'Paseo Shopping', '10:00', '22:00', '20', '0', 'Pendiente', '1611766519', 'USD - $', 'resto_1611779888.jpg', '0969764774', '-0.2490390233485423', '-79.16191614102556', 'Hamburguesas', 'carls@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito 1301, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(720, 'Picantería Carmita', '1721387213', 0, 'Restaurante', 'Santa Elena Libertad Calle 13', '07:00', '14:00', '10', '0', 'Carmita ', '1611768276', 'USD - $', 'resto_1611768276.jpg', '0989595926', '-2.226851188426624', '-80.89969522189332', 'Encebollados ', 'carmita@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 13 250, La Libertad, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(722, 'Empanadas De Paco ', '1721387213', 0, 'Restaurante', 'Paseo Shoping', '10:00', '19:00', '15', '0', 'No Hay Representante', '1611776916', 'USD - $', 'resto_1611780679.jpg', '0960540081', '-0.24870274456560376', '-79.16263229083253', 'Empanadas', 'paco@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '2021-09-01 09:00:02'),
(724, 'Rincon Familiar ', '1706874516001', 0, 'Restaurante', 'La Libertad Barrio Rocafuerte  Frente A La Ciudadela  Las Acacias Por El Puente Palou', '17:00', '23:00', '20', '0', 'Carlos Herrera ', '1611788512', 'USD - $', 'resto_1611788512.jpeg', '0984234077', '-2.224299651569046', '-80.90423351954652', 'Parrilladas Y Piques', 'rincon@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'C. 27, La Libertad, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, NULL, '2021-07-28 07:45:29'),
(726, 'La Chozita Fast Food', '1721387213', 0, 'Restaurante', 'La 38ava, Entre Garcia Goyena Y Bolivia Guayaquil', '17:00', '23:30', '16', '0', 'Orlando Enrique Sangrona Rangel', '1611867133', 'USD - $', 'resto_1611867133.jpeg', '0992718077', '-2.2028794333062898', '-79.9265897912903', 'Hamburguesas, Mariscos, Tacos , Parrilladas, Sándwiches', 'chozita@faster.com.ec', 'www.faster.com.ec', 'Guayaquil', 'Av. 29 1821, Guayaquil 090409, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(728, 'Pizza Hut', '1721387213001', 0, 'Restaurante', 'Shopping ', '10:00', '22:00', '13', '0', 'Liliana Gallegos', '1611939429', 'USD - $', 'resto_1611939429.jpg', '0987119890', '-0.24751185492853375', '-79.16316873263551', 'Pizzas ', 'pizzahut@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2p+wp9, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 16, '21-09-2021 18:18:11'),
(730, 'Parrilladas Oh Que Rico', '1721387213', 0, 'Restaurante', 'Av. Tsafiqui ', '12:00', '21:00', '20', '0', 'Pendiente', '1611951295', 'USD - $', 'resto_1611951295.jpg', '0969764774', '-0.2596061521989213', '-79.16575304102136', 'Parrilladas', 'ohquerico@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Los Almendros 101, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '06-04-2022 22:25:35'),
(732, 'Sorbetto', '1721387213', 0, 'Restaurante', 'Santa Elena Avenida Malecón Y Avenida 15', '11:00', '22:00', '10', '0', 'Sorbetto', '1612032773', 'USD - $', 'resto_1612032773.jpeg', '0989595926', '-2.206106422905926', '-80.9580815477295', 'Heladería', 'sorbetto@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 15, Salinas, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(734, 'Cevichería D Hugo ', '1721387213', 0, 'Restaurante', 'Avenida María Luz Gonzales Rubio', '08:00', '22:00', '20', '0', 'Hugo ', '1612037049', 'USD - $', 'resto_1612037049.jpeg', '0986759426', '-2.2038657564511723', '-80.97715741824342', 'Cevichería', 'hugo@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Calle 15 9, Salinas, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(736, 'Faceburguer', '1724715220', 0, 'Restaurante', 'Rio Toachi Y Abraham Calazacon', '16:00', '10:00', '14', '0', 'Liliana Gallegos', '1612127606', 'USD - $', 'resto_1612209275.jpg', '0969764774', '-0.25579443646816175', '-79.16497117709352', 'Hamburguesas , Hot Dog, ', 'faceburguer@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Luis A. Valencia 207, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(738, 'Cevichería  Karina ', '1721387213', 0, 'Restaurante', 'Salinas Avenida General Enriquez Y Las Palmeras Entre Calles 17 Y 18', '08:00', '18:00', '20', '0', 'Karina ', '1612638310', 'USD - $', 'resto_1612638310.jpeg', '0989595926', '-2.2040560524175237', '-80.97656330894664', 'Parrillada De Marisco, Ceviche, Pescado', 'cevicheriak@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Gral. Enríquez Gallo, Salinas, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '24-09-2021 21:37:23'),
(740, 'Papi Burger Joe\'s', '1717564429', 0, 'Restaurante', 'Av. Venezuela Y Guatemala Esquina', '17:00', '22:30', '20', '0', 'Pendiente', '1612643820', 'USD - $', 'resto_1612643820.jpg', '0987505743', '-0.2494430272588633', '-79.18284541796876', 'Papas Fritas Y Hamburguesas', 'papiburger@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr28+6rf, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '28-07-2022 20:22:20'),
(742, 'Mayflower', '1721387213', 0, 'Restaurante', 'Shooping Santo Domingo', '10:00', '22:00', '10', '0', 'Liliana Gallegos', '1612817921', 'USD - $', 'resto_1612817921.jpeg', '0969764774', '-0.24751185492853375', '-79.16385537814332', 'Chaulafan De Pollo , Tallarín De Pollo', 'mayflower@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Ec120170, Santo Domingo, Ecuador', 0, 'Moto Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(744, 'Grill Y Bar Rayotomas', '1721388609', 0, 'Restaurante', 'Calle Tulcán Entre 6 De Noviembre Y Edmundo Catford', '11:00', '23:00', '25', '10', 'Luis Suarez', '1612832754', 'USD - $', 'resto_1612969417.jpg', '0984428570', '-0.2571355275404161', '-79.16949069928361', 'Comida Rapida ', 'luis.suarez.aguilar@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Tulcán 613, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-07-28 07:45:29'),
(746, 'La Perrada De Raul', '1721387213', 0, 'Restaurante', 'Salinas', '17:00', '23:00', '15', '0', 'No Hay Representante ', '1612971543', 'USD - $', 'resto_1612971543.jpeg', '0992039540', '-2.2044232431570934', '-80.95891839694215', 'Hamburguesas Hot Dogs ', 'perrada@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Avenida Malecón, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(748, 'Oahu Superfood', '1724715220', 0, 'Restaurante', 'Vicente Rocafuerte Y Calle 52', '08:30', '21:00', '20', '0', 'Pendiente', '1612974971', 'USD - $', 'resto_1645300413.jpeg', '0980146519', '-2.2056092418247797', '-80.95914504360391', 'Comida Saludable', 'oahu@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q2vr+r3h, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '19-02-2022 14:53:33'),
(750, 'Carl\'s Jr', '1724715220', 0, 'Restaurante', 'Santa Elena Libertad', '11:00', '21:00', '15', '0', 'Pendiente', '1613074728', 'USD - $', 'resto_1613425958.jpg', '0969764774', '-2.2259935294714', '-80.92295533847047', 'Hamburguesas', 'carlsjr@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'A Vei 9, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(752, 'Tikkis Burguer', '0914685094', 0, 'Restaurante', 'Santa Elena, Libertad, Calle 16', '07:00', '22:00', '14', '0', 'María Isabel Reyes Campuzano', '1613081956', 'USD - $', 'resto_1613081956.jpeg', '0994289310', '-2.2236001223107746', '-80.89658117722703', 'Hamburguesas', 'sepaladi@gmail.com', 'www.faster.com.ec', 'Santa Elena', 'Q4g3+h9w, La Libertad, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 21, '08-01-2022 12:00:50'),
(754, 'Marcelo Tacos  ', '1721387213', 0, 'Restaurante', 'Salinas ', '17:00', '23:00', '15', '0', 'No Tiene Representante', '1613141680', 'USD - $', 'resto_1613141680.jpeg', '0984754553', '-2.2075322998016307', '-80.95790988635255', 'Tacos,sanduches,bandejitas Y Algo Mas', 'tacos@faster.com.ec', 'faster.com.ec', 'Santa Elena', '24, Las Dunas 240209, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(756, 'Picantería El Pez Amarillo', '1721387213', 0, 'Restaurante', 'Santa Elena, Libertad, Avenida Carlos Espinoza', '07:30', '14:00', '10', '0', 'Faster', '1613149238', 'USD - $', 'resto_1613149238.jpeg', '0969764774', '-2.2283306489509', '-80.90607887934877', 'Encebollado, Ceviches ', 'pezamarillo@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Eleodoro Solorzano, La Libertad 240350, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(758, 'Lui E Lei  Restobar ', '1721387213', 0, 'Restaurante', 'Av Malecon  Salinas ', '08:00', '22:00', '15', '0', 'No Tiene Representante ', '1613165176', 'USD - $', 'resto_1613165176.jpeg', '0989595926', '-2.204078164271192', '-80.97490033935736', 'Mariscos Y Comida Italiana ', 'luielei@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Sixto Durán Ballén S/n Y Filemón Tomalá, Salinas 241550, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(760, 'Masas Didace', '1720347796', 0, 'Lo Que Sea', 'Rio Quevedo Y Abraham Calazacon', '08:00', '21:00', '5', '10', 'Diego David Cedeño Vega', '1613421551', 'USD - $', 'resto_1613494444.jpg', '0980336351', '-0.24377825429451963', '-79.16387683581544', 'Masas Listas Para Hacer Tortillas, Muchines , Corviques, Tortas', 'diegocede@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Rio De Oro 102, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-07-28 07:45:29'),
(762, 'Cuke Fast Food', '1723219315', 0, 'Restaurante', 'Calle José Martí Y Simón Bolivar, Casa Esquinera  De Dos Pisos  Frente A Una Casa Turqueza', '16:00', '22:00', '15', '10', 'Juan Isaac Vizueta Valencia ', '1613755156', 'USD - $', 'resto_1613755156.jpeg', '0958851484', '-0.2636049488808802', '-79.15967113208009', 'Alitas', 'issac.vizuti@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prpr+f87, Santo Domingo, Ecuador', 0, 'Moto Auto ', 0, 1, 'active', 'Gratis', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '06-09-2022 10:48:18'),
(764, 'Tablita Del Tartaro', '1721387213', 0, 'Restaurante', 'Paseo Shopping Patio De Comidas', '10:00', '22:00', '20', '0', 'Pendiente', '1613766744', 'USD - $', 'resto_1613769328.jpg', '0969764774', '-0.2487510238729584', '-79.16209048461153', 'Asados', 'tablitasto@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2q+g57, Santo Domingo, Ecuador', 0, 'Moto ', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-03-2022 16:08:33'),
(766, 'Tablita Del Tartaro', '1721387213', 10, 'Restaurante', 'Paseo Shopping ', '10:00', '22:00', '20', '0', 'Pendiente', '1613767089', 'USD - $', 'resto_1613769357.jpg', '0969764774', '-2.2265938907924814', '-80.92106706332399', 'Carnes Asadas', 'tartaro@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Av. Onceava 42, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(768, 'La Sazon Manabita', '2300366479', 1, 'Restaurante', 'Via Quito Km5 Sector Turiscol Margen Izquierdo\r\nFrente Al Hotel San Miguel\r\n', '07:00', '17:00', '15', '0', 'Evelyn Tatiana  Merchan Veliz', '1614052050', 'USD - $', 'resto_1614118222.jpeg', '0939051078', '-0.25429241430089383', '-79.13083202075197', 'Vendemos Comida Criolla 100% Hecha En Leña', 'veliztatiana3@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Pvw9+7m Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '10-03-2022 12:50:09'),
(770, 'Blukoi Sushi Bar', '2300366479', 1, 'Restaurante', 'Av. Río Lelia Y', '15:00', '22:00', '30', '0', 'Pendiente', '1614098001', 'USD - $', 'resto_1614098001.jpeg', '0992502176', '-0.2514181200556404', '-79.15258339475824', 'Sushi', 'blukoi@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 142, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(772, 'Sushi Asai Express', '1721387213', 10, 'Restaurante', 'Salinas', '12:00', '23:00', '20', '0', 'No Tiene Representante', '1614112909', 'USD - $', 'resto_1614112909.jpeg', '0979952311', '-2.2203101862002876', '-80.94540676902963', 'Shushi', 'asai@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q3h3+vr Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '08-10-2021 15:07:17'),
(774, 'Empanadas De Paco', '1721387213', 10, 'Restaurante', ' Shooping  Santa Elena', '09:00', '22:00', '10', '0', 'No Hay Representante', '1614115695', 'USD - $', 'resto_1614115695.jpg', '0989595926', '-2.225864880585107', '-80.92213994692995', 'Empanadas', 'pacose@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Calle 9, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(776, 'Comidas De Victor ', '1721387213', 10, 'Restaurante', 'Santa Elena ', '10:00', '21:00', '20', '0', 'No Tiene Representante', '1614121386', 'USD - $', 'resto_1614197999.jpeg', '0989595926', '-2.226363394957066', '-80.92188513707353', 'Asados', 'comidavictor@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Avenida Central, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(778, 'Piqueos Y Moritos', '1721387213', 10, 'Restaurante', 'Santa Elena, Libertad, Av Carlos Espinoza', '10:00', '21:00', '15', '0', 'No Tiene Representante', '1614131078', 'USD - $', 'resto_1614198021.jpeg', '0989595926', '-2.226194543333841', '-80.92112070750429', 'Piqueos', 'piqueos@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'C.c. Paseo Shopping La Libertad Barrio 28 De Mayo, Vía Salina, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(780, 'Nice Cream ', '1721387213', 10, 'Restaurante', 'Santa Elena, Libertad, Av Carlos Espinoza', '10:00', '21:00', '19', '0', 'No Tiene Representante', '1614182715', 'USD - $', 'resto_1614200851.jpeg', '0989595926', '-2.225474913579835', '-80.92088064979745', 'Helados', 'nice@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Av. Onceava 42, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(782, 'Cajún', '2300366479', 10, 'Restaurante', 'Paseo Shopping, La Libertad', '10:00', '20:50', '20', '0', 'Pendiente', '1614198958', 'USD - $', 'resto_1614198958.jpeg', '0969764774', '-2.2265118101575516', '-80.92111869584753', 'Asados', 'cajun@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Av. Onceava 42, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(784, 'Coco Express', '1721387213', 10, 'Restaurante', 'Santa Elena, Libertad, Av Carlos Espinoza', '10:00', '21:00', '15', '0', 'No Tiene Representante', '1614200524', 'USD - $', 'resto_1614200901.jpeg', '0989595926', '-2.226465241958553', '-80.92121190261079', 'Helados Agua ', 'express@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Av. Onceava 42, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(786, 'Los Pollos De San Bartolo', '1723866149', 4, 'Restaurante', 'Av. Nogales N50-160 Y Pasaje C', '09:00', '20:30', '20', '0', 'Fantasma', '1614205251', 'USD - $', 'resto_1614205251.jpeg', '0989629049', '-0.1475948112968613', '-78.46563345622255', 'Asadero De Pollos', 'bartolo@faster.com.ec', 'www.faster.com.ec', 'Quito', 'De Los Nogales 150-1, Quito 170124, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(788, 'Señor Hot Dog ', '1721387213', 10, 'Restaurante', 'Santa Elena, Libertad, Av Carlos Espinoza', '10:00', '21:00', '15', '0', 'Pendiente', '1614220810', 'USD - $', 'resto_1614270891.jpeg', '0989595926', '-2.226422359011421', '-80.92128164004518', 'Hot Dog ', 'señorhotdog@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Av. Onceava 42, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(790, 'Los Pinchos De Langostino', '1723866149', 4, 'Restaurante', 'Río Coca E5-49, Quito 170138', '12:00', '22:00', '15', '0', 'Fantasma', '1614225287', 'USD - $', 'resto_1614225287.jpg', '0989629049', '-0.1621001446367532', '-78.48187154959872', 'Asados', 'langostas@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Río Coca E5-49, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(792, 'Costeñito Al Paso', '1723866149', 5, 'Restaurante', 'Río Cofanes, Quito 170513', '09:00', '17:00', '15', '0', 'Fantasma', '1614269025', 'USD - $', 'resto_1614269025.jpeg', '0989629049', '-0.16265804187137023', '-78.48366326522067', 'Mariscos', 'costeñitoalpaso@faster.com.ec', 'www.faster.com.ec', 'La Concordia', 'Isla Española E4-09, Quito 170513, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(794, 'Mr Wafle ', '1721387213', 10, 'Restaurante', 'Santa Elena, Libertad, Av Carlos Espinoza\r\n\r\n', '10:00', '21:00', '15', '0', 'Pendiente', '1614272364', 'USD - $', 'resto_1614272364.jpeg', '0989595926', '-2.225864880585107', '-80.92106706332399', 'Waffles Y Crepes ', 'waflesydulces@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q3fh+jm5, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '04-07-2022 08:24:49'),
(796, 'Dolupa', '0923275051001', 10, 'Panadería', 'Santa Elena Shooping', '09:00', '17:00', '10', '0', 'Sin Representante', '1614283881', 'USD - $', 'resto_1614283881.jpg', '0989595926', '-2.2256075827787694', '-80.92351323794557', 'Pasteleria ', 'dolupas@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'A Vei 8, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(798, 'Mundo Licor', '1719825653', 1, 'Licorería', 'Urb. Las Palmeras Calle Atahualpa Y Huáscar Esquina', '07:00', '23:59', '5', '10', 'Cruz Rivadeneira Marcos Santiago ', '1614305344', 'USD - $', 'resto_1614359062.jpeg', '0982027660', '-0.26072965091735084', '-79.17839295100404', 'Licores Artesanales ', 'santiago_0.13@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'C. Atahualpa 119, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '22-05-2022 04:33:03'),
(800, 'Nixtaco Comida Mexicana', '1718053620001', 1, 'Restaurante', 'Av. Quito Y Calle Roma Diagonal Al Parque De La Juventud', '16:00', '23:00', '20', '8', 'Andrés Cevallos', '1614369272', 'USD - $', 'resto_1614369272.jpeg', '0995679985', '-0.24692713880628525', '-79.14997762870027', 'La Auténtica Comida Mexicana Ahora En Santo Domingo', 'nixtacoec@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito 113, Santo Domingo, Ecuador', 1, 'Moto Auto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 17, '04-02-2022 19:03:14'),
(802, 'Pollo Campero', '1723866149', 4, 'Restaurante', 'Av. Galo Plaza Lasso Y Av. De Los Agarrobos', '10:00', '21:45', '15', '0', 'Fantasma', '1614370820', 'USD - $', 'resto_1614370820.jpeg', '0989629049', '-0.1422357748282581', '-78.48267084788516', 'Pollo Asado', 'campero@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. Galo Plaza Lasso N52-98, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 20:39:00'),
(804, 'Maracay Arepas Y Empanadas Venezolanas', '1721387213', 10, 'Restaurante', 'Avenida Eleodoro Solorzano Diagonal A La Plaza La Libertad', '17:00', '23:00', '25', '0', 'Pendiente', '1614374369', 'USD - $', 'resto_1614374369.jpeg', '0969764774', '-2.227080344094219', '-80.89993092101051', 'Arepas Y Empanadas', 'maracay@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'A Vei 13 250, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(806, 'Pizza Mia ', '2490030444001', 10, 'Restaurante', 'Salinas\r\n', '11:00', '23:00', '15', '0', 'Miriam Gonzales ', '1614444734', 'USD - $', 'resto_1614876723.jpeg', '0978636579', '-2.2419566247751717', '-80.9278047723694', 'Pizzas ', 'kledezmagonzalez@gmail.com', 'faster.com.ec', 'Santa Elena', 'Calle 12, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(808, 'Pizza Hut', '0801913724', 10, 'Restaurante', 'Paseo Shopping La Libertad', '10:00', '21:00', '14', '0', 'Sin Representante', '1614457075', 'USD - $', 'resto_1614457075.jpeg', '0989595926', '-2.2262079442570206', '-80.92102414797975', 'Pizzas Paseo Shoping', 'hutlibertad@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Onceava 42, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(810, 'Kobe Sushi Rolls', '1723866149', 4, 'Restaurante', 'Granados Plaza', '11:00', '22:00', '10', '0', 'Fantasma', '1614634045', 'USD - $', 'resto_1614634045.jpeg', '0989629049', '-0.168473046734938', '-78.47547179888917', 'Sushi', 'kobe@faster.com.ec', 'www.faster.com.ec', 'Quito', 'De Los Granados, Quito 170513, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(812, 'Lai Lai', '1723866149', 4, 'Restaurante', 'Rio Coca E Isla Seymour', '10:00', '21:30', '15', '0', 'Fantasma', '1614705280', 'USD - $', 'resto_1614705280.jpeg', '0989629049', '-0.1627867873848609', '-78.47960240077208', 'Comida China', 'lailai@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Río Coca 1529, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(814, 'Frozen Yogurt', '1721387213001', 10, 'Restaurante', 'Libetard, Paseo Shopping', '10:00', '21:00', '10', '0', 'Ninguno ', '1614877374', 'USD - $', 'resto_1614877374.jpeg', '0989595926', '-2.2246641571047414', '-80.92046624850465', 'Yogurt, Pan De Yuca ', 'frozen@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Octava 240, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(816, 'Menestras Del Negro', '1723866149', 4, 'Restaurante', 'Av. 6 De Diciembre Y De Las Cuadras', '11:00', '21:00', '16', '0', 'Fantasma', '1614877531', 'USD - $', 'resto_1614877531.jpeg', '0989629049', '-0.1466667700375684', '-78.47486830186082', 'Menestras', 'menestradelnegroquito@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. 6 De Diciembre N49-160, Y, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(818, 'Pepitos Grill', '0801913724', 4, 'Restaurante', 'Av. De Los Shyris N37-195, Quito 170505', '09:00', '22:00', '15', '0', 'Pendiente', '1614897644', 'USD - $', 'resto_1614897644.jpeg', '0989629049', '-0.17370735428921583', '-78.48061359357072', 'Arepas', 'pepitosgrill@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Últimas Noticias 404, Quito 170135, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(820, 'Sushi Fugu', '1721387213001', 10, 'Restaurante', 'Salinas, Cdla La Carolina ', '12:00', '23:00', '15', '0', 'Cesar Tamayo', '1614953842', 'USD - $', 'resto_1614953842.jpeg', '0978681571', '-2.226829746958834', '-80.92407113742073', 'Rollos De Sushi ', 'sushifugu@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Cantón Salinas Cdla. La Carolina, Calle 6, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(822, 'Farmacia Cruz Azul', '2450867623', 1, 'Farmacia', 'Av. Quito S/n Y Abraham Calazacon, Santo Domingo', '08:00', '22:00', '20', '0', 'Pendiente', '1614977870', 'USD - $', 'resto_1614977870.jpeg', '0969764774', '-0.24816630780541543', '-79.16093445252608', 'Farmacia', 'cruzazul@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito S/n Y Abraham Calazacon, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(824, 'Farmacia Cruz Azul', '2450867623', 1, 'Farmacia', 'Av. 29 De Mayo Y Calle Cocaniguas', '08:00', '22:00', '20', '0', 'Fantasma', '1614978105', 'USD - $', 'resto_1614978105.jpeg', '0969764774', '-0.25391992618724024', '-79.16739220600559', 'Farmacia', 'azul@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. 29 De Mayo 116, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(826, 'Farmacia Cruz Azul', '1723866149', 10, 'Farmacia', 'La Libertad', '07:00', '23:00', '20', '0', 'Fantasma', '1614978460', 'USD - $', 'resto_1614978460.jpeg', '0969764774', '-2.232666169970823', '-80.89783075135185', 'Farmacia', 'azullibertad@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 20, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(828, 'Farmacia Cruz Azul', '1723866149', 10, 'Farmacia', 'Salinas', '07:00', '20:00', '20', '0', 'Fantasma', '1614978849', 'USD - $', 'resto_1614978849.jpeg', '0969764774', '-2.2354361260141182', '-80.93143044840528', 'Farmacia', 'azulsalinas@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 9, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(830, 'Farmacia Santa Martha', '1723866149', 10, 'Farmacia', 'A Vei 20, La Libertad', '07:00', '22:00', '20', '0', 'Fantasma', '1614980074', 'USD - $', 'resto_1614980107.jpeg', '0969764774', '-2.2327415498306933', '-80.89755817186071', 'Farmacia', 'marthalibertad@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 20, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(832, 'Farmacia Sana Sana', '1723866149', 1, 'Farmacia', 'Avenida Quito, Santo Domingo', '08:30', '21:00', '20', '0', 'Fantasma', '1614980388', 'USD - $', 'resto_1614980388.jpeg', '0969764774', '-0.2505329995724117', '-79.16326361577941', 'Farmacia', 'sanasanay@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(834, 'Farmacia Sana Sana', '1723866149', 1, 'Farmacia', 'Santo Domingo Y Del Indio Colorado', '08:00', '21:00', '20', '0', 'Fantasma', '1614981041', 'USD - $', 'resto_1614981041.jpeg', '0969764774', '-0.25400877348805506', '-79.17624047826959', 'Farmacia', 'sanasana@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. 3 De Julio, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(836, 'Farmacia Sana Sana', '1723866149', 10, 'Farmacia', 'La Libertad', '08:00', '22:30', '20', '0', 'Fantasma', '1614981693', 'USD - $', 'resto_1614981693.jpeg', '0969764774', '-2.2214228018700486', '-80.90989096891118', 'Farmacia', 'sanalibertad@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Segunda A 430, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(838, 'Red Farmacy\'s', '1724715220', 1, 'Farmacia', 'Av. Abraham Calazacón, Santo Domingo', '08:30', '20:00', '10', '0', 'Fantasma', '1615061692', 'USD - $', 'resto_1615061692.jpg', '0969764774', '-0.26404583231374273', '-79.16886742096378', 'Farmacia', 'farmacy@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón 40, Santo Domingo 230101, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02');
INSERT INTO `fooddelivery_restaurant` (`id`, `name`, `dni`, `city_id`, `type_store`, `address`, `open_time`, `close_time`, `delivery_time`, `commission`, `store_owner`, `timestamp`, `currency`, `photo`, `phone`, `lat`, `lon`, `desc`, `email`, `website`, `city`, `location`, `is_active`, `del_charge`, `enable`, `session`, `status`, `ally`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`, `sequence`, `edit_id`, `edit_date_time`) VALUES
(840, 'Red Farmacy\'s', '1724715220', 1, 'Farmacia', 'Av. Río Lelia, Santo Domingo', '08:00', '20:00', '10', '0', 'Fantasma', '1615062026', 'USD - $', 'resto_1615062026.jpg', '0969764774', '-0.2541720513562436', '-79.15260451715423', 'Farmacia', 'redfarmacy@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 142, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(842, 'Coral Hipermercados', '1724715220', 1, 'Supermercado', 'Baterias Ecuador, 1/2, Av. Quevedo 3-703-914, Santo Domingo +593', '09:00', '19:00', '40', '0', 'Fantasma', '1615062532', 'USD - $', 'resto_1615062532.jpg', '0969764774', '-0.26748405200646735', '-79.19392964672281', 'Hipermercados', 'coral@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quevedo, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(844, 'Supermaxi', '1724715220', 1, 'Supermercado', 'Avenida Quito 456, Santo Domingo', '09:30', '20:00', '40', '0', 'Fantasma', '1615062713', 'USD - $', 'resto_1615062713.jpg', '0969764774', '-0.2525037336572978', '-79.1656873269005', 'Supermercados', 'supermaxi@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito 456, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(846, 'Supermaxi', '1724715220', 10, 'Supermercado', 'Manzana R1, Salinas 241550', '09:30', '20:30', '40', '0', 'Fantasma', '1615063202', 'USD - $', 'resto_1615063202.jpg', '0969764774', '-2.221310568770633', '-80.9448062894864', 'Supermercado', 'super@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Brasil, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(848, 'Farmacia Cruz Azul', '1724715220', 4, 'Farmacia', 'Eloy Alfaro Y Juan Molineros', '07:00', '22:00', '20', '0', 'Fantasma', '1615064675', 'USD - $', 'resto_1615064675.jpg', '0969764774', '-0.12850457941031543', '-78.47085605245067', 'Farmacia', 'azuluio@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Juan Molineros Y Eloy Alfaro 1, Quito, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 21:12:31'),
(850, 'Farmacia Santa Martha', '1724715220', 1, 'Farmacia', 'Av. Jacinto Cortez Jhayya Nro.s/n (jorge Icaza)', '08:00', '20:00', '20', '0', 'Fantasma', '1615065489', 'USD - $', 'resto_1615065489.jpg', '0969764774', '-0.25901305480473535', '-79.17070037554933', 'Farmacia', 'santa@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Federico Gonzalez Suarez 100, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(852, 'Sana Sana', '1724715220', 4, 'Farmacia', 'Calle, Capitan Ramón Borja E7-238, Quito 170502', '8:00', '21:00', '20', '0', 'Fantasma', '1615065898', 'USD - $', 'resto_1615065898.jpg', '0969764774', '-0.13991231831221482', '-78.47472580950691', 'Farmacia', 'sana@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Capitán Ramón Borja 17-23, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '03-09-2022 06:23:16'),
(854, 'Farmacias Económicas', '1724715220', 4, 'Farmacia', 'César, Cesar Teran Lopez, Quito 170120', '08:00', '21:00', '20', '0', 'Fantasma', '1615066975', 'USD - $', 'resto_1615066975.jpg', '0969764774', '-0.13428137188373382', '-78.46602572929098', 'Farmacia', 'economica@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Cesar Teran Lopez Y Los Pinos, Quito 170124, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '01-05-2022 04:33:11'),
(856, 'Aldean ', '1724715220', 1, 'Supermercado', 'Ejercito Ecuatoriano Y Antisana', '07:00', '17:00', '10', '0', 'Sin Representante', '1615238152', 'USD - $', 'resto_1615238152.jpeg', '0969764774', '-0.2517711624134752', '-79.1730178041382', 'Supermercado', 'alden@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Guayaquil 1105, Santo Domingo, Ecuador', 1, 'Moto Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(858, 'Mi Comisariato', '1724715220', 1, 'Supermercado', 'Shopping Santo Domingo ', '09:30', '22:00', '10', '0', 'Sin Representante', '1615238717', 'USD - $', 'resto_1615238717.jpeg', '0969764774', '-0.24828432389452704', '-79.16286832522586', 'Supermercado', 'comisariato@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Moto Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(860, 'Encomienda Local ', '1721387213', 10, 'Transporte', 'Libertad ', '07:00', '22:00', '15', '0', 'Faster', '1615303854', 'USD - $', 'resto_1615303854.jpg', '0989595926', '-2.2291239822430122', '-80.93404895495607', 'Encomiendas', 'encomiendaslibertad@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q3c8+894, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '01-09-2022 15:11:23'),
(862, 'Ch Farina', '1724715220', 4, 'Restaurante', 'Av. Galo Plaza Lasso N54-48, Quito 170513', '15:00', '22:00', '10', '0', 'Sin Representante', '1615322526', 'USD - $', 'resto_1615322601.jpg', '0969764774', '-0.13762775348464792', '-78.48212367724611', 'Pizza', 'chfarinaq@faster.com.ec', 'faster.com.ec', 'Quito', 'Av. Galo Plaza Lasso 9564, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 20:47:01'),
(864, 'Smoothie House', '1721387213', 10, 'Restaurante', 'Santa Elena ', '08:00', '22:00', '10', '0', 'Sin Representante', '1615330753', 'USD - $', 'resto_1615516596.jpeg', '0969764774', '-2.2276338017876385', '-80.9227944059296', 'Smoothies, Sandwiches, Wraps', 'smoothie@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Cdla. Carolina, Calle 7 Y, Av. Carlos Espinoza, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '08-10-2021 14:44:11'),
(866, 'Pide Lo Que Sea ', '1721387213', 10, 'Lo Que Sea', 'Libertad ', '07:00', '22:30', '15', '0', 'No Hay Representante ', '1615412874', 'USD - $', 'resto_1615412874.jpg', '0989595926', '-2.2318684833057625', '-80.9067333383484', 'Lo Que Sea', 'loquesealibertad@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q39v+87x, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '19-03-2022 21:58:33'),
(868, 'Se Lo Que Sea', '1721387213', 10, 'Lo Que Sea', 'Santa  Elena ', '07:00', '22:30', '15', '0', 'Sin Representante', '1615563146', 'USD - $', 'resto_1615563146.jpg', '0989595926', '-2.2283800717647333', '-80.87755001148138', 'Lo Que Sea', 'loqueseasantaelena@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Calle Guayaquil, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(870, 'Parrillada  Del Uruguayo ', '1721387213001', 10, 'Restaurante', 'Salinas Atras Del Banco Pichincha Del Malecón, Avenida Malecón ', '12:30', '23:30', '30', '0', 'Ninguno ', '1615572927', 'USD - $', 'resto_1618946325.jpeg', '0989595926', '-2.206535258206313', '-80.96907860469058', 'Parrillada Lomo, Chuleta', 'uruguayo@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'General Enríquez Gallo, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(872, 'Lo Que Sea', '1724715220', 4, 'Lo Que Sea', 'Av. Galo Plaza Lasso Y De Los Pinos', '07:00', '22:00', '15', '0', 'Pendiente', '1615581614', 'USD - $', 'resto_1615581614.jpg', '0989629049', '-0.13878110000574137', '-78.48238116931154', 'Lo Que Sea', 'loqueseauio@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Galo Plaza Lasso Y De Los Pinos, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 20:44:13'),
(874, 'Lo Que Sea', '1724715220', 4, 'Lo Que Sea', 'Av Eloy Alfaro Y De Las Avellanas', '07:00', '22:00', '15', '0', 'Pendiente', '1615582561', 'USD - $', 'resto_1615582561.jpg', '0989629049', '-0.11581071884815787', '-78.47390538882448', 'Lo Que Sea', 'loqueseaeloy@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Vgmg+p9c, Quito 170144, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 20:46:08'),
(876, 'Lo Que Sea', '1724715220', 4, 'Lo Que Sea', 'Av. 10 De Agosto Y Av. El Inca', '07:00', '22:00', '15', '0', 'Pendiente', '1615583361', 'USD - $', 'resto_1615583361.jpg', '0989629049', '-0.16029770731244306', '-78.48533428143693', 'Lo Que Sea', 'loqueseainca@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. El Inca 2579, Quito, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(877, 'Soporte Logistics', '1723149850', 4, 'Supermercado', 'Quito - Sucursal', '00:00', '23:59', '15', '0', 'Soporte', '1558154534', 'USD - $', 'store_1607950770.png', '0969764774', '-0.142133', '-78.4790023', 'Soporte Store', 'servicio@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Quito, Ecuador - Sucursal', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(879, 'Parrillada De Dario', '1721387213', 10, 'Restaurante', 'Libertad ', '17:00', '21:30', '20', '0', 'Nionguno', '1616170955', 'USD - $', 'resto_1616170955.jpeg', '0997041253', '-2.2218713991583865', '-80.90933776330186', 'Parrilladas ', 'parrilladadario@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Segunda A 430, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(881, 'Parrillada De Dario ', '1721387213', 10, 'Restaurante', 'Salinas ', '18:00', '22:30', '16', '0', 'Pendiente', '1616188699', 'USD - $', 'resto_1616188699.jpeg', '0993007015', '-2.227794612700724', '-80.93550271224214', 'Parrillada', 'parrilladadario1@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av Carlos Espinoza Larrea,y, Av. 69, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(883, 'Panaderia Y Pasteleria Ambato', '1721387213', 10, 'Panadería', 'Santa Elena ', '07:00', '22:00', '15', '0', 'Juan Carlos Arias ', '1616251709', 'USD - $', 'resto_1616251709.jpeg', '0983248843', '-2.227124567113678', '-80.85718220900729', 'Panaderia ', 'panaderiaambato@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Sucre 838, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(885, 'Sekeria', '0801913724', 4, 'Restaurante', 'Calle,jeronimo Leiton N23-54,quito 170129', '11:00', '16:30', '15', '0', 'Sin Representante', '1616277335', 'USD - $', 'resto_1616533142.jpeg', '0998576045', '-0.19681077598780747', '-78.50594940464927', 'Pollo Asado', 'sakeria@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Jeronimo Leiton 195, Quito 170129, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '2021-09-01 09:00:02'),
(887, 'Esquina Helilupa', '1721387213', 10, 'Restaurante', 'Libertad', '17:00', '22:00', '15', '0', 'Ninguno ', '1616280273', 'USD - $', 'resto_1617658913.jpeg', '0961445868', '-2.234843473787693', '-80.89154130648805', 'Asados', 'helilupa@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'C. 43, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 13, '25-11-2021 17:33:53'),
(889, 'Los Hot Dogs De La Gonzalez Suarez', '2300366479', 4, 'Restaurante', 'Avenida Eloy Alfaro, Batán Alto N47-05, Quito 170138', '12:00', '22:00', '20', '0', 'Pendiente', '1616282929', 'USD - $', 'resto_1616532966.jpeg', '0989629049', '-0.15792194983824298', '-78.4666164858265', 'Hamburguesas Y Hot Dogs', 'gonzalez@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. Eloy Alfaro N47-41, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 20:46:32'),
(891, 'Kfc', '1724715220', 4, 'Restaurante', 'Av. Amazonas Y, Quito', '10:00', '22:00', '9', '0', 'Sin Representante', '1616345248', 'USD - $', 'resto_1616345248.jpg', '0989629049', '-0.15946488465579703', '-78.48292699884607', 'Pollo Broaster', 'kfcquito@faster.com.ec', 'faster.com.ec', 'Quito', 'Luis Coloma 282, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '2021-09-01 09:00:02'),
(893, 'Fritaderia El Dorado ', '1721387213', 10, 'Restaurante', 'Av. 12 Salinas', '08:00', '18:00', '10', '0', 'Sin Representante', '1616463253', 'USD - $', 'resto_1616463253.jpeg', '0994558594', '-2.2101883939049625', '-80.97324407529071', 'Bolón, Tostadas, Fritada, Batidos ', 'eldoradof@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q2rg+3p9, Rafael De La Cuadra Alvarado, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:59:03'),
(895, 'La Casa Manabita Cevicheria', '1723866149', 4, 'Restaurante', 'Los Nogales Y Jose Felix Barreiro Esquina ', '07:00', '18:00', '15', '0', 'Pendiente', '1616684563', 'USD - $', 'resto_1616684563.jpeg', '0968277919', '-0.14658630403061143', '-78.46473223399354', 'Marisqueria', 'pedrog.4472@gmail.com', 'www.faster.com.ec', 'Quito', 'Y Jose Felix Barreiro, De Los Nogales N50-308, Quito 170124, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(897, 'Noe Sushi Bar ', '1724715220', 4, 'Restaurante', 'Quito', '12:30', '22:00', '20', '0', 'Pendiente', '1616708270', 'USD - $', 'resto_1616708270.jpeg', '0989629049', '-0.17632651917264333', '-78.47928925286962', 'Sushi', 'noesushi@faster.com.ec', 'faster.com.ec', 'Quito', 'Avenida Naciones Unidas 27, Quito 170102, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(899, 'Mcdonals', '1724715220', 4, 'Restaurante', 'Centro Iñaquito Av. Amazonas Y Naciones Unidas ', '08:00', '22:00', '10', '0', 'Sin Representante', '1616733182', 'USD - $', 'resto_1616768713.jpeg', '0989629049', '-0.17661083197970348', '-78.48532087039186', 'Hamburguesas, Helados', 'mcdonalds@faster.com.ec', 'faster.com.ec', 'Quito', 'Av. Río Amazonas, Quito 170135, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '2021-07-28 07:45:29'),
(901, 'Veterinaria Mascotas', '0202172300001', 1, 'Lo Que Sea', 'Av. Abraham Calazacon Y  Calle 18 De Octubre.\r\nJunto A La Licorería La Pista Y La Kasa Del Pañal.\r\nMás Bajo Del Colegio Jaques  Cousteau', '09:00', '19:00', '10', '10', 'Mauricio García Representante', '1616787643', 'USD - $', 'resto_1617049782.jpeg', '0997281503', '-0.2602790444603816', '-79.16108733843996', 'Peluquería O Estética Canina Y Felina', 'ezequielmauricio163@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Principal Pablo Neruda 130, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '2021-09-01 09:00:02'),
(903, 'Encebollado Con Todo De Felipaso', '1721387213', 1, 'Restaurante', 'Quito Y Loja', '08:00', '16:00', '15', '0', 'Pendiente', '1616873103', '', 'resto_1616873103.jpg', '0994560850', '-0.25484494390422097', '-79.17432672213747', 'Encebollados', 'felipaso@faster.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito N. 910 y, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(905, 'Alas Papas Sport Bar', '1724715220', 4, 'Restaurante', 'Av. Juan Jaramillo  Y Luis Minancho', '01:00', '20:00', '20', '0', 'Pendiente', '1616878374', 'USD - $', 'resto_1616878374.jpg', '0994793667', '-0.2473425420632153', '-78.53297198992206', 'Alitas', 'alaspapas@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Qf38+3r6, Luis Minacho, Quito 170111, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '09-07-2022 03:44:10'),
(907, 'Ícaro Pizzería', '0924272750', 10, 'Restaurante', 'Santa Elena, Calle 9de Octubre E/ Olmedo Y Guayaquil (diagonal A La Radio Genial)', '15:00', '23:00', '15', '0', 'Mario Rodriguez Choez ', '1616884150', 'USD - $', 'resto_1617377770.jpeg', '0988990383', '-2.227651222970738', '-80.85915765594675', 'Pizzas', 'icaropizzeria@gmail.com', 'www.faster.com.ec', 'Santa Elena', 'Estacion De Autobuses, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(909, 'Charlotte Cookies', '2450086745', 10, 'Panadería', 'Libertad Barrio Rocafuerte Av 5 Entre Calle 26 Y 27 ', '09:00', '18:00', '15', '0', 'Lisbeth Andrade', '1617069047', 'USD - $', 'resto_1617380444.jpeg', '0991265278', '-2.2243505751419437', '-80.90441590975954', 'Galletas', 'lizbethandrademontero@hotmail.com', 'www.faster.com.ec', 'Santa Elena', 'C. 27, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(911, 'Osole', '1721387213', 10, 'Restaurante', 'Salinas Calle General Enrrique Gallo Y La Américas', '17:00', '23:00', '15', '0', 'Pendiente', '1617114811', 'USD - $', 'resto_1617120927.jpeg', '0989595926', '-2.205142883139407', '-80.96126398872568', 'Pizzeria', 'osole@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Las Américas 23, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(913, 'Helados  Bogati', '1721387213', 10, 'Restaurante', 'Libertad', '11:00', '18:00', '15', '0', 'Sin Representante', '1617120898', 'USD - $', 'resto_1617120898.jpeg', '0988067795', '-2.2214955021119893', '-80.90945645105077', 'Helados De Queso', 'bogati@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av 9 De Octubre, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(915, 'Asadero El Secreto De Javier ', '1721387213', 10, 'Restaurante', 'Santa Elena, Libertad , Av Eleodoro Solorzano ', '10:00', '21:00', '10', '0', 'Sin Representante', '1617231586', 'USD - $', 'resto_1617234046.jpeg', '0989595926', '-2.227837495607921', '-80.90661532115175', 'Pollo Asado', 'asaderojavier@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Eleodoro Solorzano 23, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(917, 'Delicias Mall', '1721387213', 10, 'Restaurante', 'Santa Elena ', '16:00', '23:00', '15', '0', 'Sin Representante', '1617251905', 'USD - $', 'resto_1617658887.jpeg', '0989595926', '-2.2274723208113985', '-80.85850386749937', 'Comida Rapida ', 'deliciasmall@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', '70 1, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '29-01-2022 09:21:02'),
(919, 'Gelatomix Carcelén ', '1720100708001', 4, 'Restaurante', 'Alejandro Ponce Borja N80-05 Y, Quito 170330  (frente Al Coliseo Del Parque De Carcelén)', '13:00', '22:00', '20', '0', 'Daniela Calle Burneo', '1617284024', 'USD - $', 'resto_1618345348.png', '0995542621', '-0.08907249071123201', '-78.47251667510702', 'Heladería ', 'gelatomixcarcelen@gmail.com', 'www.heladosconqueso.com', 'Quito', 'Alejandro Ponce N80, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(921, 'El Pechugon Horneado ', '1724715220', 4, 'Restaurante', 'Av Real Audiencia, Av Del Maestro N60-206 Y, Quito 170512', '10:30', '20:00', '18', '0', 'Pendiente ', '1617290344', 'USD - $', 'resto_1619027557.jpeg', '0961250888', '-0.12467741176423981', '-78.48585831802322', 'Restaurante \r\n', 'elpechugon@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Real Audiencia Y Del Maestro, Quito 170144, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(923, 'Tienda De Regalo Y Detalle M-gcrea', '1724715220', 4, 'Regalo', '....', '10:00', '18:00', '20', '0', 'Pendiente ', '1617297103', 'USD - $', 'resto_1617297103.jpeg', '0990420337', '-0.12793695834889598', '-78.49407828282548', 'Tienda De Regalos \r\n', 'tiendamg@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. De La Prensa 441, Quito, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-07-28 07:45:29'),
(925, 'Ron Retaque ', '1724715220', 4, 'Licorería', 'E19c, Quito 170124', '10:00', '22:00', '17', '0', 'Pendiente ', '1617305232', 'USD - $', 'resto_1619027595.jpeg', '0999932518', '-0.14387124667742696', '-78.45303780268861', 'Licoreria ', 'ronretaque@faster.com.ec', 'www.faster.com.ec', 'Quito', 'José Felix Barrerio 165, Quito 170124, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(927, 'House Loord Wings', '1721387213', 10, 'Restaurante', 'Salinas', '17:00', '22:00', '15', '0', 'Pendiente', '1617329287', 'USD - $', 'resto_1617659088.jpeg', '0983524243', '-2.218153967480284', '-80.94616717528535', 'Alitas ', 'lordwings@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 55 12, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(929, ' Gus ', '2450238502', 4, 'Restaurante', 'Av. Río Amazonas N45-96, Quito 170138', '09:00', '22:45', '20', '0', 'Pendiente', '1617374444', 'USD - $', 'resto_1619027635.jpeg', '0989629049', '-0.15738215731740424', '-78.48441294264032', 'Restaurante \r\n', 'pollogus@gmail.com', 'www.faster.com.ec', 'Quito', 'Av. Río Amazonas N45-96, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '22-05-2022 21:49:06'),
(931, 'Greenfrost ', '2450238502', 10, 'Restaurante', 'Libertad ', '10:00', '21:00', '20', '0', 'Pendiente', '1617393403', 'USD - $', 'resto_1619027679.jpeg', '0989595926', '-2.220554754004421', '-80.90897968839838', 'Heladeria \r\n', 'greenfrost@gmail.com', 'www.faster.com.ec', 'Santa Elena', 'Calle Malecón 28, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(933, 'Manabiche ', '1721387213', 4, 'Restaurante', 'Av. 6 De Diciembre, Quito 170138', '07:00', '17:00', '20', '0', 'Pendiente', '1617398788', 'USD - $', 'resto_1619027714.jpeg', '0995594473', '-0.14106022545908609', '-78.47439149186243', 'Cevicheria ', 'manabiche@faster.com.ec', 'http://manabiche.com/', 'Quito', 'Av. 6 De Diciembre N52-65, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(935, 'Mini Market El Ahijado', '2450625393001', 10, 'Supermercado', 'Salinas Barrio Bazan Av7 Entre Calle 25 Y 26', '07:00', '23:59', '20', '0', 'Lissthe Medina', '1617480103', 'USD - $', 'resto_1617483716.jpg', '0998566902', '-2.207762798569899', '-80.97233145367338', 'Mini Market', 'julissa21medi@gmail.com', 'www.faster.com.ec', 'Santa Elena', 'Avenida Los Ficus, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(937, 'Alitas Dali', '0801913724', 10, 'Restaurante', ' Santa Elena Barrio Otto Arosemena Gómez Calle Manglaralto 484 Y Julio Moreno Atrás De La Escuela Dr Otto Arosemena Gómez', '19:00', '22:30', '15', '0', 'Ariana Rosales', '1617484343', 'USD - $', 'resto_1617658351.jpeg', '0984935030', '-2.2299012340402173', '-80.85672086905673', 'Alitas', 'dali@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Manglaralto 90, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'NO', 'YES', 0, 15, '2021-09-01 09:00:02'),
(939, 'Sanduches La Reina ', '1724715220', 4, 'Restaurante', 'De Los Alamos &, Quito 170138', '07:30', '20:00', '20', '0', 'Pendiente', '1617721975', 'USD - $', 'resto_1619027755.jpeg', '0995759040', '-0.14467791848122852', '-78.47396406214668', 'Restaurante ', 'alimentoslareinaec@gmail.com', 'www.faster.com.ec', 'Quito', 'Almería 131, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '05-12-2021 11:28:59'),
(941, 'José El Capitán Cangrejo', '1724715220', 4, 'Restaurante', 'Gonzalo Zaldumbide N49-171, Quito 170138', '12:00', '20:00', '20', '0', 'Pendiente ', '1617726483', 'USD - $', 'resto_1619027806.jpeg', '0987597758', '-0.1457333643391302', '-78.47759476732446', 'Restaurante ', 'jesparza007@hotmail.com', 'info@www.capicangrejo.com', 'Quito', 'Gonzalo Zaldumbide 170, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(943, 'Pastidelicias ', '1724715220', 4, 'Panadería', 'Av. El Inca, Y, Quito 170501', '08:00', '20:00', '20', '0', 'Pendiente ', '1617733153', 'USD - $', 'resto_1619027842.jpeg', '0995273323', '-0.15513782727090877', '-78.47792501430942', 'Pasteleria ', 'pastidelicias@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. El Inca 176, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(945, 'Dfz Electronics', '1724715220', 4, 'Supermercado', 'Juan Lagos, Quito 170148', '10:00', '19:00', '20', '0', 'Pendiente', '1617740839', 'USD - $', 'resto_1619027873.jpeg', '0995069353', '-0.2509758950944306', '-78.53692321907714', 'Tienda \r\n', 'dfzelectronics@gmail.com', 'www.faster.com.ec', 'Quito', 'El Canelo 1066, Quito 170148, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '2021-09-01 09:00:02'),
(947, 'Mascotas Y Mascosas', '1711530392001', 4, 'Supermercado', '170502, Quito 170138', '09:00', '20:00', '20', '0', ' Oswaldo Santiago Cruz García', '1617743250', 'USD - $', 'resto_1619027903.jpeg', '0978659426', '-0.14932918887867386', '-78.48216592203809', 'Tienda De Mascotas ', 'mascotasymascosas@gmx.es', 'www.faster.com.ec', 'Quito', 'Carlos Andrade Marín 144, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(949, 'El Rincon De Polita ', '1721387213', 10, 'Restaurante', 'Santa Elena ', '14:45', '14:45', '15', '0', 'Pendiente', '1617744291', 'USD - $', 'resto_1617744291.jpeg', '0989122070', '-2.227293418630342', '-80.85987313520147', 'Desayunos Comidas  Rapidas ', 'rinconpolita@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Calle Guayaquil 436, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(951, 'Sushi And Sweets', '1721387213', 4, 'Restaurante', 'Sushi And Sweets, N46 Marcos Jofre Oe5-71 Y Sabino Zambrano Pb Local 1, Quito 171105', '12:00', '20:30', '25', '0', 'Pendiente', '1617814755', 'USD - $', 'resto_1620167071.jpeg', '0985945135', '-0.15597121729488547', '-78.49254076934537', 'Restaurante De Sushi ', 'sushiandsweets2017@gmail.com', 'https://sushiandsweets.ec/', 'Quito', 'Marcos Jofre 169, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '2021-09-01 09:00:02'),
(953, 'Aché De La Flaka', '1721387213', 4, 'Restaurante', 'Cristóbal Sandoval, Quito 170104', '10:30', '17:30', '20', '0', 'Pendiente', '1617830559', 'USD - $', 'resto_1617830559.jpg', '0989629049', '-0.14637533721411983', '-78.49244719470697', 'Restaurante Cubano ', 'achedelaflaka@faster.com.ec', 'https://ache-de-la-flaka.negocio.site/', 'Quito', 'Cristóbal Sandoval 216, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(955, 'Parrilla Toribio', '1721387213', 4, 'Restaurante', 'Av. Luis G. Tufiño Oe3-138, Quito 170104', '11:00', '19:00', '20', '0', 'Pendiente', '1617835850', 'USD - $', 'resto_1620166336.jpeg', '0968503860', '-0.1283673290777292', '-78.48892861299706', 'Parrilla \r\n', 'toribio@faster.com.ec', 'https://www.parrillatoribio.com/', 'Quito', 'Av. Luis G. Tufiño Oe3-138, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(957, 'Alfajores Artesanales Chemi ', '0801913724', 4, 'Panadería', 'Inglaterra N31-187 Y, Quito 170519', '09:00', '18:00', '20', '0', 'Pendiente', '1617888024', 'USD - $', 'resto_1620166518.jpeg', '0998089595', '-0.18968803338809034', '-78.49138780034096', 'Tienda De Alfajores', 'chemialfajores@faster.com.ec', 'faster.com.ec', 'Quito', 'Inglaterra N31-173 Y, Quito 170519, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '18-08-2022 14:27:59'),
(959, 'Pasteleria San Luis ', '1724715220', 4, 'Panadería', 'Carlos Arteta, Quito 170132', '07:00', '20:00', '20', '0', 'Pendiente', '1617890025', 'USD - $', 'resto_1620166963.jpeg', '0986886356', '-0.13658402559267216', '-78.50660007378774', 'Pasteleria ', 'pasteleriasanluis@faster.com.ec', 'faster.com.ec', 'Quito', 'Carlos Arteta 55-02, Quito 170132, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(961, 'Telecom ', '1724715220', 4, 'Supermercado', 'Centro Comercial Quitus Av. San Gregorio Y Juan Murillo  Local 267 ', '10:00', '18:00', '20', '0', 'Pendiente', '1617892792', 'USD - $', 'resto_1620167095.jpeg', '0982603285', '-0.20334996169134079', '-78.49975953679515', 'Centro Comercial ', 'telecom@faster.com.ec', 'faster.com.ec', 'Quito', 'Tzantza_tatto_studio Ec C.c. Quitus Local 434, Versalles &, Quito 170129, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '2021-09-01 09:00:02'),
(963, 'Artesanías María Belén ', '1723866149', 4, 'Supermercado', 'Carlos Arteta Y Virgilio Corral Oe1023', '08:00', '18:00', '20', '0', 'Pendiente', '1617899535', 'USD - $', 'resto_1620166574.jpeg', '0989629049', '-0.13658490028779083', '-78.50660148227718', 'Tienda De Artesanias ', 'artesaniasmb@faster.com.ec', 'faster.com.ec', 'Quito', 'Carlos Arteta 55-02, Quito 170132, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(965, 'Qchevere Grill Hou', '1721387213001', 6, 'Restaurante', 'Los Vergeles Mz 85 Sol 20,  Guayaquil, Ecuador', '07:00', '13:00', '14', '0', 'Miguel Angel Colmenares ', '1617987593', 'USD - $', 'resto_1618945554.jpeg', '0999906392', '-2.086403022735888', '-79.9019885702057', 'Desayunos, Bolones, Tigrillo  ', 'qcheveregrillhouse@gmail.com', 'www.faster.com.ec', 'Guayaquil', '18b, Los Vergeles 090703, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02'),
(967, 'Hamburguesas De Rusty', '1724715220', 4, 'Restaurante', 'Av. De Los Shyris N43-157, Quito 170513', '10:30', '22:00', '20', '0', 'Pendiente', '1618003867', 'USD - $', 'resto_1620167028.jpeg', '0989629049', '-0.16356730704279532', '-78.4789442537351', 'Hamburguesería', 'info@rusty.com.ec', 'http://www.rusty.com.ec/', 'Quito', 'Av. De Los Shyris N43-157, Quito 170513, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 21:10:55'),
(969, 'Picanteria Carchi ', '1721387213', 4, 'Restaurante', 'Machala N58-101, Quito 170511', '10:00', '17:00', '20', '0', 'Pendiente ', '1618237807', 'USD - $', 'resto_1620167003.jpeg', '0998437329', '-0.13042403033643768', '-78.49820083808137', 'Picanteria ', 'picanteriacarchi@faster.com.ec', 'faster.com.ec', 'Quito', 'Machala 1983, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(971, 'La Burgatta ', '1721387213', 4, 'Restaurante', 'Isla Isabela 454, Quito 170513', '17:00', '22:00', '20', '0', 'Pendiente ', '1618248912', 'USD - $', 'resto_1620166802.jpeg', '0963413348', '-0.16669508503955907', '-78.48305071573685', 'Hamburguesería ', 'info@laburgatta.com', 'https://queresto.com/laburgatta', 'Quito', 'Av. Isla Floreana 156e, Quito 170513, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-07-28 07:45:29'),
(973, 'Los Tíos ', '1721387213', 4, 'Restaurante', 'La Mariscal, Av. Gral. Ignacio De Veintimilla N21-43, Quito 170143', '10:00', '21:00', '20', '0', 'Pendiente ', '1618264158', 'USD - $', 'resto_1620166902.jpeg', '0979188714', '-0.20667252683865017', '-78.49105476271342', 'Pizzeria', 'pizzatiosveintimilla@gmail.com', 'faster.com.ec', 'Quito', 'Av. Gral. Ignacio De Veintimilla E9-21 Y, Quito 170523, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(975, 'Punta Del Mar ', '1724715220', 10, 'Restaurante', 'Av.tercera Libertad', '07:15', '19:30', '10', '0', 'Punta Del Mar', '1618273405', 'USD - $', 'resto_1618273405.jpeg', '0968134756', '-2.2224342394767684', '-80.90868598651124', 'Hotel, Cafetería, Restaurante, Eventos', 'puntamar@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Av. Tercera 520, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '06-11-2021 08:20:19'),
(977, 'Cevicheria De Hugo 2', '1721387213', 10, 'Restaurante', 'Salinas ', '07:30', '22:00', '15', '0', 'Pendiente', '1618274508', 'USD - $', 'resto_1618274508.jpg', '0969604968', '-2.203985026461105', '-80.9772667182608', 'Mariscos ', 'cevicheriadehugo2@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Calle 15 9, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(979, 'Legitimo Hornado Pastuso ', '1721387213', 4, 'Restaurante', 'Av. 6 De Diciembre N49-81 Y Cucardas, Diagonal Al Colegio Los Shirys Sector El Inca', '09:00', '17:00', '30', '0', 'Pendiente ', '1618328578', 'USD - $', 'resto_1620166765.jpeg', '0994785154', '-0.14702886706529347', '-78.47535311114024', 'Hornados ', 'hornadopatuso@faster.com.ec', 'https://el-legitimo-hornado-pastuso.negocio.site/?utm_source=gmb&utm_medium=referral', 'Quito', 'Av. 6 De Diciembre N49-81, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(981, ' Sidi Bou Restaurante Arabe', '1757465693001', 4, 'Restaurante', 'Quito, Carlos Mantilla Y El Doral', '13:00', '22:00', '30', '0', 'Esteban Sotaquira Marien', '1618335671', 'USD - $', 'resto_1620167048.jpeg', '0995647479', '-0.09137751122530569', '-78.43724361490443', 'Restaurante ', 'riadhg03@gmail.com', 'faster.com.ec', 'Quito', 'Derby Oe4-294, Quito 170203, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 16, '2021-09-01 09:00:02'),
(983, 'Aroma Y Letras Cafetería', '2100103460001', 4, 'Restaurante', 'Tnte. Eustaquio Bernal, Quito 170104', '15:00', '20:00', '30', '0', 'Davila Garcia Edis Galub ', '1618430249', 'USD - $', 'resto_1620166547.jpeg', '0998916346', '-0.1447057463110316', '-78.4935723511501', 'Cafetería ', 'egdavila@hotmail.es', 'faster.com.ec', 'Quito', 'Sbte. Fernando Dávalos 04-63, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '2021-09-01 09:00:02'),
(985, 'Itakimasu Sushi', '1726469008', 4, 'Restaurante', 'San Francisco De La Pita Oe10-40  Y 10 Ma Transversal', '12:00', '21:00', '10', '0', 'Luis Damián Tafur', '1618577547', 'USD - $', 'resto_1618946781.jpeg', '0998697089', '-0.1591564318114274', '-78.50401586722566', 'Sushi', 'itakimasu@faster.com.ec', 'faster.com.ec', 'Quito', 'Oe11 Y N45, Quito 170132, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(987, 'Wings Fest', '2300571557', 1, 'Restaurante', 'Gran Colombia', '15:00', '21:00', '20', '0', 'Michael Arellano', '1618602320', 'USD - $', 'resto_1618603734.jpeg', '0978780078', '-0.23756363083650056', '-79.18474442195131', 'Alitas', 'sucrezambrano4@hotmail.com', 'ww.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-08-20 09:00:01'),
(989, 'Vaka Grill Restaurant', '1721387213', 9, 'Restaurante', 'Terminal Terrestre De Manta. Vía Puerto Aeropuerto Frente A La Ciudadela El Palmar 130802 Manta, Ecuador\r\n', '10:00', '21:00', '20', '0', 'Pendiente ', '1618930883', 'USD - $', 'resto_1618930883.png', '0990867098', '-0.9598061191156787', '-80.68909655194713', 'Restaurante De Carnes Asadas ', 'vacagrillrestaurante@gmail.com', 'faster.com.ec', 'Manta', 'Unnamed Road, Manta 130204, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(991, 'Los Asados De La Vaca', '1721387213', 9, 'Restaurante', 'Av. 20 Y Calle 17 Manta, Ecuador', '12:00', '21:00', '20', '0', 'Pendiente ', '1618936431', 'USD - $', 'resto_1620166880.jpeg', '0990074494', '-0.9458974362318419', '-80.73125920128061', 'Asados ', 'asadosdelavaca@faster.com.ec', 'faster.com.ec', 'Manta', 'Av 20 1733, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(993, 'Restaurante Cabañas Aeropuerto', '1302183312001', 9, 'Restaurante', 'Entrada Al Aeropuerto, Manta 130204', '08:00', '15:00', '20', '0', 'Briones Rivera Augusta Mariana', '1618949393', 'USD - $', 'resto_1619642847.jpeg', '0979203862', '-0.9586244363868811', '-80.6831933451815', 'Somos Un Restaurante Familiar Que Ofrece Cocina Casera “manaba” Al Estilo Criollo Como En Casa Con Platos A La Carta Y Almuerzos.', 'restaurante.aeropuertosn@gmail.com', 'faster.com.ec', 'Manta', 'Entrada Aeropuerto, Manta 130204, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 14, '2021-09-01 09:00:02'),
(995, 'La Burguer La Tentación A La Parrilla', '1718460387001', 1, 'Restaurante', 'Urbanización  Centenario Calle Peripa Y Niguas Esquina', '17:30', '22:00', '10', '10', 'Jorge Javier Arellana Pinela', '1618952782', 'USD - $', 'resto_1618952782.jpeg', '0989281554', '-0.23558417745717009', '-79.16654496323301', 'Hamburguesas', 'dianachazy@autlook.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Yumbos 12, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(997, 'Bar Restaurant  Lo Nuestro', '1721387213', 9, 'Restaurante', 'Barrio San Agustin - Calle Oliva Miranda Diagonal A La Iglesia Puerto De Manta, Ecuador', '07:00', '16:00', '20', '0', 'Pendiente ', '1618957146', 'USD - $', 'resto_1618957146.png', '0968121920', '-0.9633769774628677', '-80.69701275657846', 'Bar Restaurant  ', 'lonuestp@faster.com.ec', 'faster.com.ec', 'Manta', 'Calle Oliva Miranda 619, Manta, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '2021-07-28 07:45:29'),
(999, 'Bar Restaurant  Lo Nuestro', '1721387213', 9, 'Restaurante', 'Barrio San Agustin - Calle Oliva Miranda Diagonal A La Iglesia Puerto De Manta, Ecuador', '07:00', '16:00', '20', '0', 'Pendiente ', '1618957408', 'USD - $', 'resto_1620166855.jpeg', '0968121920', '-0.9633766422341344', '-80.69701711516811', 'Bar Restaurant ', 'barlonuestro@faster.com.ec', 'faster.com.ec', 'Manta', 'Calle Oliva Miranda 619, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1001, 'Megaflipper', '1721387213', 9, 'Restaurante', 'Calle 23, Manta', '08:00', '19:00', '20', '0', 'Pendiente ', '1619036672', 'USD - $', 'resto_1620166944.jpeg', '0985358971', '-0.9444210810668229', '-80.73362021576597', 'Restaurante  ', 'hola@flipper.com.ec', 'http://www.megaflipper.com.ec/', 'Manta', 'Av Flavio Reyes 23, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1003, 'La Cava Río Zamora', '1723866149', 1, 'Licorería', 'Av. Abraham Calazacon, Y, Santo Domingo ', '00:00', '01:00', '1', '5', 'Juan Aguirre', '1619048086', 'USD - $', 'resto_1647116377.png', '0939664875', '-0.2456289616357206', '-79.163595539145', 'Licores', 'lacavariozamora@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3p+hgq, Santo Domingo, Ecuador', 0, 'Moto', 1, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 0, '10-09-2022 23:59:01'),
(1005, 'Pizzeria Da Gianluca', '1721387213', 9, 'Restaurante', 'Avenida 19 & Av Flavio Reyes, Manta, Ecuador Manta, Ecuador', '12:00', '15:00', '20', '0', 'Pendiente ', '1619109949', 'USD - $', 'resto_1620166666.jpeg', '0987369107', '-0.9457321676217313', '-80.73094806503488', 'Restaurante Pizzeria Nuestro Punto De Fuerza La Calidad De La Pasta Artesanal Elaborada Al Momento Y La Masa De La Pizza A Levitación Lenta Que Permite Una Mayor Digeribilidad.', 'gianlucalaise@gmail.com', 'https://pizzeriadagianluca.business.site/?m=true', 'Manta', 'Av 19 1709, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1007, 'Market D Lago', '1721387213', 4, 'Supermercado', 'Hernando De Veas, Quito 170120', '08:00', '19:00', '20', '0', 'Pendiente ', '1619129448', 'USD - $', 'resto_1620166924.jpeg', '0994649244', '-0.09018862357184106', '-78.46937077920863', 'Tienda De Ultramarinos ', 'info@agroindustriasgonzalez.com', 'http://marketdelago.com/', 'Quito', 'Bartolomé Hernandez 430, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1009, 'Pollo Colorado Indio Colorado ', '1724968084', 1, 'Restaurante', 'Indio Colorado ', '10:00', '20:00', '15', '0', 'Andres Tamayo ', '1619195523', 'USD - $', 'resto_1619195523.jpg', '0997552074', '-0.25372647376034696', '-79.17649662923051', 'Pollo Asado ', 'andrestamayo0112@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Chone, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1011, 'Chifa Fulin ', '1721387213', 4, 'Restaurante', 'Juan Breton, Quito 170120', '10:30', '22:00', '20', '0', 'Pendiente ', '1619196979', 'USD - $', 'resto_1620166612.jpeg', '0986103552', '-0.08896386137723632', '-78.47280534785224', 'Chifa', 'chifafulin@faster.com.ec', 'faster.com.ec', 'Quito', 'Juan Breton N 80-31 Y, Quito 170302, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1013, 'Pollo Colorado 5 Esquinas', '1724968084', 1, 'Restaurante', 'Av. Quito Y Cocaniguas Esquina', '10:00', '20:00', '20', '0', 'Andrés Tamayo', '1619206079', 'USD - $', 'resto_1619206079.jpg', '0989020239', '-0.25463606894167307', '-79.16767920237018', 'Pollo Asado Y Pollo Broaster', '5esquinas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Quito 400 Y, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1015, 'Pollo Colorado Santa Marta', '1724968084', 1, 'Restaurante', 'Pollo Asado', '10:00', '20:00', '20', '0', 'Andres Tamayo ', '1619207287', 'USD - $', 'resto_1619207287.jpg', '0989928133', '-0.26253107076585763', '-79.18386633377506', 'Pollo Asado', 'pollosantamarta@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Jacinto Cortéz Jhayya, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '20-09-2021 00:11:24'),
(1017, 'Chili Peppers', '1721387213', 10, 'Restaurante', 'San Lorenzo', '14:00', '22:00', '20', '0', 'Pendiente', '1619210121', 'USD - $', 'resto_1619640972.jpeg', '0980905514', '-2.205270863770208', '-80.95900925677255', 'Comida Mexicana', 'chillis@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Vicente Rocafuerte, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1019, 'El Barón De Las Mollejas', '1721387213', 4, 'Restaurante', 'Alejandro Ponce, Y, Quito 170503', '17:00', '21:00', '20', '0', 'Pendiente ', '1619447625', 'USD - $', 'resto_1620166715.jpeg', '0995040040', '-0.08931782937964788', '-78.47254875755469', 'Restaurante ', 'info@barondelasmollejas.com', 'http://www.barondelasmollejas.com/', 'Quito', 'Alejandro Ponce Borja Y N80, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '15-03-2022 17:45:23'),
(1021, 'Pasteleria Tu Tentación', '1721387213', 4, 'Publicidad', 'Alonzo Lopez N 80-43, Quito 170120', '09:00', '17:00', '20', '0', 'Pendiente ', '1619453014', 'USD - $', 'resto_1619453014.png', '0999223942', '-0.08892228718759367', '-78.4735000399871', 'Pasteleria \r\n', 'pasteleriatutentacion@outlook.com', 'https://pasteleriatutentac.wixsite.com/postres', 'Quito', 'Alonso Lopez N80-56, Quito 170302, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 3, NULL, '2021-07-28 07:45:29'),
(1023, 'Pasteleria Tu Tentación', '1721387213', 4, 'Restaurante', 'Alonzo Lopez N 80-43, Quito 170120', '09:00', '17:00', '20', '0', 'Pendiente ', '1619454174', 'USD - $', 'resto_1620166486.jpeg', '0999223942', '-0.08892228718759367', '-78.47349802833034', 'Pasteleria ', 'pasteleriatutentacion@faster.com.ec', 'https://pasteleriatutentac.wixsite.com/postres', 'Quito', 'Alonso Lopez N80-56, Quito 170302, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1025, 'Pastelería Paty Flores', '1721387213', 4, 'Panadería', 'Alejandro Ponce Borja N78-94 Y Hernando Paredes. Junto A Encebollados El Vecino 170120 Quito, Ecuador', '07:30', '20:30', '20', '0', 'Pendiente ', '1619466141', 'USD - $', 'resto_1620166982.jpeg', '0987256608', '-0.09046589658419317', '-78.47245967816545', 'Panaderia ', 'pasteleriapatyflorescarcelen@hotmail.com', 'http://www.pasteleriapatyflores.com/', 'Quito', 'Alejandro Ponce N78-85, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1027, 'Red Point Pizza', '1721387213', 10, 'Restaurante', 'Santa Elena. Cantón Santa Elena. Parroquia Ballenita. Calle: Avda 1 Intersección, Calle 3. Referencia: Al Lado Del Salon De Eventos Del Malecon De Ballenita.', '14:00', '22:00', '20', '0', 'Angel David Mogollon Medina', '1619475524', 'USD - $', 'resto_1621629798.jpeg', '0985423174', '-2.202426809932489', '-80.87236954700185', 'Pizzeria', '0aristoteles6@gmail.com', 'faster.com.ec', 'Santa Elena', 'Av. J Leopoldo Carrera Calvo, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1029, 'La Burguer', '1718460387', 1, 'Restaurante', 'Urbanizacion Centenario Calle Peripa Y Niguas Esquina', '19:00', '22:00', '10', '10', 'Jorge Javier Orellana Pinela ', '1619476214', '', 'resto_1619554212.jpeg', '0963280124', '-0.2355546734073804', '-79.16656172703935', 'Hamburguesas, Papas ', 'dianachazy@outlook.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Yumbos 12, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '2021-09-01 09:00:02'),
(1031, 'Common Grounds Coffee And Waffle House', '1721387213', 10, 'Restaurante', 'Vicente Rocafuerte, Salinas', '08:00', '14:00', '20', '0', 'Pendiente ', '1619533022', 'USD - $', 'resto_1619642885.jpeg', '0963515534', '-2.2054551290569937', '-80.95908536445333', 'Restaurante \r\n', 'commongrounds@faster.com.ec', 'https://common-grounds-coffee-and-waffle-house.negocio.site/?utm_source=gmb&utm_medium=referral', 'Santa Elena', 'Vicente Rocafuerte, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1033, 'El Café De Amanda ', '1721387213001', 10, 'Restaurante', 'Salinas, José Luis Tamayo, Muey,  Frente A La Iglesia ', '07:00', '13:00', '15', '0', 'Ninguno ', '1619536282', 'USD - $', 'resto_1619616982.jpeg', '0990922798', '-2.2356743259088243', '-80.93129164408876', 'Bolones, Patacones, Empanadas, Tigrillo ', 'cafeamanda@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'A Vei 9, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-09-01 09:00:02');
INSERT INTO `fooddelivery_restaurant` (`id`, `name`, `dni`, `city_id`, `type_store`, `address`, `open_time`, `close_time`, `delivery_time`, `commission`, `store_owner`, `timestamp`, `currency`, `photo`, `phone`, `lat`, `lon`, `desc`, `email`, `website`, `city`, `location`, `is_active`, `del_charge`, `enable`, `session`, `status`, `ally`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`, `sequence`, `edit_id`, `edit_date_time`) VALUES
(1035, 'La Mamá De Las Hamburguesas', '1721387213001', 10, 'Restaurante', 'Salinas, Avenida Carlos Espinoza, Frente Al Colegio John Kennedy ', '17:00', '23:00', '10', '0', 'Ninguno ', '1619547610', 'USD - $', 'resto_1619616962.jpeg', '0960635170', '-2.228432495816374', '-80.9216464204712', 'Hamburguesa, Hot Dog, Sandwich', 'mama@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Avenida Punta Carnero Av. Punta Carnero, La Libertad, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 7, '2021-08-13 09:00:01'),
(1037, 'Domms Alitas Bbq', '1721387213', 4, 'Restaurante', 'Carcelén Alto, Calle Alejandro Ponce Borja N79-05 Y Pasaje Francisco Chavez Quito, Ecuador', '14:00', '22:00', '20', '0', 'Pendiente', '1619548640', 'USD - $', 'resto_1620166686.jpeg', '0984399280', '-0.08993683151164215', '-78.4726038469', 'Restaurante ', 'lalobkn_08@hotmail.com', 'faster.com.ec', 'Quito', 'Alejandro Ponce N79-24, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 17, '10-12-2021 21:09:57'),
(1039, 'Parrilla 042', '2400189664', 10, 'Restaurante', 'Calle Alberto Spencer, Santa Elena', '18:00', '23:00', '20', '0', 'Jose Chalen Fernandez', '1619562715', 'USD - $', 'resto_1619562715.jpg', '0991710915', '-2.232774716967802', '-80.86400273125604', 'Restaurante De Parrilla ', 'jacf-3000@hotmail.com', 'faster.com.ec', 'Santa Elena', 'Calle T-1, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1041, 'Nativo', '1724968084', 10, 'Restaurante', 'Barrio San Francisco Av. Séptima Entre Av. 13ava. Y Av. 14ava. 240350 La Libertad, Ecuador\r\n', '05:00', '09:00', '20', '0', 'Pendiente', '1619619840', 'USD - $', 'resto_1619619840.jpg', '0999859811', '-2.223924425188225', '-80.91688818167879', 'Cafetería Rústica Artesanal', 'nativocafeteria@gmail.com', 'faster.com.ec', 'Santa Elena', 'Av. Séptima 1553, La Libertad 240350, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(1043, 'La Estancia De Domalu Tsachila', '1718632589', 1, 'Supermercado', 'Av De Los Tsachilas ', '08:00', '19:00', '15', '5', 'Doris Garofalo ', '1619621397', 'USD - $', 'resto_1619732437.jpeg', '0999575930', '-0.2482427500450765', '-79.16831589173509', 'Frigorifico ', 'dorismari43@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(1045, 'Gelatomix Bicentenario', '1721387213', 4, 'Restaurante', 'Av. Amazonas N47-19 E Isaac Albéniz (frente A La Estación Del Trole De El Labrador)', '10:30', '19:00', '10', '0', 'Pendiente ', '1619628382', 'USD - $', 'resto_1619628382.jpeg', '0992524200', '-0.15427784714052997', '-78.48810634445384', 'Heladeria \r\n', 'gelatomixbicentenario@gmail.com', 'www.heladosconqueso.com', 'Quito', 'Av. Río Amazonas 7003, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '2021-09-01 09:00:02'),
(1047, 'Guayaco Republik Ceviches ', '1718501339001', 1, 'Restaurante', 'Calle Río Zamora, Río Marañon', '08:30', '16:00', '15', '8', 'Nathaly Macas', '1619630333', 'USD - $', 'resto_1619630333.jpg', '0967485072', '-0.24557531794826448', '-79.1655612630768', 'Ceviches', 'republikceviches@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Rio Papallacta 27, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-09-01 09:00:02'),
(1049, 'Mac Burgers', '1718739582', 1, 'Restaurante', 'Av. Rio Lelia Y Av. Los Anturios Junto Al Comercial Las Villegas Santo Domingo, Ecuador', '15:00', '22:30', '20', '10', 'Thalia Alejandra Acuña Cuichan ', '1619645491', 'USD - $', 'resto_1619651089.jpeg', '0967749653', '-0.24851800915877842', '-79.15246638338996', 'Restaurante \r\n', '1macburgers1@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Los Anturios 126, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 21, '15-03-2022 18:46:13'),
(1051, 'Guayaco Republik', '1718501339001', 1, 'Restaurante', 'Es Rio Marañón Y Rio Zamora, Frente Al Parqueadero', '08:30', '16:00', '20', '8', 'Nataly  Macas', '1619650347', 'USD - $', 'resto_1619650347.jpg', '0967485072', '-0.24552703862937078', '-79.1655451698227', 'Bolones', 'guayacobolones@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3m+xj6, Rio Zamora, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '06-09-2022 10:47:36'),
(1053, 'Cevicheria Joalpade ', '0803429166', 1, 'Restaurante', 'Calle Tulcan, Y, Santo Domingo', '07:00', '14:30', '15', '0', 'Diana Elizabeth Daza Cedeño ', '1619710489', 'USD - $', 'resto_1619814516.jpeg', '0959982554', '-0.25574950991480283', '-79.16935725938514', 'Restaurante Cevicheria ', 'amadapaz85@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Prvj+j83, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:53:08'),
(1055, 'Barba Negra ', '2300397730', 1, 'Restaurante', 'Coop Dos Pinos Calle Luis Cordero Y Juan Pío Montufar', '07:30', '15:00', '15', '10', 'Rodriguez Rogel Freddy Fernando', '1619713851', 'USD - $', 'resto_1619729739.jpeg', '0990642548', '-0.2589778511710847', '-79.17896258514358', 'Marisqueria Y Grill \r\n', 'freddy_rodriguez94@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Dr. Luis Cordero 146, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-08-2022 01:12:50'),
(1057, 'Estilo Y Moda ', '1725992265001', 1, 'Lo Que Sea', 'Vía A Quevedo Km 4, Dentro De Supermercados Ok (segunda Planta)', '09:00', '21:00', '15', '10', 'Stalin Francisco Lema Andrango', '1619717226', 'USD - $', 'resto_1619729772.jpeg', '0990210329', '-0.2787518840422402', '-79.20482612084581', 'Tienda De Ropa ', 'estilo.moda.stodomingo@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Km 4 Via Quevedo, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1059, 'Mc Pato ', '1714496583', 1, 'Restaurante', 'Calle Francisco Durini, Santo Domingo', '15:00', '23:00', '15', '0', 'Berrezueta Merchan Patricio Marcelo', '1619729636', 'USD - $', 'resto_1619729805.jpeg', '0986101826', '-0.24923113475308906', '-79.18314213734104', 'Restaurante Comida Rapida  ', 'schardiente@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr28+8p5, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '06-04-2022 22:52:55'),
(1061, 'The Grill Yard ', '1715488142001', 1, 'Restaurante', 'Av Galo Luzuriaga Y Puruhaes (urb. Banco De Fomento) ', '12:00', '23:00', '15', '10', 'Daniel Armendaris', '1619735860', 'USD - $', 'resto_1620347382.jpeg', '0997696235', '-0.2484965516884854', '-79.15107599329184', 'Restaurante ', 'nod-dan@hotmail.com', 'https://www.facebook.com/the-grill-yard-172102640124392/', 'Santo Domingo de los Colorados', 'Puruhaes 202, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-08-2022 01:14:03'),
(1063, 'Gelatomix Católica', '1721387213', 4, 'Restaurante', 'Av. Isabel La Católica N24-222, Quito 170525', '10:30', '19:00', '10', '0', 'Pendiente ', '1619799501', 'USD - $', 'resto_1619799501.jpeg', '0998233011', '-0.20654478746482988', '-78.48570878487064', 'Heladeria ', 'gelatomixreala@gmail.com', 'www.heladosconqueso.com', 'Quito', 'Av. Isabel La Católica N24-222, Quito 170525, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1065, 'Lo De Pepo ', '1721387213', 10, 'Restaurante', 'Avenida Malecón\r\nSalinas', '14:00', '00:00', '20', '0', 'Pendiente ', '1619813008', 'USD - $', 'resto_1619813008.jpeg', '0991159591', '-2.2254960200441007', '-80.93687063883974', 'Restaurante De Comida Rapida ', 'sanducheslodepepo@gmail.com', 'faster.com.ec', 'Santa Elena', 'Calle B, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1067, 'Ibombay Capaes', '1726697145', 10, 'Restaurante', 'Ruta Del Spondylus, Ballenita', '08:30', '17:30', '20', '0', 'Pendiente ', '1619817657', 'USD - $', 'resto_1619817657.jpeg', '0979263680', '-2.1919155901673717', '-80.84680340122415', 'Restaurante ', 'ibombay@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Ruta Del Spondylus, Ballenita, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1069, 'Ibombay Salinas ', '1726697145', 10, 'Restaurante', 'Avenida Malecón\r\nSalinas', '18:30', '21:30', '20', '0', 'Pendiente ', '1619822216', 'USD - $', 'resto_1619822216.jpeg', '0979263680', '-2.205687303285847', '-80.97095112185909', 'Restaurante', 'ibombaysalinas@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Edificio Balboa, Avenida Malecón, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1071, 'Las Palmeras Cotocollao', '1721387213', 4, 'Restaurante', 'Alberto Bastidas Oe4-40 Y Diego De Vásquez - 2594572\r\nQuito', '09:00', '17:00', '20', '0', 'Pendiente ', '1620061600', 'USD - $', 'resto_1620166822.jpeg', '0991274438', '-0.11946656202911886', '-78.493091229908', 'Restaurante  ', 'grupopalmeras@gmail.com', 'http://www.laspalmeras.com.ec/locales/', 'Quito', 'Cotocollao, Quito 170144, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1073, 'La Cuevita Del Camarón Reventado', '1723315253', 1, 'Restaurante', ' Rosales Segunda Etapa De Los Rosales,  Calle Venezuela', '10:00', '23:30', '15', '10', 'Andrea Marisol Urresta Abril', '1620073405', 'USD - $', 'resto_1620073405.png', '0939745716', '-0.24932534645306323', '-79.18314582537843', 'Restaurante ', 'andreaurresta2018@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Qr28+8p5, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '24-07-2022 22:45:03'),
(1075, 'Glow Point ', '1721387213', 10, 'Supermercado', 'Calle 16a, La Libertad', '08:00', '18:00', '20', '0', 'Pendiente ', '1620079354', 'USD - $', 'resto_1620166741.jpeg', '0985154251', '-2.229026490717062', '-80.91368193607761', 'Soluciones Electricas Y Ferreteras ', 'glowpoint19@gmail.com', 'faster.com.ec', 'Santa Elena', 'Av. 14 1219, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1077, 'La Estancia De Domalu 2 De Mayo', '1718632589', 1, 'Supermercado', 'Local 2 Frente Al Tía En La 2 De Mayo', '08:00', '19:00', '15', '5', 'Doris Garofalo ', '1620135893', 'USD - $', 'resto_1620135893.jpeg', '0999575930', '-0.23286175805523554', '-79.18156231623124', 'Frigorifico ', 'dorismari42@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Avenida Patricio Romero 206, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1079, 'Brothers Sports Y Food', '1721387213', 4, 'Restaurante', 'Av. Republica Dominicana Y Fco. Ruiz 170302 Quito, Ecuador', '08:00', '22:00', '20', '0', 'Pendiente ', '1620222417', 'USD - $', 'resto_1620946943.jpeg', '0993622301', '-0.08944229983042083', '-78.46945526879264', 'Restaurante De Comida Rápida\r\n', 'heneste27@gmail.com', 'https://brothers-sportsfood.negocio.site/?utm_source=googlemybusiness&utm_medium=referral', 'Quito', 'Republica Dominicana Y Francisco Ruiz, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1081, 'Encocados De Maicol', '2300459548', 1, 'Restaurante', 'Via Quinindé Km 1, Santo Domingo', '06:30', '11:00', '20', '8', 'Merina Caicedo Orozo', '1620308685', 'USD - $', 'resto_1620947073.jpeg', '0992479798', '-0.23117399187098248', '-79.16752899866535', ' Bolones', 'maicon@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Via Quinindé Km 1, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '23-07-2022 03:52:11'),
(1083, 'Davids Hamburgers', '1721387213', 9, 'Restaurante', 'Avenida 6, Calle 18, Esquina. Manta, Ecuador\r\n', '18:00', '22:00', '20', '0', 'Pendiente ', '1620313808', 'USD - $', 'resto_1620946965.jpeg', '0997659228', '-0.9424422143842243', '-80.7283986253662', 'Restaurante De Comida Rápida  ', 'davidshamburgers@outlook.es', 'https://davids-hamburgers.negocio.site/?utm_source=gmb&utm_medium=referral', 'Manta', 'Avenida 6 Y Calle 18, Barrio, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1085, 'Kobe Sushi Y Rolls', '1721387213', 9, 'Restaurante', 'Mall Del Pacífico, Manta\r\nManta, Ecuador', '12:00', '22:00', '20', '0', 'Pendiente ', '1620317169', 'USD - $', 'resto_1620946985.jpeg', '0993182372', '-0.942153245447063', '-80.73267373125984', 'Restaurante Japonés \r\n', 'servicioalcliente@sushicorp.ec', 'https://www.kobesushiexpress.com/', 'Manta', 'Córdoba, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '2021-09-01 09:00:02'),
(1087, 'Botelos Manta', '1721387213', 9, 'Restaurante', 'Plaza Comercial La Quadralocal #42,43,44', '12:00', '23:00', '20', '0', 'Pendiente ', '1620340022', 'USD - $', 'resto_1621021480.jpeg', '0969490831', '-0.9457050139548171', '-80.75242518316938', 'Restaurante  ', 'boletos@faster.com.ec', 'faster.com.ec', 'Manta', 'Unnamed Road, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1089, 'Parrilladas El Brasero 2', '1714910161001', 1, 'Restaurante', 'Calle Venezuela Y Mon Señor Schumager Frente Al Colegio Antonio Neumane', '12:00', '22:00', '20', '10', 'Karen Barreno Palomino', '1620399280', 'USD - $', 'resto_1620428679.jpeg', '0958797029', '-0.2493468039220077', '-79.18092797379924', 'Restaurante', 'maopalomino@hotmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Colombia 108, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 6, '2021-07-28 07:45:29'),
(1091, 'Los Motes De La Magdalena', '1721387213', 9, 'Restaurante', 'Mall Del Pacífico (manta)\r\n', '09:30', '22:00', '20', '0', 'Pendiente ', '1620837038', 'USD - $', 'resto_1620946904.jpeg', '0987056759', '-0.9422105699132917', '-80.7327381042762', 'Restaurante Especializado En Cocina Moderna Latinoamericana', 'pacifico@losmotesdelamagdalena.com', 'http://www.losmotesdelamagdalena.com/', 'Manta', 'Córdoba, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1093, 'Bottero Restaurante', '1721387213', 9, 'Restaurante', 'Calle U8, Av. U2-u3 Ciudadela Universitaria, Km 1,5. Sector Barbasquillo', '12:00', '23:30', '20', '0', 'Pendiente ', '1620853730', 'USD - $', 'resto_1621021444.jpeg', '0967973440', '-0.9471434875479449', '-80.74563751798107', 'Restaurante ', 'info@casadebottero.com', 'http://www.casadebottero.com/', 'Manta', 'Calle Universidad 8, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1095, 'Gelatomix Real Audiencia ', '1718515172', 4, 'Restaurante', 'Av. Real Audiencia, Quito', '10:30', '19:30', '10', '0', 'Flor Vinueza', '1620919903', 'USD - $', 'resto_1620919903.jpeg', '0999934142', '-0.12919256428297177', '-78.48726882468893', 'Heladeria  ', 'gelatomixcatolica@gmail.com', 'www.heladosconqueso.com', 'Quito', 'Real Audiencia Y Luis Tufino, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1097, 'Gelatomix Cotocollao', '1720100708001', 4, 'Restaurante', 'Av. De La Prensa', '10:30', '19:00', '10', '0', 'Daniela Calle Burneo', '1620920856', 'USD - $', 'resto_1620920856.jpeg', '0995542621', '-0.12469819883487619', '-78.49407895337774', 'Heladeria', 'gelatomixcotocollao@gmail.com', 'www.heladosconqueso.com', 'Quito', 'Av. De La Prensa N60-21, Quito 170301, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '2021-09-01 09:00:02'),
(1099, 'La Avenida Del Licor 24-7', '0926588906', 6, 'Licorería', '1er Pasaje 1 Ne, Guayaquil 090509', '11:00', '23:00', '20', '0', 'Jenniffer Astudilllo', '1620946702', 'USD - $', 'resto_1621021516.jpeg', '0989184047', '-2.144442986851923', '-79.90056364666654', 'Licoreria ', 'lavenidadelicor@faster.com.ec', 'faster.com.ec', 'Guayaquil', 'Calle 16a Ne 7, Guayaquil 090509, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1101, 'Asadero The King El Rey', '0915253355001', 1, 'Restaurante', 'Sector 5 Esquinas', '08:00', '20:00', '15', '10', 'Hilda Maria Barzola Peñafie', '1621003321', 'USD - $', 'resto_1621003321.png', '0993898544', '-0.2546333867591475', '-79.16767886709405', 'Asadero De Pollos \r\n', 'asaderotheking@faster.com.ec', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito 400 Y, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '30-07-2022 02:02:21'),
(1103, 'Picantería Polo Apolo', '0402010276', 10, 'Restaurante', '28 Y 29 Av. 12 Ava, La Libertad 240350', '07:00', '15:00', '30', '8', 'Barbara Polo', '1621032754', 'USD - $', 'resto_1621032754.jpg', '0993998265', '-2.227124567113678', '-80.90200996827318', 'Picantería Polo Apolo', 'barbarapolo@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Av. Eleodoro Solorzano, La Libertad 240350, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1105, 'Pame’s Tradición Parrillera', '1707530950', 4, 'Restaurante', 'Carcelen', '12:00', '19:30', '20', '0', 'Pendiente ', '1621094063', 'USD - $', 'resto_1638211956.jpeg', '0994652539', '-0.08818970972543048', '-78.47392684649661', 'Pinchos', 'lospinchosdepame@gmail.com', 'www.faster.com.ec', 'Quito', 'Francisco Del Campo 0e3-147 Y, Alonso Lopez, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 13, '29-11-2021 13:52:36'),
(1107, 'El Rincon De Los Manabitas', '0701816787', 10, 'Restaurante', 'Libertad', '07:00', '16:30', '20', '0', 'Walter Coronel', '1621110205', 'USD - $', 'resto_1621110205.jpg', '0993266412', '-2.226915512828137', '-80.90205556582643', 'Desayunos', 'rinconmanabita@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Octava, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1109, 'Finisterre', '1721387213', 9, 'Restaurante', 'Calle 27 Avenida 35 Barrio Umina 22522 Manta, Ecuador', '12:00', '22:00', '20', '0', 'Pendiente ', '1621288623', 'USD - $', 'resto_1621890888.jpeg', '0993816262', '-0.9471974596287277', '-80.73943423908193', 'Restaurante ', 'betty_36ec@hotmail.com', 'http://www.finisterre-manta.com/', 'Manta', 'Calle 27 222, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '2021-09-01 09:00:02'),
(1111, 'The Rusty Bold Ruta 66', '0802852673001', 1, 'Restaurante', 'Av. Rio Lelia, Y Los Ceibos', '15:30', '23:00', '10', '0', 'Viviana Maritza Castro Rosero', '1621540214', 'USD - $', 'resto_1621540685.jpeg', '0991775192', '-0.2500887629436981', '-79.1522970689459', 'Cortes, Alitas, Mariscos, Cocteles', 'castroviviana1190@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Prxx+w3x, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '09-06-2022 16:42:01'),
(1113, 'La Tacada', '0919402966', 10, 'Restaurante', 'Calle 20, La Libertad', '18:00', '22:00', '30', '0', 'Kleber Gutierrez', '1621702313', 'USD - $', 'resto_1623771138.jpeg', '0978828534', '-2.2274347982583698', '-80.90862094294263', 'Restaurante ', 'kleberin80@gmail.com', 'faster.com.ec', 'Santa Elena', 'Q3fr+4gj, Calle 20, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:59:19'),
(1115, 'Cangrejos Mi Sargento', '1721387213', 1, 'Supermercado', 'Avenida Los Colonos, Entrada Al Redondel Los Rosales ', '10:00', '18:00', '20', '0', 'Eduard Parra', '1621881184', 'USD - $', 'resto_1622048831.jpeg', '0969844255', '-0.23975598241051474', '-79.18480141889287', 'Marisco Crudo', 'parraeduard207@gmail.com', 'faster.com.ec', 'Santo Domingo de los Colorados', 'Troncal De La Costa, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-07-28 07:45:29'),
(1117, 'Restaurante El Negro Joe', '0800330409001', 4, 'Restaurante', 'Carcelen Calle Alejandro Ponce Borja Número: N81-103 Intersección: Gonzalo Gordillo Referencia: Diagonal A Las Cinco Canchas', '09:00', '17:00', '20', '0', 'Garcia Castro Maria Libia', '1621975968', 'USD - $', 'resto_1621981267.jpeg', '0983518492', '-0.08715437825775824', '-78.47238122355176', 'Restaurante ', 'samechyudted@gmail.com', 'faster.com.ec', 'Quito', 'Gonzalo Duarte Y Oe2, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:00:39'),
(1119, 'Transporte Puerta A Puerta', '1723149850', 4, 'Publicidad', 'Quito', '06:00', '20:00', '10', '0', 'Ruben Borja', '1621987693', 'USD - $', 'resto_1621987693.png', '0985494782', '-0.14108242847699354', '-78.47566491793825', 'Puerta A Puerta', 'quitop@faster.com.ec', 'faster.com.ec', 'Quito', 'Zoila Rendón De Mozquera 37, Quito 170502, Ecuador', 0, 'Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 2, 1, '25-05-2021 19:14:19'),
(1121, 'Quality Manta', '0952322451', 9, 'Supermercado', 'Manta', '08:00', '18:00', '15', '0', 'Pablo Aguirre', '1621989895', 'USD - $', 'resto_1621989895.jpg', '0963506536', '-0.9441535670528901', '-80.7331126077099', 'Productos De Limpieza', 'qualitymanta@faster.com.ec', 'www.faster.com.ec', 'Manta', 'Calle 22 106, Manta, Ecuador', 0, 'Moto Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 8, '2021-09-01 09:00:02'),
(1123, 'Broad Burguer', '1721387213', 9, 'Restaurante', 'Calle 108 Av. 108. Al Frente Del Colegio San Jose. Manta, Ecuador\r\n', '09:00', '23:00', '20', '0', 'Pendiente ', '1622051063', 'USD - $', 'resto_1622148807.jpeg', '099856577', '-0.953805848470045', '-80.71175115983917', 'Restaurante', 'broad.burguer@hotmail.com', 'https://broadburguer.wixsite.com/misitio', 'Manta', 'Avenida 108 610, Manta 130203, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1125, 'Aliss Cafe', '1721387213', 9, 'Restaurante', 'Calle 16 Avenida 7\r\nBarrio Cordova\r\nManta 130802\r\nEcuador', '08:30', '18:00', '20', '0', 'Pendiente ', '1622125210', 'USD - $', 'resto_1622148738.jpeg', '0986558948', '-0.943817916274201', '-80.726839369349', 'Restaurante', 'alisscafe@faster.com.ec', 'https://aliss-cafe.negocio.site/?utm_source=gmb&utm_medium=referral', 'Manta', 'Calle 16 7, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '2021-09-01 09:00:02'),
(1126, 'Soporte Logistics', '1723149850', 9, 'Supermercado', 'Manta - Sucursal', '00:00', '23:59', '15', '0', 'Soporte', '1558154534', 'USD - $', 'store_1607950770.png', '0993182372', '-0.9630614', '-80.7021676', 'Soporte Store', 'servicio@faster.com.ec', 'www.faster.com.ec', 'Manta', 'Manta - Sucursal', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1128, 'Asadero La Brasa Original', '1721387213', 1, 'Restaurante', 'Av Esmeraldas ', '11:30', '21:00', '15', '15', 'Marlene Loor Barreto', '1622492039', 'USD - $', 'resto_1622492039.jpeg', '0998155388', '-0.24165496963497973', '-79.17072317432596', 'Pollo Asado', 'asaderobraorg@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Esmeraldas, Santo Domingo, Ecuador', 1, 'Moto Auto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-07-28 07:45:29'),
(1130, 'Casa Rabotti', '1721387213', 10, 'Restaurante', 'Calle 52, Salinas ', '12:00', '23:00', '20', '0', 'Pendiente ', '1622749921', 'USD - $', 'resto_1622763572.jpeg', '0987285940', '-2.205352275527007', '-80.95961610656215', 'Restaurante ', 'rabotti@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q2vr+v5 Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '23-10-2021 13:19:56'),
(1132, 'Pollo Horneado Stav', '1724715220', 4, 'Restaurante', 'Av. De La Prensa N60-64 Y, Quito 170512', '09:00', '22:00', '20', '0', 'Pendiente ', '1622828251', 'USD - $', 'resto_1622921827.jpg', '0996053219', '-0.12374568159717268', '-78.49403000306322', 'Pollo Hornado \r\n', 'social@pollostav.com', 'http://www.pollostav.com/', 'Quito', 'Av. De La Prensa N60, Quito 170301, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '10-12-2021 21:13:40'),
(1134, 'La Tablita Del Tártaro', '1724715220', 4, 'Restaurante', 'Av. De La Prensa N59-30 Y, Quito 170138', '11:00', '20:00', '20', '0', 'Pendiente ', '1622931858', 'USD - $', 'resto_1622987040.jpg', '0989629049', '-0.12653818979673037', '-78.49365617018177', 'Restaurante De Comida Rapida ', 'servicioalcliente@latablitadeltartaro.com', 'www.faster.com.ec', 'Quito', 'Av. De La Prensa N59-30 Y, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1136, 'Pollos Chester', '1724715220', 4, 'Restaurante', 'Av. Cristóbal Vaca De Castro, Quito', '10:00', '21:00', '20', '0', 'Pendiente ', '1622988657', 'USD - $', 'resto_1623094638.jpg', '0987854794', '-0.12889986896662392', '-78.49816295187901', 'Restaurante De Pollo \r\n', 'polloschester@faster.com.ec', 'https://www.facebook.com/pollos-chesters-109737310702728/app/701720909911837/', 'Quito', 'Machala Y Vaca De Castro, Quito, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(1138, 'Texas Chicken', '1724715220', 4, 'Restaurante', 'Av. Colón Y Av. 6 De Diciembre Ec107143 Quito, Ecuador', '11:00', '22:00', '20', '0', 'Pendiente ', '1623007468', 'USD - $', 'resto_1623094705.jpg', '0980411431', '-0.12240759766206946', '-78.49364342968894', 'Restaurante Especializado En Pollo ', 'sugerencias@grupotcg.com', 'http://texaschicken.com.ec/', 'Quito', 'Av. De La Prensa N61-124, Quito, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(1140, 'Nanotech Market ', '0401374061', 4, 'Lo Que Sea', 'Centro Comercial Quitus Local 536 Planta Alta ', '09:30', '18:00', '10', '0', 'Galo Mora Mendez', '1623339755', 'USD - $', 'resto_1624488392.jpeg', '0998377619', '-0.20332548668821548', '-78.49975651931001', 'Venta De Accesorios  Tecnológicos ', 'nanotech@faster.com.ec', 'www.nanotech-market.com', 'Quito', 'San Gregorio &, Quito 170129, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 16, '2021-09-01 09:00:02'),
(1142, 'Salchicheria Dibo2 Interbarrial ', '1310260920', 9, 'Restaurante', 'Av. Interbarrial Sector Las Cumbres.', '08:00', '14:00', '15', '0', 'Amira Mera Bosada', '1623427963', 'USD - $', 'resto_1623771260.jpeg', '0997382503', '-0.966992082213972', '-80.72351298164557', 'Manta', 'salchicheriadibo.2@faster.com.ec', 'faster.com.ec', 'Manta', 'C. 14 De Febrero 705, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1144, 'Helados Gourmet Ice Candy', '2300212566', 1, 'Restaurante', 'Calle Jorge Araujo Chiriboga Y Calle Dolores Sucre Lavayen', '09:00', '19:00', '20', '10', 'Willian Francisco Cando ', '1623505149', 'USD - $', 'resto_1623693668.jpeg', '0998377854', '-0.2632478835797168', '-79.18242632281019', 'Heladería Gourmet ', 'wcandoveintimilla@yahoo.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Calle Jorge Araujo Chiriboga 20, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '2021-09-01 09:00:02'),
(1146, 'Chifa Central Puerto Ila ', '1723866149', 1, 'Restaurante', 'Castelo,av.puerto Ila #328 Y, Av. Quevedo, Santo Domingo 230203', '11:00', '23:00', '20', '8', 'Liu Genwei', '1623507324', 'USD - $', 'resto_1623507324.jpg', '0988188897', '-0.2630611367467663', '-79.18958647977544', 'Chifa ', 'centralpuertoila@faster.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av.puerto Ila 326, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '14-09-2021 13:34:41'),
(1148, 'El Papalote', '1722342191', 4, 'Lo Que Sea', 'De Los  Tulipanes Y Av. De Las Palmeras', '09:00', '19:00', '15', '0', 'Oscar Andres Osorio Cabrera', '1623512827', 'USD - $', 'resto_1623512827.jpg', '0984794488', '-0.16007668738702258', '-78.47450272549742', 'Papeleria', 'elpapaloteventas@gmail.com', 'www.faster.com.ec', 'Quito', 'De Los Viñedos 277, Quito 170138, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-07-28 07:45:29'),
(1150, 'Don Juan Pa Ella ', '1708048366', 4, 'Restaurante', 'Av. Isla Floreana E6-20, Quito 170138', '11:30', '17:00', '20', '0', 'Iván Rueda Mejía', '1623531756', 'USD - $', 'resto_1624388552.jpeg', '0993501265', '-0.1675480238779392', '-78.48219173829986', 'Restaurante ', 'ruedamejia@hotmail.com', 'www.faster.com.ec', 'Quito', 'Av. Isla Floreana 608, Quito 170513, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '2021-09-01 09:00:02'),
(1152, 'Umidigi', '1715432041', 4, 'Lo Que Sea', 'Quito 170129', '10:00', '17:00', '30', '0', 'Santiago ', '1623591796', 'USD - $', 'resto_1624388683.jpeg', '0996382632', '-0.20288560717355855', '-78.4996653242035', 'Productos Electrónicos  ', 'compras@umidigiec.com', 'faster.com.ec', 'Quito', 'San Gregorio Oe3-86, Quito 170129, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '2021-09-01 09:00:02'),
(1154, 'Organika Ec', '1724901952001', 1, 'Supermercado', 'Vía Quevedo Km 4.5 En Coop Unión Cívica Pasando El Kfc En El Semáforo Ingresa Mano Izquierda 5 Cuadras A Dentro En Una Tienda Esquinera 2 Pisos Justo En La Parada De Buses', '08:00', '19:00', '15', '10', 'Paola OrdoÑez', '1623779265', 'USD - $', 'resto_1623779265.jpg', '0997328946', '-0.28211198113794983', '-79.20441574286653', 'Venta De Diversos Productos ', 'pao.ord_lam@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Vía Quevedo Km 4,5 En La Coop. Unión Cívica, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '06-06-2022 17:55:46'),
(1156, 'Pizzería El Hornero', '0993202223001', 10, 'Restaurante', 'Avenida 10 Y Calle 23 En La Esquina, Salinas 240209', '01:00', '22:00', '15', '0', 'Resestrada Cia Ltda', '1623861305', 'USD - $', 'resto_1623861305.jpg', '0995263724', '-2.2053479201656394', '-80.97326553296281', 'Comida', 'pizzeria.elhornero@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Lupercio Bazán Malavu, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1158, 'El Krug Pub', '1721387213', 9, 'Restaurante', 'Avenida Umiña 1 Y Vía Barbasquillo, Manta 130214', '16:00', '22:00', '20', '0', 'Pendiente', '1624046651', 'USD - $', 'resto_1624388941.jpeg', '0987229392', '-0.9453148056808347', '-80.74399902354911', 'Restaurante ', 'andres@krugpub.com', 'faster.com.ec', 'Manta', 'Avenida Umiña 1, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '2021-09-01 09:00:02'),
(1160, 'El Velero Manabita', '1202433619001', 4, 'Restaurante', 'De Los Alamos E8 149 Quito 170138', '08:00', '17:00', '10', '0', 'Bustamante Guevara Jina Elizabeth', '1624051508', 'USD - $', 'resto_1624051508.jpeg', '0981393718', '-0.14447071849445967', '-78.47452464383079', 'Ofrece Servicio De Restaurant', 'elveleromanabita@faster.com.ec', 'faster.com.ec', 'Quito', 'De Los Alamos E8-149, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '2021-09-01 09:00:02'),
(1162, 'Wisconsin Ribs', '1709927352', 4, 'Restaurante', 'Centro Comercial Caracol Av. Amazonas ', '12:00', '17:30', '10', '0', 'Marcos Rueda ', '1624131637', 'USD - $', 'resto_1624488367.jpeg', '0993501265', '-0.17636842848999204', '-78.48582780789567', 'Grill', 'marcosrueda@faster.com.ec', 'faster.com.ec', 'Quito', 'Rgf7+fm Puembo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '03-11-2021 11:44:02'),
(1164, 'El Mejor Bolon D Carol', '0919891242', 10, 'Restaurante', 'Libertad', '06:00', '22:00', '15', '0', 'Isidra Pillasagua Figueroa', '1624368825', 'USD - $', 'resto_1624372974.jpeg', '0994955143', '-2.2277088468826025', '-80.90800470542146', 'Desayunos', 'mejor.bolondecarol@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q3cr+xqh, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '12-05-2022 14:17:54'),
(1166, 'Asadero El Pollo Kuku', '0914781182001', 10, 'Restaurante', 'Av. Eleodoro Solorzano Y Calle 49 La Libertad', '14:00', '22:00', '15', '0', 'Steven Tipan', '1624669325', 'USD - $', 'resto_1624669325.jpg', '096028075', '-2.2283695115714477', '-80.8953312678261', 'Asadero', 'asadero.kuku@faster.com.ec', 'faster.com.ec', 'Santa Elena', 'Q4c3+jm8 La Libertad, Empresa Electrica Cnel, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:59:36'),
(1168, 'Quitacos Comida Fusión ', '0992918624001', 4, 'Restaurante', 'San Gabriel Oe635 Y Martìn Utreras', '08:00', '20:00', '20', '0', 'Rhenals Ramirez Fabian Adolfo ', '1624741053', 'USD - $', 'resto_1625081537.jpeg', '0969282646', '-0.18689537541154366', '-78.50039086174203', 'Restaurante ', 'fabianadol82@faster.com', 'www.faster.com.ec', 'Quito', 'San Gabriel Oe5-139, Quito 170129, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 17, '04-11-2021 13:45:29'),
(1170, 'La Chama Burgers', '1721387213', 10, 'Restaurante', 'La Libertad Avda.25 Esquina Y Calle 8 Esquina, La Libertad 240250', '18:00', '23:59', '15', '0', 'Hilarie Milagros Sanchez Palencia', '1624753578', 'USD - $', 'resto_1629920512.jpeg', '0978918993', '-2.234846153956584', '-80.92122531365587', 'Comida Rapida', 'lachamaburgers@gmail.com', 'faster.com.ec', 'Santa Elena', 'Q38h+2g6, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:59:48'),
(1172, 'Alice Italian Restaurant', '1721387213', 9, 'Restaurante', 'Avenida Umiña 1, Manta', '12:30', '23:00', '20', '0', 'Pendiente ', '1624806612', 'USD - $', 'resto_1624899640.jpg', '0983846268', '-0.9451559064226853', '-80.74409860055877', 'Restaurante Italiano \r\n', 'alice@faster.com.ec', 'https://drive.google.com/file/d/1guamnr915hhlxva2pku1nnb_my4iuiot/view?fbclid=iwar3lec8i7zofphvr9zqw41jaunma0uto00fk8bi-ss4gteqivn6tszxqvay', 'Manta', 'Avenida Umiña 1, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(1174, 'Los Cebiches De La Rumiñahui', '1724715220', 9, 'Restaurante', 'Mall Del Pacifico ', '10:00', '20:00', '20', '0', 'Fantasma', '1624833370', 'USD - $', 'resto_1624899102.jpg', '0989514123', '-0.9420416135890436', '-80.7329952610655', 'Restaurante ', 'alainloorlcr@hotmail.com', 'https://goo.gl/rk6znv', 'Manta', 'Mall Del Pacifico, Av. Malecón, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(1176, 'Gelatomix Central ', '1751429018', 4, 'Restaurante', 'San Gregorio Y Antonio De Ulloa', '10:30', '18:30', '10', '0', 'Daniel Espinoza Burneo ', '1625155536', 'USD - $', 'resto_1625155536.jpeg', '098621143', '-0.20253692218393227', '-78.50067919921113', 'Heladeria', 'gelatomixcentral@faster.com.ec', 'https://heladosconqueso.com/tiendas/', 'Quito', 'San Gregorio 357, Quito 170129, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1178, 'Cosas Finas De La Florida', '1705617536001', 4, 'Restaurante', 'Manuel Serrano N52-67 Y Pedro Leon', '10:00', '16:00', '20', '0', 'Galo Pillalaza', '1625330211', 'USD - $', 'resto_1625514391.jpg', '0998870069', '-0.14245236253780755', '-78.49491144400073', 'Hornados-fritadas-chicharrones', 'cosasfinasdelaflorida@outlook.es', 'http://www.facebook.com/cosasfinasdelaflorida', 'Quito', 'Teniente Manuel Serrano N52-67, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(1180, ' La Tablita Del Tártaro', '1751429018', 9, 'Restaurante', 'Mall Del Pacifico ', '10:00', '20:00', '20', '0', 'Pendiente', '1625406197', 'USD - $', 'resto_1625406197.jpg', '0989629049', '-0.9422481157620135', '-80.73305494021608', 'Restaurante ', 'lttmalldelpacifico@latablitadeltartaro.com', 'https://www.latablitadeltartaro.com/', 'Manta', 'Córdoba, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1182, 'Cajún', '1724715220', 9, 'Restaurante', 'Mall Del Pacifico ', '10:00', '21:00', '20', '0', 'Fantasma', '1625427475', 'USD - $', 'resto_1625427475.jpeg', '0989629049', '-0.9424009809990562', '-80.73176479767992', 'Restaurante ', 'cjnc23@cajun.com.ec', 'http://www.cajun.ec', 'Manta', 'Mall Del Pacifico, Av. Malecón, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '24-10-2021 15:55:35'),
(1184, 'Menestras Del Negro', '1724715220', 9, 'Restaurante', 'Mall Del Pacifico', '10:00', '21:00', '20', '0', 'Pendiente ', '1625953347', 'USD - $', 'resto_1625953347.jpeg', '0989629049', '-0.9424023219221694', '-80.73193511795236', 'Restaurante', 'm52@menestrasdelnegro.com.ec', 'http://www.menestrasdelnegro.com', 'Manta', 'Mall Del Pacifico, Av. Malecón, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1186, 'Pollo Ideal  Todo Express ', '1753035383001', 4, 'Restaurante', 'Belladonas E13-405 Y De Los Trigales', '10:00', '19:00', '20', '0', 'Jennifer Estefania Moyano Erazo', '1626038653', 'USD - $', 'resto_1627999321.jpg', '0998441918', '-0.13326146468562738', '-78.46513825338317', 'Restaurante', 'moyanoedwin@hotmail.com', 'www.faster.com.ec', 'Quito', 'Belladonas 224, Quito 170124, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '2021-09-01 09:00:02'),
(1188, 'Made In China Store', '1724715220', 1, 'Lo Que Sea', 'Coop Ciudad Colorada, Calle Túpac Yupanqui Entre Manuelita Sáenz Y San Antonio', '09:00', '18:00', '20', '15', 'David Montesdeoca', '1626303094', 'USD - $', 'resto_1626527542.jpeg', '0996826221', '-0.2583304395671438', '-79.17549381833507', 'Tienda Tecnológica ', 'madeinchinastore@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Cap. Byron Palacios 101, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '2021-09-01 09:00:02'),
(1190, 'Donde Pipe Comida Colombiana', '1724837628001', 4, 'Restaurante', 'Av. Rio Amazonas Frente A La Estación Del Trole Labrador ', '11:30', '20:00', '10', '0', 'Miranda Cruz Juan Felipe', '1626390543', 'USD - $', 'resto_1626460027.jpeg', '0980375891', '-0.15438714676136167', '-78.4880060968919', 'Restaurante De Comidas Típicas De Colombia', 'dondepipecomidacolombiana@hotmail.com', 'logistica@faster.com.ec', 'Quito', 'Av. Río Amazonas 7003, Quito 170104, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 16, '2021-08-13 09:00:01'),
(1192, 'La Yapa Bicentenario', '1711273605', 4, 'Restaurante', 'La Yapa Sector Bicentenario', '07:30', '16:00', '20', '0', 'Arroyo Burbano Jorge Enrrique ', '1626905019', 'USD - $', 'resto_1626961557.jpeg', '0983639388', '-0.14991994339983364', '-78.48930260967444', 'Restaurante ', 'jarroyoburbanobicentenario@yahoo.com', 'ww.faster.com.ec', 'Quito', 'Rio Blanco N48 206 Y, Quito 170127, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1194, 'La Yapa Sector De La Y', '1711273605', 4, 'Restaurante', 'La Yapa Sector De La Y', '07:30', '18:00', '20', '0', 'Arroyo Burbano Jorge Enrrique ', '1626905513', 'USD - $', 'resto_1626961505.jpeg', '0983639388', '-0.17010415797234324', '-78.48645376842452', 'Restaurante ', 'jarroyoburbanosectory@yahoo.com', 'ww.faster.com.ec', 'Quito', 'José Arizaga Y, Lonires, Quito 170135, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '2021-09-01 09:00:02'),
(1196, 'Chau Lao', '1711273605', 1, 'Restaurante', 'Avenida Chone Y Pedro Vicente Maldonado', '10:00', '22:00', '20', '0', 'Fantasma ', '1627223481', 'USD - $', 'resto_1627504792.jpeg', '0969764774', '-0.2551761934366088', '-79.17852203231288', 'Comida Asiática Cocinada En Wok', 'chaulao@faster.com.ec', 'https://www.instagram.com/chaulao_santodomingo/?hl=es', 'Santo Domingo de los Colorados', 'Prvc+whv, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '14-07-2022 16:23:38'),
(1198, 'La Hueca D Anver', '1724715220', 1, 'Restaurante', 'Calle Río Mulaute Entre Quito Guayaquil', '12:00', '18:00', '20', '15', 'Fantasma', '1627250538', 'USD - $', 'resto_1629037194.jpeg', '0980283525', '-0.250076022572249', '-79.16345572900012', 'Sazón Manabita ', 'lahuecadeanver@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Quito &, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 16, '2021-09-01 09:00:02'),
(1200, 'Tacos Mexicanos Del Hiper', '1717401655', 1, 'Restaurante', 'Av. Venezuela, Una Cuadra Antes Del Anillo', '16:30', '23:59', '20', '0', 'Silvana Sharupi', '1627509004', 'USD - $', 'resto_1627509004.jpeg', '0963256778', '-0.24931931153992537', '-79.18279277961685', 'Comida Mexicana; Tacos ', 'sharupisilvi@gmail.com', 'ww.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 137, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '01-05-2022 17:59:56'),
(1202, 'Soffy Pizza', '1711273605', 10, 'Restaurante', 'La Libertad, Frente Al Parque 28 De Mayo', '16:00', '23:00', '20', '0', 'Wilson Alberto Ramírez Vera', '1628356199', 'USD - $', 'resto_1628946862.jpeg', '0960991657', '-2.230188013047927', '-80.9132524473591', 'Pizzería', 'wilson03sophia@gmail.com', 'ww.faster.com.ec', 'Santa Elena', 'Barrio 28 De Mayo, Calle 16 A Y 17 / Avenida 17, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:00:03'),
(1204, 'Chifa Thang Long', '1727224626', 4, 'Restaurante', 'Avenida Del Maestro Oe3-181 Y Maria Tigsilema', '11:00', '22:30', '20', '0', 'Hiep Nguyen Vu', '1628369747', 'USD - $', 'resto_1628369747.jpeg', '0994667151', '-0.12352205294118548', '-78.48742640446855', 'Chifa Vietnamita', 'hiepnguyenvu86@gmail.con', 'www.faster.com.ec', 'Quito', 'Av Del Maestro Oe3-181, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 16:01:52'),
(1206, 'Gelatomix Nayon', '1716149420', 4, 'Restaurante', 'Rhr4+rc9, Quito 170170', '17:45', '17:30', '10', '0', 'Fantasma ', '1628895914', 'USD - $', 'resto_1628895914.jpeg', '0999195368', '-0.15790518609557883', '-78.44274884890748', 'Heladeria', 'nayon@faster.com.ec', 'ww.faster.com.ec', 'Quito', 'Quito Eje Transversal 09-30, Quito 170170, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, '2021-09-01 09:00:02'),
(1208, 'Burguer Bros Rm', '2450700980001', 10, 'Restaurante', 'Direccion. Diagonal Al Hotel Adin, Calle Principal Atras Del Comisariato, Salinas', '18:00', '23:00', '20', '0', 'Ronald Jose Pilco Lucas', '1629046560', 'USD - $', 'resto_1629920566.jpeg', '0989376268', '-2.2073165422012813', '-80.9749915344639', 'Comida Rapida', 'victoria123quimi@gmail.com', 'ww.faster.com.ec', 'Santa Elena', 'Av. 12 De Octubre, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 0, 14, '2021-09-01 09:00:02'),
(1210, 'Diamantes Shoes ', '1724715220', 1, 'Lo Que Sea', 'Calle Machala Entre Ibarra Y Tulcán', '08:30', '19:00', '20', '10', 'Pendiente', '1630181711', 'USD - $', 'resto_1630345537.jpeg', '0980046235', '-0.25311225390395975', '-79.16923052500917', 'Tienda De Calzado ', 'diamanteshoes@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Machala 203, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 14, '18-12-2021 17:45:01'),
(1212, 'Santas Alitas Plaza Garden', '1711273605', 1, 'Restaurante', 'Santas Alitas Av. Quito', '13:00', '23:00', '20', '10', 'Nurys Montaño', '1630762945', 'USD - $', 'resto_1630762945.jpg', '0989821823', '-0.2499479483110835', '-79.16194497477247', 'Deliciosas Alitas ', 'salitas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prxq+x57, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '28-05-2022 13:16:17'),
(1214, 'Zuba Restaurante', '1721249819001', 1, 'Restaurante', 'Calle Venezuela Y Bernardo Rodriguez', '15:30', '22:45', '25', '15', 'Zambrano Rendon Kleber Adalberto', '1630771366', 'USD - $', 'resto_1638211703.jpeg', '0963450578', '-0.24927874351259866', '-79.18241090010835', 'Alitas, Cortes Y Mariscos', 'klebzam@live.com', 'www.zubaecsd.com', 'Santo Domingo de los Colorados', 'Venezuela 122, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-08-2022 01:13:27'),
(1216, 'Chifa Wong Kee', '1715869937', 10, 'Restaurante', 'La Libertad', '10:00', '23:30', '20', '0', 'Fantasma ', '1630788496', 'USD - $', 'resto_1631397578.jpeg', '0968007999', '-2.227270972100466', '-80.90373362284137', 'Comida China', 'chifawongkee@faster.com.ec', 'ww.faster.com.ec', 'Santa Elena', 'Av. Eleodoro Solorzano, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '11-09-2021 16:59:38'),
(1218, 'Bolon De Ruchis ', '1711273605', 9, 'Restaurante', '130804, Manta 130804', '09:00', '17:00', '20', '0', 'Fantasma ', '1630852615', 'USD - $', 'resto_1631132426.jpeg', '0968811872', '-0.9704077224370903', '-80.7070522649212', 'Comida Como Hecha En Casa ', 'bolonderuchis@faster.com.ec', 'ww.faster.com.ec', 'Manta', 'A Vei 205 11, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 15, '08-09-2021 15:20:26'),
(1220, 'Che Pepe', '1720953502', 9, 'Restaurante', 'Av. 14, Manta', '08:00', '16:00', '30', '0', 'Pendiente', '1630873996', 'USD - $', 'resto_1631052197.jpeg', '0962770131', '-0.9477438849955472', '-80.72677119504644', 'Restaurante ', 'chepepe@faster.com.ec', 'www.faster.com.ec', 'Manta', 'Av. 14 1305, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '07-09-2021 17:03:17'),
(1222, 'La Leña El Autentico Sabor Criollo', '2350529752', 9, 'Restaurante', 'Av. 111 A, Manta', '08:00', '18:00', '20', '0', 'Pendiente', '1631369446', 'USD - $', 'resto_1635375430.jpeg', '0986699732', '-0.9620323747441842', '-80.70477775167657', 'Restaurante', 'laleñael@faster.com.ec', 'www.faster.com.ec', 'Manta', 'C. 123 532, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '27-10-2021 17:57:10'),
(1224, 'Mister Shawarma ', '1705303608', 4, 'Restaurante', ' Angel Espinoza N65-49 Y Joaquin Pareja ', '12:00', '21:00', '15', '0', 'Angel Acosta Guerrero', '1631395117', 'USD - $', 'resto_1631396131.jpeg', '0993986411', '-0.11974148785413688', '-78.46662754993869', 'Comida Rápida', 'angelacostaguerrero@gmail.com', 'www.faster.com.ec', 'Quito', 'Angel Espinoza 1141, Quito 170133, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 17, '08-12-2021 08:22:34');
INSERT INTO `fooddelivery_restaurant` (`id`, `name`, `dni`, `city_id`, `type_store`, `address`, `open_time`, `close_time`, `delivery_time`, `commission`, `store_owner`, `timestamp`, `currency`, `photo`, `phone`, `lat`, `lon`, `desc`, `email`, `website`, `city`, `location`, `is_active`, `del_charge`, `enable`, `session`, `status`, `ally`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday`, `sequence`, `edit_id`, `edit_date_time`) VALUES
(1226, 'Frappesito Coffee Shop', '1721507620', 1, 'Restaurante', 'Rio Toachi Y Tsáfiqui', '10:00', '21:00', '20', '15', ' José Ricardo Intriago Arequipa', '1631893292', 'USD - $', 'resto_1631904088.png', '0996512918', '-0.2597563543610405', '-79.16526856701805', 'Frappes  Creps Vevidas De Cafè Frias Y Calientes', 'frappesitoec@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Río Toachi 382, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '30-03-2022 07:36:25'),
(1228, 'Los Asados D Javi', '2450625393001', 9, 'Restaurante', 'Av. Las Acacias &, Manta', '12:00', '23:59', '30', '0', 'Fantasma', '1632592021', 'USD - $', 'resto_1635375607.jpeg', '0968872727', '-0.9691388840674163', '-80.69191354196502', 'Restaurante De Asados  ', 'losasadosdjavi@faster.com.ec', 'www.faster.com.ec', 'Manta', 'Av. Las Acacias &, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'YES', 0, 21, '04-01-2022 15:30:23'),
(1230, 'La Esquina De Ales El Palmar', '1720100690', 9, 'Restaurante', 'C. 114, Manta', '11:00', '22:30', '30', '0', 'Pendiente', '1632690412', 'USD - $', 'resto_1632690412.jpg', '0995436912', '-0.9597615336470776', '-80.71031718384458', 'Asadero De Pollo', 'laesquinadealesmanta@faster.com.ec', 'www.faster.com.ec', 'Manta', 'C. 114 507, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 9, '26-09-2021 16:33:02'),
(1232, 'Maxi Pizza', '1724005853', 10, 'Restaurante', 'Av. 9 De Octubre, La Libertad', '14:00', '20:00', '15', '0', 'Faster', '1632794992', 'USD - $', 'resto_1635375585.jpeg', '0988702524', '-2.221667704514111', '-80.91213061343859', 'Pizzeria', 'maxipizza@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. 9 De Octubre 150, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 'NO', 0, 15, '27-10-2021 17:59:45'),
(1234, 'Chu Burguer ', '2300806912', 9, 'Restaurante', '27w9+cr8, Manta', '17:30', '23:30', '20', '0', 'Pendiente', '1633040013', 'USD - $', 'resto_1635375637.jpeg', '0963451836', '-0.9539667587085203', '-80.73041296433638', 'Restaurante De Comida Rapida', 'chuburguer@faster.com.ec', 'www.faster.com.ec', 'Manta', '27w9+cr8, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 0, 15, '27-10-2021 18:00:37'),
(1236, 'Chef Point Snack Bar Y Grill', '2350529752', 9, 'Restaurante', 'Urb. Manta Beach; Avenida Principal Entre Calles 11 Y 12, Manta 000593', '08:00', '21:00', '20', '0', 'Pendiente ', '1633205825', 'USD - $', 'resto_1635375361.jpeg', '0996321911', '-0.9543559603167431', '-80.7605210958047', 'Restaurante Comida Rapida ', 'chefpoint@faster.com.ec', 'www.faster.com.ec', 'Manta', 'C. 12 Urb. Manta Beach, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '27-10-2021 17:56:01'),
(1238, 'Del Tanque Ribs ', '2350529752', 10, 'Restaurante', 'Av. Punta Carnero Av. Punta Carnero, La Libertad', '18:00', '23:00', '20', '0', 'Carlos Machuca Galindo', '1633211847', 'USD - $', 'resto_1635375564.jpeg', '0997223008', '-2.2285986670028035', '-80.92154986094667', 'Costillas; Bife De Chorizo Y Otros Platos ', 'deltanqueribs@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Punta Carnero Av. Punta Carnero, La Libertad, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 15, '27-10-2021 17:59:24'),
(1240, 'Punto Cangrejo Y Sabores Del Mar', '2450867623', 10, 'Restaurante', 'Av. Novena, La Libertad 548494', '12:00', '21:00', '15', '0', 'Pendiente', '1633470945', 'USD - $', 'resto_1634142091.jpeg', '0959005636', '-2.224363976081891', '-80.91974741648866', 'Restaurante', 'puntocangrejo@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. Octava 191, La Libertad 240350, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '13-10-2021 11:21:31'),
(1242, 'Chifa Jia Le ', '1723572960', 10, 'Restaurante', 'La Libertad', '12:00', '22:00', '15', '0', 'Faster', '1634142019', 'USD - $', 'resto_1634142019.jpeg', '0969455581', '-2.236080371209823', '-80.91039187144472', 'Comida China ', 'chifajiale@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', '11 De Diciembre 2201, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1244, 'Platano Con Salprieta ', '1793137334001', 4, 'Restaurante', 'Capri N 75 Y Gonzalo Correa Esquina', '08:30', '20:30', '25', '0', 'Verá Pincay Jennifer Katherine ', '1634222789', 'USD - $', 'resto_1635116295.jpeg', '0964108884', '-0.0998784255738341', '-78.46836126279071', 'Cafetería  ', 'pcs.cafeteria@gmail.com', 'http://comprodesde.casa/platano-con-salprieta/productos/todos', 'Quito', 'Vgxj+qmm, Quito 170144, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '23-01-2022 11:45:23'),
(1246, 'Chau Lao Flavio Reyes ', '1711273605', 9, 'Supermercado', 'Av Flavio Reyes, Manta', '10:00', '22:00', '20', '0', 'Fantasma ', '1634236432', 'USD - $', 'resto_1634236432.jpeg', '0958776637', '-0.9448229601726664', '-80.73213780477693', 'Restaurante Comida China', 'chaulaoflavioreyes@faster.com.ec', 'ww.faster.com.ec', 'Manta', 'Av Flavio Reyes 1944, Manta, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1248, 'Alitas Extremas ', '1715869937', 10, 'Restaurante', 'Malecon De La Libertad', '17:00', '23:00', '25', '0', 'Fantasma ', '1634396511', 'USD - $', 'resto_1635374141.jpeg', '0968857900', '-2.22091758534337', '-80.91131958048776', 'Deliciosas Alitas', 'alitasextremas@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q3hq+hfm, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '27-10-2021 17:35:41'),
(1250, 'Lania Churros ', '0950817957', 10, 'Restaurante', 'Eugenio Espejo, Salinas', '02:00', '20:00', '15', '0', 'Moises Peña ', '1634595547', 'USD - $', 'resto_1634652844.jpeg', '0961983504', '-2.2000115878441826', '-80.9806281967087', 'Antojitos', 'laniachurros@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Ave Eloy Alfaro 5, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '19-10-2021 09:14:04'),
(1252, 'La Tierrita ', '2350529752', 1, 'Licorería', 'Coop. 30 De Julio Sector 2, Calle Río Pastaza Y Río Tumbes', '09:00', '21:00', '20', '15', 'Jose Jaramillo', '1634998383', 'USD - $', 'resto_1635375472.jpeg', '0980960161', '-0.24285021834349615', '-79.1773576183243', 'Licoreria', 'latierrita@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Río Pastaza 210, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '27-10-2021 17:57:52'),
(1254, 'El Buen Corte ', '2300851462', 1, 'Supermercado', 'Av. Patricio Romero Y San Miguel', '07:00', '20:00', '20', '15', 'Alisson Fernanda Conde Lopez', '1635014288', 'USD - $', 'resto_1635375846.jpeg', '0981379974', '-0.23430946833998578', '-79.18163909446433', 'La Mejor En Carnes Selectas ', 'soyalisson@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr89+78 Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '08-11-2021 11:54:36'),
(1256, 'La Esquina De Ales ', '1721387213', 10, 'Restaurante', 'Av. 9 De Octubre, La Libertad', '12:00', '22:00', '20', '0', 'Pendiente ', '1635107137', 'USD - $', 'resto_1635107137.jpg', '0994470181', '-2.2216586588631415', '-80.9122456131501', 'Asadero De Pollo', 'esquinase@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. 9 De Octubre 150, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1258, 'El Mejor Bolon Algo Diferente ', '1724005853', 10, 'Restaurante', 'Q3cq+pjv, La Libertad', '07:00', '14:00', '15', '0', 'Faster', '1635204672', 'USD - $', 'resto_1635204672.png', '0969213974', '-2.228084072300046', '-80.91096049975587', 'Restaurant Y Cafeteria ', 'algodiferente@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q3cq+pjv, La Libertad, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 21, '28-02-2022 07:19:24'),
(1260, 'Pizza Caliente ', '1724791643', 1, 'Restaurante', 'Av.santa Rosa Y Av.monseñor Pedro Shumager A Dos Cuadras Del Colegio Antonio Neumane', '14:00', '22:00', '25', '15', 'Yanez Carlos Geovany ', '1635267017', '', 'resto_1635429632.jpeg', '0979541041', '-0.2504407995186444', '-79.18034559916688', 'Pizzeria ', 'catgeovanny@gmail.com', 'https://pizzacaliente.ola.click/products', 'Santo Domingo de los Colorados', 'C. Obispo P. Schumacher 502, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '20-04-2022 00:03:48'),
(1262, 'Comidas Rapidas El Chonero', '2350529752', 1, 'Restaurante', 'C. Río Mulaute 203, Santo Domingo', '15:00', '23:59', '20', '0', 'Villa Rodriguez Mariuxi Maricela', '1635527711', 'USD - $', 'resto_1635951691.jpg', '0980030461', '-0.2502128139283272', '-79.16319823693468', 'Comidas Rapidas ', 'carlostalledo2010@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Río Mulaute &, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '16-06-2022 14:06:31'),
(1264, 'Pipes Bbq', '1724004583', 10, 'Restaurante', 'Av. 9 De Octubre, La Libertad', '14:00', '22:30', '20', '0', 'Pendiente', '1635604125', 'USD - $', 'resto_1635632125.jpg', '0987870430', '-2.2204810486430553', '-80.91848946046068', 'Carnes Deliciosas', 'pipesbbq@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q3hj+rj6, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '30-10-2021 17:15:25'),
(1266, 'Magic Pizza', '2300295645', 1, 'Restaurante', 'Av. Abraham Calazacón Ingresando Por El Auto Mercado 20 De Octubre Entre Jorge Carrera Andrade Y Espinoza Polit', '11:00', '23:59', '25', '10', 'Jhonathan Fernando Zambrano Mora ', '1635714416', 'USD - $', 'resto_1635882278.jpeg', '0989052901', '-0.2665245021505576', '-79.1793585462494', 'Pizzeria', 'magic21pizza@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prm9+7xw, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '21-11-2021 07:21:13'),
(1268, 'Bogati', '1001813235001', 4, 'Restaurante', 'Santa Clara De San Millan, Quito 170129', '10:00', '19:00', '20', '0', 'Roxana Peña ', '1635884132', 'USD - $', 'resto_1635884132.jpeg', '0990645491', '-0.20237847444478063', '-78.50081350107801', 'Helados Con Queso', 'bogatiquito@faster.com.ec', 'www.faster.com.ec', 'Quito', 'San Gregorio 357, Quito 170129, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1270, 'Flores Coffe', '1716976426', 4, 'Restaurante', 'M. Jordán 167, Quito 170104', '08:00', '17:00', '25', '0', 'Pendiente', '1635897188', 'USD - $', 'resto_1635897188.jpg', '0996475194', '-0.14266559749444263', '-78.49600679110719', 'Cafeteria', 'florescoffe@faster.com.ec', 'www.faster.com.ec', 'Quito', 'M. Jordán 167, Quito 170104, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1272, 'Mecánica Paramo', '1701222943001', 4, 'Lo Que Sea', 'Rio Blanco, Quito 170104', '09:00', '19:00', '20', '0', 'Mecanica Paramo', '1635967494', 'USD - $', 'resto_1636044013.jpeg', '0999685277', '-0.14979086253249946', '-78.48990878891185', 'Copia De Llaves ', 'mecanicaparamo@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. De La Prensa 2018, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '04-11-2021 11:40:13'),
(1274, 'La Bandeja De Marisco Cevicheria', '0802885129', 4, 'Restaurante', 'Rio Blanco, Quito 170104', '07:30', '18:00', '25', '0', 'Agustin Ortiz', '1635973128', 'USD - $', 'resto_1636636086.jpeg', '0998038065', '-0.14979153308245638', '-78.48992655854656', 'Cevicheria', 'labandejacevicheria@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. De La Prensa 2018, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '11-11-2021 08:08:06'),
(1276, 'Mandingos Fast Food', '2350529752', 1, 'Restaurante', 'Av. Catacocha Y Calle Valencia', '15:00', '23:00', '20', '15', 'Sara Ruth Pantoja Rodriguez', '1636043858', 'USD - $', 'resto_1636043858.jpeg', '0987922969', '-0.27142551456596997', '-79.16980552356674', 'Comida Rapida ', 'sararodriguez429@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Unnamed Road, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'NO', 'NO', 'NO', 'NO', 'YES', 'YES', 'YES', 0, 10, '20-11-2021 17:16:25'),
(1278, 'Fitgreen', '2300120421', 1, 'Restaurante', 'Av. La Lorena\r\nY Gabriela Mistral (marina Peñaherrera). Tercera\r\nCasa Desde La Lorena; Tres Pisos Color Beige, Portón\r\nBlanco.', '09:00', '14:30', '10', '10', 'Diego Andrés Ninabanda Guamán', '1636208125', 'USD - $', 'resto_1636215827.png', '0995750428', '-0.2554749214995007', '-79.15879941415025', 'Restaurante De Comida Saludable \r\n', 'fitgreen.ec@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prvr+mgv, G. Mistral, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 23, '09-09-2022 11:53:22'),
(1280, 'Charlies Bistro Cafe Y Deli', '1724715220', 10, 'Restaurante', 'Av 25 De Diciembre Y Av 22 De Diciembre\r\nSalinas', '10:00', '18:00', '20', '0', 'Pendiente', '1636214348', 'USD - $', 'resto_1636636133.jpeg', '0959712303', '-2.21591432429189', '-80.9536280749364', 'Bistro, Cafe & Deli ', 'charliesbistro@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. 10 De Agosto Entre Calle Estados Unidos Y Av. 22 De Diciembre, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '11-11-2021 08:08:53'),
(1282, 'Kfc Carcelén ', '1724715220', 4, 'Restaurante', 'Alejandro Ponce, Carcelén', '10:00', '22:00', '20', '0', 'Pendiente', '1636302433', 'USD - $', 'resto_1636302433.jpg', '0981867734', '-0.0912236196784563', '-78.47241341005994', 'Comida Rápida', 'kfccarcelen@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Avenida Clemente Yerovi Indaburu N78-10, Quito 170120, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1284, 'Taco Madre ', '1720100690', 4, 'Restaurante', 'Edmundo Carvajal Y Brasil.\r\nVicente Cárdenas Y Japón.', '12:30', '21:00', '20', '0', 'Fantasma', '1636320573', 'USD - $', 'resto_1636636175.jpeg', '0995267551', '-0.15964157448955496', '-78.49122206550076', 'Tacos ', 'tacosmadre@faster.com.ec', 'www.faster.com.ec', 'Quito', 'Av. Edmundo Carvajal 814, Quito 170104, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '11-11-2021 08:09:35'),
(1286, 'Cevicheria Al Paso', '1724715220', 10, 'Restaurante', 'Ave Eloy Alfaro 11, Salinas', '08:00', '18:00', '20', '0', 'Pendiente ', '1636833955', 'USD - $', 'resto_1637510215.jpeg', '0959756592', '-2.20107362938878', '-80.97858200650646', 'Cevicheria ', 'cevichealpaso@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Ave Eloy Alfaro 11, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '21-11-2021 10:56:55'),
(1288, 'Pizza Burger ', '1720718186', 1, 'Restaurante', 'Zona Rosa', '16:00', '23:59', '20', '15', 'Pendiente', '1637448068', 'USD - $', 'resto_1638624686.jpeg', '0979738514', '-0.23691655345868026', '-79.16873733382656', 'Pizzas Y Hamburguesas ', 'pizzaburger@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. 5 111, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '10-12-2021 23:30:54'),
(1290, 'Inka Burger', '1792925150001', 4, 'Restaurante', 'La Florida.  Tte. Homero Salas Y Tte. Carlos Cabezas', '12:00', '22:00', '20', '0', 'David Alejandro Maldonado Padilla', '1637953065', 'USD - $', 'resto_1637956742.jpg', '0987943423', '-0.146415984314934', '-78.49569163154794', 'Comida Rápida.', 'dmaldonado@inka.com.ec', 'https://inka.com.ec/', 'Quito', 'Tte. Homero Salas 606, Quito 170104, Ecuador', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '28-11-2021 11:07:59'),
(1292, 'Pernil Sym', '1717406431001', 1, 'Restaurante', 'Av. Abraham Calazacón, Santo Domingo', '08:00', '22:00', '20', '15', 'Sonia Yauqui', '1638020986', 'USD - $', 'resto_1638624651.jpeg', '0989854444', '-0.2559077586691918', '-79.16116881053878', 'Sanduches De Pernil', 'pernilsym@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prvq+jgg, Av. Abraham Calazacón, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '27-08-2022 11:14:19'),
(1294, 'Licorería Locos X Beber ', '1724954456', 1, 'Licorería', 'Av. Lorena, Frente A Santo Manaba ', '07:00', '23:59', '20', '10', 'Intriago Loor Coraima', '1638044959', 'USD - $', 'resto_1638624725.jpeg', '0990744670', '-0.26092679123720514', '-79.13903388064338', 'Licorería ', 'ronny.suarez2016@uteq.edu.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Pvq6+j9 Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 15, '05-12-2021 23:42:36'),
(1296, 'Verde - Café', '1720100690', 10, 'Restaurante', 'Calle Eleodora Peña, Y, Salinas', '07:00', '16:30', '20', '0', 'Pendiente ', '1638052670', 'USD - $', 'resto_1638117687.jpg', '0995122516', '-2.203563561046177', '-80.9770273311062', 'Cevichería ', 'verdecafe@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'C. 15 9, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '28-11-2021 11:41:27'),
(1298, 'Heladería Encholados ', '2450625393001', 9, 'Restaurante', 'Av. 105 Manta', '13:00', '21:00', '20', '0', 'Pendiente ', '1638127073', 'USD - $', 'resto_1638741303.jpg', '0967097902', '-0.9535158747921103', '-80.7106232909484', 'Heladería ', 'echoladosmanta@faster.com.ec', 'www.faster.com.ec', 'Manta', 'Unnamed Road, Manta 130203, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '05-12-2021 16:55:03'),
(1300, 'Cholados Y Algo Mas ', '1715940076', 1, 'Restaurante', ' Calle Rio Chimbo Y Av Quito', '11:00', '22:00', '10', '10', 'Xavier Gonzalo Benalcazar Kabiedes', '1638628484', 'USD - $', 'resto_1639063766.jpeg', '0990695883', '-0.25194047522177265', '-79.1642929134889', 'Heladería ', 'xavi_bk@yahoo.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Ah. Río Quito Y, Prxp+76h, C. Rio Chimbo, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '16-07-2022 01:13:58'),
(1302, 'La Cava Río Lelia', '1723866149', 1, 'Licorería', 'Av. Río Lelia, Santo Domingo 230103', '15:00', '03:00', '1', '5', 'Juan Aguirre', '1638742932', 'USD - $', 'resto_1638742932.png', '0992474649', '-0.24949935311425256', '-79.15239027570917', 'Licorería', 'lacavariolelia@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2x+53w, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '10-09-2022 01:20:34'),
(1304, 'La Cava Chone', '1723866149', 1, 'Licorería', 'Av. Chone, Y, Santo Domingo 230203', '17:00', '02:00', '1', '5', 'Juan Aguirre', '1638743302', 'USD - $', 'resto_1638743302.png', '0981873963', '-0.25512389087943455', '-79.182888333313', 'Licoreria', 'lacavaavchone@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prv8+wwq, Santo Domingo, Ecuador', 0, 'Moto', 1, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '02-10-2022 18:50:43'),
(1306, 'Pizza House ', '0917514804', 1, 'Restaurante', 'C. Tulcán 1268-1330, Santo Domingo', '10:00', '23:59', '20', '0', 'Murati Bowen Rolf Antonio ', '1639240864', 'USD - $', 'resto_1639834331.jpeg', '0994675160', '-0.2517711624134752', '-79.16899180840684', 'Pizzeria', 'muratirolf04@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Tulcán 1308, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-05-2022 12:17:59'),
(1308, 'Sabores De Mi Tierra 100 Tsáchila', '1724445034', 1, 'Restaurante', 'De Las Madreselva N47-45 Y Av. El Inca', '16:00', '21:00', '15', '15', 'Silvana Elizabeth Raffo Quiñonez', '1639253936', 'USD - $', 'resto_1662067618.jpeg', '0984700455', '-0.15361802610464076', '-78.47177940290406', 'Comida Rapida', 'nenitasinti@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'De Las Madreselvas N47-45 Y, Av. El Inca, Quito 170138, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '10-09-2022 15:33:13'),
(1310, 'D Lunitas ', '1720100690', 1, 'Supermercado', 'Av. Abraham Calazacón, Santo Domingo', '08:30', '18:30', '20', '0', 'Elsa Luna', '1639254353', 'USD - $', 'resto_1639834283.jpeg', '0994765696', '-0.2578033908419011', '-79.1815740508957', 'Distribuidora  ', 'dlunitas@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prr9+v9r, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '18-12-2021 08:31:23'),
(1312, 'Los Chamos Fast Food ', '2390059127001', 1, 'Restaurante', 'Av. Lorena Y Abraham Calazacòn Santo Domingo, Ecuador', '17:00', '23:30', '20', '15', 'Campos Nuñez Eloy Enrique ', '1639835316', 'USD - $', 'resto_1642254513.jpeg', '0963121849', '-0.25633489618717437', '-79.16053849142028', 'Restaurante De Comida Rápida ', 'loschamosfast@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. La Lorena 210, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 17, '07-03-2022 17:41:13'),
(1314, 'Amazonas Yasuni', '1720718186', 4, 'Restaurante', 'Amazonas Y Jorge Washington Entrada Del Centro Comercial Espiral', '09:00', '22:00', '20', '0', 'Pendiente', '1639921896', 'USD - $', 'resto_1639921896.jpg', '0992002620', '-0.20638016795532074', '-78.49596991073324', 'Comida 0992002620\r\n', 'amazonas.yasuni2017@gmail.com', 'www.faster.com.ec', 'Quito', 'Jorge Washington 639, Quito 170143, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '19-12-2021 08:52:04'),
(1316, 'Wilson Pizza', '1709365710', 1, 'Restaurante', 'Avenida Clemencia De Mora Y Avenida Abraham Calazacón', '15:00', '23:00', '20', '15', 'Mendoza Wilson Ramon', '1640551200', 'USD - $', 'resto_1642254755.jpeg', '0999394675', '-0.23994071793776858', '-79.17555517386629', 'Pizzeria', 'wilson343526@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr6f+2q, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 22, '22-01-2022 18:00:40'),
(1318, 'El Libanes ', '0959587254001', 1, 'Restaurante', 'Calle Venezuela Al Lado De Santas Alitas', '17:00', '23:00', '10', '15', 'Raja Nasr', '1641585526', 'USD - $', 'resto_1642254647.jpeg', '0996000921', '-0.25073449859677815', '-79.15223068427278', 'Comida Rapida  ', 'ellibanes@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Río Lelia 138142, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 21, '28-02-2022 17:32:48'),
(1320, 'Go Whisky ', '2350529752', 1, 'Licorería', 'Av. Abraham Calazacón 40, Santo Domingo', '07:00', '23:59', '20', '0', 'Go Whisky ', '1641677944', 'USD - $', 'resto_1641678476.jpg', '0983703549', '-0.2655756809406944', '-79.17667834889124', 'Licorería  ', 'gowisky@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Abraham Calazacón 40, Santo Domingo, Ecuador', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '08-01-2022 16:47:56'),
(1322, ' Ford Wings', '2300668130001', 1, 'Restaurante', 'Rosales 1era Etapa Calle Venezuela Junto Al Hipermarket', '15:30', '23:30', '20', '15', 'Darwin Alexander Montaño Rojas', '1641743377', 'USD - $', 'resto_1642254724.jpeg', '0993302082', '-0.24921504165124395', '-79.18268415015174', 'Comida Rapida ', 'royerk.95@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Venezuela 137, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '07-09-2022 23:43:27'),
(1324, 'Ni Fu Ni Fa', '2300258197', 1, 'Restaurante', 'Av. Chone Y Av. Bomboli, Casa 3 Pisos Celeste', '11:30', '22:00', '20', '15', 'Luquez Romero Arianna Estefania ', '1642266157', 'USD - $', 'resto_1642792118.jpeg', '0995868280', '-0.2545488980092622', '-79.19740411322547', 'Dumplings & Wantanes   ', 'nifunifa.sd@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prw2+7w9, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '13-08-2022 01:17:34'),
(1326, 'El Taquerito', '1725640963', 10, 'Restaurante', 'La Libertad, Calle 21', '16:30', '23:59', '20', '15', 'Pendiente', '1642366527', 'USD - $', 'resto_1643334945.jpeg', '0963828832', '-2.23058400920265', '-80.90771100353439', 'Comida Rapida ', 'eltaquerito@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Av. 17 Calle 21 Esquina, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '10-09-2022 15:32:53'),
(1328, 'Brazzuca Asadero ', '1721643631', 1, 'Restaurante', '2 De Mayo, Calle 24 De Septiembre Y Patricia Romero. Diagonal A Tia.', '11:00', '21:00', '20', '15', 'Xavier Granda Paz', '1642797984', 'USD - $', 'resto_1642882344.jpg', '0990570304', '-0.2335215760080477', '-79.18156466316415', 'Asadero', 'maryjif1709@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', '24 De Septiembre &, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 23, '23-01-2022 16:31:51'),
(1330, 'Prieta Manaba ', '1722272679001', 1, 'Restaurante', 'Rio Yanuncay Entre Río Tarquiy  Rio Cochambi', '08:00', '16:00', '20', '15', 'Zambrano Del Valle Kelly Nallely', '1642799413', 'USD - $', 'resto_1643809047.jpeg', '0979060557', '-0.2469848057644509', '-79.16419769506885', 'Comida Manaba ', 'prietamanabaexpress@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3p+68v, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 10, '07-06-2022 09:02:52'),
(1332, 'Chicho La Libertad', '1721387213', 10, 'Restaurante', 'Av. Carlos Espinoza Libertad', '07:00', '15:00', '20', '0', 'Pendiente ', '1642888769', 'USD - $', 'resto_1643334910.jpeg', '0962908295', '-2.2272290942453172', '-80.91928339432909', 'Bolones ', 'chicho@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q3fj+47 La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '27-01-2022 20:55:10'),
(1334, 'Parrillada De Lupe', '0940615875001', 1, 'Restaurante', 'Pqgp+f67, Santo Domingo', '16:00', '23:59', '15', '0', 'Pendiente ', '1642977236', 'USD - $', 'resto_1642978103.jpg', '0978973719', '-0.2738495335197142', '-79.2144592745228', 'Parrilla & Grill ', 'parrilladadelupe@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Pqgp+f67, Santo Domingo, Ecuador', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '25-01-2022 16:39:43'),
(1336, 'Supermercado La Economía ', '2390013879001', 1, 'Supermercado', 'Dirección Galápagos Y Cuenca 450', '08:00', '19:30', '20', '3', 'Seguro Pino Sergio Alejandro', '1643249928', 'USD - $', 'resto_1643334973.jpeg', '0997284916', '-0.2557139709993546', '-79.17399949263765', 'Supermercado ', 'amecucol@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Galapagos 450, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '27-01-2022 20:56:13'),
(1338, 'Liquor Box ', '1718501339001', 1, 'Licorería', 'Av. Abraham Calazacón, Santo Domingo 230101', '13:00', '23:59', '15', '5', 'Macas Vera Nathaly Carolina', '1643403588', 'USD - $', 'resto_1643403588.jpg', '0980352290', '-0.2615068129086429', '-79.17920431923105', 'Licores ', 'liquor4@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Urb. Las Palmeras, Av. Abraham Calazacón, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '19-06-2022 20:30:11'),
(1340, 'Delicias De Meche ', '1724004583', 10, 'Restaurante', 'Avenida San José, Salinas', '07:30', '17:00', '20', '0', 'Pendiente', '1643463275', 'USD - $', 'resto_1643464815.jpeg', '0978614612', '-2.211434692729477', '-80.9522189093752', 'Desayunos ', 'deliciasmeche@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q2qx+c4 Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '29-01-2022 09:00:15'),
(1342, 'Icaro Pizza', '1724004583', 10, 'Restaurante', 'Ícaro Pizzería Calle Comercio, Sucre Y Diez De Agosto', '12:00', '23:30', '15', '0', 'Pendiente', '1643489236', 'USD - $', 'resto_1643489236.jpg', '0988990383', '-2.2258716792630335', '-80.85757090546713', 'Pizzeria  ', 'icaropizza@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Ícaro Pizzería Calle Comercio, Sucre Y Diez De Agosto, Santa Elena, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1344, 'Leños Pizza', '2390013879001', 10, 'Restaurante', 'Unnamed Road, Salinas ', '13:30', '23:00', '20', '0', 'Pendiente', '1645155357', 'USD - $', 'resto_1645299774.jpeg', '0990839629', '-2.20528091460462', '-80.95811842810346', 'Pizzaria', 'leñospizza@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Unnamed Road, Salinas, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'NO', 'NO', 'YES', 'YES', 'YES', 0, 14, '19-02-2022 14:42:54'),
(1346, 'El Buen Sabor 3', '1314434042001', 1, 'Restaurante', 'Av Abraham Calazacon. Sector Zona Rosa Frente Al Hotel Golden Vista', '15:30', '23:59', '15', '15', 'Mejia Loor Wellington Antonio', '1645666788', 'USD - $', 'resto_1645753224.jpeg', '0993949260', '-0.23930705159978544', '-79.16394657324985', 'Comida Rapida', 'elbuensabor3@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', '28026, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '31-08-2022 08:16:54'),
(1348, 'Barón De Las Mollejas Santo Domingo', '2300667090001', 1, 'Restaurante', 'Calle Venezuela Y Enrique Tábara', '15:00', '23:00', '20', '15', 'Marcelo Moreno ', '1645669171', 'USD - $', 'resto_1645669171.jpeg', '0939298705', '-0.24932903445553706', '-79.18797782491876', 'Mollejas Asadas', 'marcmorn11@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Venezuela Y Calle Manuel Samaniego Una Cuadra Antes De La Subida Al Bombolí, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '13-08-2022 01:19:30'),
(1350, 'Kfc Shopping ', '2390013879001', 1, 'Restaurante', 'Paseo Shopping Santo Domingo', '10:00', '21:45', '20', '0', 'Pendiente', '1646359967', 'USD - $', 'resto_1646359967.jpg', '0969764774', '-0.24848146440466753', '-79.16118926238249', 'Comida Rápida ', 'kfcshoppingsd@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr2q+gp4, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', '+ 0.10', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 1, '20-08-2022 19:18:31'),
(1352, 'Fritadas San Blas', '1724612245001', 4, 'Restaurante', 'Centro Comercial Quitus, Patio De Comidas, Local 218 Pb', '11:00', '18:00', '20', '0', 'Molina Zambrano Marcelo Alejandro', '1646945837', 'USD - $', 'resto_1647029217.jpeg', '0984999870', '-0.20334929114331762', '-78.49975920151903', 'Fritadas', 'maralemol90@hotmail.com', 'www.faster.com.ec', 'Quito', 'Universidad Central, Centro Comercial Quitus, Local 440, Piso 2, Pasillo 8, Calle Versalles Y, San Gregorio, Quito 170129, Ecuador', 0, 'Moto ', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '18-08-2022 14:27:16'),
(1354, 'Señora Pizza Gran Aki', '1723866149', 1, 'Restaurante', 'Dentro Del Gran Aki De La Via Esmeraldas', '10:00', '20:30', '20', '10', 'Pendiente', '1647440290', 'USD - $', 'resto_1647440290.jpg', '0981008935', '-0.2456251097662733', '-79.17375582505652', 'Pizzería ', 'senorapizzaaki@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3g+qfg, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '23-03-2022 07:29:56'),
(1356, 'Nuwa', '1724554918001', 1, 'Restaurante', 'Avenida La Lorena Y Atacames Esquina', '14:00', '22:00', '15', '15', 'Tran Benalcazar Stefany Mylin', '1647633914', 'USD - $', 'resto_1647638062.jpeg', '0964043629', '-0.258076973389025', '-79.15183103512956', 'Bar - Cafeteria  ', 'nuwa@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prvx+37m, Av. La Lorena, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '23-07-2022 03:52:53'),
(1358, 'Faster Market Licores', '1723866149', 1, 'Market', 'Calle Arroyo Robelly 359 Y Peralta', '00:00', '23:59', '5', '3', 'Jose Luis Baque Burgos', '1647650564', 'USD - $', 'resto_1648819527.png', '0980008742', '-0.25941806422107117', '-79.16997617911531', 'Licores ', 'marketlicores@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 0, 'Moto ', 1, 1, 'active', '- 0.50', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '23-07-2022 16:18:42'),
(1360, 'Ela Brownie Artesanal', '1723107981001', 1, 'Restaurante', 'Av Río Toachi Y Calle Bambúes, Esquina, Primera Puerta Junto A Bárbaros Bar', '08:00', '21:00', '15', '10', 'Navarrete Forero Santiago', '1648656425', 'USD - $', 'resto_1648658196.jpg', '0996644857', '-0.26122283698383547', '-79.16545464526845', 'Brownie Artesanales ', 'snavarreteforero@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prqm+frq, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '30-07-2022 02:00:11'),
(1362, 'Asadero Galaxis', '2300061856', 1, 'Restaurante', 'Av Abraham Calazacón Y Clemencia De Mora (anillo Vial Sector Terminal Terrestre)', '11:00', '22:00', '5', '0', 'Jasson Delgado Andrade ', '1648853890', 'USD - $', 'resto_1648907050.jpeg', '0980271687', '-0.23908677710400628', '-79.17580461930467', 'Pollo Asado ', 'luisinho_52_10@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr6f+cm8, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '01-07-2022 15:52:42'),
(1364, 'Hannana Sona', '1723866149', 1, 'Lo Que Sea', 'Coop 29 De Diciembre Calle Arroyo Robelly 359 Y Peralta', '00:01', '23:59', '10', '3', 'Jose Luis Baque', '1649377243', 'USD - $', 'resto_1649377243.jpg', '0987462639', '-0.2593563740459092', '-79.16986352633668', 'Venta De Sandalias', 'hannana@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Arroyo Robelli 359, Santo Domingo De Los Tsáchilas, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '07-04-2022 19:26:38'),
(1366, 'Asadero Galaxis  Santa Martha ', '2300061856', 1, 'Restaurante', 'Av Jacinto Cortéz Jhayya 1090, Santo Domingo', '11:00', '22:00', '15', '15', 'Jasson Delgado Andrade ', '1649864635', 'USD - $', 'resto_1649864635.jpeg', '0980271687', '-0.26751020325934927', '-79.18282664250566', 'Pollo Asado ', 'galaxi@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av Jacinto Cortéz Jhayya 1090, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '23-07-2022 03:53:50'),
(1368, 'La Mia Alitas', '1715441471', 1, 'Restaurante', 'Ernesto Pinto Y Calle F', '14:00', '23:30', '20', '15', 'César Bastidas', '1651029119', 'USD - $', 'resto_1651092868.jpeg', '0939814255', '-0.2526187322515529', '-79.20939928721617', 'Alitas Con Varios Sabores De Salsas', 'cbastidas88@outlook.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Pqwr+m63, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '30-07-2022 02:00:40'),
(1370, 'Faster Market Gye', '1722231477001', 6, 'Market', 'Florida Norte', '06:00', '23:59', '10', '0', 'Erika Villota Soliz', '1651786923', 'USD - $', 'resto_1651786923.png', '0989222177', '-2.122881921210057', '-79.9376673145218', 'Productos De Consumo', 'vilbaqpao@hotmail.es', 'www.faster.com.ec', 'Guayaquil', 'V3g6+xxr, Guayaquil 090602, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '05-05-2022 16:42:43'),
(1372, 'El Cafe Del Tanque ', '0918798935', 10, 'Restaurante', 'Parque Los Hambrientos Patio Comidas Abdon Calderon Local 3 ', '07:30', '12:30', '15', '10', 'Jorge Luis Machuca Galindo ', '1652301139', 'USD - $', 'resto_1652396820.jpeg', '0997223008', '-2.2285035205999564', '-80.90794435571863', 'Desayunos ', 'carlosmachuca33@gmail.com', 'www.faster.com.ec', 'Santa Elena', 'Q3cr+hrv, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-08-2022 12:29:31'),
(1374, 'Del Tanque Ribs ', '0918798935', 10, 'Restaurante', 'Patio Comidas Abdon Calderon Local #3 Parque Los Hambrientos ', '18:00', '22:30', '15', '10', 'Jorge Luis Machuca Galindo ', '1652303542', 'USD - $', 'resto_1652396569.jpeg', '0997223008', '-2.2285082109157406', '-80.90794502627088', 'Asados ', 'tanqueribs@faster.com.ec', 'www.faster.com.ec', 'Santa Elena', 'Q3cr+hrv, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 0, 5, '14-08-2022 12:29:59'),
(1376, 'Delicias Express', '1759714379', 1, 'Restaurante', 'Av Venezuela ', '17:00', '23:59', '15', '15', 'Romulo Rene  Paez ', '1652308622', 'USD - $', 'resto_1652384605.jpeg', '0963666437', '-0.24931562353743883', '-79.18055347036554', 'Platos A La Carta Y Almuerzos ', 'deliciasexpress1993@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'C. Obispo P. Schumacher 735y, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '31-08-2022 12:15:44'),
(1378, 'Choclo Loco', '1722840293', 1, 'Restaurante', 'Calle Pedro Schumacher Y Santa Rosa A 100 Metro Del Colegio Neuman', '16:00', '22:00', '15', '0', 'Bayron Barberan', '1652392634', 'USD - $', 'resto_1652395653.jpeg', '0967570025', '-0.25026685130035087', '-79.18022494371124', 'Asados', 'chocloloco@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Av. Santa Rosa Y Calle Shumager, Santo Domingo De Los Tsachilas Santo Domingo De Los Tsachilas, Ecuador, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '19-07-2022 16:17:12'),
(1380, 'Shawarma Express D Javi', '2350529752001', 1, 'Restaurante', 'Av. Abraham Calazacón; Zona Rosa ', '15:00', '23:00', '15', '0', 'Miguel Zevallos', '1652734920', 'USD - $', 'resto_1652991411.png', '0980222236', '-0.2393419200127942', '-79.16559344958499', 'Comida Rapida; Hamburguesas, Shawarma, Alitas ', 'shawarmaexpress@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr6m+6qm, Av. Abraham Calazacón, Santo Domingo, Ecuador', 1, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 10, '19-07-2022 09:46:52'),
(1382, 'Noyo Heladeria Chorrera ', '1802758662001', 1, 'Restaurante', 'Av Quevedo Sector Chorrera ', '10:00', '21:30', '15', '15', 'Williama Castro', '1652972005', 'USD - $', 'resto_1652985580.jpeg', '0939985898', '-0.25878641045684636', '-79.18136953245832', 'Helados ', 'noyo@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prr9+ffc, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '06-08-2022 01:15:23'),
(1384, 'Noyo Heladeria  Tsachila', '1802758662001', 1, 'Restaurante', ' Tsachila Y Machala Frente A La Notaria Segunda ', '10:00', '20:00', '15', '15', 'Williama Castro', '1652987643', 'USD - $', 'resto_1652987643.jpeg', '0982664141', '-0.2532242350371487', '-79.16838428806497', 'Helados', 'noyotsachila@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prwj+mmr, Av. De Los Tsáchilas, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '01-09-2022 13:54:56'),
(1386, 'La Duquesa', '0927667121001', 10, 'Supermercado', 'La Libertad. Cdla General Enríquez Gallo. Calle 42 Entre Av 13 Y 14', '08:00', '18:30', '15', '15', 'Espinoza Ortiz Grace Elizabeth', '1654550559', 'USD - $', 'resto_1655997051.jpeg', '0993073135', '-2.2311307651395422', '-80.89122748803331', 'Charcutería Premium Gourmet', 'laduquesaec@hotmail.com', 'https://laduquesa-ecu.ola.click/products', 'Santa Elena', 'Calle 42 Entre Avenidas 13 Y 14, La Libertad, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '25-06-2022 17:26:44'),
(1388, 'La Casa Del Morocho', '2300264757', 1, 'Restaurante', 'Av. Río Yamboya Y Cayena A 1 Cuadra Del Che Luis', '15:00', '21:00', '20', '15', 'Luis Manobanda', '1656194531', 'USD - $', 'resto_1661549865.jpeg', '0963367002', '-0.24665154438654993', '-79.15819792877868', 'Morocho', 'lacasadelmorocho@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr3r+8mp, Av. Yamboya, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '06-09-2022 10:27:17'),
(1390, 'Chifa Kuan', '0801330614', 1, 'Restaurante', 'Av.  Río Toachi 709, Santo Domingo, Ecuador', '11:00', '21:45', '15', '0', 'Carmen Llumipanta', '1656975735', 'USD - $', 'resto_1656975735.jpg', '979082800', '-0.2638087946069101', '-79.1654003305359', 'Chifa Kuan', 'chifa.k20@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prpm+frh, Santo Domingo, Ecuador', NULL, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, NULL, NULL),
(1392, 'Fesfy', '1720050101001', 1, 'Restaurante', 'Redondel De La Tri De La Santa Martha A 200m Por La Ex Fábrica De Ladrillos', '14:00', '21:00', '20', '15', 'Manuel Alejandro Cuenca Bermeo', '1657206723', 'USD - $', 'resto_1657225815.jpeg', '0996493990', '-0.26572621830359605', '-79.1766025764866', 'Comida Rápida A Base De Verde', 'mashr4@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prmf+p8v, Av. Abraham Calazacón, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 23, '28-07-2022 20:45:21'),
(1394, 'Rey Alitas ', '0503797979', 1, 'Restaurante', 'Av. Lorena Y Los Jivaros, Al Lado De Polon Kafe. Frente A La Unidad Educativa Emilio Lorenzo', '16:00', '22:30', '20', '15', 'Johana Elizabeth Ortega Alvarado', '1658433525', 'USD - $', 'resto_1658531062.jpeg', '0986937522', '-0.2580038839346055', '-79.1491716248913', 'Alitas, Hamburguesas, Hot Dogs\r\n', 'johisortega44@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Pvr2+q8w, Av. La Lorena, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 14, '19-08-2022 09:18:40'),
(1396, 'Premium Coffe ', '1719615831', 1, 'Restaurante', 'Urb. Las Palmeras Calle Juan Bautista Aguirre Y Cristóbal Colon. A Una Cuadra De Los Ceviches De Wacho Margen Izquierdo', '07:00', '20:00', '15', '15', 'Azucena Margarita Palacios Ureta', '1658443206', 'USD - $', 'resto_1658522863.jpeg', '0988088848', '-0.2582372337509071', '-79.17468613814546', 'Desayunos', 'azucena1984palacios@gmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prrg+m3c, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '26-08-2022 14:56:47'),
(1398, 'Granilate ', '1718963943', 1, 'Restaurante', 'Los Rosales 2da Etapa Entre Abraham Calazacon Y Joaquín Pinto. Frente Al Colegio Alfredo Pareja Diezcanseco', '12:00', '20:30', '20', '15', 'Fausto Javier Chicaiza Ramos', '1660258099', 'USD - $', 'resto_1660313443.jpeg', '0963280380', '-0.2478638915722691', '-79.18387002181245', 'Heladería ', 'fausto.j.ch.r@hotmail.com', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Qr28+rc, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'NO', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 10, '01-09-2022 14:53:54'),
(1400, 'Las Alitas Del Buen Sabor', '2450320078', 10, 'Restaurante', 'Santa Elena Barrio Narcisa De Jesus Calle Guillermo Ordóñez', '15:00', '22:00', '20', '15', 'Erika Roxana Tómala Tómala', '1661639187', 'USD - $', 'resto_1662067641.jpeg', '0982413803', '-2.223227575942107', '-80.85094070862964', 'Alitas', 'roxantom2428@gmail.com', 'www.faster.com.ec', 'Santa Elena', 'Q4gx+hm3, Santa Elena, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 0, 8, '10-09-2022 15:33:28'),
(1402, 'Mostacho', '1750655514', 1, 'Restaurante', 'Tsafiqui Y Abraham Calazacon Diagonal A Otro Rollo', '15:00', '23:59', '20', '15', 'Tatiana Lilibeth García Duran', '1662237690', 'USD - $', 'resto_1662591303.jpeg', '0992508669', '-0.2587193559152593', '-79.16131029706432', 'Comida Rápida', 'mostacho@faster.com.ec', 'www.faster.com.ec', 'Santo Domingo de los Colorados', 'Prrq+gf9, Av. Abraham Calazacón, Santo Domingo, Ecuador', 0, 'Moto', 0, 1, 'active', 'Gratis', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'NO', 0, 8, '08-09-2022 16:12:32');

-- --------------------------------------------------------

--
-- Table structure for table `fooddelivery_res_owner`
--

CREATE TABLE `fooddelivery_res_owner` (
  `id` int(11) NOT NULL,
  `username` varchar(30) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `phone` varchar(225) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `res_id` int(11) DEFAULT 0,
  `role` varchar(50) DEFAULT NULL,
  `timestamp` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `fooddelivery_res_owner`
--

INSERT INTO `fooddelivery_res_owner` (`id`, `username`, `password`, `phone`, `email`, `res_id`, `role`, `timestamp`, `status`) VALUES
(14, 'Chifa Asia', '0993378231', '0993378231', 'leleychen28@gmail.com', 15, '2', '1558154534', 'active'),
(16, 'Señora Pizza', '123', '0981008935', 'senorapizza@faster.com.ec', 17, '2', '1558154895', 'active'),
(19, 'A la Mexicana', '123', '0985870686', 'mexicana@faster.com.ec', 20, '2', '1558359920', 'active'),
(20, 'Santo Manaba', '123', '0984868224', 'santomanaba@faster.com.ec', 21, '2', '1558459713', 'active'),
(22, 'Alistas del Cadillac', '123', '0998109111', 'cadillac@faster.com.ec', 23, '2', '1558974060', 'active'),
(24, 'Krosty comidas rápidas', '123', '0985708789', 'krosty@faster.com.ec', 25, '2', '1558992045', 'active'),
(25, 'Pizza Focaccia', '123', '0997639482', 'focaccia@faster.com.ec', 26, '2', '1559138399', 'active'),
(26, 'Restaurante Quito', '123', '0989652128', 'restaurantequito@gmail.com', 27, '2', '1559168671', 'active'),
(29, 'La Plaza chifa china', '123', '0985372611', 'qinghao1979@gmail.com', 29, '2', '1560386979', 'active'),
(30, 'Don Pollo', '123', '0969990890', 'donpollo@faster.com.ec', 30, '2', '1560394929', 'active'),
(32, 'Chefarina', '123', '0981956413', 'chfarina@faster.com.ec', 32, '2', '1560476070', 'active'),
(33, 'Camarón reventado la revancha', '123', '0989283979', 'camaron@faster.com.ec', 33, '2', '1560476070', 'active'),
(35, 'Ceviches de wacho', '123', '0994916372', 'wacho@faster.com.ec', 35, '2', '1560533877', 'active'),
(36, 'Panadería D\' Nelly', '123', '023700705', 'valeri_mora@hotmail.com', 36, '2', '1560533877', 'active'),
(37, 'Pizzería los Tios', '123', '022751200', 'tios@faster.com.ec', 37, '2', '1560551802', 'active'),
(39, 'Nena\'s Café', '123', '0939068778', 'nenas@faster.com.ec', 39, '2', '1560552562', 'active'),
(40, 'La Cueva del Oso', 'kamilongo1988', '0983958236', 'alvarocalero26@gmail.com', 40, '2', '1561175532', 'active'),
(44, 'Asadero Esquina de Ales', '123', '0994465112', 'ales@faster.com.ec', 44, '2', '1565765020', 'active'),
(46, 'Ela - Brownie Artesanal', '123', '0996644857', 'ela@faster.com.ec', 46, '2', '1565812658', 'active'),
(48, 'D\' Kaviedes', '123', '0990695883', 'kaviedes@faster.com.ec', 48, '2', '1565812658', 'active'),
(49, 'KFC', '123', '0969764774', 'kfc@faster.com.ec', 49, '2', '1571379183', 'active'),
(50, 'MAYFLOWER', '123', '0963089525', 'mayflower@gmail.com', 50, '2', '1571387061', 'active'),
(51, 'Mexican Food', '123', '0996517218', 'mexican@faster.com.ec', 51, '2', '1572757408', 'active'),
(52, 'El Chuzazo', '123', '0999128667', 'chuzazo@faster.com.ec', 52, '2', '1572759153', 'active'),
(53, 'Menestras del Negro', '123', '0969764774', 'negro@faster.com.ec', 53, '2', '1572761209', 'active'),
(54, 'prueba', 'Test@123', '0980145405', 'ruben_pc3@hotmail.com', 54, '2', '1578675190', 'active'),
(58, 'The Grill Yard', 'Yard2020', '0978944838', 'nod-dan@hotmil.com', 56, '2', '1579122263', 'active'),
(61, 'Shawarma Ralla', 'Ralla@123', '0995906302', 'abusaidah@hotmail.com', 58, '2', '1579129960', 'active'),
(67, 'Parrillada del Cubano', 'cubano', '0994958422', 'cubano@faster.com.ec', 62, '2', '1579216291', 'active'),
(68, 'Los Popeyitos', 'popeyitos', '0997907510', 'emilaaz82@gmail.com', 0, '2', '1579296440', 'active'),
(73, 'American corner', '123', '0980015587', 'corner@faster.com.ec', 68, '2', '1579297440', 'active'),
(75, 'Mr Pincho', '123', '0994090233', 'mrpincho@faster.com.ec', 70, '2', '1579301029', 'active'),
(77, 'Stav Pollo Horenado', '123', '0996483903', 'stav@faster.com.ec', 74, '2', '1581369584', 'active'),
(78, 'Santo Moro', '123', '0963666114', 'santomoro@faster.com.ec', 76, '2', '1581442354', 'active'),
(79, 'Sweet Land', '123', '0939785765', 'sweetland@faster.com.ec', 78, '2', '1581523962', 'active'),
(80, 'kiwi Limón', '123', '0963190023', 'kiwilimon@faster.com.ec', 80, '2', '1581549649', 'active'),
(81, 'GelatoMix', '123', '0994733536', 'gelatomix_sd@hotmail.com', 82, '2', '1581560141', 'active'),
(82, 'Sra Empanada', '123', '0998101170', 'bautistacarmen0819@gmail.com', 84, '2', '1581600124', 'active'),
(84, 'Gus', '123', '022751770', 'gus@faster.com.ec', 88, '2', '1582049724', 'active'),
(85, 'La Casa del Hornado', '123', '0981147881', 'hornado@faster.com.ec', 90, '2', '1582051618', 'active'),
(86, 'Tio Jr Wings', '123', '0960133829', 'tiojrwings@faster.com.ec', 92, '2', '1582151992', 'active'),
(87, '100 % Chonero', '123', '0988484731', 'chonero@faster.com.ec', 94, '2', '1582326362', 'active'),
(88, 'Boli Gourmet', '123', '0993739616', 'boligourmet@faster.com.ec', 96, '2', '1582328423', 'active'),
(89, 'Esquina de ales', '123', '0988527380', 'aleschone@faster.com.ec', 98, '2', '1582330988', 'active'),
(90, 'Mooi', '123', '0969764774', 'mooi@faster.com.ec', 100, '2', '1582393975', 'active'),
(91, 'Embobate', '123', '0985941785', 'embobate@faster.com.ec', 102, '2', '1582410543', 'active'),
(92, 'Auto Pollo', '123', '0979948711', 'autopollo@faster.com.ec', 104, '2', '1582911345', 'active'),
(93, 'Encebollado San Andres ', '123', '0969764774', 'sanandres@faster.com.ec', 106, '2', '1583253460', 'active'),
(94, 'Marisqueria los popeyitos ', '123', '0980967332', 'popeyitos@faster.com.ec', 108, '2', '1583257297', 'active'),
(95, 'Prueba Quito', '123', '0988888888', 'quito@gmail.com', 110, '2', '1583329654', 'active'),
(98, 'Max Pollo', '123', '0981077359', 'maxpollo@faster.com.ec', 112, '2', '1583542567', 'active'),
(99, 'Pizza en Cono', '123', '0999814446', 'pizzaencono@faster.com.ec', 114, '2', '1583545672', 'active'),
(100, 'SR BOLÓN', '123', '0980716299', 'srbolon@faster.com.ec', 116, '2', '1583949994', 'active'),
(105, 'Pide Lo Que Sea! Sto Dgo', '123', '0985494782', 'loqueseastodgo@faster.com.ec', 120, '2', '1585623333', 'active'),
(107, 'Supermercado Proint', '123', '0969764774', 'proint@faster.com.ec', 124, '2', '1585881089', 'active'),
(108, 'Agachaditos', '123', '0994047707', 'agachaditos@faster.com.ec', 126, '2', '1585933596', 'active'),
(109, 'Mas Que Alitas', '123', '0999696114', 'masquealitas@faster.com.ec', 128, '2', '1585935607', 'active'),
(110, 'Ferreteria Carlin', 'carlin123', '0985523648', 'ferreteriacarlin@hotmail.com', 130, '2', '1585945629', 'active'),
(111, 'Pinchos De La Pio', '123', '0982733560', 'pinchosdelapio@faster.com.ec', 132, '2', '1585967200', 'active'),
(112, 'Doña Bella', '123', '0963921064', 'donabella@faster.com.ec', 134, '2', '1586047924', 'active'),
(113, 'Pollo Colorado', '123', '0981185053', 'pollocolorado@faster.com.ec', 136, '2', '1586054774', 'active'),
(116, 'Panadería Porta Venecia', '123', '0982807974', 'portavenecia@faster.com.ec', 138, '2', '1586065067', 'active'),
(117, 'La Cevicheria', '123', '0969764774', 'lacevicheria@faster.com.ec', 140, '2', '1586194764', 'active'),
(118, 'Madeli S. A.', '123', '0969764774', 'madeli@faster.com.ec', 142, '2', '1586254144', 'active'),
(120, 'Santas Alitas', '12345', '0989821823', 'santasalitas@faster.com.ec', 146, '2', '1586354874', 'active'),
(121, 'Marisquería Los Delfines ', '123', '0997610235', 'delfines@faster.com.ec', 148, '2', '1586393406', 'active'),
(122, 'Las Hamburguesas & Papas D` Ba', '123', '0981362680', 'bambam@faster.com.ec', 150, '2', '1586439780', 'active'),
(123, 'Taco & Nacho', '123', '099 938 4729', 'nacho@faster.com.ec', 152, '2', '1586475536', 'active'),
(124, 'Pizzería El Hornero', '123', '096 976 4774', 'hornero@faster.com.ec', 154, '2', '1586486163', 'active'),
(125, 'Marisqueria Albacora', '123', '0992121613', 'albacora@faster.com.ec', 156, '2', '1586699964', 'active'),
(126, 'Bariloche La Parrillada D`mari', '123', '098 067 4871', 'bariloche@faster.com.ec', 158, '2', '1586814681', 'active'),
(127, 'Ala Carga ', '123', '0987053055', 'alacarga@faster.com.ec', 160, '2', '1586829169', 'active'),
(128, 'Helados Cosecha Gourmet', '123', '0998417857', 'cosecha@faster.com.ec', 162, '2', '1586831751', 'active'),
(129, 'Super Licores', '123', '0997200170', 'superlicores@faster.com.ec', 164, '2', '1586865851', 'active'),
(130, 'Shawarma Dubai', '123', '0989515981', 'dubai@faster.com.ec', 166, '2', '1586950788', 'active'),
(158, 'El Pajaro Rojo', '123', '0992079561', 'pajarorojo@faster.com.ec', 168, '2', '1587138391', 'active'),
(159, 'Cangrejadas Del Guayas ', '123', '0939747147', 'guayas@faster.com.ec', 170, '2', '1587147237', 'active'),
(160, 'Restaurante Laura', '123', '0987506204', 'laura@faster.com.ec', 172, '2', '1587423005', 'active'),
(161, 'Cafetería Gusto Exclusivo', '123', '0991591666', 'costacafe@faster.com.ec', 174, '2', '1587428585', 'active'),
(162, 'Restaurante Costa Norte # 2', '123', '0939910523', 'costanorte2@faster.com.ec', 176, '2', '1587509609', 'active'),
(164, 'Al Costo', '123', '0997888885', 'alcosto@faster.com.ec', 180, '2', '1587527148', 'active'),
(165, 'Supermercados Don Luis', '123', '0969764774', 'donluis@faster.com.ec', 182, '2', '1587619711', 'active'),
(166, 'Moros En La Costa ', '123', '0993950909', 'moros@faster.com.ec', 184, '2', '1587680047', 'active'),
(167, 'Mojitos- Resto- Bar', '123', '0963483518', 'restobar@faster.com.ec', 186, '2', '1587686605', 'active'),
(168, 'Lunettes', '123', '0981116075', 'lunette@faster.com.ec', 188, '2', '1587743204', 'active'),
(169, 'Quinta Campestre', '123', '0978907105', 'quinta@faster.com.ec', 190, '2', '1587744866', 'active'),
(170, 'Chori Dogs', '123', '0987590954', 'choridogs@faster.com.ec', 192, '2', '1587762352', 'active'),
(171, 'Chaoping', '123', '0996438209', 'chaoping@faster.com.ec', 194, '2', '1587932478', 'active'),
(172, 'El Mundo De Las Carnes ', '123', '0958753544', 'mundodelascarnes@faster.com.ec', 196, '2', '1588080552', 'active'),
(173, 'Santo Pollo', '123', '0967575333', 'picho2966@hotmail.com', 198, '2', '1588100521', 'active'),
(174, 'Cheesecake', '123', '0960135727', 'cheesecake@faster.com.ec', 200, '2', '1588113305', 'active'),
(175, 'Cerveza Artesanal Alderete ', '123', '0986880730', 'alderete@faster.com.ec', 202, '2', '1588192706', 'active'),
(176, 'Rustik', '1234', '0960137783', 'rustik@faster.com.ec', 204, '2', '1588200748', 'active'),
(178, 'Happy Landia', '123', '0997749545', 'happylandia@faster.com.ec', 208, '2', '1588286607', 'active'),
(179, 'Siafu', '123', '0993622985', 'siafu@faster.com.ec', 210, '2', '1588349205', 'active'),
(180, 'Bolos Gourmet De Esparta ', '123', '0996017947', 'bolosesparta@faster.com.ec', 212, '2', '1588366244', 'active'),
(181, 'Greenfrost', '123', '0969764774', 'greenfrost@faster.com.ec', 214, '2', '1588440315', 'active'),
(182, 'Guacamole  ', '123', '0987420045', 'guacamole@faster.com.ec', 216, '2', '1588555990', 'active'),
(183, 'La Cueva Del Oso', '123', '0984740828', 'cuevaoso@faster.com.ec', 218, '2', '1588628071', 'active'),
(184, 'Frigorifico De Torres', '123', '0991672871', 'torres@faster.com.ec', 220, '2', '1588642171', 'active'),
(185, 'Grill Fest ', '123', '0984172275', 'grill@faster.com.ec', 222, '2', '1588723938', 'active'),
(186, 'Parrillada Brasero', '123', '0981066110', 'brasero@faster.com.ec', 224, '2', '1588724717', 'active'),
(187, 'Pollo Papa Pura Lisa ', '123', '0999581999', 'puralisa@faster.com.ec', 226, '2', '1588731792', 'active'),
(188, 'Viva Parrilla', '123', '0994830161', 'viva@faster.com.ec', 228, '2', '1588785893', 'active'),
(189, 'Artesano Gourmet', '123', '0996860624', 'artesanogourmet@faster.com.ec', 230, '2', '1588803395', 'active'),
(190, 'Restaurant La Hueca 3', '123', '0994640259', 'hueca3@faster.com.ec', 232, '2', '1588976782', 'active'),
(191, 'La Taberna', '123', '0982035304', 'taberna@faster.com.ec', 234, '2', '1588984163', 'active'),
(192, 'Super Paco', '123', '0986854916', 'superpaco@faster.com.ec', 236, '2', '1589227419', 'active'),
(193, 'Papas D Bronkis', '123', '0939330243', 'bronkis@faster.com.ec', 238, '2', '1589322317', 'active'),
(194, 'Comida Rapida 3 Hermanos', '123', '0980793833', '3hermanos@faster.com.ec', 240, '2', '1589324726', 'active'),
(195, 'La Castellana', '123', '0985494782', 'castellana@faster.com.ec', 242, '2', '1589382386', 'active'),
(196, 'Jeffer S Burger', '123', '0997600539', 'burger@faster.com.ec', 244, '2', '1589392864', 'active'),
(197, 'Shushu Tenka ', '123', '0983388227', 'tenka@faster.com.ec', 246, '2', '1589407995', 'active'),
(198, 'Costa Norte # 5', '123c4', '0994986939', 'costanorte5@faster.com.ec', 248, '2', '1589413197', 'active'),
(199, 'Mega Empanada', '123', '0994879587', 'empanada@faster.com.ec', 250, '2', '1589423512', 'active'),
(200, 'Esquina De Ales Pambilies ', '123', '022763756', 'esquinaales@faster.com.ec', 252, '2', '1589482616', 'active'),
(201, 'Chifa Central ', '123', '0968666688', 'central@faster.com.ec', 254, '2', '1589844134', 'active'),
(202, 'Kiwilimón Av Chone', '123', '0963190016', 'kiwichone@faster.com.ec', 256, '2', '1589847880', 'active'),
(203, 'Rincon Del Cuy ', '123', '0960444567', 'rincondelcuy@faster.com.ec', 258, '2', '1590026523', 'active'),
(204, 'La Casa De Las Ofertas ', '123', '0986380434', 'ofertas@faster.com.ec', 260, '2', '1590029172', 'active'),
(205, 'Panaderías La Mejor ', '123', '0999345198', 'lamejor@faster.com.ec', 262, '2', '1590181803', 'active'),
(206, 'Pollos Piki', '123', '0999590591', 'piki@faster.com.ec', 264, '2', '1590282747', 'active'),
(207, 'Luigi Electric', '123', '0993560275', 'luigi@faster.com.ec', 266, '2', '1590441562', 'active'),
(208, 'Scanner Express', '123', '0999194590', 'palma@faster.com.ec', 268, '2', '1590442146', 'active'),
(209, 'Natubrak', '123', '0962629262', 'natubrak@faster.com.ec', 270, '2', '1590593625', 'active'),
(210, 'Pizza Napoli', '123', '0992432257', 'pizzanapoli@faster.com.ec', 272, '2', '1590603058', 'active'),
(211, 'Blue Dreams ', '123', '0994546323', 'bluedreams@faster.com.ec', 274, '2', '1590614926', 'active'),
(212, 'Chuzo Loco', '123', '979810275', 'chuzoloco@faster.com.ec', 276, '2', '1590619775', 'active'),
(213, 'Cafetería El Goloso', '123', '022710992', 'goloso@faster.com.ec', 278, '2', '1590626083', 'active'),
(214, 'Largarto Burgers', '123', '0991154019', 'lagarto@faster.com.ec', 280, '2', '1590696368', 'active'),
(215, 'Wafles Y Crepes Dulce Tentacio', '123', '0963519916', 'wafles@faster.com.ec', 282, '2', '1590704049', 'active'),
(216, 'Cafeteria Tamal Lojano', '123', '0998138166', 'tamal@faster.com.ec', 284, '2', '1590770992', 'active'),
(218, 'Restaurante 5ta Avenida', '123', '0988395048', 'avenida@faster.com.ec', 288, '2', '1590783565', 'active'),
(219, 'La Flaca', '123', '0986764349', 'laflaca@faster.com.ec', 290, '2', '1590799175', 'active'),
(220, 'Dulce Tentación Wafles Y Crepp', '123', '0963519916', 'waflesrosales@faster.com.ec', 292, '2', '1590858132', 'active'),
(221, 'Don Pollo Av Quevedo', '123', '0969990890', 'donpolloquevedo@faster.com.ec', 294, '2', '1590858740', 'active'),
(222, 'Dulce Tentación Wafles Y Crepp', '123', '0963519916', 'waffleszonarosa@faster.com.ec', 296, '2', '1590883426', 'active'),
(223, 'American Deli', '123', '0986866675', 'americandeli@faster.com.ec', 298, '2', '1590968496', 'active'),
(224, 'Sherwin Williams', '123', '0985425580', 'cgaibor@faster.com.ec', 300, '2', '1591032078', 'active'),
(225, 'Taurus Security', '123', '0997732985', 'taurusmatriz13@gmail.com', 302, '2', '1591033531', 'active'),
(226, 'Server', '123', '0959271082', 'info@agenciaserver.com', 304, '2', '1591040436', 'active'),
(228, 'Encebollados Poseidon ', '123', '0995104034', 'poseidon@faster.com.ec', 308, '2', '1591132369', 'active'),
(229, 'Frank Vera', '123', '0989253288', 'frank@faster.com.ec', 310, '2', '1591136973', 'active'),
(230, 'Verduras Martha Y  Chivita ', '123', '0981048822', 'verduraschivita@faster.com.ec', 312, '2', '1591196759', 'active'),
(231, 'Rotu Mark ', '123', '0980975540', 'rotu@faster.com.ec', 314, '2', '1591204324', 'active'),
(232, 'Lynda Store', '123', '0939641160', 'lynda@faster.com.ec', 316, '2', '1591248866', 'active'),
(234, 'Costa Norte 4 ', '123', '0960002103', 'costanorte4@faster.com.ec', 320, '2', '1591393422', 'active'),
(235, 'Fruits Y Coffe', '123', '0980472032', 'fruitscoffe@faster.com.ec', 322, '2', '1591478727', 'active'),
(236, 'Conchal Chabelita', '123', '0958961202', 'conchal@faster.com.ec', 324, '2', '1591498085', 'active'),
(237, 'Rosapastel', '123', '0993210860', 'rosapastel@faster.com.ec', 326, '2', '1591582306', 'active'),
(238, 'La Negra ', '123', '0978817213', 'lanegra@faster.com.ec', 328, '2', '1591725384', 'active'),
(239, 'Hornado 5 Delicias ', '123', '0989988122', '5delicias@faster.com.ec', 330, '2', '1591743877', 'active'),
(240, 'Todo Bb Be', '123', '0992452919', 'todobb@faster.com.ec', 332, '2', '1591823235', 'active'),
(241, 'Loex', '123', '0980460496', 'loex@faster.com.ec', 334, '2', '1591834898', 'active'),
(243, 'Crepes De Casa Nutella', '123', '0212098701', 'crepesnutella@faster.com.ec', 338, '2', '1591976754', 'active'),
(244, 'Deli Kitchen ', '123', '0987275679', 'delikitchen@faster.com.ec', 340, '2', '1592014124', 'active'),
(245, 'Ibrandi', '123', '0969764774', 'ibrandi@faster.com.ec', 342, '2', '1592234007', 'active'),
(246, 'Licorería Alcalu', '123', '0959507381', 'alcalu@faster.com.ec', 344, '2', '1592240403', 'active'),
(247, 'Choclo Mix D Jaime', '123', '0969696900', 'jaime@faster.com.ec', 346, '2', '1592252826', 'active'),
(248, 'Quality', '123', '0985494782', 'quality@faster.com.ec', 348, '2', '1592420910', 'active'),
(249, 'The Old Bike', '123', '0994532904', 'bike@faster.com.ec', 350, '2', '1592432786', 'active'),
(250, 'Servi - Alum', '123', '0985501019', 'servi@faster.com.ec', 352, '2', '1592436716', 'active'),
(252, 'Sophymell', '123', '0994540042', 'sophymell@faster.com.ec', 356, '2', '1592439516', 'active'),
(254, 'Mensajeria Express', '123', '0989595926', 'mensajeria@faster.com.ec', 360, '2', '1592442881', 'active'),
(255, 'Pide Lo Que Sea', '123', '0989595926', 'loqueseaconcor@faster.com.ec', 362, '2', '1592622424', 'active'),
(256, 'Kiwi Limon La Concordia ', '123', '0982037832', 'kiwiconcordia@faster.com.ec', 364, '2', '1592661629', 'active'),
(257, 'Rincon De Alex', '123', '0980415387', 'rincondealex@faster.com.ec', 366, '2', '1592689289', 'active'),
(258, 'Mundo Del Pañal ', '123', '0967097522', 'mundo@faster.com.ec', 368, '2', '1592692186', 'active'),
(259, 'La Tablita Express', '123', '0983252325', 'tablitaexpress@faster.com.ec', 370, '2', '1592860477', 'active'),
(260, 'Sweetland', '123', '0959834993', 'sweetlandlelia@faster.com.ec', 372, '2', '1593015164', 'active'),
(261, 'Pizzeria De Rubens Concordia', '123', '0993464570', 'rubens@faster.com.ec', 374, '2', '1593018739', 'active'),
(262, 'Monalisa', '123', '0939174190', 'monalisa@faster.com.ec', 376, '2', '1593124582', 'active'),
(264, 'Restaurante Chachita Concordia', '123', '0991395551', 'chachita@faster.com.ec', 380, '2', '1593444821', 'active'),
(265, 'Manaos', '123', '0979131581', 'manaos@faster.com.ec', 382, '2', '1593538495', 'active'),
(266, 'Encomienda', '123', '0985494782', 'encomienda@faster.com.ec', 384, '2', '1593547062', 'active'),
(267, 'Los Encebollados De Jessy ', '123', '0997159714', 'jessy@faster.com.ec', 386, '2', '1593610800', 'active'),
(268, 'Nápoles Pizza ', '123', '0997159714', 'napoles@faster.com.ec', 388, '2', '1593617355', 'active'),
(269, 'El Mañanero Desayunos Y Algo M', '123', '0990371169', 'desayunos@faster.com.ec', 390, '2', '1593620671', 'active'),
(270, 'Mio Detalles', '123', '0987163546', 'mio@faster.com.ec', 392, '2', '1593709300', 'active'),
(271, 'Importadora Cellmax', '123Amistad', '0985863633', 'cellmax@faster.com.ec', 394, '2', '1593821210', 'active'),
(272, 'Dolupa', '123', '022713445', 'dolupa@faster.com.ec', 396, '2', '1593874937', 'active'),
(273, 'Rollis Heladeria', '123', '0994653839', 'rollis@faster.com.ec', 398, '2', '1594142081', 'active'),
(274, 'La Pollería ', '123', '0958708093', 'polleria@faster.com.ec', 400, '2', '1594156023', 'active'),
(275, 'Green Frost Concordia', '123', '0980426906', 'frost@faster.com.ec', 402, '2', '1594225518', 'active'),
(276, 'Chef Danny', 'danpalvel.,', '0939815253', 'chefdanny@faster.com.ec', 404, '2', '1594301961', 'active'),
(277, 'Pañas Burguer', '123', '0984084220', 'burguer@faster.com.ec', 406, '2', '1594311564', 'active'),
(278, 'Iqueza', '123', '0967132154', 'iqueza@faster.com.ec', 408, '2', '1594318042', 'active'),
(279, 'Café Vilbaque', '123', '0969764774', 'cafe@faster.com.ec', 410, '2', '1594334421', 'active'),
(280, 'Carlin', '123', '0988804804', 'carlin@faster.com.ec', 412, '2', '1594336829', 'active'),
(281, 'Comercial Marthita', '123', '0984691531', 'marthita@faster.com.ec', 414, '2', '1594672560', 'active'),
(282, 'Liquor Box', '123', '0980352290', 'licor@faster.com.ec', 416, '2', '1594840673', 'active'),
(283, 'Lo Que Sea', '123', '0969764774', 'loqueseasur@faster.com.ec', 418, '2', '1594925143', 'active'),
(284, 'Feria Gastronomicas ', '123', '0999332065', 'feria@faster.com.ec', 420, '2', '1595001956', 'active'),
(285, 'Encomienda', '123', '0989595926', 'encomiendaconcoria@faster.com.ec', 422, '2', '1595040437', 'active'),
(286, 'Encomienda ', '123', '0969764774', 'paqueteria@faster.com.ec', 424, '2', '1595083216', 'active'),
(287, 'La Cuadra Steakhouse', '1234', '0969345477', 'cuadra@faster.com.ec', 426, '2', '1595286544', 'active'),
(288, 'The House Como Hecho En Casa', '123', '0978672766', 'thehouse@faster.com.ec', 428, '2', '1595293617', 'active'),
(289, 'Sari Flowers', '123', '0996914683', 'sari@faster.com.ec', 430, '2', '1595362719', 'active'),
(290, 'D Bryan', '123', '0967570025', 'bryan@faster.com.ec', 432, '2', '1595517203', 'active'),
(291, 'Chicken Box', '123', '0980228166', 'chicken@faster.com.ec', 434, '2', '1595620361', 'active'),
(292, 'La Corvina Sauces 8', '1234', '0979821152', 'corvina@faster.com.ec', 436, '2', '1595686594', 'active'),
(293, 'A Lo Mero Mero', '123', '0986057257', 'mero@faster.com.ec', 438, '2', '1595688205', 'active'),
(294, 'Morocho Express', '123', '0990897359', 'morocho@faster.com.ec', 440, '2', '1595690567', 'active'),
(295, 'Vimar-vi Pizza Artesanal', '1234', '967795029', 'vimar@faster.com.ec', 442, '2', '1595695955', 'active'),
(296, 'Laboratorios Marquez', '123', '0969764774', 'marquez@faster.com.ec', 444, '2', '1595880453', 'active'),
(297, 'Deli Crepes', 'princesa77', '0988786650', 'delicrepes@faster.com.ec', 446, '2', '1595889903', 'active'),
(298, 'Cavnet S A', '123', '0969764774', 'cavnet@faster.com.ec', 448, '2', '1596033141', 'active'),
(299, 'Lomo A Lo Pobre ', '123', '0980001474', 'lomo@faster.com.ec', 450, '2', '1596035105', 'active'),
(300, 'Go Burguers', '123', '0982896824', 'goburguers@faster.com.ec', 452, '2', '1596063062', 'active'),
(301, 'Delizie', '123', '0978675785', 'delizie@faster.com.ec', 454, '2', '1596136704', 'active'),
(302, 'Piu Pizza Norte', '123', '0961705851', 'piupizza@faster.com.ec', 456, '2', '1596223229', 'active'),
(303, 'Moyo Heladería Y Cafetería', 'Andres51', '0996902887', 'moyo@faster.com.ec', 458, '2', '1596473320', 'active'),
(304, 'Chamito Burguer', '123', '0962915114', 'chamito@faster.com.ec', 460, '2', '1596639184', 'active'),
(305, 'Hueca 81 ', '123', '0978721454', 'alitas@faster.com.ec', 462, '2', '1597068699', 'active'),
(306, 'Delta Vip Car', '123', '0959063757', 'deltavip@faster.com.ec', 464, '2', '1597160659', 'active'),
(307, 'Delta Vip Car', '123', '0959063757', 'vipcar@faster.com.ec', 466, '2', '1597180678', 'active'),
(308, 'Delta Vip Car', '123', '0959063757', 'delta@faster.com.ec', 468, '2', '1597333222', 'active'),
(309, 'Los Pinchos De Metro ', '123', '0999012623', 'lospinchosdemetro@faster.com.ec', 470, '2', '1597443349', 'active'),
(310, 'Elys Sweet', '123', '0992443741', 'elianaavilesf1980@gmail.com', 472, '2', '1597508421', 'active'),
(311, 'Papitas De La 30', '123', '0992658766', 'papitas@faster.com.ec', 474, '2', '1597793437', 'active'),
(312, 'Servicio De Incubación ', '123', '0987148122', 'servicioincubación@faster.com.ec', 476, '2', '1597847788', 'active'),
(313, 'Trans Colorado Express', '123', '0989721196', 'transcolorado@faster.com.ec', 478, '2', '1597853920', 'active'),
(314, 'Trans Colorado Express', '123', '0989721196', 'colorado@faster.com.ec', 480, '2', '1597855446', 'active'),
(315, 'Siscont', '123', '0968227906', 'siscont@faster.com.ec', 482, '2', '1597866901', 'active'),
(316, 'Humitas De Guillita', '123', '0939315055', 'guillita@faster.com.ec', 484, '2', '1597938087', 'active'),
(317, ' Parrilladas Donosti', '123', '0959798148', 'donosti@faster.com.ec', 486, '2', '1598454026', 'active'),
(318, 'Container Parrilla Moya ', '123', '0993215230', 'container@faster.com.ec', 488, '2', '1598477834', 'active'),
(319, 'Picanteria Pedacito De Esmeral', '123', '0988192707', 'esmeraldas@faster.com.ec', 490, '2', '1598478931', 'active'),
(320, 'Donde Pao Lasaña Y Algo Mas', '123', '0998451570', 'dondepao@faster.com.ec', 492, '2', '1598888269', 'active'),
(321, 'Yu Cafe', '123', '0992453857', 'yucafe@faster.com.ec', 494, '2', '1598913381', 'active'),
(322, 'Arepas Gloria ', '123', '0986583612', 'arepas@faster.com.ec', 496, '2', '1598914137', 'active'),
(323, 'Floristeria Juanito ', '123', '0994837502', 'juanito@faster.com.ec', 498, '2', '1598915570', 'active'),
(324, 'Chifa Central Norte', '123', '0988888212', 'centralnorte@faster.com.ec', 500, '2', '1599075493', 'active'),
(325, 'Promociones', '123', '0969764774', 'promo@faster.com.ec', 503, '2', '1599086319', 'active'),
(326, 'Faster Business', '123', '0969764774', 'premium@faster.com.ec', 505, '2', '1599274258', 'active'),
(327, 'Servicios De Enfermeria', '123', '0987197810', 'ajlopez@faster.com.ec', 507, '2', '1599751597', 'active'),
(328, 'El Sombrero De Jabali', '123', '0997761250', 'jabali@faster.com.ec', 509, '2', '1599838087', 'active'),
(330, 'Barbecue', '123', '0999058976', 'barbecue@faster.com.ec', 513, '2', '1600198358', 'active'),
(331, 'Froita', '123', '0987820746', 'froita@faster.com.ec', 515, '2', '1600377308', 'active'),
(332, 'Encebollados El Colorado', '123', '0999379167', 'elcolorado@faster.com.ec', 517, '2', '1600650202', 'active'),
(333, 'Pide Lo Que Sea', '123', '0985494782', 'loqueseanoche@faster.com.ec', 519, '2', '1600742198', 'active'),
(334, 'Doña Bety', '123', '0990378542', 'bety@faster.com.ec', 521, '2', '1600874564', 'active'),
(335, 'Nenes Burgers', '123', '0979303307', 'nenes@faster.com.ec', 523, '2', '1600966643', 'active'),
(336, 'Codiec', '123', '0989309687', 'codiec@faster.com.ec', 525, '2', '1600987007', 'active'),
(337, 'Chef Pescao', '123', '0999149800', 'pescao@faster.com.ec', 527, '2', '1601048781', 'active'),
(338, 'Gordiscos Burger', '123', '0983205161', 'gordiscos@faster.com.ec', 529, '2', '1601567208', 'active'),
(339, 'Restaurante D Jenny', '123', '0998570077', 'jenny@faster.com.ec', 531, '2', '1601671331', 'active'),
(340, 'La Gran Pesca ', '123', '0985835550', 'granpesca@faster.com.ec', 533, '2', '1601677587', 'active'),
(341, 'Chifa Yon Xing', '123', '0968427223', 'yon@faster.com.ec', 535, '2', '1601926758', 'active'),
(342, 'Los Secos De Paupau', '123', '0991038078', 'paupau@faster.com.ec', 537, '2', '1602012507', 'active'),
(343, 'Delta Vip Car', '123', '0959063757', 'deltapublicidad@faster.com.ec', 539, '2', '1602047680', 'active'),
(344, 'La Tonga Manaba ', '123', '0983839722', 'tongamanaba@faster.com.ec', 541, '2', '1602082020', 'active'),
(345, 'Pizza Express', '123', '0961033199', 'pizzaexpress@faster.com.ec', 543, '2', '1602083272', 'active'),
(346, 'Lubricentro El Doctor', '123', '0983685950', 'lubricentro@faster.com.ec', 545, '2', '1602088591', 'active'),
(347, 'Mangiamo', '123', '0962895193', 'mangiamo@faster.com.ec', 547, '2', '1602102810', 'active'),
(348, 'Quality', '123', '0969764774', 'qualitygye@faster.com.ec', 549, '2', '1602346360', 'active'),
(349, 'Parrilladas De Wacho ', '123', '0969764774', 'parrillada@faster.com.ec', 551, '2', '1602363902', 'active'),
(350, 'Pollo Stav', '123', '042610492', 'stavurdesa@faster.com.ec', 553, '2', '1602535329', 'active'),
(351, 'Pide Lo Que Sea', '123', '0989595926', 'loqueseacentro@faster.com.ec', 555, '2', '1602550240', 'active'),
(352, 'Pide Lo Que Sea', '123', '0989595926', 'loqueseasambo@faster.com.ec', 557, '2', '1602552766', 'active'),
(353, 'Pide Lo Que Sea', '123', '0989595926', 'loqueseagarzota@faster.com.ec', 559, '2', '1602556289', 'active'),
(354, 'Lo Que Sea', '123', '0989595926', 'loqueseacamilo@faster.com.ec', 561, '2', '1602608447', 'active'),
(355, 'Pollo A La Brasa D Gustar', '123', '0978902523', 'gustar@faster.com.ec', 563, '2', '1602619725', 'active'),
(356, 'Pollo Campero Gye', '123', '0995358433', 'camperogye@faster.com.ec', 565, '2', '1602634117', 'active'),
(357, 'Panaderia', '1234', '0989595926', 'panaderiagye@faster.com.ec', 567, '2', '1602697716', 'active'),
(358, 'Licoreria', '1234', '0989595926', 'licoresgye@faster.com.ec', 569, '2', '1602701753', 'active'),
(359, 'Supermercado', '1234', '0989595926', 'supermercadogye@faster.com.ec', 571, '2', '1602702991', 'active'),
(360, 'Doña Melbita', '123', '0993776185', 'melbita@faster.com.ec', 573, '2', '1602713888', 'active'),
(361, 'Ruedas De Camion', '123', '0989848625', 'ruedas@faster.com.ec', 575, '2', '1603118356', 'active'),
(362, 'La Paisa', '123', '0963192389', 'lapaisa@faster.com.ec', 577, '2', '1603150402', 'active'),
(363, 'Ruedas De Camion 2', '123', '0989848625', 'ruedacamion@faster.com.ec', 579, '2', '1603207551', 'active'),
(364, 'Dra Paola Rivas', '123', '0993061589', 'privas@faster.com.ec', 581, '2', '1603287099', 'active'),
(365, 'Tiendas Purpure', '123', '0998993859', 'purpure@faster.com.ec', 583, '2', '1603287564', 'active'),
(366, 'Burger Express', '123', '0961033199', 'burgerexpress@faster.com.ec', 585, '2', '1603298965', 'active'),
(367, 'El Pájaro Rojo ', '123', '0999328459', 'pajaro@faster.com.ec', 587, '2', '1603299336', 'active'),
(368, 'El Pájaro Rojo 3', '123', '0991644544', 'pajaro3@faster.com.ec', 589, '2', '1603378496', 'active'),
(369, 'Shushi Matsuri', '123', '0981472211', 'shushi@faster.com.ec', 591, '2', '1603386435', 'active'),
(370, 'Super Pollo ', '123', '0996787539', 'superpollo@faster.com.ec', 593, '2', '1603394866', 'active'),
(371, 'PizzaDitas', '123', '0988522327', 'pizzaditas@faster.com.ec', 595, '2', '1603406794', 'active'),
(372, 'Doña Bety', '123', '0990378542', 'bety1@faster.com.ec', 597, '2', '1603488121', 'active'),
(373, 'Ruedas De Camión', '123', '0989848625', 'ruedacamion3@faster.com.ec', 599, '2', '1603570935', 'active'),
(374, 'Bocanete Pizzería', '123', '0963250964', 'bocaquente@faster.com.ec', 601, '2', '1603724523', 'active'),
(375, 'Pollo Stav', '123', '043951513', 'stavorellana@faster.com.ec', 603, '2', '1603814963', 'active'),
(376, 'Pollo Stav 3', '123', '0439012850', 'stavsanborondon@faster.com.ec', 605, '2', '1603832321', 'active'),
(377, 'Kfc', '1234', '0989595926', 'kfcse@faster.com.ec', 607, '2', '1603837810', 'active'),
(378, 'Yummy Wings Para Chuparse Los ', '123', '0989184047', 'yummy@faster.com.ec', 609, '2', '1603838403', 'active'),
(379, 'Moon Garden ', '123', '0997974180', 'garden@faster.com.ec', 611, '2', '1603911530', 'active'),
(380, 'D Saul Corviches', '123', '0997358836', 'saul@faster.com.ec', 613, '2', '1604423373', 'active'),
(381, 'Faster Market', '123', '0980008742', 'market@faster.com.ec', 615, '2', '1604619301', 'active'),
(382, 'Don Chuzo', '123', '0990355899', 'donchuzo@faster.com.ec', 617, '2', '1605044064', 'active'),
(383, 'Encebollados Tu Pana', '123', '0978736874', 'pana@faster.com.ec', 619, '2', '1605154599', 'active'),
(384, 'PaÑalera Madeleine ', '123', '0990072662', 'madeleine@faster.com.ec', 621, '2', '1605203587', 'active'),
(385, 'La Bodeguita', '123', '0992361013', 'bodeguita@faster.com.ec', 623, '2', '1605281693', 'active'),
(386, 'Que De Pinga Ec', '123', '0985328443', 'quedepingaec@faster.com.ec', 625, '2', '1605387064', 'active'),
(387, 'Encomienda Nacional ', '123', '0969764774', 'nacional@faster.com.ec', 627, '2', '1605559258', 'active'),
(388, 'Liquor Box', '123', '0980352290', 'box@faster.com.ec', 629, '2', '1605715712', 'active'),
(389, 'Liquor Box', '123', '0980352290', 'liquorbox@faster.com.ec', 631, '2', '1605716535', 'active'),
(390, 'La Canasta De Yogui', '123', '0982510273', 'canasta@faster.com.ec', 633, '2', '1605899618', 'active'),
(391, 'King Kono', '123', '0999830768', 'kono@faster.com.ec', 635, '2', '1606144703', 'active'),
(392, 'Kiwilimón La Lorena', '123', '0963190017', 'kiwilorena@faster.com.ec', 637, '2', '1606507878', 'active'),
(393, 'Coronel Fast Food And Beer', '123', '0994015366', 'coronel@faster.com.ec', 639, '2', '1606683144', 'active'),
(394, 'Grill House Meat And Drink', '123', '0969078988', 'grillhouse@faster.com.ec', 641, '2', '1606828662', 'active'),
(395, 'Delta Vip Car', '123', '0959063757', 'deltaquito@faster.com.ec', 643, '2', '1606839315', 'active'),
(396, 'KALIJAMA', '123', '0984039246', 'kalijama@faster.com.ec', 645, '2', '1607115850', 'active'),
(397, 'El Buen Sabor ', '123', '0985443985', 'sabor@faster.com.ec', 647, '2', '1607205218', 'active'),
(398, 'El Rincón De Génova', '1234', '0995693881', 'genova@faster.com.ec', 649, '2', '1607350135', 'active'),
(399, 'Big Birger', '1234', '0983827193', 'bigbirger@faster.com.ec', 651, '2', '1607388734', 'active'),
(400, 'Lo Que Sea', '2424', '0989595926', 'loqueseasalinas@faster.com.ec', 653, '2', '1607407561', 'active'),
(401, 'Pide Un Repartidor', '2424', '0989595926', 'pidesalinas@faster.com.ec', 655, '2', '1607407787', 'active'),
(402, 'El Mejor Bolon De La Sra Mero', '1234', '0982854960', 'mejorbolon@faster.com.ec', 657, '2', '1607454359', 'active'),
(403, 'Mr Puffin', '1234', '0983795470', 'mrpuffin@faster.com.ec', 659, '2', '1607526769', 'active'),
(404, 'Babys Wings', '1234', '0987395614', 'babys@faster.com.ec', 661, '2', '1607530220', 'active'),
(405, 'Pasteles Y Algo Mas ', '1234', '0997210804', 'pasteles@faster.com.ec', 663, '2', '1607533184', 'active'),
(406, 'Tamara Spa', '1234', '0983843523', 'spa@faster.com.ec', 665, '2', '1607713997', 'active'),
(407, 'Restaurante El Dorado', '1234', '0984688388', 'eldorado@faster.com.ec', 667, '2', '1607714983', 'active'),
(408, 'Chifa Guang Cai', '1234', '0959175206', 'guang@faster.com.ec', 669, '2', '1607719191', 'active'),
(409, 'Plops Pizza', '1234', '0969060419', 'plops@faster.com.ec', 671, '2', '1607726203', 'active'),
(410, 'Dsi', '1234', '0969094564', 'dsi@faster.com.ec', 673, '2', '1607791088', 'active'),
(411, 'Amor En La Piel', '1234', '0983616970', 'piel@faster.com.ec', 675, '2', '1607814102', 'active'),
(412, 'Carnicos Sweet', '1234', '0995577921', 'carnicos@faster.com.ec', 677, '2', '1607817745', 'active'),
(413, 'Cevicheria Lojanita', '1234', '0994492121', 'lojanita@faster.com.ec', 679, '2', '1607818669', 'active'),
(414, 'Green S Restaurante', '1234', '0989665574', 'greens@faster.com.ec', 681, '2', '1607977884', 'active'),
(415, ' Chichos Asados', '1234', '0963128713', 'chichos@faster.com.ec', 686, '2', '1608153585', 'active'),
(416, 'La Gustosa- Pizzeria', '123', '0967098450', 'gustosa@faster.com.ec', 688, '2', '1608154565', 'active'),
(417, 'Dulce Factoria ', '1234', '0925802126', 'dulce@faster.com.ec', 690, '2', '1608157047', 'active'),
(418, 'Licores Bodegón', '1234', '0993951525', 'bodegon@faster.com.ec', 692, '2', '1608237682', 'active'),
(419, 'Waffel Kuchen', '1234', '0991165877', 'waffel@faster.com.ec', 694, '2', '1608324633', 'active'),
(420, 'La Piedra', '123', '0939185318', 'lapiedra@faster.com.ec', 696, '2', '1608413774', 'active'),
(421, 'New West Bbq And Carryout ', 'Nixongael', '0987635993', 'new@faster.com.ec', 698, '2', '1608640363', 'active'),
(422, 'Mercadito Todito', '1234', '0982913902', 'todito@faster.com.ec', 700, '2', '1609098881', 'active'),
(423, 'Baruc Burgers', '1234', '0963697425', 'baruc@faster.com.ec', 702, '2', '1609276204', 'active'),
(424, ' Nikys Salt Y Sweet', '1234', '0996309684', 'nikys@faster.com.ec', 704, '2', '1609358245', 'active'),
(425, 'Rodri Food ', '1234', '0988393062', 'rodrifood@faster.com.ec', 706, '2', '1610124162', 'active'),
(427, 'Gelatomix', '123', '0994214728', 'gelatomix@faster.com.ec', 708, '2', '1611525459', 'active'),
(429, 'Papa Johns', '123', '0969764774', 'jhons@faster.com.ec', 712, '2', '1611670569', 'active'),
(430, 'La Jama De Launa ', '123', '0992333521', 'jama@faster.com.ec', 714, '2', '1611672160', 'active'),
(431, 'Naturissimo', '123', '0969764774', 'naturissimo@faster.com.ec', 716, '2', '1611692429', 'active'),
(432, 'Carls Jr', '123', '0969764774', 'carls@faster.com.ec', 718, '2', '1611766519', 'active'),
(433, 'Picantería Carmita', '1234', '0989595926', 'carmita@faster.com.ec', 720, '2', '1611768276', 'active'),
(434, 'Empanadas De Paco ', '123', '0960540081', 'paco@faster.com.ec', 722, '2', '1611776916', 'active'),
(435, 'Rincon Familiar ', '1234', '0984234077', 'rincon@faster.com.ec', 724, '2', '1611788512', 'active'),
(436, 'La Chozita Fast Food', '1234', '0992718077', 'chozita@faster.com.ec', 726, '2', '1611867133', 'active'),
(437, 'Pizza Hut', '123', '0987119890', 'pizzahut@faster.com.ec', 728, '2', '1611939429', 'active'),
(438, 'Oh Que Rico', '123', '0969764774', 'ohquerico@faster.com.ec', 730, '2', '1611951295', 'active'),
(439, 'Sorbetto', '1234', '0989595926', 'sorbetto@faster.com.ec', 732, '2', '1612032773', 'active'),
(440, 'Cevichería D Hugo ', '1234', '0986759426', 'hugo@faster.com.ec', 734, '2', '1612037049', 'active'),
(441, 'Faceburguer', '123', '0969764774', 'faceburguer@faster.com.ec', 736, '2', '1612127606', 'active'),
(443, 'Cevichería  Karina ', '123', '0989595926', 'cevicheriak@faster.com.ec', 738, '2', '1612638310', 'active'),
(444, 'Papi Burger Joes', '123', '0987505743', 'papiburger@faster.com.ec', 740, '2', '1612643820', 'active'),
(445, 'Mayflower', '123', '0969764774', 'mayflower@faster.com.ec', 742, '2', '1612817921', 'active'),
(446, 'Grill Y Bar Rayotomas', '123', '0984428570', 'luis.suarez.aguilar@gmail.com', 744, '2', '1612832754', 'active'),
(447, 'La Perrada De Raul', '1234', '0992039540', 'perrada@faster.com.ec', 746, '2', '1612971543', 'active'),
(448, 'Oahu Superfood', '1234', '0980146519', 'oahu@faster.com.ec', 748, '2', '1612974971', 'active'),
(449, 'Carl S Jr', '1234', '0969764774', 'carlsjr@faster.com.ec', 750, '2', '1613074728', 'active'),
(450, 'Tikkis Burguer', '1234', '0994289310', 'sepaladi@gmail.com', 752, '2', '1613081956', 'active'),
(451, 'Marcelo Tacos  ', '1234', '0984754553', 'tacos@faster.com.ec', 754, '2', '1613141680', 'active'),
(452, 'Picantería El Pez Amarillo', '1234', '0969764774', 'pezamarillo@faster.com.ec', 756, '2', '1613149238', 'active'),
(453, 'Lui E Lei  Restobar ', '1234', '0989595926', 'luielei@faster.com.ec', 758, '2', '1613165176', 'active'),
(454, 'Masas Didace Del Campo A La Me', '123', '0980336351', 'diegocede@hotmail.com', 760, '2', '1613421551', 'active'),
(455, 'Cuke Fast Foob', '123', '0958851484', 'issac.vizuti@hotmail.com', 762, '2', '1613755156', 'active'),
(456, 'Tablita Del Tartaro', '1809', '0969764774', 'tablitasto@faster.com.ec', 764, '2', '1613766744', 'active'),
(457, 'Tablita Del Tartaro', 'Hanna2020', '0969764774', 'tartaro@faster.com.ec', 766, '2', '1613767089', 'active'),
(458, 'Restaurant La Sazon Manabita', '123', '0939051078', 'veliztatiana3@gmail.com', 768, '2', '1614052050', 'active'),
(459, 'Blukoi Sushi Bar', '123', '0992502176', 'blukoi@faster.com.ec', 770, '2', '1614098001', 'active'),
(460, 'Sushi Asai Express', '1234', '0979952311', 'asai@faster.com.ec', 772, '2', '1614112909', 'active'),
(461, 'Empanadas De Paco', '1234', '0989595926', 'pacose@faster.com.ec', 774, '2', '1614115695', 'active'),
(462, 'Comidas De Victor ', '1234', '0989595926', 'comidavictor@faster.com.ec', 776, '2', '1614121386', 'active'),
(463, 'Piqueos Y Moritos', '1234', '0989595926', 'piqueos@faster.com.ec', 778, '2', '1614131078', 'active'),
(464, 'Nice Cream ', '1234', '0989595926', 'nice@faster.com.ec', 780, '2', '1614182715', 'active'),
(465, 'Cajún', '123', '0969764774', 'cajun@faster.com.ec', 782, '2', '1614198958', 'active'),
(466, 'Coco Express', '1234', '0989595926', 'express@faster.com.ec', 784, '2', '1614200524', 'active'),
(467, 'Los Pollos De San Bartolo', '123', '0989629049', 'bartolo@faster.com.ec', 786, '2', '1614205251', 'active'),
(468, 'Señor Hot Dog ', '1234', '0989595926', 'señorhotdog@faster.com.ec', 788, '2', '1614220810', 'active'),
(469, 'Los Pinchos De Langostino', '123', '0989629049', 'langostas@faster.com.ec', 790, '2', '1614225287', 'active'),
(470, 'Costeñito Al Paso', '123', '0989629049', 'costeñitoalpaso@faster.com.ec', 792, '2', '1614269025', 'active'),
(471, 'Mr Wafle ', '1234', '0989595926', 'waflesydulces@faster.com.ec', 794, '2', '1614272364', 'active'),
(472, 'Dolupa', '1234', '0989595926', 'dolupas@faster.com.ec', 796, '2', '1614283881', 'active'),
(473, 'Mundo Licor', '123', '0982027660', 'santiago_0.13@hotmail.com', 798, '2', '1614305344', 'active'),
(474, 'Nixtaco Comida Mexicana', '123', '0995679985', 'nixtacoec@gmail.com', 800, '2', '1614369272', 'active'),
(475, 'Pollo Campero', '123', '0989629049', 'campero@faster.com.ec', 802, '2', '1614370820', 'active'),
(476, 'Maracay Arepas Y Empanadas Ven', '1234', '0969764774', 'maracay@faster.com.ec', 804, '2', '1614374369', 'active'),
(477, 'Pizza Mia ', '1234', '0978636579', 'kledezmagonzalez@gmail.com', 806, '2', '1614444734', 'active'),
(478, 'Pizza Hut', '1234', '0989595926', 'hutlibertad@faster.com.ec', 808, '2', '1614457075', 'active'),
(479, 'Kobe Sushi Rolls', '123', '0989629049', 'kobe@faster.com.ec', 810, '2', '1614634045', 'active'),
(480, 'Lai Lai', '123', '0989629049', 'lailai@faster.com.ec', 812, '2', '1614705280', 'active'),
(481, 'Frozen Yogurt', '1234', '0989595926', 'frozen@faster.com.ec', 814, '2', '1614877374', 'active'),
(482, 'Menestras Del Negro', '123', '0989629049', 'menestradelnegroquito@faster.com.ec', 816, '2', '1614877531', 'active'),
(483, 'Pepitos Grill', '123', '0989629049', 'pepitosgrill@faster.com.ec', 818, '2', '1614897644', 'active'),
(484, 'Sushi Fugu', '1234', '0978681571', 'sushifugu@faster.com.ec', 820, '2', '1614953842', 'active'),
(485, 'Farmacia Cruz Azul', '123', '0969764774', 'cruzazul@faster.com.ec', 822, '2', '1614977870', 'active'),
(486, 'Farmacia Cruz Azul', '123', '0969764774', 'azul@faster.com.ec', 824, '2', '1614978105', 'active'),
(487, 'Farmacia Cruz Azul', '1234', '0969764774', 'azullibertad@faster.com.ec', 826, '2', '1614978460', 'active'),
(488, 'Farmacia Cruz Azul', '123', '0969764774', 'azulsalinas@faster.com.ec', 828, '2', '1614978849', 'active'),
(489, 'Farmacia Santa Martha', '123', '0969764774', 'marthalibertad@faster.com.ec', 830, '2', '1614980074', 'active'),
(490, 'Farmacia Sana Sana', '123', '0969764774', 'sanasanay@faster.com.ec', 832, '2', '1614980388', 'active'),
(491, 'Farmacia Sana Sana', '123', '0969764774', 'sanasana@faster.com.ec', 834, '2', '1614981041', 'active'),
(492, 'Farmacia Sana Sana', '123', '0969764774', 'sanalibertad@faster.com.ec', 836, '2', '1614981693', 'active'),
(493, 'Red Farmacys', '123', '0969764774', 'farmacy@faster.com.ec', 838, '2', '1615061692', 'active'),
(494, 'Red Farmacys', '123', '0969764774', 'redfarmacy@faster.com.ec', 840, '2', '1615062026', 'active'),
(495, 'Coral Hipermercados', '123', '0969764774', 'coral@faster.com.ec', 842, '2', '1615062532', 'active'),
(496, 'Supermaxi', '123', '0969764774', 'supermaxi@faster.com.ec', 844, '2', '1615062713', 'active'),
(497, 'Supermaxi', '1234', '0969764774', 'super@faster.com.ec', 846, '2', '1615063202', 'active'),
(498, 'Farmacia Cruz Azul', '1234', '0969764774', 'azuluio@faster.com.ec', 848, '2', '1615064675', 'active'),
(499, 'Farmacia Santa Martha', '123', '0969764774', 'santa@faster.com.ec', 850, '2', '1615065489', 'active'),
(500, 'Sana Sana', '123', '0969764774', 'sana@faster.com.ec', 852, '2', '1615065898', 'active'),
(501, 'Farmacias Económicas', '123', '0969764774', 'economica@faster.com.ec', 854, '2', '1615066975', 'active'),
(502, 'Aldean ', '123', '0969764774', 'alden@faster.com.ec', 856, '2', '1615238152', 'active'),
(503, 'Mi Comisariato', '123', '0969764774', 'comisariato@faster.com.ec', 858, '2', '1615238717', 'active'),
(504, 'Encomienda Local ', '1234', '0989595926', 'encomiendaslibertad@faster.com.ec', 860, '2', '1615303854', 'active'),
(505, 'Ch Farina ', '12345', '0969764774', 'chfarinaq@faster.com.ec', 862, '2', '1615322526', 'active'),
(506, 'Smoothie House', '1234', '0969764774', 'smoothie@faster.com.ec', 864, '2', '1615330753', 'active'),
(507, 'Se Lo Que Sea ', '1234', '0989595926', 'loquesealibertad@faster.com.ec', 866, '2', '1615412874', 'active'),
(508, 'Se Lo Que Sea', '1234', '0989595926', 'loqueseasantaelena@faster.com.ec', 868, '2', '1615563146', 'active'),
(509, 'Parrillada  Del Uruguayo ', '1234', '0989595926', 'uruguayo@faster.com.ec', 870, '2', '1615572927', 'active'),
(510, 'Lo Que Sea', '123', '0989629049', 'loqueseauio@faster.com.ec', 872, '2', '1615581614', 'active'),
(511, 'Lo Que Sea', '123', '0989629049', 'loqueseaeloy@faster.com.ec', 874, '2', '1615582561', 'active'),
(512, 'Lo Que Sea', '123', '0989629049', 'loqueseainca@faster.com.ec', 876, '2', '1615583361', 'active'),
(513, 'Parrillada De Dario', '1234', '0997041253', 'parrilladadario@faster.com.ec', 879, '2', '1616170955', 'active'),
(514, 'Parrillada De Dario ', '1234', '0993007015', 'parrilladadario1@faster.com.ec', 881, '2', '1616188699', 'active'),
(515, 'Panaderia Y Pasteleria Ambato', '1234', '0983248843', 'panaderiaambato@faster.com.ec', 883, '2', '1616251709', 'active'),
(516, 'Sekeria', '12345', '0998576045', 'sakeria@faster.com.ec', 885, '2', '1616277335', 'active'),
(517, 'Esquina Helilupa', '1234', '0961445868', 'helilupa@faster.com.ec', 887, '2', '1616280273', 'active'),
(518, 'Los Hot Dogs De La Gonzalez Su', '123', '0989629049', 'gonzalez@faster.com.ec', 889, '2', '1616282929', 'active'),
(519, 'Kfc', '12345', '0989629049', 'kfcquito@faster.com.ec', 891, '2', '1616345248', 'active'),
(520, 'Fritaderia El Dorado ', '1234', '0994558594', 'eldoradof@faster.com.ec', 893, '2', '1616463253', 'active'),
(521, 'La Casa Manabita Cevicheria', '1234', '0968277919', 'pedrog.4472@gmail.com', 895, '2', '1616684563', 'active'),
(522, 'Noe Sushi Bar ', '1234', '0989629049', 'noesushi@faster.com.ec', 897, '2', '1616708270', 'active'),
(523, 'Macdonals', '12345', '0989629049', 'mcdonalds@faster.com.ec', 899, '2', '1616733182', 'active'),
(524, 'Mascotas Veterinaria', '123', '0997281503', 'ezequielmauricio163@gmail.com', 901, '2', '1616787643', 'active'),
(525, 'Encebollado Con Todo De Felipa', '123', '0994560850', 'felipaso@faster.com', 903, '2', '1616873103', 'active'),
(526, 'Alas Papas Sport Bar', '12345', '0994793667', 'alaspapas@faster.com.ec', 905, '2', '1616878374', 'active'),
(527, 'Icaro Pizzeria', '1234', '0988990383', 'icaropizzeria@gmail.com', 907, '2', '1616884150', 'active'),
(528, 'Charlotte Cookies', '1234', '0991265278', 'lizbethandrademontero@hotmail.com', 909, '2', '1617069047', 'active'),
(529, 'Osole', '1234', '0989595926', 'osole@faster.com.ec', 911, '2', '1617114811', 'active'),
(530, 'Helados  Bogati', '1234', '0988067795', 'bogati@faster.com.ec', 913, '2', '1617120898', 'active'),
(531, 'Asadero El Secreto De Javier ', '1234', '0989595926', 'asaderojavier@faster.com.ec', 915, '2', '1617231586', 'active'),
(532, 'Delicias Mall', '1234', '0989595926', 'deliciasmall@faster.com.ec', 917, '2', '1617251905', 'active'),
(533, 'Gelatomix Bicentenario ', '123', '0995542621', 'gelatomixcarcelen@gmail.com', 919, '2', '1617284024', 'active'),
(534, 'El Pechugon Horneado ', '123', '0961250888', 'elpechugon@faster.com.ec', 921, '2', '1617290344', 'active'),
(535, 'Tienda De Regalo Y Detalle M-g', '1234', '0990420337', 'tiendamg@faster.com.ec', 923, '2', '1617297103', 'active'),
(536, 'Ron Retaque ', '123', '0999932518', 'ronretaque@faster.com.ec', 925, '2', '1617305232', 'active'),
(537, 'House Loord Wings', '1234', '0983524243', 'lordwings@faster.com.ec', 927, '2', '1617329287', 'active'),
(538, 'Pollo Gus ', '123', '0989629049', 'pollogus@gmail.com', 929, '2', '1617374444', 'active'),
(539, 'Greenfrost ', '123', '0989595926', 'greenfrost@gmail.com', 931, '2', '1617393403', 'active'),
(540, 'Manabiche ', '123', '0995594473', 'manabiche@faster.com.ec', 933, '2', '1617398788', 'active'),
(541, 'Mini Market El Ahijado', '1234', '0998566902', 'julissa21medi@gmail.com', 935, '2', '1617480103', 'active'),
(542, 'Alitas Dali', '1234', '0984935030', 'dali@faster.com.ec', 937, '2', '1617484343', 'active'),
(543, 'Sanduches La Reina ', '123', '0995759040', 'alimentoslareinaec@gmail.com', 939, '2', '1617721975', 'active'),
(544, 'Jose El Capitan Cangrejo ', '123', '0987597758', 'jesparza007@hotmail.com', 941, '2', '1617726483', 'active'),
(545, 'Pastidelicias ', '123', '0995273323', 'pastidelicias@faster.com.ec', 943, '2', '1617733153', 'active'),
(546, 'Dfz Electronics', '123', '0995069353', 'dfzelectronics@gmail.com', 945, '2', '1617740839', 'active'),
(547, 'Mascotas Y Mascosas', '123', '0978659426', 'mascotasymascosas@gmx.es', 947, '2', '1617743250', 'active'),
(548, 'El Rincon De Polita ', '1234', '0989122070', 'rinconpolita@faster.com.ec', 949, '2', '1617744291', 'active'),
(549, 'Sushi And Sweets', '123', '0985945135', 'sushiandsweets2017@gmail.com', 951, '2', '1617814755', 'active'),
(550, 'Aché De La Flaka', '123', '0989629049', 'achedelaflaka@faster.com.ec', 953, '2', '1617830559', 'active'),
(551, 'Parrilla Toribio', '123', '0968503860', 'toribio@faster.com.ec', 955, '2', '1617835850', 'active'),
(552, 'Alfajores Artesanales Chemi ', '123', '0998089595', 'chemialfajores@faster.com.ec', 957, '2', '1617888024', 'active'),
(553, 'Pasteleria San Luis ', '123', '0986886356', 'pasteleriasanluis@faster.com.ec', 959, '2', '1617890025', 'active'),
(554, 'Telecom ', '123', '0982603285', 'telecom@faster.com.ec', 961, '2', '1617892792', 'active'),
(555, 'Artesanías María Belén ', '123', '0989629049', 'artesaniasmb@faster.com.ec', 963, '2', '1617899535', 'active'),
(556, 'Qchevere Grill Hou', '1234', '0999906392', 'qcheveregrillhouse@gmail.com', 965, '2', '1617987593', 'active'),
(557, 'Hamburguesas De Rusty', '123', '0989629049', 'info@rusty.com.ec', 967, '2', '1618003867', 'active'),
(558, 'Picanteria Carchi ', '123', '0998437329', 'picanteriacarchi@faster.com.ec', 969, '2', '1618237807', 'active'),
(559, 'La Burgatta ', '123', '0963413348', 'info@laburgatta.com', 971, '2', '1618248912', 'active'),
(560, 'Los Tios ', '123', '0979188714', 'pizzatiosveintimilla@gmail.com', 973, '2', '1618264158', 'active'),
(561, 'Punta Del Mar ', '1234', '0968134756', 'puntamar@faster.com.ec', 975, '2', '1618273405', 'active'),
(562, 'Cevicheria De Huho 2', '123', '0969604968', 'cevicheriadehugo2@faster.com.ec', 977, '2', '1618274508', 'active'),
(563, 'Legitimo Hornado Patuso ', '123', '0994785154', 'hornadopatuso@faster.com.ec', 979, '2', '1618328578', 'active'),
(564, 'Restaurante Arabe Side Bou', '123', '0995647479', 'riadhg03@gmail.com', 981, '2', '1618335671', 'active'),
(565, 'Yachik Cafetería Y Sabores', '123', '0998916346', 'egdavila@hotmail.es', 983, '2', '1618430249', 'active');
INSERT INTO `fooddelivery_res_owner` (`id`, `username`, `password`, `phone`, `email`, `res_id`, `role`, `timestamp`, `status`) VALUES
(566, 'Itakimasu Sushi', '12345', '0998697089', 'itakimasu@faster.com.ec', 985, '2', '1618577547', 'active'),
(567, 'Wings Fest', '123', '0978780078', 'sucrezambrano4@hotmail.com', 987, '2', '1618602320', 'active'),
(568, 'Vaka Grill Restaurant', '123', '0990867098', 'vacagrillrestaurante@gmail.com', 989, '2', '1618930883', 'active'),
(569, 'Los Asados De La Vaca', '123', '0990074494', 'asadosdelavaca@faster.com.ec', 991, '2', '1618936431', 'active'),
(570, 'Restaurante Cabaña Aeropuerto', '123', '0979203862', 'restaurante.aeropuertosn@gmail.com', 993, '2', '1618949393', 'active'),
(571, 'La Burguer La Tentación A La P', '123', '0989281554', 'dianachazy@autlook.com', 995, '2', '1618952782', 'active'),
(572, 'Bar Restaurant  Lo Nuestro', '123', '0968121920', 'lonuestp@faster.com.ec', 997, '2', '1618957146', 'active'),
(573, 'Bar Restaurant  Lo Nuestro', '123', '0968121920', 'barlonuestro@faster.com.ec', 999, '2', '1618957408', 'active'),
(574, 'Megaflipper', '123', '0985358971', 'hola@flipper.com.ec', 1001, '2', '1619036672', 'active'),
(575, 'Super Licores Sd', '123', '0939664875', 'lacavariozamora@faster.com.ec', 1003, '2', '1619048086', 'active'),
(576, 'Pizzeria Da Gianluca', '123', '0987369107', 'gianlucalaise@gmail.com', 1005, '2', '1619109949', 'active'),
(577, 'Market De Lago', '123', '0994649244', 'info@agroindustriasgonzalez.com', 1007, '2', '1619129448', 'active'),
(578, 'Pollo Colorado Indio Colorado ', '123', '0997552074', 'andrestamayo0112@hotmail.com', 1009, '2', '1619195523', 'active'),
(579, 'Chifa Fulin ', '123', '0986103552', 'chifafulin@faster.com.ec', 1011, '2', '1619196979', 'active'),
(580, 'Pollo Colorado 5 Esquinas', '123', '0989020239', '5esquinas@faster.com.ec', 1013, '2', '1619206079', 'active'),
(581, 'Pollo Colorado Santa Marta', '123', '0989928133', 'pollosantamarta@faster.com.ec', 1015, '2', '1619207287', 'active'),
(582, 'Chili Peppers', '123', '0980905514', 'chillis@faster.com.ec', 1017, '2', '1619210121', 'active'),
(583, 'El Barón De Las Mollejas', '123', '0995040040', 'info@barondelasmollejas.com', 1019, '2', '1619447625', 'active'),
(584, 'Pasteleria Tu Tentación', '123', '0999223942', 'pasteleriatutentacion@outlook.com', 1021, '2', '1619453014', 'active'),
(585, 'Pasteleria Tu Tentación', '123', '0999223942', 'pasteleriatutentacion@faster.com.ec', 1023, '2', '1619454174', 'active'),
(586, 'Pastelería Paty Flores', '123', '0987256608', 'pasteleriapatyflorescarcelen@hotmail.com', 1025, '2', '1619466141', 'active'),
(587, 'Red Point Pizza', '123', '0985423174', '0aristoteles6@gmail.com', 1027, '2', '1619475524', 'active'),
(588, 'La Burguer', '123', '0963280124', 'dianachazy@outlook.com', 1029, '2', '1619476214', 'active'),
(589, 'Common Grounds Coffee And Waff', '123', '0963515534', 'commongrounds@faster.com.ec', 1031, '2', '1619533022', 'active'),
(590, 'El Café De Amanda ', '1234', '0990922798', 'cafeamanda@faster.com.ec', 1033, '2', '1619536282', 'active'),
(591, 'La Mamá De Las Hamburguesas', '1234', '0960635170', 'mama@faster.com.ec', 1035, '2', '1619547610', 'active'),
(592, 'Domms Alitas Bbq', '123', '0984399280', 'lalobkn_08@hotmail.com', 1037, '2', '1619548640', 'active'),
(593, 'Parilla 042', '123', '0991710915', 'jacf-3000@hotmail.com', 1039, '2', '1619562715', 'active'),
(594, 'Nativo', '123', '0999859811', 'nativocafeteria@gmail.com', 1041, '2', '1619619840', 'active'),
(595, 'La Estancia De Domalu', '123', '0999575930', 'dorismari43@hotmail.com', 1043, '2', '1619621397', 'active'),
(596, 'Gelatomix Bicentenario', '123', '0992524200', 'gelatomixbicentenario@gmail.com', 1045, '2', '1619628382', 'active'),
(597, 'Guayaco Republik Ceviches ', '123', '0967485072', 'republikceviches@faster.com.ec', 1047, '2', '1619630333', 'active'),
(598, 'Mac Burgers', '123', '0967749653', '1macburgers1@gmail.com', 1049, '2', '1619645491', 'active'),
(599, 'Guayaco Republik Bolones', '123', '0967485072', 'guayacobolones@faster.com.ec', 1051, '2', '1619650347', 'active'),
(600, 'Cevicheria Joalpade ', '123', '0959982554', 'amadapaz85@hotmail.com', 1053, '2', '1619710489', 'active'),
(601, 'Barba Negra ', '123', '0990642548', 'freddy_rodriguez94@hotmail.com', 1055, '2', '1619713851', 'active'),
(602, 'Estilo Y Moda', '123', '0990210329', 'estilo.moda.stodomingo@gmail.com', 1057, '2', '1619717226', 'active'),
(603, 'Mac Pato ', '123', '0986101826', 'schardiente@hotmail.com', 1059, '2', '1619729636', 'active'),
(604, 'The Grill Yard ', '123', '0997696235', 'nod-dan@hotmail.com', 1061, '2', '1619735860', 'active'),
(605, 'Gelatomix Catolica', '123', '0998233011', 'gelatomixreala@gmail.com', 1063, '2', '1619799501', 'active'),
(606, 'Lo De Pepo ', '123', '0991159591', 'sanducheslodepepo@gmail.com', 1065, '2', '1619813008', 'active'),
(607, 'Ibombay Capaes', '123', '0979263680', 'ibombay@faster.com.ec', 1067, '2', '1619817657', 'active'),
(608, 'Ibombay Salinas ', '123', '0979263680', 'ibombaysalinas@faster.com.ec', 1069, '2', '1619822216', 'active'),
(609, 'Las Palmeras Cotocollao', '123', '0991274438', 'grupopalmeras@gmail.com', 1071, '2', '1620061600', 'active'),
(610, 'La Cuevita Del Camarón Reventa', '123', '0939745716', 'andreaurresta2018@gmail.com', 1073, '2', '1620073405', 'active'),
(611, 'Glow Point ', '123', '0985154251', 'glowpoint19@gmail.com', 1075, '2', '1620079354', 'active'),
(612, 'La Estancia De Domalu 2 De May', '123', '0999575930', 'dorismari42@hotmail.com', 1077, '2', '1620135893', 'active'),
(613, 'Brothers Sports Y Food', '123', '0993622301', 'heneste27@gmail.com', 1079, '2', '1620222417', 'active'),
(614, 'Enconcados De Maicon ', '123', '0992479798', 'maicon@faster.com.ec', 1081, '2', '1620308685', 'active'),
(615, 'Davids Hamburgers', '123', '0997659228', 'davidshamburgers@outlook.es', 1083, '2', '1620313808', 'active'),
(616, 'Kobe Sushi Y Rolls', '123', '0993182372', 'servicioalcliente@sushicorp.ec', 1085, '2', '1620317169', 'active'),
(617, 'Botelos Manta', '123', '0969490831', 'boletos@faster.com.ec', 1087, '2', '1620340022', 'active'),
(618, 'Parrilladas El Brasero 2', '123', '0958797029', 'maopalomino@hotmail.com', 1089, '2', '1620399280', 'active'),
(619, 'Los Motes De La Magdalena', '123', '0987056759', 'pacifico@losmotesdelamagdalena.com', 1091, '2', '1620837038', 'active'),
(620, 'Bottero Restaurante', '123', '0967973440', 'info@casadebottero.com', 1093, '2', '1620853730', 'active'),
(621, 'Gelatomix Real Audiencia ', '123', '0999934142', 'gelatomixcatolica@gmail.com', 1095, '2', '1620919903', 'active'),
(622, 'Gelatomix Cotocollao', '12345', '0995542621', 'gelatomixcotocollao@gmail.com', 1097, '2', '1620920856', 'active'),
(623, 'La Avenida Del Licor 24-7', '123', '0989184047', 'lavenidadelicor@faster.com.ec', 1099, '2', '1620946702', 'active'),
(624, 'Asadero De King El Rey ', '123', '0993898544', 'asaderotheking@faster.com.ec', 1101, '2', '1621003321', 'active'),
(625, 'Picantería Polo Apolo', '12345', '0993998265', 'barbarapolo@faster.com.ec', 1103, '2', '1621032754', 'active'),
(626, 'Pame’s Tradición Parrillera', '12345', '0994652539', 'lospinchosdepame@gmail.com', 1105, '2', '1621094063', 'active'),
(627, 'El Rincon De Los Manabitas', '1234', '0993266412', 'rinconmanabita@faster.com.ec', 1107, '2', '1621110205', 'active'),
(628, 'Finisterre', '123', '0993816262', 'betty_36ec@hotmail.com', 1109, '2', '1621288623', 'active'),
(629, 'The Rusty Bold Ruta 66', '123', '0991775192', 'castroviviana1190@gmail.com', 1111, '2', '1621540214', 'active'),
(630, 'La Tacada', '12345', '0978828534', 'kleberin80@gmail.com', 1113, '2', '1621702313', 'active'),
(631, 'Cangrejos Mi Sargento', '123', '0969844255', 'parraeduard207@gmail.com', 1115, '2', '1621881184', 'active'),
(632, 'Restaurante El Negro Joe', '123', '0983518492', 'samechyudted@gmail.com', 1117, '2', '1621975968', 'active'),
(633, 'Transporte Puerta A Puerta', '1234', '0985494782', 'quitop@faster.com.ec', 1119, '2', '1621987693', 'active'),
(634, 'Quality Manta', '1234', '0963506536', 'qualitymanta@faster.com.ec', 1121, '2', '1621989895', 'active'),
(635, 'Martinica ', '123', '099856577', 'broad.burguer@hotmail.com', 1123, '2', '1622051063', 'active'),
(636, 'Aliss Cafe', '123', '0986558948', 'alisscafe@faster.com.ec', 1125, '2', '1622125210', 'active'),
(637, 'Asadero La Brasa Original', '123', '0998155388', 'asaderobraorg@gmail.com', 1128, '2', '1622492039', 'active'),
(638, 'Casa Rabotti', '123', '0987285940', 'rabotti@faster.com.ec', 1130, '2', '1622749921', 'active'),
(639, 'Botelos ', '123', '0996053219', 'social@pollostav.com', 1132, '2', '1622828251', 'active'),
(640, 'La Tablita Del Tártaro', '123', '0989629049', 'servicioalcliente@latablitadeltartaro.com', 1134, '2', '1622931858', 'active'),
(641, 'Pollos Chester', '123', '0987854794', 'polloschester@faster.com.ec', 1136, '2', '1622988657', 'active'),
(642, 'Texas Chicken', '123', '0980411431', 'sugerencias@grupotcg.com', 1138, '2', '1623007468', 'active'),
(643, 'Nanotech  Market ', '12345', '0998377619', 'nanotech@faster.com.ec', 1140, '2', '1623339755', 'active'),
(644, 'Salchicheria Dibo2 Interbarria', '12345', '0997382503', 'salchicheriadibo.2@faster.com.ec', 1142, '2', '1623427963', 'active'),
(645, 'Helados Gourmet Ice Candy', '123', '0998377854', 'wcandoveintimilla@yahoo.com', 1144, '2', '1623505149', 'active'),
(646, 'Chifa Central Puerto Ila ', '123', '0988188897', 'centralpuertoila@faster.com', 1146, '2', '1623507324', 'active'),
(647, 'El Papalote', '123', '0984794488', 'elpapaloteventas@gmail.com', 1148, '2', '1623512827', 'active'),
(648, 'Cocinando Pa Ella ', '123', '0993501265', 'ruedamejia@hotmail.com', 1150, '2', '1623531756', 'active'),
(649, 'Umidigi', '123', '0996382632', 'compras@umidigiec.com', 1152, '2', '1623591796', 'active'),
(650, 'Organika Ec', '123', '0997328946', 'pao.ord_lam@hotmail.com', 1154, '2', '1623779265', 'active'),
(651, 'Pizzería El Hornero', '12345', '0995263724', 'pizzeria.elhornero@faster.com.ec', 1156, '2', '1623861305', 'active'),
(652, 'El Krug Pub', '123', '0987229392', 'andres@krugpub.com', 1158, '2', '1624046651', 'active'),
(653, 'El Velero Manabita', '123456', '0981393718', 'elveleromanabita@faster.com.ec', 1160, '2', '1624051508', 'active'),
(654, 'Wisconsin Ribs', '12345', '0993501265', 'marcosrueda@faster.com.ec', 1162, '2', '1624131637', 'active'),
(655, 'El Mejor Bolon D Carol', '12345', '994955143', 'mejor.bolondecarol@faster.com.ec', 1164, '2', '1624368825', 'active'),
(656, 'El Pollo Kuku', '12345', '096028075', 'asadero.kuku@faster.com.ec', 1166, '2', '1624669325', 'active'),
(657, 'Quitacos Comida Fusión ', '123', '0969282646', 'fabianadol82@faster.com', 1168, '2', '1624741053', 'active'),
(658, 'La Chama Burgers', '12345', '0978918993', 'lachamaburgers@gmail.com', 1170, '2', '1624753578', 'active'),
(659, 'Alice Italian Restaurant', '123', '0983846268', 'alice@faster.com.ec', 1172, '2', '1624806612', 'active'),
(660, 'Los Cebiches De La Rumiñahui', '123', '0989514123', 'alainloorlcr@hotmail.com', 1174, '2', '1624833370', 'active'),
(661, 'Gelatomix Central ', '123', '098621143', 'gelatomixcentral@faster.com.ec', 1176, '2', '1625155536', 'active'),
(662, 'Cosas Finas De La Florida', '123', '0998870069', 'cosasfinasdelaflorida@outlook.es', 1178, '2', '1625330211', 'active'),
(663, ' La Tablita Del Tártaro', '123', '0989629049', 'lttmalldelpacifico@latablitadeltartaro.com', 1180, '2', '1625406197', 'active'),
(664, 'Cajun', '123', '0989629049', 'cjnc23@cajun.com.ec', 1182, '2', '1625427475', 'active'),
(665, 'Menestras Del Negro', '123', '0989629049', 'm52@menestrasdelnegro.com.ec', 1184, '2', '1625953347', 'active'),
(666, 'Pollo Ideal  Todo Express ', '123', '0998441918', 'moyanoedwin@hotmail.com', 1186, '2', '1626038653', 'active'),
(667, 'Made In China Store', '123', '0996826221', 'madeinchinastore@faster.com.ec', 1188, '2', '1626303094', 'active'),
(668, 'Donde Pipe Comida Colombiana', '123', '0980375891', 'dondepipecomidacolombiana@hotmail.com', 1190, '2', '1626390543', 'active'),
(669, 'La Yapa Bicentenario', '123', '0983639388', 'jarroyoburbanobicentenario@yahoo.com', 1192, '2', '1626905019', 'active'),
(670, 'La Yapa Sector De La Y', '123', '0983639388', 'jarroyoburbanosectory@yahoo.com', 1194, '2', '1626905513', 'active'),
(671, 'Chau Lao', '123', '0969764774', 'chaulao@faster.com.ec', 1196, '2', '1627223481', 'active'),
(672, 'La Hueca D Anver', '123', '0980283525', 'lahuecadeanver@faster.com.ec', 1198, '2', '1627250538', 'active'),
(673, 'Tacos Mexicanos Del Hiper', '123', '0963256778', 'sharupisilvi@gmail.com', 1200, '2', '1627509004', 'active'),
(674, 'Soffy Pizza', '123', '0960991657', 'wilson03sophia@gmail.com', 1202, '2', '1628356199', 'active'),
(675, 'Chifa Thang Long', '123', '0994667151', 'hiepnguyenvu86@gmail.con', 1204, '2', '1628369747', 'active'),
(676, 'Gelatomix Nayon', '123', '0999195368', 'nayon@faster.com.ec', 1206, '2', '1628895914', 'active'),
(677, 'Burguer Bros Rm', '123', '0989376268', 'victoria123quimi@gmail.com', 1208, '2', '1629046560', 'active'),
(678, 'Diamante Shoes ', '12345', '0980046235', 'diamanteshoes@faster.com.ec', 1210, '2', '1630181711', 'active'),
(679, 'Santas Alitas Av Quito', '123', '0989821823', 'salitas@faster.com.ec', 1212, '2', '1630762945', 'active'),
(680, 'Zuba Restaurante', '123', '0963450578', 'klebzam@live.com', 1214, '2', '1630771366', 'active'),
(681, 'Chifa Wong Kee', '12345', '0968007999', 'chifawongkee@faster.com.ec', 1216, '2', '1630788496', 'active'),
(682, 'Bolon De Ruchis ', '123', '0968811872', 'bolonderuchis@faster.com.ec', 1218, '2', '1630852615', 'active'),
(683, 'Che Pepe', '12345', '0962770131', 'chepepe@faster.com.ec', 1220, '2', '1630873996', 'active'),
(684, 'La LeÑa El Autentico Sabor Cri', '123', '0986699732', 'laleñael@faster.com.ec', 1222, '2', '1631369446', 'active'),
(685, 'Mister Shawarma ', '123', '0993986411', 'angelacostaguerrero@gmail.com', 1224, '2', '1631395117', 'active'),
(686, 'Frappesito Coffee Shop', '12345', '0996512918', 'frappesitoec@gmail.com', 1226, '2', '1631893292', 'active'),
(687, 'Los Asados D Javi', '123', '0968872727', 'losasadosdjavi@faster.com.ec', 1228, '2', '1632592021', 'active'),
(688, 'La Esquina De Ales ', '12345', '0995436912', 'laesquinadealesmanta@faster.com.ec', 1230, '2', '1632690412', 'active'),
(689, 'Maxi Pizza', '12345', '0988702524', 'maxipizza@faster.com.ec', 1232, '2', '1632794992', 'active'),
(690, 'Chu Burguer ', '12345', '0963451836', 'chuburguer@faster.com.ec', 1234, '2', '1633040013', 'active'),
(691, 'Chef Point Snack Bar Y Grill', '12345', '0996321911', 'chefpoint@faster.com.ec', 1236, '2', '1633205825', 'active'),
(692, 'Del Tanque Ribs ', '12345', '0997223008', 'deltanqueribs@faster.com.ec', 1238, '2', '1633211847', 'active'),
(693, 'Punto Cangrejo Y Sabores Del M', '12345', '959005636', 'puntocangrejo@faster.com.ec', 1240, '2', '1633470945', 'active'),
(694, 'Chifa Jia Le ', '12345', '0969455581', 'chifajiale@faster.com.ec', 1242, '2', '1634142019', 'active'),
(695, 'Platano Con Salprieta ', '12345', '0964108884', 'pcs.cafeteria@gmail.com', 1244, '2', '1634222789', 'active'),
(696, 'Chau Lao Flavio Reyes ', '12345', '0958776637', 'chaulaoflavioreyes@faster.com.ec', 1246, '2', '1634236432', 'active'),
(697, 'Alitas Extremas ', '12345', '0968857900', 'alitasextremas@faster.com.ec', 1248, '2', '1634396511', 'active'),
(698, 'Lania Churros ', '12345', '0961983504', 'laniachurros@faster.com.ec', 1250, '2', '1634595547', 'active'),
(699, 'La Tierrita ', '12345', '0980960161', 'latierrita@faster.com.ec', 1252, '2', '1634998383', 'active'),
(700, 'El Buen Corte ', '12345', '0981379974', 'soyalisson@gmail.com', 1254, '2', '1635014288', 'active'),
(701, 'La Esquina De Ales ', '12345', '0994470181', 'esquinase@faster.com.ec', 1256, '2', '1635107137', 'active'),
(702, 'El Mejor Bolon Algo Diferente ', '12345', '0969213974', 'algodiferente@faster.com.ec', 1258, '2', '1635204672', 'active'),
(703, 'Pizza Caliente ', '12345', '0979541041', 'catgeovanny@gmail.com', 1260, '2', '1635267017', 'active'),
(704, 'Comidas Rapidas El Chonero', '12345', '0980030461', 'carlostalledo2010@hotmail.com', 1262, '2', '1635527711', 'active'),
(705, 'Pipes Bbq', '12345', '0987870430', 'pipesbbq@faster.com.ec', 1264, '2', '1635604125', 'active'),
(706, 'Magic Pizza', '12345', '0989052901', 'magic21pizza@gmail.com', 1266, '2', '1635714416', 'active'),
(707, 'Bogati', '12345', '0990645491', 'bogatiquito@faster.com.ec', 1268, '2', '1635884132', 'active'),
(708, 'Flores Coffe', '12345', '0996475194', 'florescoffe@faster.com.ec', 1270, '2', '1635897188', 'active'),
(709, 'Mecánica Paramo', '12345', '0999685277', 'mecanicaparamo@faster.com.ec', 1272, '2', '1635967494', 'active'),
(710, 'La Bandeja De Marisco Cevicher', '12345', '0998038065', 'labandejacevicheria@faster.com.ec', 1274, '2', '1635973128', 'active'),
(711, 'Mandingos Fast Food', '12345', '0987922969', 'sararodriguez429@gmail.com', 1276, '2', '1636043858', 'active'),
(712, 'Fitgreen', '12345', '0995750428', 'fitgreen.ec@gmail.com', 1278, '2', '1636208125', 'active'),
(713, 'Charlies Bistro Cafe Y Deli', '12345', '0959712303', 'charliesbistro@faster.com.ec', 1280, '2', '1636214348', 'active'),
(714, 'Kfc Carcelén ', '12345', '0981867734', 'kfccarcelen@faster.com.ec', 1282, '2', '1636302433', 'active'),
(715, 'Taco Madre ', '54321', '0995267551', 'tacosmadre@faster.com.ec', 1284, '2', '1636320573', 'active'),
(716, 'Cevicheria Al Paso', '12345', '0959756592', 'cevichealpaso@faster.com.ec', 1286, '2', '1636833955', 'active'),
(717, 'Pizza Burger ', '12345', '0979738514', 'pizzaburger@faster.com.ec', 1288, '2', '1637448068', 'active'),
(718, 'Inka Burger', '12345', '0987943423', 'dmaldonado@inka.com.ec', 1290, '2', '1637953065', 'active'),
(719, 'Pernil Sym', '12345', '0989854444', 'pernilsym@faster.com.ec', 1292, '2', '1638020986', 'active'),
(720, 'Licorería Locos X Beber ', '12345', '0990744670', 'ronny.suarez2016@uteq.edu.ec', 1294, '2', '1638044959', 'active'),
(721, 'Verde - Café', '12345', '0995122516', 'verdecafe@faster.com.ec', 1296, '2', '1638052670', 'active'),
(722, 'Heladería Encholados ', '12345', '0967097902', 'echoladosmanta@faster.com.ec', 1298, '2', '1638127073', 'active'),
(723, 'Cholados Y Algo Mas ', '12345', '0990695883', 'xavi_bk@yahoo.com', 1300, '2', '1638628484', 'active'),
(724, 'La Cava Río Lelia ', '123', '0992474649', 'lacavariolelia@faster.com.ec', 1302, '2', '1638742932', 'active'),
(725, 'La Cava Chone', '123', '0981873963', 'lacavaavchone@faster.com.ec', 1304, '2', '1638743302', 'active'),
(726, 'Pizza House ', '12345', '0994675160', 'muratirolf04@gmail.com', 1306, '2', '1639240864', 'active'),
(727, 'Picaditas El Rincón Futbolero', '12345', '0984700455', 'nenitasinti@hotmail.com', 1308, '2', '1639253936', 'active'),
(728, 'D Lunitas ', '12345', '0994765696', 'dlunitas@faster.com.ec', 1310, '2', '1639254353', 'active'),
(729, 'Los Chamos Fast Food ', '12345', '0963121849', 'loschamosfast@faster.com.ec', 1312, '2', '1639835316', 'active'),
(730, 'Amazonas Yasuni', '12345', '0992002620', 'amazonas.yasuni2017@gmail.com', 1314, '2', '1639921896', 'active'),
(731, 'Wilson Pizza', '12345', '0999394675', 'wilson343526@gmail.com', 1316, '2', '1640551200', 'active'),
(732, 'El Libanes ', '12345', '0996000921', 'ellibanes@faster.com.ec', 1318, '2', '1641585526', 'active'),
(733, 'Go Whisky ', '12345', '0983703549', 'gowisky@faster.com.ec', 1320, '2', '1641677944', 'active'),
(734, ' Ford Wings', '12345', '0993302082', 'royerk.95@gmail.com', 1322, '2', '1641743377', 'active'),
(735, 'Nifu Nifa', '12345', '0995868280', 'nifunifa.sd@gmail.com', 1324, '2', '1642266157', 'active'),
(736, 'El Taquerito', '12345', '0963828832', 'eltaquerito@faster.com.ec', 1326, '2', '1642366527', 'active'),
(737, 'Brazzuca Asadero ', '12345', '0990570304', 'maryjif1709@gmail.com', 1328, '2', '1642797984', 'active'),
(738, 'Prieta Manaba ', '12345', '0979060557', 'prietamanabaexpress@gmail.com', 1330, '2', '1642799413', 'active'),
(739, 'Chicho La Libertad', '12345', '0962908295', 'chicho@faster.com.ec', 1332, '2', '1642888769', 'active'),
(740, 'Parrillada De Lupe', '12345', '0978973719', 'parrilladadelupe@faster.com.ec', 1334, '2', '1642977236', 'active'),
(741, 'Supermercado La Economía ', '12345', '0997284916', 'amecucol@hotmail.com', 1336, '2', '1643249928', 'active'),
(742, 'Liquor Box ', '12345', '0980352290', 'liquor4@faster.com.ec', 1338, '2', '1643403588', 'active'),
(743, 'Delicias De Meche ', '12345', '0978614612', 'deliciasmeche@faster.com.ec', 1340, '2', '1643463275', 'active'),
(744, 'Icaro Pizza', '12345', '0988990383', 'icaropizza@faster.com.ec', 1342, '2', '1643489236', 'active'),
(745, 'Leños Pizza', '12345', '0990839629', 'leñospizza@faster.com.ec', 1344, '2', '1645155357', 'active'),
(746, 'El Buen Sabor 3', '12345', '0993949260', 'elbuensabor3@faster.com.ec', 1346, '2', '1645666788', 'active'),
(747, 'Barón De Las Mollejas Santo Do', '12345', '0939298705', 'marcmorn11@gmail.com', 1348, '2', '1645669171', 'active'),
(748, 'Kfc Shopping ', '12345', '0969764774', 'kfcshoppingsd@faster.com.ec', 1350, '2', '1646359967', 'active'),
(749, 'Fritadas San Blas', '123', '0984999870', 'maralemol90@hotmail.com', 1352, '2', '1646945837', 'active'),
(750, 'Señora Pizza Gran Aki', '123', '0981008935', 'senorapizzaaki@faster.com.ec', 1354, '2', '1647440290', 'active'),
(751, 'Nuwa', '12345', '0964043629', 'nuwa@faster.com.ec', 1356, '2', '1647633914', 'active'),
(752, 'Faster Market Licores ', '123', '0980008742', 'marketlicores@faster.com.ec', 1358, '2', '1647650564', 'active'),
(753, 'Ela Brownie Artesanal', '12345', '0996644857', 'snavarreteforero@gmail.com', 1360, '2', '1648656425', 'active'),
(754, 'Asadero Galaxis ', '12345', '0980271687', 'luisinho_52_10@hotmail.com', 1362, '2', '1648853890', 'active'),
(755, 'Hannana Sona', '123', '0987462639', 'hannana@faster.com.ec', 1364, '2', '1649377243', 'active'),
(756, 'Asadero Galaxi Santa Martha ', '1234', '0980271687', 'galaxi@faster.com.ec', 1366, '2', '1649864635', 'active'),
(757, 'La Mia Alitas', '12345', '0939814255', 'cbastidas88@outlook.com', 1368, '2', '1651029119', 'active'),
(758, 'Faster Market Gye', '123', '0989222177', 'vilbaqpao@hotmail.es', 1370, '2', '1651786923', 'active'),
(759, 'El Cafe Del Tanque ', '1234', '0997223008', 'carlosmachuca33@gmail.com', 1372, '2', '1652301139', 'active'),
(760, 'Del Tanque Ribs ', '1234', '0997223008', 'tanqueribs@faster.com.ec', 1374, '2', '1652303542', 'active'),
(761, 'Delicias Express', '1234', '0963666437', 'deliciasexpress1993@gmail.com', 1376, '2', '1652308622', 'active'),
(762, 'Choclo Loco', '12345', '0967570025', 'chocloloco@faster.com.ec', 1378, '2', '1652392634', 'active'),
(763, 'Shawarma Express D Javi', '12345', '0980222236', 'shawarmaexpress@faster.com.ec', 1380, '2', '1652734920', 'active'),
(764, 'Noyo Heladeria Chorrera ', '123', '0939985898', 'noyo@faster.com.ec', 1382, '2', '1652972005', 'active'),
(765, 'Noyo Heladeria  Tsachila', '123', '0982664141', 'noyotsachila@faster.com.ec', 1384, '2', '1652987643', 'active'),
(766, 'La Duquesa', '123456', '0993073135', 'laduquesaec@hotmail.com', 1386, '2', '1654550559', 'active'),
(767, 'Iglu Fruz Frozen Yogurt', '123', '0963367002', 'lacasadelmorocho@faster.com.ec', 1388, '2', '1656194531', 'active'),
(768, 'Chifa Kuan', '123', '979082800', 'chifa.k20@gmail.com', 1390, '2', '1656975735', 'active'),
(769, 'Fesfy', '12345', '0996493990', 'mashr4@hotmail.com', 1392, '2', '1657206723', 'active'),
(770, 'Rey Alitas ', '12345', '0986937522', 'johisortega44@gmail.com', 1394, '2', '1658433525', 'active'),
(771, 'Premium Coffe ', '123456', '0988088848', 'azucena1984palacios@gmail.com', 1396, '2', '1658443206', 'active'),
(772, 'Granilate ', '123456', '0963280380', 'fausto.j.ch.r@hotmail.com', 1398, '2', '1660258099', 'active'),
(773, 'Las Alitas Del Buen Sabor', '123', '0982413803', 'roxantom2428@gmail.com', 1400, '2', '1661639187', 'active'),
(774, 'Mostacho', '123', '0992508669', 'mostacho@faster.com.ec', 1402, '2', '1662237690', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fooddelivery_adminlogin`
--
ALTER TABLE `fooddelivery_adminlogin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fooddelivery_allies`
--
ALTER TABLE `fooddelivery_allies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fooddelivery_city`
--
ALTER TABLE `fooddelivery_city`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cname` (`cname`);

--
-- Indexes for table `fooddelivery_restaurant`
--
ALTER TABLE `fooddelivery_restaurant`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fooddelivery_res_owner`
--
ALTER TABLE `fooddelivery_res_owner`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `fooddelivery_adminlogin`
--
ALTER TABLE `fooddelivery_adminlogin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `fooddelivery_allies`
--
ALTER TABLE `fooddelivery_allies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fooddelivery_city`
--
ALTER TABLE `fooddelivery_city`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `fooddelivery_restaurant`
--
ALTER TABLE `fooddelivery_restaurant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1403;

--
-- AUTO_INCREMENT for table `fooddelivery_res_owner`
--
ALTER TABLE `fooddelivery_res_owner`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=775;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
