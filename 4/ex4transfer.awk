BEGIN{
    total_byte_sent = 0;
    total_byte_received = 0;
}
{
    if($1=="r" && $4=="1" && $5=="tcp")
        total_byte_received+=$6;
    if($1=="+" && $3=="0" && $5=="tcp")
        total_byte_sent+=$6
}   
{
    print("Bytes sent %f Mbps",total_byte_sent/1000000)
    print("Bytes received %f Mbps",total_byte_received/1000000)
    print("Time ",$2)
}