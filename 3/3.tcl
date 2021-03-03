
















































#Question: Design networks that demonstrate the working of Distance vector routing
#protocol. The link between node 1 and 4 breaks at 1.0 ms and comes up at 3.0ms. Assume
#that the source node 0 transmits packets to node 4. Plot the congestion window when

set ns [new Simulator]
set tfd [open 3.tr w]
$ns trace-all $tfd

set nfd [open 3.nam w]
$ns namtrace-all $nfd

set cwind [open win.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n5 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n2 1Mb 10ms DropTail
$ns duplex-link $n0 $n2 1Mb 10ms DropTail

$ns set queue-limit $n1 $n4 10
$ns set queue-limit $n2 $n3 10

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
$tcp0 set fid_ 1
set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns rtmodel-at 1.0 down $n1 $n4 
$ns rtmodel-at 3.0 up $n1 $n4 

proc plotWindow {tcpSource file} {
    global ns
    set time 0.01
    set now [$ns now]
    set cwnd [$tcpSource set cwnd_]
    puts $file "$now $cwnd"
    $ns at [expr $now + $time] "plotWindow $tcpSource $file"
}

$ns at 0.5 "plotWindow $tcp0 $cwind"

$ns at 0.1 "$ftp0 start"
$ns at 10.0 "$ftp0 stop"
$ns at 10.1 "finish"

proc finish {} {
    global ns tfd nfd
    $ns flush-trace
    close $tfd
    close $nfd
    exec nam 3.nam &
    exec xgraph win.tr &
    exit 0
}

$ns run

