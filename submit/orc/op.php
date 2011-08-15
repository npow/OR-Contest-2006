<?php
session_start();
$target = isset($_SESSION['target'])?$_SESSION['target']:"";
echo "<p>Displaying <b>".$target."</b></p>";
if($target == "") {
	echo "No target presents.";
	exit();
} if(!file_exists("output/".$target.".lst")) {
	echo "The output file doesn't exists. Go to \"Main Terminal\" to create first.";
	exit();
}
?>
<p><a onclick="output(1)">Show the detail</a> |
<a onclick="output(0)">Hide the detail (Default)</a> |
<a onclick="output(2)">Show the RAW output (Debugging Only)</a></p>
<?php
define("VAR_H", "---- VAR ");
#SYSTEM IS USED TO TEST EXECUTION FROM THE WEB BROWSER
#echo "<pre>".system("gams/gams test.gms")."</pre>";
$onlyResult = isset($_GET['onlyResult'])?$_GET['onlyResult']:1;
$doParsing = false;
$openBox = false;
$in = -1;
$labels = array(
	# "Month" will be added for each section
		array("Input"),
		array("Input", "Output"),
		array("Output"),
		array("Input"),
		array("Stored Output"),
		array("Output in Inventory"),
		array("Input in Inventory"),
		array(),
		array("Purchased Input")
	);

$fp = fopen("output/".$target.".lst", "r");
if(!$fp) {
    die("Cannot find the output file. Make the output file first!");
}

# Start parsing.
if($_SERVER['QUERY_STRING'] == "raw") echo "<pre>";
while(!feof($fp)) {
	$str = fgets($fp, 1024);
	if($_SERVER['QUERY_STRING'] == "raw") {
		echo $str;
		continue;
	}
	if(!$doParsing) {
		if(preg_match("/^".VAR_H."/", $str)) $doParsing = true;
	} else {
		if(preg_match("/  z  total profit$/", $str)) $doParsing = false;
	}
	# Dev Note: Because we need the immediate output of the starting line,
	#		so it need to check the second time.
	if($doParsing) {
		if(preg_match("/^".VAR_H."/", $str) && !preg_match("/^".VAR_H."z/", $str)) {
			$in++;
			if($onlyResult) continue;
			if($in > -1) {
				echo "</div>";
			}
			echo "<div class=\"tag\">";
			$headers = split("  ", substr($str, strlen(VAR_H)));
			echo "<div class=\"header\">".$headers[0]."</div>";
			echo "<div class=\"desc\">".$headers[1]."</div>";
			echo "<div class=\"tag_header\">";
			echo "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>";
			for($i = 0; $i < sizeof($labels[$in]); $i++) {
				echo "<td class=\"index\">";
				echo $labels[$in][$i];
				echo "</td>";
			}
			echo "<td class=\"index\">Month</td>";
			echo "<td class=\"index\">Level</td>";
			echo "</tr></table>";
			echo "</div>";
		} else if(preg_match("/^".VAR_H."z/", $str)) {
			if(!$onlyResult) echo "</div>";
			$coms = split(" * ", $str);
			echo "<div class=\"tag\">";
			echo "<div class=\"header\">Profit</div>";
			echo "<div class=\"desc\">".$coms[4]."</div>";
			echo "</div>";
		} else if(preg_match("/^[0-9]/", $str)) {
			if($onlyResult) continue;
			$coms = split(" * ", $str);
			$ids = split("\.", $coms[0]);
			echo "<div class=\"tag_content\">";
			echo "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>";
			for($i = 0; $i < sizeof($labels[$in]) + 1; $i++) {
				echo "<td class=\"index\">";
				echo $ids[$i];
				echo "</td>";
			}
			echo "<td class=\"level\">";
			echo ($coms[2] != ".")?$coms[2]:"0.0000";
			echo "</td>";
			echo "</tr></table>";
			echo "</div>";
		} else {
			continue;
		}
	}
}
if($_SESSION['QUERY_STRING'] == "raw") echo "</pre>";
fclose($fp);
