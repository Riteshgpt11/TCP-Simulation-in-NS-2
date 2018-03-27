proc expt2 {agent1 agent2 cbr_rate} {

	#Making a NS Simulator
	global nf ns
	set ns [new Simulator]

	#Writing Trace data to file
	set nf [open pra2.tr w]
	$ns trace-all $nf

	#Defining finish procedure
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
	$ns duplex-link $n1 $n2 10Mb 10ms DropTail
	$ns duplex-link $n2 $n3 10Mb 10ms DropTail
	$ns duplex-link $n4 $n3 10Mb 10ms DropTail
	$ns duplex-link $n3 $n6 10Mb 10ms DropTail
	$ns duplex-link $n5 $n2 10Mb 10ms DropTail

	#Setting up the queue limit 
	$ns queue-limit $n2 $n3 10

	#Setting up a TCP stream1 'tcp1' from node n1 to node n4

	#Adding a TCP sending module to node n1
	set tcp1 [new Agent/TCP/$agent1]
	$ns attach-agent $n1 $tcp1

	#Adding a TCP receiving module to node n4
	set sink1 [new Agent/TCPSink]
	$ns attach-agent $n4 $sink1

	#Directing traffic from tcp1 to sink1
	$ns connect $tcp1 $sink1
	$tcp1 set fid_ 1
	
	#Setting up a TCP stream2 'tcp2' from node n5 to node n6

	#Adding a TCP sending module to node n5
	set tcp2 [new Agent/TCP/$agent2]
	$ns attach-agent $n5 $tcp2

	#Adding a TCP receiving module to node n6
	set sink2 [new Agent/TCPSink]
	$ns attach-agent $n6 $sink2

        #Directing traffic from tcp2 to sink2
	$ns connect $tcp2 $sink2
	$tcp2 set fid_ 2

	#Setting up FTP ftp1 over TCP Connection1 tcp1
        set ftp1 [new Application/FTP]
        $ftp1 attach-agent $tcp1
        $ftp1 set type_ FTP

        #Setting up FTP ftp2 over TCP Connection2 tcp2
        set ftp2 [new Application/FTP]
        $ftp2 attach-agent $tcp2
        $ftp2 set type_ FTP

	#Setting up a UDP connection from node n2 to node n3
	set udp [new Agent/UDP]
	$ns attach-agent $n2 $udp
	set udpsink [new Agent/Null]
	$ns attach-agent $n3 $udpsink
	$ns connect $udp $udpsink
	$udp set fid_ 3

	#Setting up CBR over UDP connection
	set cbr [new Application/Traffic/CBR]
	$cbr attach-agent $udp
	$cbr set type_ CBR
	$cbr set packet_size_ 1000
	$cbr set rate_ ${cbr_rate}mb
	$cbr set random_ false

	#Setting up start/stop time
	$ns at 0.1 "$cbr start"
	$ns at 0.5 "$ftp1 start"
	$ns at 0.5 "$ftp2 start"
	$ns at 9.0 "$ftp1 stop"
	$ns at 9.0 "$ftp2 stop"
	$ns at 9.5 "$cbr stop"

	#Setting the simulation end time
	$ns at 10.0 "finish"

	$ns run

}

#Passing arguments as TCPVariant1, TCPVariant2 and CBR value
expt2 [lindex $argv 0] [lindex $argv 1] [lindex $argv 2]
