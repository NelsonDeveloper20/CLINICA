<?php session_start();
 include('../includes/header.php'); 
 if (isset($_SESSION['idTrabajador'])) {
    
}else{
    header('Location: login.php');
}?>
<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Required meta tags-->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Colorlib Templates">
    <meta name="author" content="Colorlib">
    <meta name="keywords" content="Colorlib Templates">

    <!-- Title Page-->
    <title>Clinica</title>

    <!-- Icons font CSS-->
    <link href="../vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">
    <link href="../vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
    <!-- Font special for pages-->
    <link href="https://fonts.googleapis.com/css?family=Roboto:100,100i,300,300i,400,400i,500,500i,700,700i,900,900i" rel="stylesheet">

    <!-- Vendor CSS-->
    <link href="../vendor/select2/select2.min.css" rel="stylesheet" media="all">
    <link href="../vendor/datepicker/daterangepicker.css" rel="stylesheet" media="all">

    <!-- Main CSS-->
    <link href="../vendor/main.css" rel="stylesheet" media="all">
    <style>
        .card-2 .card-body {
    display: table-cell;
    padding: 5px 90px !important;
    padding-bottom: 88px;
}
   
.input {
    outline: none;
    margin: 0;
    border: none;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
    width: 3% !important;
    font-size: 14px;
    font-family: inherit;
}
.float{
    display:none;
}
    </style>
</head>

<body>
    
    <div class="">
        <div class="wrapper wrapper--w960">
            <div class="card card-2">
                <div class="card-heading"></div>
                <div class="card-body">
                    <h2 class="title"></h2>
                    <form>
                        
                             <h2 class="" style="font-weight: 700;
    margin-bottom: 37px;
    font-family: revert;">Bienvenido  
                                 <p style="text-transform:uppercase"><span ID="LalBLNombre"  ></span></p>
Iniciaremos el proceso de entrega de la documentación necesaria para tu rol 
  </h2>
                        <div class="input-group" style="visibility: hidden;">
                            <input class="input--style-2" type="text" placeholder="Name" name="name">
                        </div>

                          <div class="row row-space" style="font-size: medium;margin-bottom: 21px;">
                        <div class="col-lg-12">
                        <div class="form-check">                 
                        <input type="checkbox" id="chk1" class="scale3" style="width: 3% !important;"/>
                        <span class="card-title text-center" for="exampleCheck1">Certifico que  la documentación que proveré ,
                            es exacta y cubre lo que la Clinica Internacional exige para el cumplimiento de mis responsabilidades</span>
                        </div>
                        </div>
                            </div>
                        
                        <div class="row row-space"  style="font-size: medium;">
                        <div class="col-lg-12"> 
                        <div class="form-check">
                        <input type="checkbox" id="chk2" class="scale3" style="width: 3% !important;"/>      
                            <span class="card-title text-center" for="exampleCheck1">Comprendo que esta información pasara a formar parte de mi file dentro de recursos humanos
</span>
                        </div>  
                        </div> 
                        </div>
                        <div class="row row-space" >
                            <div class="col-2" style="visibility: hidden;">
                                <div class="input-group">
                                    <input class="input--style-2 js-datepicker" type="text" placeholder="Birthdate" name="birthday">
                                    <i class="zmdi zmdi-calendar-note input-icon js-btn-calendar"></i>
                                </div>
                            </div>
                            <div class="col-2">
                                <div class="input-group" style="visibility: hidden;">
                                    <div class="rs-select2 js-select-simple select--no-search">
                                        <select name="gender">
                                            <option disabled="disabled" selected="selected">Gender</option>
                                            <option>Male</option>
                                            <option>Female</option>
                                            <option>Other</option>
                                        </select>
                                        <div class="select-dropdown"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                      
                        <div class="p-t-10" style="float: right;">
<button  class="btn btn--radius bg-blue" type="button" onclick="continuar();">Continuar</button>
                           
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Jquery JS-->
    <script src="../vendor/jquery/jquery.min.js"></script>
    <!-- Vendor JS-->
    <script src="../vendor/select2/select2.min.js"></script>
    <script src="../vendor/datepicker/moment.min.js"></script>
    <script src="../vendor/datepicker/daterangepicker.js"></script>

    <!-- Main JS-->
    <script src="../js/global.js"></script>

</body><!-- This templates was made by Colorlib (https://colorlib.com) -->
<?php
   
   $var_value = $_SESSION['datosuser'];
?>
<script>
var nameuser=<?php echo $var_value;?>;
var idtrabajador=nameuser[0];
var idpuesto=nameuser[1];
var idperfil=nameuser[2];
var nombrepuesto=nameuser[3];
var nombrecompleto=nameuser[4];
document.getElementById("LalBLNombre").innerHTML =nombrecompleto;

localStorage.setItem("idtrabajador", idtrabajador);
localStorage.setItem("idpuesto", idpuesto);
localStorage.setItem("idperfil", idperfil);
localStorage.setItem("nombrepuesto", nombrepuesto);
localStorage.setItem("nombrecompleto", nombrecompleto); 

function continuar(){
    
    var chk1=document.getElementById("chk1");
    var chk2=document.getElementById("chk2");
  if(chk1.checked == true && chk2.checked==true){
    window.location.replace("instruccionfile.php");
  }else{
    swal({ 
  text: "Debe Aceptar las normas!",
  icon: "warning",
});
  }

   
}
</script>
</html>
<!-- end document-->