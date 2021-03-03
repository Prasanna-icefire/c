















































#Set up a 2-node wireless network. Analyze TCP performance for this scenario with DSDV as routing protocol.
set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(ant) Antenna/OmniAntenna
set val(nn) 2
set val(x) 500
set val(y) 500
set val(rp) DSDV
set val(stop) 20.0
set val(ll) LL
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(mac) Mac/802_11
set val(rp) DSDV
set val(phy) Phy/WirelessPhy

set ns [new Simulator]

set tracefd [open 6.tr w]
$ns trace-all $tracefd

set namtrace [open 6.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set prop [new $val(prop)]

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)


$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -phyType $val(phy) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -channelType $val(chan) \
                -topoInstance $topo \
                -antType $val(ant) \
                -macType $val(mac) \
                -propType $val(prop) \
                -agentTrace ON \
                -macTrace ON \
                -routerTrace ON 

#create 2 Nodes

for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
    $node_($i) random-motion 0
}

#initial Positions
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $node_($i) 40
}

#topology Design
$ns at 1.1 "$node_(0) setdest 310.0 10.0 20.0"
$ns at 1.1 "$node_(1) setdest 10.0 310.0 20.0"

#generate Traffic
set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]

$ns attach-agent $node_(0) $tcp0
$ns attach-agent $node_(1) $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns at 1.0 "$ftp0 start"
$ns at 18.0 "$ftp0 stop"

#Simulation Termination
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at $val(stop) "$node_($i) reset";
}
    $ns at $val(stop) "puts \"NS Exititing...\"; $ns halt"
$ns run



