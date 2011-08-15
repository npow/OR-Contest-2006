<?php
$ftp_server = "rees.uwaterloo.ca";
$ftp_user_name = "jnopporn";
$ftp_user_pass = "xfxiBcxT";
$filename = $_GET['filename'];
$source_path = "/users/jnopporn/www/orc/input/";
$source_file = $source_path.$filename;
if(!file_exists($source_file)) die("Cannot find \"".$source_file."\"!");
$destination_file = "/u9/jnoppornpitak/public_html/data/".$filename;
?>
