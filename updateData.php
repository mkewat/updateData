<?php
 
 $conn=new mysqli("localhost","demo000","demo1","demo000");
    
 if($conn){
 }
  else{
}

    $id = $_POST['id'];
    $title = $_POST['title'];

    $conn->query("update upload set id='".$id."',  title='".$title."' where id='".$id."'");

?>




