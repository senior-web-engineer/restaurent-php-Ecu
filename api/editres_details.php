<?php
include '../controllers/apicontroller.php';
include 'error_response.php';
$api = new apicontroller();
extract($_REQUEST);
if($res_id != "" && $rname != "" && $address != "" &&  $desc != "" && $open_time != ""  && $close_time != "" && $delivery_time !=""   && isset($file)  && isset($latitude) && $latitude != "" && isset($longitude) && $longitude != "" && isset($email) && $email != "" && isset($website) && $website && isset($city) && $city != "" && isset($location) && $location != "" && isset($del_charge) && $del_charge != "" && $phone != "" && $category !=""){
      if(isset($_FILES['file']['name']) && $_FILES['file']['name'] != "")
    {
                $filename=$_FILES['file']['name'];
                $tmp_file=$_FILES['file']['tmp_name'];
                $imageuploadpath="../uploads/restaurant/profile_".time().".png";
                $imagename="profile_".time().".png";
                $edit_details=$api->editrestaurantdetail_image($res_id,$rname,$address,$desc,$email,$phone,$website,$delivery_time,$open_time,$close_time,$category,$city,$location,$latitude,$longitude,$imagename,$currency,$del_charge);
    }else{
         $edit_details=$api->editrestaurantdetail($res_id,$rname,$address,$desc,$email,$phone,$website,$delivery_time,$open_time,$close_time,$category,$city,$location,$latitude,$longitude,$currency,$del_charge);   
    }
    if($edit_details)
    {  
        echo $edit_msg;
    }
    else
    {
        echo $no_record;
    }
}
else
{
    echo $error;
}



?>