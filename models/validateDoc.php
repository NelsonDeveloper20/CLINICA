<?php 
//try{
include("../db.php");


if(isset($_POST['iddocTrabajador'])){
$iddocTrabajador =$_POST['iddocTrabajador'];
$idEstado =$_POST['idEstado'];

$query = "call Usp_validaDocumento('$idEstado','$iddocTrabajador')";
mysqli_query($conn, $query);
/*} catch (Exception $e) {
    echo 'errror';
  }*/
}
  
if(isset($_POST['idArchivoTrabajador'])){
  $iddocTrabajador =$_POST['idArchivoTrabajador'];
  $idEstado =$_POST['idEstado'];
  
  $query = "call Usp_validaDocumentov2('$idEstado','$iddocTrabajador')";
  mysqli_query($conn, $query);
}
  

?>