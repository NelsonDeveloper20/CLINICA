<?php include("../db.php"); 
include('../includes/header.php'); 
if (isset($_SESSION['idTrabajador'])) {
    
}else{
    header('Location: login.php');
}
if($_SESSION['PuestoArchivo'] !='CLINICA'){
    header('Location: login.php');
}
?>
<script type="text/javascript" src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
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
}  .hiidenn{
            display:none;
        }
    </style>
 <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="https://unpkg.com/xlsx@0.15.1/dist/xlsx.full.min.js"></script>
  
<form id="form1" ><div class="loader"></div>
       
<div class="row">
<div class="col-lg-12" style="    padding-left: 0px;
    padding-right: 0px;
    border-top-width: 5px;
    margin-top: 0px;">
<div class="card card-small mb-4">
<div class="card-header border-bottom">
<h3 class="m-0">Validacion del administrador
</h3> 

</div>
<ul class="list-group list-group-flush">
<li class="list-group-item p-3">
<div class="row">
<div class="col-lg-1">
                
</div>
<div class="col">
    <div class="modal fade" id="modalComentario" tabindex="-1" role="dialog" aria-labelledby="modalComentario" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Comentario</h5>
        <button type="button" class="close" data-dismiss="modal" onclick="hideModal();" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
          <textarea  id="TxtComentario" placeholder="Ingrese Cometario" class="form-control" ></textarea>
      </div>
      <div class="modal-footer">               
          <button type="button" id="BtnCancelar" class="btn btn-secondary" onclick="hideModal();">Cancelar</button>
          <button type="button" id="BtnGuadar" class="btn btn-primary" onclick="validaRechazado();">Guardar</button>
            
          
    <asp:HiddenField ID="HndId"  />
      </div>
    </div> 
  </div>
</div> 
        <div   class="row" >
            
        <div class="col-lg-4"  style="display:none"> 
        <div class="form-group"> 
        <input type="text" id="TxtDni" class="form-control" placeholder="Buscar por DNI" />
        </div>            
        </div>

        <div class="col-lg-4"  style="display:none">
        <div class="form-group"> 
        <input type="text" id="TxtNombre"   class="form-control" placeholder="Buscar por Nombre"/>
        </div>
        </div>  
         
    <div class="col-lg-4">
        <button type="button" ID="BtnBuscar"  class="btn btn-primary" onclick="buscarTrabajador();" style="display:none;">Buscar <i class="fa fa-search" aria-hidden="true"></i></button>
        <button type="button" id="BtnExportar" class="btn btn-primary" onclick="exportar();">Exportar <i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
    </div>
            <br />
            <br />
            <h6 Style="font-weight: 800;
                    font-weight: 800;
                    font-size: 22px;
                    padding-left: 14px;
            ">
<span id="NombreTrabajador"   Text="" Style="font-weight: 500;"></span>  <br />
</h6>
        </div>
    <div class="table-responsive">
    <table cellspacing="0" rules="all" class="table-bordered" border="1" id="ContentPlaceHolder1_GvDocs" style="border-collapse:collapse;">
    <thead>
    
        <tr style="background-color:#F0F1F3;font-size:12pt;"> 
        <th scope="col" rowspan="2">Documento</th> 
        <th scope="col" colspan="4" style="display:none; width: 30%;text-align: center;">Archivos Entregados</th> 
        </tr>        
        </tr>
        <tr>
        <th>Nombre</th>
        <th>Accion</th>
        <th>Resultado</th>
        <th>Obserbación</th> 
        </tr>
    </thead><tbody id="listaresult"> 
<td colspan="6">
<div class="col-lg-12" style="text-align: center;
width: 102%;
font-size: 14px;
margin-top: 20px;
padding-right: 50px;"> 
<div class="form-group"> 
No hay registros
</div>            
</div>
</td>
		</tbody></table>
        <div style="display:none">
        <table cellspacing="0" rules="all" class="table-bordered" border="1" id="exporttable" style="border-collapse:collapse;">
    <thead>
    <tr style="background-color:#F0F1F3;font-size:12pt;" class="bg-primary"> 
                <th scope="col">Trabajador</th>
                <th scope="col">Documento</th>
                <th scope="col">Archivos entregados</th> 
                <th scope="col">Estado Validacion</th> 
                <th scope="col">Validacion Clinica</th> 
                <th scope="col">Observacion</th> 
			</tr>
    </thead><tbody id="listaresult_export"> 
<td colspan="6">
<div class="col-lg-12" style="text-align: center;
width: 102%;
font-size: 14px;
margin-top: 20px;
padding-right: 50px;"> 
<div class="form-group"> 
No hay registros
</div>            
</div>
</td>
		</tbody></table></div>
    </div>    
  
