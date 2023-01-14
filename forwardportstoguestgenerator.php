#!/usr/bin/php
<?PHP
// forwardportstoguestgenerator.php
// v0102
// scan ifconfig and virsh, create iptables directives to forward ports to kvm guests
// chmod this script 755 to run as ./forwardportstoguestgenerator.php or run with php forwardportstoguestgenerator.php
// writes to a text file the BASH script forwardportstoguestscript.sh
 
// 2021/04/07
// Gordon Buchan https://gordonbuchan.com
// MIT license https://mit-license.org
 
// overview
// run the command "ifconfig" to isolate potential wan adapter names and ip addresses
// infer the KVM subnet based on the first 3 sections of the ip address of the "virbr0" adapter
// run the command "virsh net-dhcp-leases default" to isolate potential kvm guest names and ip addresses
// ask client to choose WAN adapter
// ask client to choose KVM guest
// create a batch file containing iptables directives to open the virtual adapter to packets from outside the host
// and to forward ports from the host adapter to the KVM guest adapter 80/tcp, and 443/tcp, 8022/tcp
 
// //////////////////////////////////////////////////////////////////////////////////
// start function sink
 
// str_contains() polyfill for pre PHP8
if (!function_exists('str_contains')) {
    function str_contains(string $haystack, string $needle): bool
    {
        return '' === $needle || false !== strpos($haystack, $needle);
    }
}
 
// end function sink
// //////////////////////////////////////////////////////////////////////////////////
 
// start get the WAN adapter names and ip addresses
 
// capture output of ifconfig command to variable $ifcstr
$ifcstr = `ifconfig`;
 
// convert string $ifcstr to array of lines $ifcstrarr
// use linefeed as field delimiter in array population
$ifcstrarr = explode("\n",$ifcstr);
 
// count lines in the array
$ifcstrarrnumlines = count($ifcstrarr);
 
$adnamestrarr = array();
$adipstrarr = array();
 
$kvmsubnet = "";
 
// iterate through array of lines
for ( $i=0;$i<$ifcstrarrnumlines;$i++) {
 
    if ( str_contains($ifcstrarr[$i],"flags")) {
        $flagsstr = "flags";
        $flagsstrloc = strpos("$ifcstrarr[$i]", $flagsstr) - 2;
        $adnamestr = substr($ifcstrarr[$i],0,$flagsstrloc);
    } // close if str contains "flags"
 
    // we will eventually filter virbr0, but for now we can find out the subnet for the KVM guest network
 
    if ( str_contains($ifcstrarr[$i],"inet") && !str_contains($ifcstrarr[$i],"inet6") ) {
 
        $inetstr = "inet";
        $inetstrloc = strpos("$ifcstrarr[$i]",$inetstr) + 5;
        $adipstr = substr($ifcstrarr[$i],$inetstrloc,"20");
        $spacestrloc = strpos("$adipstr"," ");
        // trimming the variable
        $adipstr = substr($adipstr,0,$spacestrloc);
 
        if (str_contains($adnamestr,"virbr0")) {
            // start infer KVM subnet
            // //////////////////////////////////////////////////////////
            // do stuff here to get the virbr0 ip address so we can infer subnet
            $kvmsubnetraw = $adipstr;
            $lastdotloc = strrpos($kvmsubnetraw,".");
            $kvmsubnet = substr($kvmsubnetraw,0,$lastdotloc) . ".0/24";
            echo "\nKVM subnet\nkvmsubnet: $kvmsubnet\n\n";
            // end infer KVM subnet
            // //////////////////////////////////////////////////////////
        } else {
            // stuff the arrays they will match by number because done at same time
            // filter for loopback device
            if (!($adipstr == "127.0.0.1")) {
                $adnamestrarr[] = $adnamestr;
                $adipstrarr[] = $adipstr;
            }
        }
 
    } // close if str contains "inet"
 
} // end for $i
 
