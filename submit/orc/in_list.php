<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3c.org/1999/xhtml">
<head>
<title>ACOS</title>
<!-- Meta -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<!-- Meta -->
<script src="ajax.js" type="text/javascript" language="javascript"></script>
<script language="javascript">
function call(what) {
	window.open("in_core.php?do=prompt&target=" + what, "core");
}
</script>
<link href="essential.css" rel="stylesheet" type="text/css" />
</head>
<body>
<h3>Input</h3>
<table width="100%" cellpadding="0" cellspacing="0"><tr valign="top">
	<td>
<?php
$dp = opendir("input");
while($name = readdir($dp)) {
	if(preg_match("/^\./", $name)) continue;
	?>
	<a class="selection" onclick="call('<?php echo $name; ?>')">
	<?php echo $name; ?>
	</a>
	<?php
}
?>
	</td>
</tr></table>
</body>
</html>
