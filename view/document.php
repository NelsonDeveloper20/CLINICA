<?php include('../includes/header.php'); ?>
<?php include("../db.php"); 
if (isset($_SESSION['idTrabajador'])) {
    
}else{
    header('Location: login.php');
}?>
<style>
          .progress {
  list-style: none;
  margin: 0;
  padding: 0;
  display: table;
  table-layout: fixed;
  width: 100%;
  color: #6c7680 !important;
    font-weight: 700;
}
.progress > a {
  position: relative;
  display: table-cell;
  text-align: center; 
  font-size: 0.6rem;
}
.progress > a:before {
  content: attr(data-step);
  display: block;
  margin: 0 auto;
  background: #DFE3E4;
  width: 3em;
  height: 3em;
  text-align: center;
  margin-bottom: 0.25em;
  line-height: 3em;
  border-radius: 100%;
  position: relative;
  z-index: 1000;
}
           .progress > a:after {
               content: '';
               position: absolute;
               display: block;
               background: #DFE3E4;
               width: 100%;
               height: 0.5em;
               top: 1.25em;
               left: 50%;
               margin-left: 1.5em\9;
               z-index: -1;
           }
.progress > a:last-child:after {
  display: none;
}
.progress > a.is-complete {
  color: #2ECC71;
}
.progress > a.is-complete:before, .progress > a.is-complete:after {
  color: #FFF;
  background: #2ECC71;
}
.progress > a.is-active {
  color: #3498DB;
}
.progress > a.is-active:before {
  color: #FFF;
  background: #3498DB;
  
}

/**
 * Needed for IE8
 */
.progress__last:after {
  display: none !important;
}

/**
 * Size Extensions
 */
.progress--medium {
  font-size: 1.5em;
}

.progress--large {
  font-size: 2em;
}

/**
 * Some Generic Stylings
 */
*, *:after, *:before {
  box-sizing: border-box;
}

h1 {
  margin-bottom: 1.5em;
}

.progress {
  margin-bottom: 3em;
}

a {
  color: #3498DB;
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}

body {
  text-align: center;
  color: #444;
}
.progress > a:after {
    content: '';
    position: absolute;
    display: block;
    background: #DFE3E4;
    width: 100%;
    height: 0.5em;
    top: 1.25em;
    left: 50%;
    margin-left: 1.5em\9;
    z-index: 3;
}

.ciculeprog{
   content: attr(data-step);
    display: block;
    margin: 0 auto;
    background: #DFE3E4;
    width: 3em;
    height: 3em;
    text-align: center;
    margin-bottom: 0.25em;
    line-height: 3em;
    border-radius: 100%;
    position: relative;
    z-index: 1000;
    right:-24px;
}

           .ciculeprog:after {
            content: '';
    position: absolute;
    display: block;
    background: #DFE3E4;
    width: 100%;
    height: 0.5em;
    top: 1.25em;
    left: 50%;
    margin-left: 1.5em\9;
    z-index: 3;
           }
  
  .float{
	display:none !important;
}

.my-float{
    margin-top: 19px;
        font-size: x-large;
        color:white;
}.myClass
    {
        border: 1px;
    }
    .myClass input
    {
        background-color:Gray;	
    }
    .myClass label
    {
        font-weight:bold;
    }
    .li::marker {
  color: blue;
}
.pagination { 
    color: white !important;}
    .titulo{
      margin-bottom: 0px;
    font-weight: 700;
    color: #525165;
    font-size: x-large; 
    }
       </style>
    
<script type="text/javascript" src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  <form id="form1" >
  
  

 
  
                <div class="card" >
<div class="col-lg-12"> 
<div class="">
<div class="row"> 
     
    

