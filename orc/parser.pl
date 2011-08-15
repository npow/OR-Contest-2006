#!/usr/bin/perl
$input_counter = $output_counter = $out_counter = $inventory_count = 0;
$numSmall = $numMedium = $numLarge = 0;
@output_widths;

while(<>) {
  chomp;
  if (/^"n"/) {
    $numInputCoils = (split /,/)[1];
    print "Set\t i\t/1*$numInputCoils/;\n\n";
  }
  elsif (/^"m"/) {
    $numOutputCoils = (split /,/)[1];
    print "Set\t j\t/1*$numOutputCoils/;\n\n";
    print "Set\t s\t/small, medium, large/;\n\n";
    print "Set\t small(s)\t /small/;\n\n";
    print "Set\t medium(s)\t /medium/;\n\n";
    print "Set\t large(s)\t /large/;\n\n";
  }
  elsif (/^"T"/) {
    $numPeriods = (split /,/)[1];
    print "Set\t t\t/1*$numPeriods/;\n\n";
  }
  elsif (/^"M"/) {
    $maxOutput = (split /,/)[1];
    print "Scalar\t M\t/$maxOutput/;\n\n";
  }
  elsif (/^"L"/) {
    $_ = (split /,/)[1]; s/[mm,"]//g; $loss = $_;
    print "Scalar\t L\t/$loss/;\n\n";
  }
  elsif (/"coil","width","unit"/i) {
    $phase = "input_coil_widths";
    print "Parameter IW(i)\n";
  }
  elsif (/cost \(per coil\)/i) {
    $phase = "input_coil_costs";
    print "Parameter c(i)\n";
  }
  elsif (/n_i/i) {
    $phase = "input_coil_per_bundle";
    print "Parameter n(i)\n";
  }
  elsif (/c_0/i) {
    $bundle_cost = (split /,/)[1];
    print "Scalar\t c0\t/$bundle_cost/;\n\n";
  }
  elsif (/"output coil","width"/i) {
    $phase = "output_coil_widths";
    print "Parameter OW(j)\n";
  }
  elsif (/p_j/i) {
    $phase = "output_coil_prices";
    print "Parameter P(j)\n";
  }
  elsif ($phase eq "output_inventory_widths" && /small type/i) {
    s/[^0-9]//g; $smallB = $_;
  }
  elsif ($phase eq "output_inventory_widths" && /medium type/i) {
    ($mediumA, $mediumB) = (split / /)[6,8];
    $_ = $mediumA; s/mm//g; $mediumA = $_;
    $_ = $mediumB; s/mm//g; $mediumB = $_;
  }
  elsif ($phase eq "output_inventory_widths" && /large type/i) {
    s/[^0-9]//g; $largeA = $_;
  }
  elsif (/"Facility","Capacity"/i) {
    $phase = "output_inventory";
    print "Parameter O(s)\n";
  }
  elsif (/storage facilities/i) {
    $phase = "output_inventory_widths";
  }
  elsif (/coil\/month/i) {
    $phase = "expected_demand";
    print "Table\td(j,t)\n";
    for(1..$numPeriods) { print "\t$_"; } print "\n";
  }
  elsif (/The inventory capacity for each input coil/i) {
    $phase = "input_inventory";
    print "Parameter Cap(i)\n";
  }
  elsif (($phase eq "input_coil_costs" && /CAD/) ||
         ($phase eq "input_inventory" && /Iw/i) ||
         ($phase eq "input_coil_per_bundle") ||
         ($phase eq "input_coil_widths")) {
    $input_counter++;
    $curr = (split /,/)[1];
    $first = ($input_counter == 1 ? "/" : " ");
    $last = ($input_counter == $numInputCoils ? "/;\n" : "");
    print "\t$first$input_counter\t$curr$last\n";
    if ($phase eq "input_inventory") { $inventory_count += $curr; }
    if ($input_counter == $numInputCoils) {
      $input_counter = 0; $phase = "off";
    }
  }
  elsif (($phase eq "output_coil_widths" && /mm/) ||
         ($phase eq "output_coil_prices" && /CAD/)) {
    $output_counter++;
    $curr = (split /,/)[1];
    $first = ($output_counter == 1 ? "/" : " ");
    $last = ($output_counter == $numOutputCoils ? "/;\n" : "");
    print "\t$first$output_counter\t$curr$last\n";
    if ($phase eq "output_coil_widths") { push(@output_widths, $curr); }
    if ($output_counter == $numOutputCoils) {
      $output_counter = 0; $phase = "off";
    }
  }
  elsif ($phase eq "output_inventory") {
    $out_counter++;
    $curr = (split /,/)[1];
    $first = ($out_counter == 1 ? "/" : " ");
    $last = ($out_counter == 3 ? "/;\n" : "");
    if ($out_counter == 1) { $out = "small"; }
    elsif ($out_counter == 2) { $out = "medium"; }
    else { $out = "large"; }
    print "\t$first$out\t$curr$last\n";
    if ($out_counter == 3) {
      $out_counter = 0; $phase = "off";
    }
  }
  elsif ($phase eq "expected_demand") {
    @demand = split /,/;
    foreach $d_month(@demand) { print "$d_month\t"; }
    if ($demand[0]==$numOutputCoils) { print ";\n\n"; }
    else { print "\n"; }
  }
}
$curr = $inventory_count + $maxOutput;
print "Set\t h\t /1*$curr/;\n\n";
foreach $w(@output_widths) {
  if ($w <= $smallB) { $numSmall++; }
  elsif ($w <= $mediumB) { $numMedium++; }
  else { $numLarge++; }
}
$numMedium += $numSmall; $numLarge += $numMedium;
$start = ($numSmall>0 ? 1 : 0);
print "Set\t a(j)\t /$start*$numSmall/;\n\n"; $numSmall++;
$start = ($numMedium>0 ? $numSmall : 0);
print "Set\t b(j)\t /$numSmall*$numMedium/;\n\n"; $numMedium++;
$start = ($numLarge>0 ? $numMedium : 0);
print "Set\t k(j)\t /$numMedium*$numLarge/;\n\n";

