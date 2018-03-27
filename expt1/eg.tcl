proc expt1 {agent cbr_rate} {
	#Make a NS simulator
	global nf ns
	set ns [new Simulator]
	#Write trace data to file
	set nf [open pra.tr w] 			
	$ns trace-all $nf

	#Defining finish procedure
	proc finish {} {
	       	global nf ns
		$ns flush-trace
		close $nf
	        exit 0
	}

	#Creating the 6 nodes
	set n1 [$ns node] 
	set n2 [$ns node]
	set n3 [$ns node]
	set n4 [$ns node]
	set n5 [$ns node]
	set n6 [$ns node]

	#Creating links of the nodes
	$ns duplex-link $n1 $n2 10Mb 10ms DropTail
	$ns duplex-link $n5 $n2 10Mb 10ms DropTail
	$ns duplex-link $n2 $n3 10Mb 10ms DropTail
	$ns duplex-link $n3 $n4 10Mb 10ms DropTail
	$ns duplex-link $n3 $n6 10Mb 10ms DropTail

	#Setting the queue limit
	$ns queue-limit $n2 $n3 10

	#Setting TCP stream from node n1 to node n4

	#Setting the TCP sending module depending on the TCP Variants to node 1
	if {$agent == "Tahoe"} {
		set tcp [new Agent/TCP]
	} else {
		set tcp [new Agent/TCP/$agent]
	}
	$ns attach-agent $n1 $tcp

	#Setting the TCP receiving module to node 4
	set sink [new Agent/TCPSink]
	$ns attach-agent $n4 $sink

	#Directing traffic from 'tcp' to 'sink'
	$ns connect $tcp $sink
	$tcp set fid_ 1

	#Setting up the FTP over TCP connection
        set ftp [new Application/FTP]
        $ftp attach-agent $tcp
        $ftp set type_ FTP

	#Setting UDP stream from node n2 and node n3

	#Setting up the UDP connection
	set udp [new Agent/UDP] 
	$ns attach-agent $n2 $udp
	set udpsink [new Agent/Null]
	$ns attach-agent $n3 $udpsink
	$ns connect $udp $udpsink
	$udp set fid_ 2

	#Adding a CBR over UDP connection
	set cbr [new Application/Traffic/CBR] 
	$cbr attach-agent $udp
	$cbr set type_ CBR
	$cbr set packetSize_ 1000 
	$cbr set rate_ ${cbr_rate}mb  
	$cbr set random_ false 

	#Adding start/stop times for cbr and ftp
	$ns at 0.1 "$cbr start"
	$ns at 0.5 "$ftp start" 
	$ns at 9.0  "$ftp stop"
	$ns at 9.5 "$cbr stop"

	#Setting Simulation end time
	$ns at 10.0 "finish"

	$ns run
}


expt1 [lindex $argv 0] [lindex $argv 1]
