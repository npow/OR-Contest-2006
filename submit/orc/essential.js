function modinput() {
	display("in.html");
}

function modoutput() {
	output(0);
}

function wizard(step, target) {
	var proceed = 1;
	if(step == 2) {
		if(document.getElementById("pname").value == "") {
			alert("Please enter the profile name!");
			proceed = 0;
		} else {
			alert("Profile name is \"" + document.getElementById("pname").value + "\".");
		}
	}
	if(proceed == 1) {
		display("wizard.php?step=" + step + "&target=" + target);
	}
}

function display(url) {
	sendRequest("webcontent", url, "", "GET");
}

function output(detail) {
	if(detail == 1) {
		display("op.php?onlyResult=0");
	} else if(detail == 2) {
		display("op.php?raw");
	} else {
		display("op.php");
	}
}

function upload(override) {
	var uploadurl = "upload.php";
	if(override == 1) {
		uploadurl += "?override=1";
	}
	window.open(uploadurl, "sendmail", "height=300, width=400, status=no, toolbar=no, menubar=no, location=no, scrollbars=yes");
}