<ol class="progress" style="background-color: #ffffff00 !important;  margin-bottom: 2px; display:none;" >
 
 
    </ol>
    <div class="pagination pagination-centered pagination-large" style="bottom:0;display:none;">
       <ul class="page_control progress" id="heads"> 
      </ul>
   </div>

      
    <div ID="pnldocumets"   class="col-lg-12">
         
    <div class="pagination-container" >
    
    <div class="row">
    <!--<li data-page="-" ><a href="#" >&lt;</a></li>
    <li class="active" data-page="1"><a href="#" >1</a></li>
    <li data-page="2"><a href="#" >2</a></li>
    <li data-page="3"><a href="#" >3</a></li>
    <li data-page="4"><a href="#" >4</a></li>
    <li data-page="5"><a href="#" >5</a></li>-->



    <?php
            
            $query = "call Usp_List_DocumentosByTrabajador('".$_SESSION['idTrabajador']."')";
            $result_tasks = mysqli_query($conn, $query);    
             $count=0;
             $countitem=0;
            while($row = mysqli_fetch_assoc($result_tasks)) {?>
            <?php $count++; $countitem++;?>
   
            <?php if($countitem==1){?> 
              <?php echo '<script> document.getElementById("heads").insertAdjacentHTML("beforeend","<a id=control'.$count.' class=is-active data-page='.$count.'  data-step='.$count.'></a>");</script>'; ?>
            <div data-page="<?php echo $count?>" class="col-lg-12" >

            <p class="titulo"> <?php echo $row['TipoDocumento'];?></p>
            
                  <div  class="row" >
                  <?php 
                  $queries = json_decode($row['archivos']);  
                  foreach($queries as $display){ ?>              
                    <div class='<?php echo $display->files?>'> 
                      <div class="card-body" style="padding-top: 6px;   padding-bottom: 6px;    padding-left: 6px;    padding-right: 6px;">
                      <?php if($display->tipo !='.PDF'){?>               
                        <img src='../Documentos/<?php echo $display->nombreArchivo?>' style='height: 350px;width: auto; '> 
                       <?php }else{?>                 
                        <embed src='../Documentos/<?php echo $display->nombreArchivo?>' style='width: 100%;  height: 375px; ' type = 'application/pdf'>
                        <?php }?> 
                      </div> 
                    </div>                     
                  <?php } ?> 
                  </div>             
        <div class="row">
        <div class="col-lg-12" style="text-align: center;"> 
        <div class="form-check"> 
        <center>
        <table class="myClass">
        <tbody> 
        <?php 
        $estados = json_decode($row['estados']);  
        foreach($estados as $item){ ?>              
        <tr><td><input id="chk" type="checkbox"  <?php  if($item->idEstadoValidacion==$row['idEstadoValidacion']){ ?> checked <?php }?>  name="estado<?php echo $row['idTipoDocumentoTrabajador'] ?>"  value="<?php echo $item->idEstadoValidacion?>"><span ><?php echo $item->Descripcion?></span></td></tr> 
        <?php } ?>   
        </tbody></table>
        </center></div>
        </div>
        </div>
            <div class="pagination pagination-centered pagination-large" style="bottom:0;">
              <ul class="page_control ">
              <li data-page="+"><a href="#" onclick="continuar('<?php echo $row['idTipoDocumentoTrabajador'] ?>','estado<?php echo $row['idTipoDocumentoTrabajador'] ?>');" class="btn btn-primary">Continuar  </span><i class="fa fa-chevron-right fa-5"></i></a></li>
              </ul>
              </div>
            </div>  
            <?php }else{ ?>
              <div data-page="<?php echo $count?>" class="col-lg-12" style="display:none;" >              
              <p class="titulo"><?php echo $row['TipoDocumento'];?></p>
                  <div  class="row">                  
                  <?php 
                  $queries = json_decode($row['archivos']);  
                  foreach($queries as $display){ ?>              
                    <div class='<?php echo $display->files?>'> 
                      <div class="card-body" style="padding-top: 6px;   padding-bottom: 6px;    padding-left: 6px;    padding-right: 6px;">
                      <?php if($display->tipo !='.PDF'){?>               
                        <img src='../Documentos/<?php echo $display->nombreArchivo?>' style='height: 350px;width: auto; '> 
                       <?php }else{?>                 
                        <embed src='../Documentos/<?php echo $display->nombreArchivo?>' style='width: 100%;  height: 375px; ' type = 'application/pdf'>
                        <?php }?> 
                      </div> 
                    </div>                     
                  <?php }?> 
                  </div> 
                    <div class="row">
                    <div class="col-lg-12" style="text-align: center;"> 
                    <div class="form-check"> 
                    <center>
                    <table class="myClass">
                    <tbody> 
                    <?php 
                    $estados = json_decode($row['estados']);  
                    foreach($estados as $item){ ?>              
                    <tr><td><input id="chk" type="checkbox"  <?php  if($item->idEstadoValidacion==$row['idEstadoValidacion']){ ?> checked <?php }?>  name="estado<?php echo $row['idTipoDocumentoTrabajador'] ?>" value="<?php echo $item->idEstadoValidacion?>"><span ><?php echo $item->Descripcion?></span></td></tr>                    
                    <?php } ?>     
                    </tbody></table>
                    </center></div>
                    </div>
                    </div>

                  <div class="pagination pagination-centered pagination-large" style="bottom:0;">                  
                  <ul class="page_control">
                  <li data-page="+"><a href="#" class="btn btn-primary" onclick="continuar('<?php echo $row['idTipoDocumentoTrabajador'] ?>','estado<?php echo $row['idTipoDocumentoTrabajador'] ?>');">Continuar  </span><i class="fa fa-chevron-right fa-5"></i></a></li>
                  </ul>
                  </div>              
              </div>  
              <?php echo '<script> document.getElementById("heads").insertAdjacentHTML("beforeend","<a id=control'.$count.' data-page='.$count.' data-step='.$count.'></a>");</script>'; ?>
            <?php } ?>
            <?php } ?>



   <div class="pagination pagination-centered pagination-large" style="bottom:0;display:none">
       <ul class="page_control ">
        <!--    <li data-page="-" ><a href="#" >&lt;</a></li>
            <li class="active" data-page="1">
                <a href="#" >1</a>
            </li>
            <li data-page="2"><a href="#" >2</a></li>
            <li data-page="3"><a href="#" >3</a></li>
            <li data-page="4"><a href="#" >4</a></li>
            <li data-page="5"><a href="#" >5</a></li>-->
            <li data-page="+"><a href="#" class="btn btn-primary">Continuar  </span><i class="fa fa-chevron-right fa-5"></i></a></li>
      </ul>
   </div>

