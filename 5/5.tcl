















































#multicastProtocol
set ns [new Simulator -multicast on]
set tracefd [open 5.tr w]
$ns trace-all $tracefd
set namfd [open 5.nam w]
$ns namtrace-all $namfd

#creating Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$ns duplex-link $n0 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n5 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 10ms DropTail
$ns duplex-link $n7 $n3 1.5Mb 10ms DropTail

#routing Protocols DM,ST,BST DM means DenseMode
set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

#Allocate Groups
set group1 [Node allocaddr]
set group2 [Node allocaddr]

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set dst_addr_ $group1
$udp0 set dst_port_ 0

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0


set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
$udp1 set dst_addr_ $group2
$udp1 set dst_port_ 0
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1

#Creating Receivers
set rx1 [new Agent/Null]
$ns attach-agent $n5 $rx1
$ns at 1.0 "$n5 join-group $rx1 $group1"

set rx2 [new Agent/Null]
$ns attach-agent $n6 $rx2
$ns at 1.5 "$n6 join-group $rx2 $group1"

set rx3 [new Agent/Null]
$ns attach-agent $n7 $rx3
$ns at 2.0 "$n7 join-group $rx3 $group1"

set rx4 [new Agent/Null]
$ns attach-agent $n5 $rx4
$ns at 2.5 "$n5 join-group $rx4 $group2"

set rx5 [new Agent/Null]
$ns attach-agent $n6 $rx5
$ns at 3.0 "$n6 join-group $rx5 $group2"

set rx6 [new Agent/Null]
$ns attach-agent $n7 $rx5
$ns at 3.5 "$n7 join-group $rx5 $group2"


$ns at 4.0 "$n5 leave-group $rx1 $group1"
$ns at 4.5 "$n6 leave-group $rx2 $group1"
$ns at 5.0 "$n7 leave-group $rx3 $group1"
$ns at 5.5 "$n5 leave-group $rx4 $group2"
$ns at 6.0 "$n6 leave-group $rx5 $group2"
$ns at 6.5 "$n7 leave-group $rx6 $group2"

#Start application layer shits
$ns at 0.5 "$cbr1 start"
$ns at 0.5 "$cbr2 start"
$ns at 9.0 "$cbr1 stop"
$ns at 9.0 "$cbr2 stop"

$ns at 10.0 "finish"

proc finish {} {
    global ns tracefd namfd
    $ns flush-trace
    close $tracefd
    close $namfd
    exec nam 5.nam &
    exit 0
}

$n0 label "source1"
$n1 label "source2"
$ns color 1 red
$ns color 2 blue


$ns run




