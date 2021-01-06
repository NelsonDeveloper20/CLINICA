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
} </style>
<form id="form1" ><div class="loader"></div>
       
<div class="row">
<div class="col-lg-12" style="    padding-left: 0px;
    padding-right: 0px;
    border-top-width: 5px;
    margin-top: 0px;">
<div class="card card-small mb-4">
<div class="card-header border-bottom">
<h3 class="h1_clas">4. Espera la revisión de la Clínica
</h3> 
<h6 style=""><span style="font-weight: normal;">Mira cómo quedó tu file:</span> <b>
<span ID="Lblperfil" Style="font-weight: normal;display:none"  Text=""></span> </b> 
</h6>
</div>
<ul class="list-group list-group-flush">
<li class="list-group-item p-3">
<div class="row"> 
<div class="col">
<div class="row">

<div class="col-lg-4"><p class="h1_clas"></span> documentos existentes: <span class="" id="lblexistente"> </p> </div>

<div class="col-lg-4"><p class="h1_clas"></span> documentos faltantes: <span class="" id="lblfaltante"> </p></div>

</div>
<script>
function datos(faltante,existente){
    $("#lblexistente").text(existente).trigger('change'); 
    $("#lblfaltante").text(faltante).trigger('change');  
}
</script>
    <div class="table-responsive">

    <table cellspacing="0" rules="all" class="table-bordered" border="1" id="ContentPlaceHolder1_GvDocs" style="border-collapse:collapse;font-weight: normal;">
		<tbody>
        <tr style="background-color:#F0F1F3;font-size:12pt;">
			<th scope="col" rowspan="2" style="font-weight: 600;">Documento</th>
            <th scope="col" rowspan="2" style="font-weight: 600;">Existe</th>            
<th colspan="4" style="display:none">Archivos</th>
        </tr>
        </tr>
<tr style="background-color:#F0F1F3;font-size:12pt;">
<th style="font-weight: 600;">Nombre</th>
<th style="font-weight: 600;">Validación&nbsp;Trabajador</th> 
<th style="font-weight: 600;">Estado</th>
<th style="font-weight: 600;">Observación</th>
</tr>
        
        <?php
            $query = "call Usp_ListarDocumentosValidados('".$_SESSION['idTrabajador']."')";
            $result_tasks = mysqli_query($conn, $query);     
            $faltante=0;
            $existente=0;

            while($row = mysqli_fetch_assoc($result_tasks)) { ?>
            <tr>
            <td rowspan="<?php if($row['rowsfile']=="1"){ echo "";}else{echo $row['rowsfile'];} ?>"><?php echo $row['TipoDocumento']; ?></td>
            <td rowspan="<?php if($row['rowsfile']=="1"){ echo "";}else{echo $row['rowsfile'];} ?>"><?php if($row['archivos']=='0'){ echo 'No'; $faltante++;  }else{echo 'Si'; $existente++;} ?></td>
            <?php if($row['rowsfile']=="1"){?>    
            <td colspan="4"></td> 
            <?php }?>
            </tr>
            <!-- <td><hp echo $row['estado']; ?></td>  -->
            <?php if($row['archivos']!='0'){?>

<?php 
$archivos = json_decode($row['archivos']);  
foreach($archivos as $item){ ?>              
<tr style="    font-size: 12px;">
<td style="white-space: nowrap;"><?php echo $item->nombreArchivo?></td>
<td style="white-space: nowrap;"><?php echo $item->Estado?></td> 
<td style="white-space: nowrap;"><?php echo $item->ValidacionClinica?></td>
<td style="white-space: nowrap;"><?php echo $item->Observacion?></td>
</tr> 
<?php } ?>   
<?php  }?> 
<?php }?>  
            <?php 
          echo "<script> datos('".$faltante."','".$existente."');</script>"; ?>

	</tbody></table>
    </div>    
<div class="row">
<div class="col-lg-2">                
</div>                    
<div class="col-lg-2">                
</div>
</div>
                    
</div>
<div class="col-lg-1">
                
</div>
<div class="col-lg-10">
         
<div class="col"><br>
<button type="button" style="width: 90px;font-size: 12px;font-weight: 700;" class="btn btn-primary"  onclick="returnpage();">
<span>Continuar  </span>
</button>
</div>     
</div>
</div></div></div></div>
<script>
function returnpage(){
    window.location.replace("gracias.php");
}
var nombrecompleto=localStorage.getItem("nombrepuesto"); 
document.getElementById("Lblperfil").innerHTML =nombrecompleto;
</script>
  </form>