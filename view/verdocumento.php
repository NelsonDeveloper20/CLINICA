<?php 
 include("../db.php"); ?>
<?php include('../includes/header.php');
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
  color: #849397;
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
  input[type=checkbox], input[type=radio] {
    box-sizing: border-box;
    padding: 0;
    margin: 15px;
    -ms-transform: scale(3) !important;
    -moz-transform: scale(3);
    -webkit-transform: scale(3);
    -o-transform: scale(3);
}

  .float{
	position:fixed;
	width:60px;
	height:60px;
	bottom:40px;
	right:40px;
	background-color:#1d8cff;
	color:#FFF;
	border-radius:50px;
	text-align:center;
	box-shadow: 2px 2px 3px #999;
    z-index: 99999999;
    color:white;
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
    .float{
    display:none;
    }
       </style>
    
<script type="text/javascript" src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  
                <div class="card" >
<div class="col-lg-12"> 
<div class="">
<div class="row"> 
    
   
<?php
$query = "call Listar_ArchivosTrabajador('".$_GET['id']."')";
$result_tasks = mysqli_query($conn, $query);   
while($row = mysqli_fetch_assoc($result_tasks)) { ?>
<div class='col-lg-12'>
<div class="">
<div class="card-body" style="padding-top: 6px;   padding-bottom: 6px;    padding-left: 6px;    padding-right: 6px;"> 
<?php if($row['tipo'] !='.PDF'){?>               
<img src='../Documentos/<?php echo $row['nombreArchivo']?>' style='height: 350px;width: auto; '> 
<?php }else{?>                 
<embed src='../Documentos/<?php echo $row['nombreArchivo']?>#toolbar=0' style='width: 100%;  height: 535px; ' type = 'application/pdf'>
<?php }?> 
</div>
</div>
</div>  
<?php } ?>

    





    </div>
</div>
</div>
</div>  
    <script>
$(function() {
    $(".checked_button input").click(function () {
        $('.checked_button input').attr("checked", false);
        $(this).prop("checked", true);
     });
});
    </script> 
   