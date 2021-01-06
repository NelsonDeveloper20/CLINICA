<?php

//try{
include("../db.php");
if(isset($_POST['idtipodocumento'])){
  echo 'entra';
if($_FILES['file']['name']!= ""){//SI EXISTE ARCHIVO
$fecha= date("m-d,m:s");
$formfec = str_replace('-', '', $fecha);
$formfec = str_replace(',', '', $formfec);
$formfec = str_replace(':', '', $formfec);
$filename = $_FILES['file']['name'];
$idtrabjador =$_SESSION['idTrabajador'];
$idtipodocumento =$_POST['idtipodocumento'];
$idtipodocumentotrabjador =$_POST['idtipodocumentotrabjador'];
$rutaarchivo =$_POST['rutaarchivo'];
$nombrearchivo =$formfec.$_POST['nombrearchivo'];
date_default_timezone_set('GMT');
 
//echo 'IDTRABJADOR ES: '.$idtrabjador.'idtipodoc:'.$idtipodocumento.'idtipodocumentotrabajdo:'.$idtipodocumentotrabjador.'ruraarciv:'.$rutaarchivo.'nombrarchivo:'.$nombrearchivo;

$location = "../Documentos/".$formfec.$filename; 
if (move_uploaded_file($_FILES['file']['tmp_name'], $location)){   
  $query = "call Usp_InsertArchivo('$idtrabjador','$idtipodocumento','$idtipodocumentotrabjador','$rutaarchivo','$nombrearchivo')";
  mysqli_query($conn, $query);
  echo 'Success'; 
} else { 
  echo 'Failure'; 
}

}
}

if (isset($_POST['eliminararchivo'])){
  $idarchivo=$_POST['idarchivo'];
  $nomarchivo=$_POST['archivo'];
  $query = "call Usp_eliminarArchivoById('$idarchivo')";
  mysqli_query($conn, $query);
  //echo 'Success file'; 
/*
  $nombrearchivo = 'sample.jpg';

$directorio = '../Documentos/'.$nomarchivo;

if (file_exists($directorio))
{
$deleted= unlink($directorio);

if ($deleted)
 {
  echo "elimnado";
 }else{
   echo "no se puedo eliminar";
   }
}
else
{
    echo "no existe";
}*/



}
/*
} catch (Exception $e) {
    echo 'errror';
  }*/

?>