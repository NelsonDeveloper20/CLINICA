<?php include("../db.php"); ?>
<?php include('../includes/header.php'); 
if (isset($_SESSION['idTrabajador'])) {
    
}else{
    header('Location: login.php');
}
?>
<style>
        .list-group-item {
    padding: .75rem 1.25rem;
    margin-bottom: -1px;
    background-color: #fff;
    border: 1px solid rgba(0,0,0,.125);
    font-weight: 600 !important;
}
        .table-bordered td, .table-bordered th {
    border: 1px solid #dee2e6;
    padding-left: 9px !important;
}
.float{
    width: 33px !important;
}

.h1_clas{
    margin-bottom: .75rem;
    font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;
    font-weight: 70;
    color: #3d5170;
    font-size: 1.2052rem;
/*
font-size: 1.2052rem;
    letter-spacing: -.0625rem;
    line-height: 3rem;
    */
}

.badge {
    color: #fff !important;
    border-radius: .125rem;
    -webkit-box-shadow: 0 2px 5px 0 rgba(0,0,0,0.16), 0 2px 10px 0 rgba(0,0,0,0.12);
    box-shadow: 0 2px 5px 0 rgba(0,0,0,0.16), 0 2px 10px 0 rgba(0,0,0,0.12);
}
.cyan {
    background-color: #00bcd4 !important;
}
.amber {
    background-color: #ffc107 !important;
}
    </style>


<!-- <link rel="stylesheet" href="https://mdbcdn.b-cdn.net/wp-content/themes/mdbootstrap4/css/compiled-4.19.1.min.css?ver=4.19.1" rel="stylesheet">-->
<form id="form1" ><div class="loader"></div>
       
<div class="row">
<div class="col-lg-12" style="">
<div class="card card-small mb-4">
<div class="card-header border-bottom">
<h3 class="h1_clas">1. Lista
</h3>              <h6><span style="font-weight: normal;">Tu perfil corresponde a</span> <b>
<span ID="Lblperfil" Style="font-weight: normal;"  ><?php echo $_SESSION['PuestoArchivo']?></span> </b> .
<br /><span ID="ldldocs" style="    color: red;"></span></h6>
</div>
<ul class="list-group list-group-flush">
<li class="list-group-item p-3">
<div class="row"> 
<div class="col">
<div class="row">

<div class="col-lg-4"><p class="h1_clas"> </span>documentos existentes: <span  id="lblexistente"> </p></div>

<div class="col-lg-4"><p class="h1_clas"></span>documentos faltantes: <span  id="lblfaltante"></p></div>

</div>

<script>
function datos(faltante,existente){
    $("#lblexistente").text(existente).trigger('change'); 
    $("#lblfaltante").text(faltante).trigger('change');  
    if(faltante!=0){
    $("#ldldocs").text('Hay algunos documentos faltantes para tu rol.').trigger('change');  
    }
}
</script>
<div class="table-responsive">
<table cellspacing="0" rules="all" class="table-bordered" border="1" id="ContentPlaceHolder1_GvDocs" style="border-collapse:collapse;">
<thead>
<tr style="background-color:#F0F1F3;font-size:12pt;">
<th scope="col" rowspan="2">Documento</th>
<th scope="col" rowspan="2">Existe</th>
<th colspan="2" style="display:none">Archivos</th>
</tr>
<tr style="background-color:#F0F1F3;font-size:12pt;">
<th>Archivo</th>
<th>Validación&nbsp;Trabajador</th> 
</tr>
</thead> 
<tbody></div>

        <?php
        //.$_SESSION['idTrabajador'].",".$_SESSION['IdPerfil'].",".$_SESSION['idPuestoArchivo']
          $query = "call Usp_ListDocumentosFaltantes('".$_SESSION['idTrabajador']."','".$_SESSION['IdPerfil']."','".$_SESSION['idPuestoArchivo']."')";
          $result_tasks = mysqli_query($conn, $query);    
           $faltante=0;
           $existente=0;
          while($row = mysqli_fetch_assoc($result_tasks)) { ?>
<tr>
<td rowspan="<?php if($row['rowsfile']=="1"){ echo "";}else{echo $row['rowsfile'];} ?>"><?php echo $row['TipoDocumento']; ?></td>
<td rowspan="<?php if($row['rowsfile']=="1"){ echo "";}else{echo $row['rowsfile'];} ?>"><?php if($row['archivos']=='0'){ echo 'No'; $faltante++; }else{echo 'Si'; $existente++;} ?></td>

<?php if($row['rowsfile']=="1"){?>    
    <td colspan="2"></td> 
<?php }?>


</tr>
            <!-- <td><hp echo $row['estado']; ?></td>  -->
            <?php if($row['archivos']!='0'){?>
 
  
<?php 
$archivos = json_decode($row['archivos']);  
foreach($archivos as $item){ ?>  
 <tr> 
<td style="white-space: nowrap;"><?php echo $item->nombreArchivo?></td>
<td style="white-space: nowrap;"><?php echo $item->Estado?></td>  
</tr>
<?php }?>   

<?php  }else {?>
<!-- <td colspan="2"></td>  -->
<?php }?>  
<?php } 
echo "<script> datos('".$faltante."','".$existente."');</script>"; 
?>
</tbody></table>  
<div class="row">
<div class="col-lg-2">                
</div>                        
<div class="col-lg-2">                
</div>
</div>
          
     
</div> 
<div class="col-lg-10">
<div class="col"><br /><br />
<a href="instruccioncarga.php"   style="    width: 90px;
font-size: 12px;
font-weight: 700;" class="btn btn-primary"  OnClick="BtnContinuar_Click"><span>Continuar</span></a>
</div>      
</div>
</div></div></div></div>
  </form>
 