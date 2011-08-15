<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3c.org/1999/xhtml">
<head>
<title>Upload</title>
<!-- Meta -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<!-- Meta -->
<link href="essential.css" rel="stylesheet" type="text/css" />
</head>
<body>
<?php if($_GET['do'] == "upload") {
	$uploadpath = "data/";
	$isGMS = preg_match("/\.gms$/", $_FILES['data']['name']);

	if($_FILES['data']['tmp_name'] != "" && $_FILES['data']['tmp_name'] != "none") {
		if(!preg_match("/\.csv$/", $_FILES['data']['name']) &&
			($_GET['override'] == 1 &&
			!preg_match("/\.gms$/", $_FILES['data']['name'])
			)) {
			?><p>The <b>Multipurpose Internet Mail Extensions (MINE)</b>
			of the uploaded file is not supported. It will not be added.</p>
			<pre>UPLOADING_IGNORE_TYPE: <?php echo $_FILES['data']['type']; ?></pre>
			<p><a onclick="history.go(-1);">Retry</a> |
			<a onclick="window.close();">Close this window</a></p><?php
			exit();
		}

		if($_GET['override'] == 1 || $isGMS) {
			$uploadpath = "input/";
		}

		if(move_uploaded_file($_FILES['data']['tmp_name'], $uploadpath.$_FILES['data']['name'])) {
			$_SESSION['sec'] = ($isGMS || $_GET['override'] == 1)?0:2;
			echo "Uploading successfully!";
			?><script>
			window.opener.location.href = window.opener.location.href;
			window.close();</script><?php
		} else {
			echo "Failed to upload.";
		}
	} else {
		echo "Not valid. Returning in 5 seconds (or sooner)...";
		?><script>setTimeout("window.location='?';", 5000);</script><?php
	}
} else {
?>
	<h2>Upload file (<?php echo ($_GET['override'] == 1)?"GAMS-formatted Only":"RAW-data Only";?>)</h2>
	<form method="POST" ENCTYPE="multipart/form-data" action="<?php echo $PHP_SELF."?do=upload".(($_GET['override']==1)?"&override=1":""); ?>">
	<input type="hidden" name="MAX_FILE_SIZE" value="8000000" />
	<input type="file" name="data" size="30" />
	<input type="submit" value="Upload" />
	</form>
	<p>Note<sup>1</sup>: The maximum size of file is about 8 MB.
	SERVER TIMEOUT may terminate your uploading if your connection
	is too slow.</p> 
<?php
}
?>
</body>
</html>
