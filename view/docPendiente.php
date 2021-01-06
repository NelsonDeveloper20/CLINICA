<?php include("../db.php"); ?>
<?php include('../includes/header.php'); 
if (isset($_SESSION['idTrabajador'])) {
    
}else{
    header('Location: login.php');
}?>
<style>
        .hiidenn{
            display:none;
        }
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
        .file-upload {
            display: inline-block;
            overflow: hidden;
            text-align: center;
            vertical-align: middle;
            font-family: Arial;
            border: 1px solid #dcdcdc;
            background: #efefef;
            border-radius: 6px;
            -moz-border-radius: 6px;
            cursor: pointer;
            -webkit-border-radius: 6px;
        }

                  .file-upload:hover { 
                      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#0061a7', endColorstr='#007dc1',GradientType=0);
                      background-color: #c7c7c7;
                  }

/* The button size */
.file-upload {
    height: 30px;
}

.file-upload, .file-upload span {
        /*width: 90px;*/
        width: 55px;
}

        .file-upload input {
            /*top: 0;
            left: 0;
            margin: 0;
            font-size: 11px;
            font-weight: bold;
            opacity: 0;
            filter: alpha(opacity=0);*/
            width: 15px !important;
            */
            /* left: 0; */
            /* margin-left: -26px; */
            padding-left: -17px;
            margin: -22px;
            font-size: 11px;
            /* font-weight: bold; */
            /* text-size-adjust: auto; */
            /* opacity: 31; */
            filter: alpha(opacity=0);
        }

        .file-upload strong {
            font: normal 12px Tahoma,sans-serif;
            text-align: center;
            vertical-align: middle;
        }

        .file-upload span {
            top: 0;
            left: 0;
            display: inline-block;
            /* Adjust button text vertical alignment */
            padding-top: 5px;
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
    </style>
  <script type="text/javascript" src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <form id="form1" ><div class="loader"></div>       

       
<div class="row">
<div class="col-lg-12">
<div class="card card-small mb-4">
<div class="card-header border-bottom">
<h3 class="h1_clas">2. Completa
</h3> 
<h6><span style="font-weight: normal;">Por favor, carga los documentos pendientes en formato .pdf, jpg, png un documento por archivo, legible y en formato vertical</span> 

</h6>
</div>
<ul class="list-group list-group-flush">
<li class="list-group-item p-3">
<div class="row">
<!-- <div class="col-lg-1">
                
</div>-->
<div class="col">
<div id="divFiles"></div>
<div class="table-responsive">
<table cellspacing="0" rules="all" class="table-bordered" border="1" id="GvDocs" style="border-collapse:collapse;">
<thead>
<tr> 
<th scope="col" rowspan="2">Documento</th>
<th scope="col" rowspan="2">Cargar</th>
<th scope="col" colspan="4" style="display:none; width: 30%;text-align: center;">Archivos Entregados</th> 
</tr>
<tr>
<th>Nombre</th>
<th>Estado</th>
<th>Observacion</th>
<th>Accion</th> 
</tr>
</thead>
			<tbody id="listaresult">

		</tbody></table>
</div>
<div class="row">
<div class="col-lg-2">             
</div>
<div class="col"><br /><br />
<button type="button" onclick="redirect();" style="    width: 90px;font-size: 12px;font-weight: 700;" class="btn btn-primary" >
<span>Continuar  </span></button>
<h6>Al darle Continuar. Confirmo que los documentos corresponden a la documentación requerida
</h6>
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
        
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
       var filelist = new Array();
       var countlist=0;
       function redirect(){
    if(countlist!=0){
    window.location.replace("instruccionValida.php");
    }else{
        swal({ 
  text: "Para continuar debe cargar archivos!",
  icon: "warning",
});
    }
       }
async function updateList(e,idtipodocumento,idtdttrabjador){
    var count=0;
    var countsucc=0;
    for (var i = 0; i < e.files.length; ++i) {
        let formData = new FormData();           
        formData.append("idtrabajador", "");
        formData.append("idtipodocumento", idtipodocumento);
        formData.append("idtipodocumentotrabjador", idtdttrabjador);
        formData.append("rutaarchivo",'Documentos');
        formData.append("nombrearchivo", e.files[i].name);
        formData.append("file", e.files[i]);
    $.ajax({
        type: 'post',
        method: 'post',
        url: '../models/upload.php',
        data: formData,
        dataType: 'json',
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function(){
        },
        success: function(data){
        console.log('ok: '+data);
        },
        error: function(xhr, status, error) {
            if(xhr.responseText=="Success"){
                countsucc++;
            }else if(xhr.responseText=="errror"){
                console.log('intente denuevo');
            }else{
        console.log("Error al guardar: "+xhr.responseText);   } 
        
        console.log(""+xhr.responseText);  
        listardocumentos();
        } 
    });
    count++;
    }
    if(count>0){
        console.log('cargado correctamente');
        listardocumentos();
        
    }else{
        console.log('seleccione archivos');
    }

  } 
  function eliminarArchivo(idArchivo,nombre){
    let formData = new FormData();           
        formData.append("idarchivo", idArchivo); 
        formData.append("eliminararchivo", "eliminar"); 
        formData.append("archivo", nombre); 
    $.ajax({
        type: 'post',
        method: 'post',
        url: '../models/upload.php',
        data: formData,
        dataType: 'json',
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function(){
        },
        success: function(data){
        console.log('ok: '+data);
        },
        error: function(xhr, status, error) {
            if(xhr.responseText=="Success"){
                
            }else if(xhr.responseText=="errror"){
                console.log('intente denuevo');
            }else{
        console.log("Error al guardar: "+xhr.responseText);   } 
        
        console.log(""+xhr.responseText);  
        listardocumentos();
        } 
    });

  }
  
function listardocumentos(){
    countlist=0;
    var idtrabajador=<?php echo $_SESSION['idTrabajador'];?>; 
    let formData = new FormData();           
    formData.append("idtrabajador", idtrabajador);
    $.ajax({
        type: 'post',
        method: 'post',
        url: '../models/documentos.php',
        data: formData,
        dataType: 'json',
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function(){
        },
        success: function(data){ 
            
        var html='';
        var nombrecompleto='';
        $('#listaresult').html('');  
        for(i=0; i<data.length; i++){ 

            nombrecompleto=data[i].NombreCompleto;
            var rowspan='';
            if(rowspan!='1'){
                rowspan= data[i].rowsfile;
            } 
            html +=`<tr rowspan="${rowspan}">`; 
            html +=`<td rowspan="${rowspan}">`+data[i].TipoDocumento+`</td>`;             
html +=`<td rowspan="${rowspan}"><span class="file-upload" style="margin-right: 4px !important; margin-top: 4px !important;margin-bottom: 4px !important;"> 
<span><strong>Cargar</strong></span>
<input type="file" multiple="multiple" onchange="updateList(this,'`+data[i].idTipoDocumentos+`','`+data[i].idTipoDocumentoTrabajador+`');"  accept=".pdf,.jpg,.png,.jpeg"  style="position: absolute;display: block;background: #ffffff00;opacity: 0;">  
</span> </td>`;
console.log('---'+rowspan+'---');
if(data[i].rowsfile =='1'){
    html +='<td colspan="4"></td>';
    console.log('ES:'+i+' | '+data[i].rowsfile);
}
html+=`</tr>`; 

if(data[i].archivos !='0'){
    countlist++;
var archivos = JSON.parse(data[i].archivos); 
for(ia=0; ia<archivos.length; ia++){ 
    html+='<tr style="white-space: nowrap;font-size: 12px;"><td>'+archivos[ia].nombreArchivo+'</td>';    
    html+='<td style="white-space: nowrap;">'+archivos[ia].estado+'</td>';
    html+='<td style="white-space: nowrap;">'+archivos[ia].Observacion+'</td>';
    html +=`<td style="white-space: nowrap;">
    <a href="#" style="width: 1px;height: 29px;
    border-radius: 6px !important;    margin-right: 4px;"   onclick="eliminarArchivo('${archivos[ia].idArchivoTrabajador}','${archivos[ia].nombreArchivo}');" title="Eliminar">Eliminar</button></td></tr>`;
    
}
}
        }
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

  listardocumentos();
/*

*/
</script>
</form>

