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
<h3 class="m-0" style="font-size: 24px;
    font-weight: 700;    text-align: center;">INSTRUCCIONES 
</h3> 
</div>
<ul class="list-group list-group-flush">
<li class="list-group-item p-3">
<div class="row">
<div class="col-lg-3">
                
</div>
<div class="col-lg-6">  
    <div class="table-responsive" style="text-align: center;">
   
<p style="     font-size: 27px;
    text-align: initial;"><span style="font-weight: 600;">
En la siguiente etapa, podrás validar cada documento disponible con el tipo y la vigencia. 
Por favor confirma que sea el correcto para el tipo de documento.<br>
Si no está vigente infórmanos!
<br>
<!-- (<b style="font-weight: 600;
    font-size: 21px;">
Si,
No,
Si Pero no vigente,
Si Pero no está vigente,
Pendiente
</b>) -->
</span> 
</p>

<div class="col">
<button type="button" style="width: 50%;font-size: 14px;font-weight: 700;" class="btn btn-primary"  onclick="nextnpage();">
<span>Continuar  </span><i class="fa fa-chevron-right fa-5"></i></button>
</div>    
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
function nextnpage(){ 
    window.location.replace("documentMedic.php");

}
var nombrecompleto=localStorage.getItem("nombrepuesto"); 
document.getElementById("Lblperfil").innerHTML =nombrecompleto;
</script>
  </form>