<?php
session_start();

$conn = mysqli_connect(
  'localhost',
  'root',
  '',
  'clinicadb'
) or die(mysqli_erro($mysqli));

?>
