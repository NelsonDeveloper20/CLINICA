<?php include("../db.php"); ?>
<?php include('../includes/header.php'); ?>

<!DOCTYPE html>
<html class="no-js h-100" lang="en">
<head >
<title>Login</title>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="description" content="A high-quality &amp; free Bootstrap admin dashboard template pack that comes with lots of templates and components.">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">   
<script type="text/javascript" src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<!--===============================================================================================-->	
	<link rel="icon" type="image/png" href="https://www.clinicainternacional.com.pe/static/img/header-logo-colores.png"/>
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../Vendor/login/Vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../Vendor/login/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../Vendor/login/Vendor/animate/animate.css">
<!--===============================================================================================-->	
	<link rel="stylesheet" type="text/css" href="../Vendor/login/Vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../Vendor/login/Vendor/animsition/css/animsition.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../Vendor/login/Vendor/select2/select2.min.css">
<!--===============================================================================================-->	
	<link rel="stylesheet" type="text/css" href="../Vendor/login/Vendor/daterangepicker/daterangepicker.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../Vendor/login/css/util.css"> 
    <link href="../Vendor/login/css/main.css" rel="stylesheet" />
<!--===============================================================================================-->
    <link href="../Vendor/login/css/form.css" rel="stylesheet" />
	<style>	 
.bg {
  /* The image used */
  /*background-image: url("https://citasenlinea.clinicainternacional.com.pe/smci/Static/media/b2-img.jpg");*/

  /* Full height */
  height: 100%; 

  /* Center and scale the image nicely */
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
}
.float{
    display:none;
}
	</style>
</head>
<body> 

       
	
	<div class="limiter">
		<div class="container-login100 bg" >
			<div class="wrap-login100" style="box-shadow: -1px 10px 20px 20px rgb(0 0 0 / 25%) !important">
				<?php if (isset($_SESSION['message'])) { ?>
				<div class="alert alert-<?= $_SESSION['message_type']?> alert-dismissible fade show" role="alert">
				<?= $_SESSION['message']?>
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
				</div>
				<?php session_unset(); }else {session_unset(); } ?>
				<form  action="../models/login.php" method="POST" class="login100-form validate-form p-l-55 p-r-55 p-t-132">
					<span class="header">
<center>  <img src="../Vendor/img/logo.png" style="    margin-top: 23px;   width: auto;   height: 40px;" /> </center>
</span> 
<center style="font-weight: 800;font-size: 24px;margin-top: -10%;"> Bienvenido</span><br style="clear:both;"/>
<br style="clear:both;"/><br style="clear:both;"/>
<div class="wrap-input100 validate-input m-b-16" style="margin-bottom: 19%;width: 70% !important;" data-validate="Please enter username">

<input type="text" name="usuario"  class="input_text" autocomplete="off" placeholder="Ingrese tu DNI"/>
<br />
<input type="password" name="clave" class="input_text" autocomplete="off" placeholder="Ingrese tu Constraseña " TextMode="Password"/>
</div> 
</center>   <div class="footther" style="box-shadow: inset 0px -20px 2px 0px rgb(78 122 222);"> 
<div class="container-login100-form-btn"> 
<button type="submit"  name="ingresar" class="btn_azul"  OnClick="BtnIngresar_Click">Ingresar</button>
</div>
						
					  
					</div>
				</form>

			</div>
		</div>
	</div>
	 
	
<!--===============================================================================================-->
	<script src="../Vendor/login/Vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
	<script src="../Vendor/login/Vendor/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
	<script src="../Vendor/login/Vendor/bootstrap/js/popper.js"></script>
	<script src="../Vendor/login/Vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
	<script src="../Vendor/login/Vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
	<script src="../Vendor/login/Vendor/daterangepicker/moment.min.js"></script>
	<script src="../Vendor/login/Vendor/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
	<script src="../Vendor/login/Vendor/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
	<script src="../Vendor/login/js/main.js"></script>

</body>
</html>