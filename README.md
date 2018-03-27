# TCP-Simulation-in-NS-2
Performance Analysis of TCP Variants

High- level Approach:

This project evaluates the performance of the TCP variants: Tahoe,Reno,New Reno and Vegas by computing the following 
under various load conditions and queuing algorithms:
throughput, fairness, latency and average packet loss 
NS2 network simulator environment is used and carried out the following 3 experiments for the analysis.

Experiment 1 : Performance of TCP under congestion

	Analyse the 4 TCP variants under various load conditions by changing the CBR bandwidth.
	Set up the network topology as asked.
	Only one TCP flow is set from node1 to node4. CBR flow rate is linearly varied from 1 Mbps to 10Mbps.
	For the analysis - 
		1) Start and end TCP and CBR flows at once.
		2) Start CBR flow once TCP is stable.
		3) Vary the start and end times of both flows.
		4) Start CBR flow when TCp is in slow start phase.

	Throughput, latency and packet drop rate for every TCP variant is computed.
                                     
Experiment 2 :Fairness Between TCP Variants 
  
  	Test the amount of fair usage of resources if two TCP flows have the same resources available.
  	One TCP flow has its source at node 1 and sink at node 4 and another TCP flow has its source at node 5 and sink at node 6.
	The CBR rate is increased from 1Mbps to 10Mbps.
  	Fairness is analysed by plotting graphs for throughput, latency and drop rate for each flow with respect to CBR flow rate.


Experiment 3: Influence of Queuing

  	Demonstrate the effects of queuing algorithms over the performance of TCP variants.
    	Drop Tail and Random Early Detection (RED) are the algorithms used on the throughput and Delay of TCP Reno and SACK.
  	Here, CBR rate is fixed at 7Mbps and packets start flowing after 3 secs when TCP gets stable   
	Throughput and Latency is computed to analyse the response of each variant with both the queuing algorithms

All these experiments can be executed by running the script file present in each experiment folder
The script file first executes the tcl file and then the python code to perform the experiment
The tcl file creates a trace file on execution which is automatically deleted when the python file is run.

Individual Contribution:

Riteshkumar Gupta 001280361

Developed python script for experiment 1 to calculate throughput, latency and packet drop rate.
Developed TCL script for experiment 2 by adding another TCP flow
Developed TCL script for experiment 3 by adding conditions for queuing algorithms.
Implemented T test on experiment 2 to observe fairness between TCP variants and plotted graphs for experiment 2.
Worked on experiment 1 and 2, conclusion section of the report.
Developed Script files of Experiment 1 and 2

Prajwal Patil 001280390

Devloped the TCL file for experiment 1 which generates a trace file consisting information of the data flow.
Futrher Modified python script for experiment 2 by adding one TCP flow.
Developed Python Script for Experiment 3
Implemented T test and plotted graphs for experiment 1 and 3.
Worked on abstract, introduction,methodolgy, experiment 1 and experiment 3 of the report.
Developed Script files of Experiment 3