<div class="row">
<div class="col-lg-2">                
</div>
<div class="col">

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

<input type="hidden" id="idDoctrabaj">
<input type="hidden" id="idcheck">
<script>
        function openModal() {
            
           document.getElementById("TxtComentario").value='';
            $("#modalComentario").modal();
        }
        function hideModal() {
            var idchk=document.getElementById("idcheck").value;
            document.getElementById(idchk).checked=false;
            $('#modalComentario').modal('hide');
        }
    
var TxtDni = document.getElementById("TxtDni");
var TxtNombre = document.getElementById("TxtNombre");
TxtDni.addEventListener("keyup", function(event) {
  if (event.keyCode === 13) {
   event.preventDefault();
   document.getElementById("BtnBuscar").click();
  }
});
TxtNombre.addEventListener("keyup", function(event) {
  if (event.keyCode === 13) {
   event.preventDefault();
   document.getElementById("BtnBuscar").click();
  }
});
function exportar(){
    const queryString = window.location.search; 
const urlParams = new URLSearchParams(queryString);
const searchdni = urlParams.get('id') 
    var dni=searchdni;//document.getElementById("TxtDni").value;
    var nombres=document.getElementById("TxtNombre").value;
    if(dni !='' || nombres !=''){
    let formData = new FormData();           
    formData.append("dni_n", dni);
    formData.append("nombre_n", nombres); 
    $.ajax({
        type: 'post',
        method: 'post',
        url: '../models/validClinic.php',
        data: formData,
        dataType: 'json',
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function(){
        },
        success: function(data){ 
        var html=''; 
        $('#listaresult_export').html(''); 
        console.log('-----------------------');
        var count=0;

        var myJSON = JSON.stringify(data);
       //console.log('OKAS: '+myJSON);
        for(i=0; i<data.length; i++){  
            html +=`<tr>`;
            html +=`<td>`+data[i].NombreCompleto+`</td>`;     
            html +=`<td>`+data[i].TipoDocumento+`</td>`;
            html +=`<td>`+data[i].nombreArchivo+`</td>`;
            html +=`<td>`+data[i].estadovalidacion+`</td>`;
            html +=`<td>`+data[i].ValidacionClinica+`</td>`;
            html +=`<td>`+data[i].Observacion+`</td>`;       
            html +=`</tr>`;

        }
        if(count==0){
            var htm=`
            <td colspan="6">
<div class="col-lg-12" style="text-align: center;
width: 102%;
font-size: 14px;
margin-top: 20px;
padding-right: 50px;"> 
<div class="form-group"> 
No hay registros
</div>            
</div>
</td>`;

document.getElementById("NombreTrabajador").innerHTML ='';
        $('#listaresult_export').html(htm); 
        } 
        $('#listaresult_export').html(html); 
        ExportExcel('csv');//xlsx
        },
        error: function(xhr, status, error) {
             if(xhr.responseText=="errror"){
                console.log('intente denuevo');
            }else{
        console.log("err: "+xhr.responseText);
        } 
        }
    });
         
  }
}function ExportExcel(type, fn, dl) {
   var elt = document.getElementById('exporttable');
   var wb = XLSX.utils.table_to_book(elt, {sheet:"Sheet JS"});
   return dl ?
      XLSX.write(wb, {bookType:type, bookSST:true, type: 'base64'}) :
      XLSX.writeFile(wb, fn || ('DocValidado.' + (type || 'xlsx')));
}


