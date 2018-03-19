<?php
$connection = mysqli_connect('mariadb.c6z229cycj2m.sa-east-1.rds.amazonaws.com', 'root', '3c0mPHP!', 'ecomphp');
if(!$connection){
	echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}
?>
