# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   5                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition        
#===================================
#Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n2 50.0Mb 3ms DropTail
$ns queue-limit $n0 $n2 50
$ns duplex-link $n0 $n1 50.0Mb 3ms DropTail
$ns queue-limit $n0 $n1 50
$ns duplex-link $n2 $n1 50.0Mb 3ms DropTail
$ns queue-limit $n2 $n1 50
$ns duplex-link $n1 $n3 75.0Mb 6ms DropTail
$ns queue-limit $n1 $n3 50
$ns duplex-link $n3 $n4 75.0Mb 6ms DropTail
$ns queue-limit $n3 $n4 50
$ns duplex-link $n0 $n4 90.0Mb 8ms DropTail
$ns queue-limit $n0 $n4 50
$ns duplex-link $n3 $n5 90.0Mb 8ms DropTail
$ns queue-limit $n3 $n5 50
$ns duplex-link $n4 $n5 90.0Mb 8ms DropTail
$ns queue-limit $n4 $n5 50

 
#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink4 [new Agent/TCPSink]
$ns attach-agent $n3 $sink4
$ns connect $tcp0 $sink4
$tcp0 set packetSize_ 1500

#Setup a TCP connection
set tcp1 [new Agent/TCP/Reno]
$ns attach-agent $n2 $tcp1
set sink3 [new Agent/TCPSink]
$ns attach-agent $n5 $sink3
$ns connect $tcp1 $sink3
$tcp1 set packetSize_ 1500

#Setup a TCP connection
set tcp2 [new Agent/TCP/Vegas]
$ns attach-agent $n4 $tcp2
set sink5 [new Agent/TCPSink]
$ns attach-agent $n1 $sink5
$ns connect $tcp2 $sink5
$tcp2 set packetSize_ 1500


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"

#Setup a FTP Application over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.0 "$ftp1 start"
$ns at 2.0 "$ftp1 stop"

#Setup a FTP Application over TCP connection
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 1.0 "$ftp2 start"
$ns at 2.0 "$ftp2 stop"


proc plotWindow {tcpSource filename} {
global ns
set now [$ns now]
set cwnd [$tcpSource set cwnd_]

puts $filename "$now $cwnd"
$ns at [expr $now+0.1] "plotWindow $tcpSource $filename"
}

set outfile [open "tcp0.plot" w]
$ns at 0.0 "plotWindow $tcp0 $outfile"

set outfile1 [open "Renotcp1.plot" w] 
$ns at 0.0 "plotWindow $tcp1 $outfile1"

set outfile2 [open "Vegastcp2.plot" w] 
$ns at 0.0 "plotWindow $tcp2 $outfile2"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
