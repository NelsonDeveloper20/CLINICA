<?php
include("../db.php");
if (isset($_POST['idtrabajador'])){
    $idtrabajador =$_POST['idtrabajador'];
    
    $query = "call Usp_listarPendientes('$idtrabajador')";
    $result= mysqli_query($conn, $query);
    //$json = array();
    
    $json = array();
    $dbdata = array();
    while($row =mysqli_fetch_assoc($result)){ 
      $dbdata[]=$row;
    }
    //echo json_encode($json);
    echo json_encode($dbdata);
    }
?>