



















































#Question: Simulate a point-to-point network with duplex link as follows: n0-n2, n1-n2 and
#n2-n3. Apply TCPagent between n0-n3 and UDP agent between n1-n3. Apply relevant
#applications over TCP and UDPagents. Set the queue size to 5 and vary the bandwidth to
#find the number of packets dropped and received by TCP and UDP agents using awk script
#and grep command.

set ns [new Simulator]

set tracefd [open 1.tr w]
$ns trace-all $tracefd

set namfd [open 1.nam w]
$ns namtrace-all $namfd

$ns color 1 Blue
$ns color 2 Red

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 10ms DropTail
$ns queue-limit $n2 $n3 5


set tcp1 [new Agent/TCP]
$ns attach-agent $n3 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 0.1 "$ftp1 start"


set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n3 $null1
$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$ns at 1.1 "$cbr1 start"

$ns at 10.0 "finish"

proc finish {} {
    global ns tracefd namfd
    $ns flush-trace
    close $tracefd
    close $namfd
    exec nam 1.nam &
    exit 0
}

$ns run



