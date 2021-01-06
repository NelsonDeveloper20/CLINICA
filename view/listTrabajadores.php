<?php include("../db.php"); ?>
<?php include('../includes/header.php'); 
if (isset($_SESSION['idTrabajador'])) {
    
}else{
    header('Location: login.php');
}
if($_SESSION['PuestoArchivo'] !='CLINICA'){
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
    font-weight: 700;
    color: #3d5170;
    font-size: 1.2052rem;
/*
font-size: 1.2052rem;S
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
body{
    background: white;
}
.card {
     
    box-shadow: 0 0.46875rem 2.1875rem rgb(255 255 255), 0 0.9375rem 1.40625rem rgb(251 251 251), 0 0.25rem 0.53125rem rgb(255 255 255), 0 0.125rem 0.1875rem rgb(255 255 255) !important;
}
.card-small {
    box-shadow: 0 2px 0 rgb(255 255 255), 0 4px 8px rgb(255 255 255 / 12%), 0 10px 10px rgb(255 255 255 / 6%), 0 7px 70px rgb(255 255 255 / 10%) !important;
}
</style>
<form id="form1" ><div class="loader"></div>
       
<div class="row" style="background: white;">
<div class="col-lg-12" style="padding-left: 0px;
    padding-right: 0px;
    border-top-width: 5px;
    margin-top: 0px;">
<div class="card card-small mb-4">
<div class="card-header border-bottom">
<h3 class="m-0">Listado de Trabajadores
</h3> 
<h6 style="display:none;"><span style="font-weight: 700;">Tu perfil corresponde a</span> <b>
<span ID="Lblperfil" Style="font-weight: 800;"  Text=""></span> </b> .<br />
</h6>
</div>
<ul class="list-group list-group-flush">
<li class="list-group-item p-3">
<div class="row">
<div class="col-lg-1">
                
</div>
<div class="col">
<div class="row" style="display:none">

<div class="col-lg-4"><p class="h1_clas"><span class="badge cyan" id="lblexistente">2</span>Documentos Existentes</p></div>

<div class="col-lg-4"><p class="h1_clas"><span class="badge amber" id="lblfaltante">6</span>Documentos Faltantes</p></div>

</div>
<script>
function datos(faltante,existente){
    $("#lblexistente").text(existente).trigger('change'); 
    $("#lblfaltante").text(faltante).trigger('change');  
}
</script>
    <div class="table-responsive">

    <table cellspacing="0" rules="all" class="table-bordered" border="1" id="ContentPlaceHolder1_GvDocs" style="width: 100%;border-collapse:collapse;">
		<tbody>
        <tr style="background-color:#F0F1F3;font-size:12pt;">
			<th scope="col">Trabajador</th>
            <th scope="col">Dni</th>
            <th scope="col" style="text-align: center;"> Puesto&nbsp;archivo </th>
            <th scope="col">Accion</th> 
		</tr>
        <?php
            $query = "call usp_listarTrabajadores()";
            $result_tasks = mysqli_query($conn, $query);     
            $faltante=0;
            $existente=0;

            while($row = mysqli_fetch_assoc($result_tasks)) { ?>
            <tr>
            <td><?php echo $row['NombreCompleto']; ?></td> 
            <td><?php echo $row['Dni']; ?></td> 
            <td><?php echo $row['puesto']; ?></td> 
            <td><a href="validClinica.php?id=<?php echo $row['Dni']; ?>" target="_blank">Documentos<a/></td> 
            </tr>
            <?php } 
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
         
</div>
</div></div></div></div>
<script>

var nombrecompleto=localStorage.getItem("nombrepuesto"); 
document.getElementById("Lblperfil").innerHTML =nombrecompleto;
</script>
  </form>