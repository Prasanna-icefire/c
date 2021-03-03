


































































#Write a TCL script to simulate the following scenario.
#Consider six nodes, (as shown in the figure below) moving within a flat topology of 700m x 700m. 
#The initial positions of nodes are: n0(150, 300), n1(300, 500), n2(500, 500), n3 (300, 100), n4(500, 100) and n5(650, 300) respectively. 
#A TCP connection is initiated between n0 (source) and n5 (destination) through n3 and n4 i.e., the route is 0-3-4-5. 
#At time t = 3 seconds, the FTP application runs over it. After time t = 4 seconds, n3(300,100) moves towards n1(300, 500) with a speed of 5.0m/sec 
#and after some time the path breaks. 
#The data is then transmitted with a new path via n1 and n2 i.e., the new route is 0-1-2-5. 
#The simulation lasts for 60 secs. In the above said case both the routes have equal cost. Use DSR as the routing protocol and the IEEE 802.11 MAC protocol.

set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
#set val(ifq) Queue/DropTail/PriQueue
set val(ifq) CMUPriQueue 
set val(ll)	LL
set val(ant) Antenna/OmniAntenna
set val(x) 700	
set val(y) 700	
set val(ifqlen) 50		
set val(nn) 6		
set val(stop) 60.0		
set val(rp) DSR

set ns_ [new Simulator] 

set tracefd	[open 9.tr w]
$ns_ trace-all $tracefd

set namtrace [open 9.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

set prop	[new $val(prop)]

set topo	[new Topography]
$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
         	 -phyType $val(netif) \
          	 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace ON

#Creating Nodes					 
for {set i 0} {$i < $val(nn) } {incr i} {
     set node_($i) [$ns_ node]	
     $node_($i) random-motion 0
}

#initialNodePositions
#Initial Positions of Nodes			



$node_(0) set X_ 150.0
$node_(0) set Y_ 300.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 300.0
$node_(1) set Y_ 500.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 500.0
$node_(2) set Y_ 500.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 300.0
$node_(3) set Y_ 100.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 500.0
$node_(4) set Y_ 100.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 650.0
$node_(5) set Y_ 300.0
$node_(5) set Z_ 0.0

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 40
}

$ns_ at 1.0 "$node_(0) setdest 160.0 300.0 2.0"
$ns_ at 1.0 "$node_(1) setdest 310.0 490.0 2.0"
$ns_ at 1.0 "$node_(2) setdest 490.0 490.0 2.0"
$ns_ at 1.0 "$node_(3) setdest 300.0 120.0 2.0"
$ns_ at 1.0 "$node_(4) setdest 510.0 90.0 2.0"
$ns_ at 1.0 "$node_(5) setdest 640.0 290.0 2.0"

$ns_ at 4.0 "$node_(3) setdest 300.0 500.0 5.0"

 set tcp0 [new Agent/TCP]
      set sink0 [new Agent/TCPSink]
   $ns_ attach-agent $node_(0) $tcp0
       $ns_ attach-agent $node_(5) $sink0
   $ns_ connect $tcp0 $sink0
   set ftp0 [new Application/FTP]
   $ftp0 attach-agent $tcp0
   $ns_ at 5.0 "$ftp0 start" 
       $ns_ at 60.0 "$ftp0 stop"

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop) "$node_($i) reset";
    }
    $ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"

puts "Starting Simulation..."
     $ns_ run
