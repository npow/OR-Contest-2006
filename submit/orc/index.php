<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3c.org/1999/xhtml">
<head>
    <title>ACOS</title>
    <!-- Meta -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <!-- Meta -->
    <!-- CSS -->
    <link href="essential.css" rel="stylesheet" type="text/css" />
    <!-- CSS -->
    <!-- Java Script -->
    <script src="ajax.js" type="text/javascript" language="javascript"></script>
    <script src="essential.js" type="text/javascript" language="javascript"></script>
    <script type="text/javascript" language="javascript">
	window.onload = function () {
		setAlertLocation("webalert");
		setTargetLocation("webcontent");<?php
		switch($_SESSION['sec']) {
			case 1:	echo "modoutput();"; break;
			case 2: echo "wizard(0);"; break;
			default: echo "modinput();";
		} $_SESSION['sec'] = 0;?>
	}
    </script>
    <!-- Java Script -->
</head>
<body>
<!-- Don't forget checking MSIE 1-6 and 7 -->
<div class="frame" id="alert">
<fieldset><legend>Developer's Note</legend>
<p>Working on testing code now...</p>
<p><a onclick="document.getElementById('alert').innerHTML = '';">Hide this message!</a> (To see this message, please REFRESH your browser.)</p>
</fieldset>
</div>

<div class="frame">
    <div id="webtitle"><h1>Automatic Combination and Optimization System</h1></div>
    <div id="webnav">
    	<div id="webalert"></div>
    	<a onclick="modinput()">Terminal</a> 
	<a onclick="wizard(0)">Make a GAMS Input File</a>
	<a onclick="display('about.html')">About</a>
	<a onclick="display('test.php')">Beta Code</a>
    </div>
    <div class="cbody">
      <div id="webalert"></div>
      <div id="webcontent"></div>
    </div>
    <div id="webfooter">Compatible with Firefox 1.5+. Require PHP 5.03+ and Java 2 Runtime Environment 1.3+.
    Copyright &copy; 2006 Juti Noppornpitak.
    Made on Debian GNU/Linux 3.1. Powered by the University of Waterloo's Computer Science Club's Servers,
    CSCF's UNIX Servers etc.
    </div>
</div>
</body>
</html>
