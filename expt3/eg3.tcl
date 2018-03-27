proc expt3 {agent queue_type} {

	#Making a NS Simulator
	global nf ns
	set ns [new Simulator]

	#Writing trace data tofile
	set nf [open pra3.tr w]
	$ns trace-all $nf

	#Defining a finish procedure
	proc finish {} {
        	global nf ns
		$ns flush-trace
        	close $nf
        	exit 0
	}

	#Creating the nodes
	set n1 [$ns node]
	set n2 [$ns node]
	set n3 [$ns node]
	set n4 [$ns node]
	set n5 [$ns node]
	set n6 [$ns node]

	#Creating the links between the nodes
        $ns duplex-link $n1 $n2 10Mb 10ms $queue_type
        $ns duplex-link $n5 $n2 10Mb 10ms $queue_type
        $ns duplex-link $n2 $n3 10Mb 10ms $queue_type
        $ns duplex-link $n3 $n4 10Mb 10ms $queue_type
	$ns duplex-link $n3 $n6 10Mb 10ms $queue_type

	#Adding the queue limit to each link
	$ns queue-limit $n1 $n2 10
	$ns queue-limit $n5 $n2 10
	$ns queue-limit $n2 $n3 10
	$ns queue-limit $n3 $n4 10
	$ns queue-limit $n3 $n6 10

	#Setting up the TCP connection from node n1 to node n4
	if {$agent == "Reno" || $agent == "Sack1"} {
                set tcp [new Agent/TCP/$agent]
	} else {
		puts "Only Reno and SACK is supported"
	}
	if {$agent == "Reno"} {
		 set sink [new Agent/TCPSink]
	}
	if {$agent == "Sack1"} {
		 set sink [new Agent/TCPSink/Sack1]
	}
        $ns attach-agent $n1 $tcp
	$ns attach-agent $n4 $sink

	#Directing traffic from tcp to sink
	$ns connect $tcp $sink
	$tcp set fid_ 1

	#Setting a window size
	$tcp set window_ 80
	$tcp set cwnd_ 100

	#Setting up a FTP over TCP connection
        set ftp [new Application/FTP]
        $ftp attach-agent $tcp
	$ftp set type_ FTP

	#Setting up the UDP connection from node n5 to node n6
	set udp [new Agent/UDP]
	$ns attach-agent $n5 $udp
	set udpsink [new Agent/Null]
	$ns attach-agent $n6 $udpsink
	$ns connect $udp $udpsink
	$udp set fid_ 2

	#Setting the CBR over UDP connection
	set cbr [new Application/Traffic/CBR]
	$cbr attach-agent $udp
	$cbr set type_ CBR
	$cbr set rate_ 7mb

	#Setting the start/end time
	$ns at 0.0 "$ftp start"
	$ns at 3.0 "$cbr start"
	$ns at 10.0 "$ftp stop"
	$ns at 10.0 "$cbr stop"

	#Setting the simulation end time
	$ns at 10.0 "finish"

	$ns run
}

#Passing Arguments as TCP VAriant and Queuing Discipline
expt3 [lindex $argv 0] [lindex $argv 1]
