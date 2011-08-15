<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3c.org/1999/xhtml">
<head>
<title>ACOS</title>
<!-- Meta -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<!-- Meta -->
</head>
<body>
<?php
$step = $_GET['step'];
if($step == 0) {
?><h2>Please select one of available inputs!</h2><p>
You may want to <input type="button" onclick="upload(0)" value="Upload the RAW input file"/>
or <input type="button" onclick="upload(1)" value="Upload the GAMS-formatted input file" />.</p>
<fieldset><legend>Existing RAW Input</legend><ul>
<?php
	$numFiles = 0;
	$dp = opendir("data/");
	while($name = readdir($dp)) {
		if(!preg_match("/^\./", $name)) {
			$numFiles++;
			?><li><a onclick="wizard(1, '<?php echo $name; ?>');"><?php echo $name; ?></a>
			(<i><?php echo mime_content_type("data/".$name); ?></i>)</li><?php 
		}
	}

	if($numFiles < 1) { echo "<i>Please upload files first</i>";
	} else { echo "<i>Select an available input to proceed the next step.</i>"; }
?>
</ul></fieldset>
<?php 	
} else if($step == 1) {
	if(!file_exists("data/".$_GET['target'])) {
		?>The selected RAW data doesn't exists. <input type="button" value="Go back!"><?php
	} else {
		?>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
		<td width="180"><b>INPUT DATA</b></td>
		<td><i><?php echo $_GET['target']; ?></i></td>
		</tr><tr>
		<td><b>PROFILE</b></td>
		<td><input type="text" id="pname" /></td>
		</tr>
		</table>
		<?php
	}
	if(!file_exists("algorithm.xpi")) {
		?><p>Well, we don't see the GAMS-formatted algorithm. 
		<a>Click here to create a new one</a>.</p>
		<p>Or <a onclick="wizard(0)">Go back to re-upload the input file</a>. (This will not save the change.)<?php
	} else {
		?><hr size="1" />
		<p><input type="button" onclick="wizard(2, '<?php echo $_GET['target']; ?>')" value="Confirm the action and proceed" />
		to the next step or
		<input type="button" onclick="wizard(0)" value="go back" />
		to the previous step.</p><?php
	}
?>
</legend>
<div id="alg"></div>
</fieldset>
<?php
}
?>
</body>
</html>