//so we are always defined
$adnamestrarrnumlines = "";
$adnamestrarrnumlines = count ($adnamestrarr);
if (!$adnamestrarrnumlines) {
    echo "no WAN adapters found.\nStopping.\n";
    exit();
}

// if we do not have a KVM subnet, then something is wrong. Stop.
if (!$kvmsubnet) {
    echo "KVM subnet not detected. Stopping.\n";
    exit();
}
 
// end get the WAN adapter names and ip addresses
// //////////////////////////////////////////////////////////////////////////////////
 
// start get the KVM guest names and ip addresses
 
// capture output of virsh command to variable $ifcstr
$virshleastr = `virsh net-dhcp-leases default`;
 
// convert string $virshleastr to array of lines $virshleastrarr
// use linefeed as field delimiter in array population
$virshleastrarr = explode("\n",$virshleastr);
 
// count lines in the array
$virshleastrarrnumlines = count($virshleastrarr);
 
$kvmnamestrarr = array();
$kvmipstrarr = array();
 
// iterate through array of lines
for ( $j=0;$j<$virshleastrarrnumlines;$j++) {
    if ( str_contains($virshleastrarr[$j],"ipv4")) {
        $ipv4str = "ipv4";
        $ipv4strloc = strpos("$virshleastrarr[$j]", $ipv4str) + 11;
        $kvmlinestr = substr($virshleastrarr[$j],$ipv4strloc,50);
        $slashstr = "/";
        $slashstrloc = strpos("$kvmlinestr",$slashstr);
        $kvmipstr = substr($kvmlinestr,0,$slashstrloc);
        $kvmnamestr = substr($kvmlinestr,$slashstrloc+5,12);
        $kvmnamestr = trim($kvmnamestr);
        //stuff the arrays they will match by number because done at same time
        $kvmnamestrarr[] = $kvmnamestr;
        $kvmipstrarr[] = $kvmipstr;
    } // close if str contains "ipv4"
} // end for $j
 
$kvmnumlines = count ($kvmnamestrarr);
if (!$kvmnumlines) {
    echo "no VM guest DHCP leases found. Please start a VM.\nStopping.\n";
    exit();
}

// end get the KVM guest names and ip addresses
// //////////////////////////////////////////////////////////////////////////////////
 
// start ask client to choose WAN adapter
 
// show the possible WAN adapters as a numbered list to console:
echo "WAN adapters\n";
for ($k=0;$k<$adnamestrarrnumlines;$k++) {
    $displaynum = $k + 1;
    echo "$displaynum. $adnamestrarr[$k] $adipstrarr[$k]\n";
}
 
echo "\n";
 
// use readline function to ask questions interactively
// trap function in a while condition for sanity checking on input until satisfied
$wananswer = "";
while (!$wananswer || ($wananswer>$displaynum) || !is_numeric($wananswer) ) {
    $wananswer = readline("Please choose a WAN adapter (1-$displaynum): ");
}
 
echo "choice entered: $wananswer\n";
 
// because humans start at 1 and computers start at 0
$wanchoiceminus = $wananswer - 1;
 
$wanadaptername = $adnamestrarr[$wanchoiceminus];
$wanadapterip = $adipstrarr[$wanchoiceminus];
 
echo "\n";
echo "wanadaptername: $wanadaptername\n";
echo "wanadapterip: $wanadapterip\n";
echo "\n";
 
// end ask client to choose WAN adapter
// //////////////////////////////////////////////////////////////////////////////////
 
// start ask client to choose KVM guest
 
// show the possible KVM guests as a numbered list to console:
echo "KVM guests\n";
echo "(hint: if a VM is not listed here, start the VM so it gets a DHCP lease)\n";
for ($m=0;$m<$kvmnumlines;$m++) {
    $displaynum = $m + 1;
    echo "$displaynum. $kvmnamestrarr[$m] $kvmipstrarr[$m]\n";
}
 
echo "\n";
 