</div>
          
    
    </div>  
 
    </div>
</div>
</div>
</div> 
      
    <script>
$("input:checkbox").on('click', function() {
  // in the handler, 'this' refers to the box clicked on
  var $box = $(this);
  if ($box.is(":checked")) {
    // the name of the box is retrieved using the .attr() method
    // as it is assumed and expected to be immutable
    var group = "input:checkbox[name='" + $box.attr("name") + "']";
    // the checked state of the group/box on the other hand will change
    // and the current value is retrieved using .prop() method
    
    $(group).removeAttr('checked');
    $(group).prop("checked", false);
    $box.prop("checked", true);
  } else {
    $box.prop("checked", false);
  }
});

function continuar(id,estadogroup){
  
  var cboxes = document.getElementsByName(estadogroup);
    var len = cboxes.length;
    var estad='';
    for (var i=0; i<len; i++) {
    if(cboxes[i].checked==true){
      estad=cboxes[i].value;
    }
  }
  if(estad !=''){
    let formData = new FormData();           
    formData.append("iddocTrabajador", id);
    formData.append("idEstado", estad); 
    $.ajax({
        type: 'post',
        method: 'post',
        url: '../models/validateDoc.php',
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
             if(xhr.responseText=="errror"){
                console.log('intente denuevo');
            }else{
        console.log("Validado: "+xhr.responseText);
        } 
        }
    });
         
  }
}
var paginationHandler = function(){
    // store pagination container so we only select it once
    var $paginationContainer = $(".pagination-container"),
        $pagination = $paginationContainer.find('.pagination ul');

    // click event
    $pagination.find("li a").on('click.pageChange',function(e){
        e.preventDefault();


        // get parent li's data-page attribute and current page
        var parentLiPage = $(this).parent('li').data("page"),
            currentPage = parseInt( $(".pagination-container div[data-page]:visible").data('page') ),
            numPages = $paginationContainer.find("div[data-page]").length;
            //console.log("INI:"+parentLiPage+" FIN:"+currentPage+" CANT:"+numPages);
        // make sure they aren't clicking the current page
try{
        var idcontrol='control'+(currentPage+1);
        var lights = document.getElementsByClassName("is-active");
while (lights.length){
    lights[0].classList.remove("is-active");}
    var element = document.getElementById(idcontrol);
  element.classList.add("is-active");
}catch(e){}

        if ( parseInt(parentLiPage) !== parseInt(currentPage) ) {
            // hide the current page
            $paginationContainer.find("div[data-page]:visible").hide();

            if ( parentLiPage === '+' ) {
                // next page
                $paginationContainer.find("div[data-page="+( currentPage+1>numPages ? numPages : currentPage+1 )+"]").show();
            } else if ( parentLiPage === '-' ) {
                // previous page
                $paginationContainer.find("div[data-page="+( currentPage-1<1 ? 1 : currentPage-1 )+"]").show();
            } else {
                // specific page
                $paginationContainer.find("div[data-page="+parseInt(parentLiPage)+"]").show();
            }

        }
        if(currentPage==numPages){
          window.location.replace("docValidado.php");
        }
    });
};
$( document ).ready( paginationHandler );
    </script>
    </form>
