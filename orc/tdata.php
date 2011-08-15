<?php
echo "<pre>";
echo tdata($target);
#echo file_get_contents("algorithm.xpi");
echo "</pre>";
function tdata($profile) {
echo $profile;
$fp = fopen("data/".$profile, "r");
$sec = array(); # 13 indices
$sec[0] = "\nScalar";
$sec[1] = "\nSets";
$sec[2] = "\nParameters";
$step = 0; # MAX: 13
$ct = 0;
$sec1 = 3;
$line = 0;
$h = 0;
$list = array();
$ms = array(0, 0, 0, 0);
while(!feof($fp)) {
	$str = fgets($fp, 1024);

	# Checkpoints
	if(preg_match("/^\"cost\ per\ bundle/i", $str)) {
		$sec1--;
		$parts = split(",", $str);
		$sec[0] .= "\n\tc0\t'".substr($parts[0], 1, strlen($parts[0]) - 8)
			."'\t/".$parts[1]."/".((!$sec1)?";\n\n":"");
		continue;
	} else if(preg_match("/^\"M\"/", $str)) {
		$sec1--;
		$parts = split(",", $str);
		$sec[0] .= "\n\tM\t'".substr($parts[2], 1, strlen($parts[2]) - 2)
			."'\t/".$parts[1]."/".((!$sec1)?"\n\n":"");
		$h += (int)$parts[1];
		continue;
	} else if(preg_match("/^\"L\"/", $str)) {
		$sec1--;
		$parts = split(",", $str);
		$sec[0] .= "\n\tL\t'".substr($parts[2], 1, strlen($parts[2]) - 2)
			."'\t/".substr($parts[1],1,strlen($parts[1]) - 4)."/".((!$sec1)?";\n\n":"");
		continue;
	} else if(preg_match("/\"Inventory/i", $str)) {
		$step = 1;
		continue;
	} else if(preg_match("/^\"n\"/", $str)) {
		$parts = split(",", $str);
		$sec[1] .= "\n\ti\t".substr($parts[2], 1, strlen($parts[2]) - 2)
			."\t/1*".$parts[1]."/";
	} else if(preg_match("/^\"m\"/", $str)) {
		$parts = split(",", $str);
		$sec[1] .= "\n\tj\t".substr($parts[2], 1, strlen($parts[2]) - 2)
			."\t/1*".$parts[1]."/";
	} else if(preg_match("/^\"t\"/", $str)) {
		$parts = split(",", $str);
		$sec[1] .= "\n\tt\t".substr($parts[2], 1, strlen($parts[2]) - 2)
			."\t/1*".$parts[1]."/";
	} else if(preg_match("/Iw_i/i", $str)) {
		$step = 3;
		$sec[$step] = "\nIW(i) Input Coil Widths";
		continue;
	} else if(preg_match("/c_i/i", $str)) {
		$step = 4;
		$sec[$step] = "\nc(i) Input Coil Costs";
		continue;
	} else if(preg_match("/n_i/i", $str)) {
		$step = 5;
		$sec[$step] = "\nn(i) Input Coil per Bundle";
		continue;
	} else if(preg_match("/Ow_j/i", $str)) {
		$step = 6;
		$sec[$step] = "\nOW(j) Output Coil Widths";
		continue;
	} else if(preg_match("/p_j/i", $str)) {
		$step = 7;
		$sec[$step] = "\nP(j) Product Coil Price";
		continue;
	} else if(preg_match("/The\ inventory\ capacity\ for\ each\ input\ coil\ is/", $str)) {
		$step = 8;
		$sec[$step] = "\nCap(i) The capacity is for each coil";
		continue;
	} else if(preg_match("/\"Facility\",\"Capacity\"/i", $str)) {
		$step = 9;
		$sec[$step] = "\nO(s) inventory capacity for output coil";
		continue;
	} else if(preg_match("/^\"Expected\ Demand\ \(d_jt\)\"/i", $str)) {
		$step = 11;
		$sec[$step - 1] = "\nTable d(j,t) 'Expected Demand'\n";
		continue;
	} else if(preg_match("/^\"Coil\/month\"/i", $str)) {
		$step = 12;
		$parts = split(",", $str);
		for($i = 1; $i < sizeof($parts); $i++) {
			$sec[$step - 1] .= "\t".$i;
		}
		$sec[$step - 1] .= "\n";
		continue;
	}
	
	# Dynamic generate
	if($step == 1) {
		if($line == 0) {
			$sizes = array();
			if(preg_match("/small/i", $str)) {
				$sizes[] = "small";
			} if(preg_match("/medium/i", $str)) {
				$sizes[] = "medium";
			} if(preg_match("/large/i", $str)) {
				$sizes[] = "large";
			}
			$sec[$step] .= "\n\ts\t'output coil size'\t/";
			for($i = 0; $i < sizeof($sizes); $i++) {
				$sec[$step] .= $sizes[$i].(($i < sizeof($sizes) - 1)?", ":"");
			}
			$sec[$step] .= "/";
			for($i = 0; $i < sizeof($sizes); $i++) {
				$sec[$step] .= "\n\t".$sizes[$i]."(s)\t'".$sizes[$i]
				." size'\t/".$sizes[$i]."/".(($i == sizeof($sizes) - 1)?"":"");
			}
		} else {
			if(preg_match("/small/i", $str)) {
				$parts = split(" ", $str);
				foreach($parts as $part) {
					if(preg_match("/mm$/", $part)) {
						$ms[0] = (int)substr($part, 0, strlen($part) - 2);
						break;
					}
				}
			} else if(preg_match("/medium/i", $str)) {
				$parts = split(" ", $str);
				$mm = 1;
				foreach($parts as $part) {
					if(preg_match("/mm$/", $part)) {
						$ms[$mm++] = (int)substr($part, 0, strlen($part) - 2);
					}
				}
				if($mm[1] > $mm[2]) {
					$tmp = $mm[1];
					$mm[1] = $mm[2];
					$mm[2] = $tmp;
				}
			} else if(preg_match("/large/i", $str)) {
				$parts = split(" ", $str);
				foreach($parts as $part) {
					if(preg_match("/mm$/", $part)) {
						$ms[3] = (int)substr($part, 0, strlen($part) - 2);
						break;
					}
				}
			}			
		}
		$line++;
	} else if($step == -1) { # do noting
	} else if($step >= 3 && $step <= 9) {
		$parts = split(",", $str);
		if(($step < 8 && !preg_match("/^[0-9]/", $parts[0]))
			|| ($step == 8 && !preg_match("/\"Iw[0-9]\"$/i", $parts[0]))
			|| ($step == 9 && !preg_match("/small|medium|large/i", $parts[0]))) {
			if($ct) {
				$sec[$step] .= "/\n";
				$step = -1;
				$ct = 0;
			} else {
			}
			continue;
		} 
		if($step == 6) { $list[] = $parts[1];}
		if($step == 8) $h += (int)$parts[1];

		$sec[$step] .= "\n\t".(($ct == 0)?"/":"")
			.(($step >= 8)?substr($parts[0], (($step == 9)?1:3), strlen($parts[0]) - (($step == 9)?2:4)):$parts[0])
			."\t".$parts[1];
		$ct = 1;
	} else if($step == 12) {
		$parts = split(",", $str);
		for($i = 0; $i < sizeof($parts); $i++) {
			$sec[$step] .= $parts[$i].(($i < sizeof($parts) - 1)?"\t":"");
		}
	}
}
$level= 0;
$ctm = 0;
for($i = 0; $i < sizeof($list); $i++) {
	if($ms[$level] == 0) {
		$i--;
		$level++;
		continue;
	} if($level > 3) break;
	if($list[$i] <= $ms[$level]) {
		$ctm++;
	} else {
		if($level == 0) {
			$sec[1] .= "\n\ta(j)\t'number for small output'\t/".($i-$ctm+1)
				."*".($i+1)."/";
			$level += 2;
			$ctm = 0;
		}
		else if($level == 2) {
			$sec[1] .= "\n\tb(j)\t'number for medium output'\t/".($i-$ctm+1)
				."*".($i+1)."/";
			if($ms[3] != 0)
				$sec[1] .= "\n\tk(j)\t'number for large output'\t/".($i+2)
				."*".sizeof($list)."/";
			break;
		}
	}
}
$sec[1] .= "\n\th\t'number of input coils of type i purchased'\t/1*".$h."/;\n";

fclose($fp);

$str ="";
for($i = 0; $i < 13; $i++) {
	$str .= $sec[$i].(($i == 12)?";":"");
}
return $str;
}?>
