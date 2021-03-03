
















































#Question: Consider a client and a server. The server is running an FTP application over
#TCP. The client sends a request to download a file of size 10 MB from the server. Write a
#TCL script to simulate this scenario. Let node n0 be the server and node n1 be the client.
#TCP packet size is 1500 Bytes.


set ns [new Simulator]
set tfd [open 4.tr w]
$ns trace-all $tfd

set nfd [open 4.nam w]
$ns namtrace-all $nfd

#create server and client nodes
set s [$ns node]
set c [$ns node]

$ns duplex-link $s $c 10Mb 22ms DropTail
$ns duplex-link-op $s $c orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $s $tcp0
$tcp0 set packetSize_ 1500

set sink0 [new Agent/TCPSink]
$ns attach-agent $c $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$tcp0 set fid_ 1

proc finish {} {
    global ns tfd nfd
    $ns flush-trace
    close $tfd
    close $nfd
    exec nam 4.nam &
    exec awk -f ex4transfer.awk 4.tr &
    exec awk -f ex4convert.awk 4.tr > convert.tr &
    exec xgraph convert.tr -geometry 800*400 -t "bytes_received_at_client" -x "time in sec" -y "bytes in bps" &
    exit 0
}
$ns at 0.1 "$ftp0 start"
$ns at 15.0 "$ftp0 stop"
$ns at 15.1 "finish"

$ns run