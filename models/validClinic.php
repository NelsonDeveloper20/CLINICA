<?php

include("../db.php");
if (isset($_POST['dni_n'])){ 
  $dnitrabajador_n =$_POST['dni_n'];
  $nombretrabajador_n =$_POST['nombre_n']; ;
  $querys = "call usp_exportarDocumentoClinica('$dnitrabajador_n','$nombretrabajador_n')";
  $results= mysqli_query($conn, $querys); 
  $dbdata = array();
  while($rows =mysqli_fetch_assoc($results)){ 
  $dbdata[]=$rows;
  }
  //echo json_encode($json);
  
  echo json_encode($dbdata);
  
      }
if (isset($_POST['dni'])){
$dnitrabajador =$_POST['dni'];
$nombretrabajador =$_POST['nombre'];

$query = "call Usp_ListarValidarClinica('$dnitrabajador','$nombretrabajador')";
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

if (isset($_POST['validacion'])){
  $observacion =$_POST['observacion'];
  $estado =$_POST['estado'];
  $idDoctrabj =$_POST['idDoctrabj'];
  
  $query = "call usp_validarClinica('$observacion','$estado','$idDoctrabj')";
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