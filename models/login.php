<?php
include('../db.php');

if (isset($_POST['ingresar'])){
$usuario = $_POST['usuario'];
$clave = $_POST['clave'];
$query = "call Usp_LoginUsuario('".$usuario."','".$clave."')";
$result_tasks = mysqli_query($conn, $query);    
$count=0; 
$idtrabajador='';
$idpuesto='';
$idperfil='';
$nombrepuesto='';
$nombrecompleto='';
while($row = mysqli_fetch_assoc($result_tasks)){ 
    $idtrabajador= $row['idTrabajador'];  
    $idpuesto= $row['idPuestoArchivo'];  
    $idperfil= $row['IdPerfil'];  
    $nombrepuesto= $row['PuestoArchivo']; 
    $nombrecompleto=$row["NombreCompleto"];
    $_SESSION['idTrabajador']= $row['idTrabajador'];  
    $_SESSION['idPuestoArchivo']= $row['idPuestoArchivo'];  
    $_SESSION['IdPerfil']= $row['IdPerfil'];  
    $_SESSION['PuestoArchivo']= $row['PuestoArchivo']; 
    $_SESSION['NombreCompleto']=$row["NombreCompleto"];
$count++;
} 
$myArr = array($idtrabajador, $idpuesto, $idperfil, $nombrepuesto,$nombrecompleto); 

$myJSON = json_encode($myArr);

echo $myJSON;
if($count<1){
    $_SESSION['message'] = 'Usuario ó clave incorrecto';
    $_SESSION['message_type'] = 'danger';
  header('Location: ../view/login.php');
}else{
    $_SESSION['datosuser'] = $myJSON;
    if($_SESSION['PuestoArchivo']=='CLINICA'){
        header('Location: ../view/listTrabajadores.php');
    }else{
    header('Location: ../view/bienvenido.php');
    }
} 

}

?> 
