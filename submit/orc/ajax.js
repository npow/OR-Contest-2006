// AJAX Front-end Module for X-Mode Core 2.0 "Aria"
// A Prototype Module of X-Mode Project (shiroyuki.net)
// Developed by Juti Noppornpitak (shiroyuki@gmail.com)

var req = null;
var console = null;
var alertmessage = "Loading...";
var whereus_alert = null;
var whereis_target = null;
var READY_STATE_UNINITIALIZED = 0;
var READY_STATE_LOADING = 1;
var READY_STATE_LOADED = 2;
var READY_STATE_INTERACTIVE = 3;
var READY_STATE_COMPLETE = 4;

function getXMLHTTPRequest() {
	var xRequest = null;
	if(window.XMLHttpRequest) {
		xRequest = new XMLHttpRequest(); // for Mozilla/Safari
	} else if (typeof ActiveXObject != "undefined") {
		xRequest = new ActiveXObject("Microsoft.XMLHTTP"); // for IE
	}
	return xRequest;
}

function sendRequest(output, url, params, method) {
	if(!method) {
		method = "GET";
	}

	setTargetLocation(output);

	req = getXMLHTTPRequest();
	
	if(req) {
		req.onreadystatechange=onReadyState;
		req.open(method, url, true);
		req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		req.send(params);
	} else {
	}
}

function onReadyState() {
	if(!req) {
		stdout("Failed");
	} else {
		var ready = req.readyState;
		var data = null;
		if(ready == READY_STATE_COMPLETE) {
			setConsole(whereis_alert);
			stdout("");
			setConsole(whereis_target);
			stdout(req.responseText);
		} else {
			setConsole(whereis_alert);
			stdout(alertmessage);
		}
	}
}

function setAlertLocation(where) {
	whereis_alert = where;
}

function setAlertMessage(msg) {
	alertmessage = msg;
}

function setTargetLocation(where) {
	whereis_target = where;
}

function setConsole(output) {
	console = document.getElementById(output);
}

function stdout(data) {
	if(console != null) {
		console.innerHTML = data;
	}
}
