BEGIN{
    time = 0;
    total_byte_received = 0;
}
{
    if($1=="r" && $4=="1" && $5=="tcp")
    {
        total_byte_received+=$6;
        time = $2;
        printf("\n%f\t%f",time,(total_byte_received)/1000000);
    }
}   
{
}