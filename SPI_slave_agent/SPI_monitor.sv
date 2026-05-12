class spi_monitor extends uvm_monitor;
	`uvm_component_utils(spi_monitor)
	
	uvm_analysis_port #(spi_xtn) monitor_port;
	
	function new(string name = "spi_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : spi_monitor

function void spi_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction : build_phase

function void spi_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction : connect_phase

task spi_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