// use readline function to ask questions interactively
// trap function in a while condition for sanity checking on input until satisfied
$kvmanswer = "";
while (!$kvmanswer || ($kvmanswer>$displaynum) || !is_numeric($kvmanswer) ) {
    $kvmanswer = readline("Please choose a KVM guest (1-$displaynum): ");
}
 
echo "choice entered: $kvmanswer\n";
 
// because humans start at 1 and computers start at 0
$kvmchoiceminus = $kvmanswer - 1;
 
// we should not confuse kvm guest name with kvmadaptername
// we hardcode the name of the kvm adapter as the string "virbr0"
$kvmadaptername = "virbr0";
$kvmadapterip = $kvmipstrarr[$kvmchoiceminus];
 
echo "\n";
echo "kvmadaptername: $kvmadaptername\n";
echo "kvmadapterip: $kvmadapterip\n";
echo "\n";
 
// end ask client to choose KVM guest
// //////////////////////////////////////////////////////////////////////////////////
 
// start engine section
 
// construct the string variable containing the contents of the script file
 
$timestring = date("Y/m/d H:i:s T");
 
// start from nothing
$scriptcontents = "";
 
$scriptcontents .= "#!/usr/bin/bash\n";
$scriptcontents .= "# generated $timestring by forwardportstoguestgenerator.php v0102\n";
$scriptcontents .= "# Gordon Buchan https://gordonbuchan.com\n";
$scriptcontents .= "\n";
$scriptcontents .= "# values\n";
$scriptcontents .= "kvmsubnet=\"$kvmsubnet\"\n";
$scriptcontents .= "wanadaptername=\"$wanadaptername\"\n";
$scriptcontents .= "wanadapterip=\"$wanadapterip\"\n";
$scriptcontents .= "kvmadaptername=\"$kvmadaptername\"\n";
$scriptcontents .= "kvmadapterip=\"$kvmadapterip\"\n";
$scriptcontents .= "\n";
$scriptcontents .= "# allow virtual adapter to accept packets from outside the host\n";
$scriptcontents .= "iptables -I FORWARD -i \$wanadaptername -o \$kvmadaptername -d \$kvmsubnet -j ACCEPT\n";
$scriptcontents .= "iptables -I FORWARD -i \$kvmadapterip -o \$wanadaptername -s \$kvmsubnet -j ACCEPT\n";
$scriptcontents .= "# forward ports from host to guest\n";
$scriptcontents .= "iptables -t nat -A PREROUTING -i \$wanadaptername -d \$wanadapterip -p tcp --dport 80 -j  DNAT --to-destination \$kvmadapterip:80\n";
$scriptcontents .= "iptables -t nat -A PREROUTING -i \$wanadaptername -d \$wanadapterip -p tcp --dport 443 -j DNAT --to-destination \$kvmadapterip:443\n";
$scriptcontents .= "iptables -t nat -A PREROUTING -i \$wanadaptername -d \$wanadapterip -p tcp --dport 8022 -j DNAT --to-destination \$kvmadapterip:22\n";
 
$scriptfilename = "forwardportstoguestscript.sh";
 
# write the text file
$fh = fopen("$scriptfilename","w");
$filesuccess = fwrite($fh,$scriptcontents);
fclose($fh);
 
if ($filesuccess) {
    echo "SUCCESS script written to file: $scriptfilename\n";
    chmod("$scriptfilename", 0755);
    $scriptperms = substr(sprintf('%o', fileperms("$scriptfilename")), -4);
    echo "scriptperms: $scriptperms\n";
    if ($scriptperms == "0755") {
        echo "SUCCESS chmod 755 $scriptfilename successful.\n";
    } else {
        echo "ERROR chmod 755 not $scriptfilename not successful.\n";
    }
} else {
    echo "ERROR script not written to file: $scriptfilename\n";
}
 
// end engine section
// /////////////////////
forwardportstoguestgenerator.php