function buscarTrabajador(){
    const queryString = window.location.search; 
const urlParams = new URLSearchParams(queryString);
const searchdni = urlParams.get('id') 
    var dni=searchdni;//document.getElementById("TxtDni").value;
    var nombres=document.getElementById("TxtNombre").value;
    document.getElementById("NombreTrabajador").innerHTML='';
  if(dni !='' || nombres !=''){
    let formData = new FormData();           
    formData.append("dni", dni);
    formData.append("nombre", nombres); 
    $.ajax({
        type: 'post',
        method: 'post',
        url: '../models/validClinic.php',
        data: formData,
        dataType: 'json',
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function(){
        },
        success: function(data){
        //console.log('ok: '+data);
        var myJSON = JSON.stringify(data);
       // console.log('OKAS: '+myJSON);
        //let jsonObject = JSON.parse(jsonString);
        var html='';
        var nombrecompleto='';
        $('#listaresult').html(''); 
        console.log('-----------------------');
        var count=0;

        for(i=0; i<data.length; i++){ 
            nombrecompleto=data[i].NombreCompleto;
            var rowspan='';
            if(rowspan!='1'){
                rowspan= data[i].rowsfile;
            }
            html +=`<tr>`;
            html +=`<td rowspan="${rowspan}">`+data[i].TipoDocumento+`</td>`;
            if(data[i].rowsfile=='1'){
            html+='<td colspan="4"></td>';
            }
            html+=`</tr>`; 

            if(data[i].archivos !='0'){
var archivos = JSON.parse(data[i].archivos);     
for(ia=0; ia<archivos.length; ia++){ 
    html +='<tr>';
    html +=`<td style="white-space: nowrap;">`+archivos[ia].nombreArchivo+`</td>`;
    html +=`<td  style="white-space: nowrap;"><a href="verdocumento.php?id=`+archivos[ia].idArchivoTrabajador+`" target="_blank">Ver Doumento<a/></td>`;
    if(archivos[ia].ValidacionClinica=='Ok'){
        html +=`<td  style="white-space: nowrap;"><input   type="checkbox"   checked><span >OK</span><span style="margin-left: 8px;">
    <input  type="checkbox" id="chkrech`+archivos[ia].idArchivoTrabajador+`" onclick="valid(this,'`+archivos[ia].idArchivoTrabajador+`');"><span >Rechazado</label></span>
    </td>`;
    }else if(archivos[ia].ValidacionClinica=='Rechazado'){
        html +=`<td  style="white-space: nowrap;"><input   type="checkbox" onclick="validsucces('`+archivos[ia].idArchivoTrabajador+`');"><span >OK</span><span style="margin-left: 8px;">
    <input  type="checkbox" id="chkrech`+archivos[ia].idArchivoTrabajador+`"  checked ><span >Rechazado</label></span></td>`;
    }else{
        html +=`<td  style="white-space: nowrap;"><input   type="checkbox" onclick="validsucces('`+archivos[ia].idArchivoTrabajador+`');"><span >OK</span><span style="margin-left: 8px;">
    <input  type="checkbox" id="chkrech`+archivos[ia].idArchivoTrabajador+`"  onclick="valid(this,'`+archivos[ia].idArchivoTrabajador+`');" ><span >Rechazado</label></span></td>`;
    } 
    html+='<td  style="white-space: nowrap;">'+archivos[ia].Observacion+'</td></tr>';
} 
}

        }
        if(count==0){
            var htm=`
            <td colspan="6">
<div class="col-lg-12" style="text-align: center;
width: 102%;
font-size: 14px;
margin-top: 20px;
padding-right: 50px;"> 
<div class="form-group"> 
No hay registros
</div>            
</div>
</td>`;

document.getElementById("NombreTrabajador").innerHTML ='';
        $('#listaresult').html(htm); 
        }
        document.getElementById("NombreTrabajador").innerHTML ='Trabajador: '+nombrecompleto;
        $('#listaresult').html(html); 
        
        },
        error: function(xhr, status, error) {
             if(xhr.responseText=="errror"){
                console.log('intente denuevo');
            }else{
        console.log("Validado: "+xhr.responseText);
        } 
        }
    });
         
  }
}
function valid(ev,id){
     
document.getElementById("idDoctrabaj").value=id;
document.getElementById("idcheck").value='chkrech'+id;
    openModal();
}
function validsucces(id){
    sendvalidate('','Ok',id);
} 
 
function validaRechazado(){

    var iddoc_trabaj=document.getElementById("idDoctrabaj").value;
    var observacion=document.getElementById("TxtComentario").value;
    if(observacion==''){
          swal({ 
  text: "Ingrese Comentario!",
  icon: "warning",
});
    }else{

    sendvalidate(observacion,'Rechazado',iddoc_trabaj);
    }
    
}
function sendvalidate(observacion,etado,iddoctrabaj){
    let formData = new FormData();           
    formData.append("validacion", 'validacion');
    formData.append("observacion", observacion);       
    formData.append("estado", etado);
    formData.append("idDoctrabj", iddoctrabaj); 
    $.ajax({
        type: 'post',
        method: 'post',
        url: '../models/validClinic.php',
        data: formData,
        dataType: 'json',
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function(){
        },
        success: function(data){
            //console.log('ok: '+data);
        //var myJSON = JSON.stringify(data);
        //console.log('OKAS: '+myJSON);
        if(data[0].msj=='0'){
        swal({title:'Validacion',text:"Documento Validado correctamente",icon:"success"})
        .then((value) => {
            buscarTrabajador();
            //location.reload();            
            $('#modalComentario').modal('hide');
        });
        }else{
            swal({ 
  text: "Intente Denuevo!",
  icon: "warning",
});
        }
        },
        error: function(xhr, status, error) {
             if(xhr.responseText=="errror"){
                console.log('intente denuevo');
            }else{
        console.log("Validado: "+xhr.responseText);
        } 
        }
    });
}
buscarTrabajador();
</script>
  </form> 