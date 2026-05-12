class spi_driver extends uvm_driver #(spi_xtn);
	`uvm_component_utils(spi_driver)

	function new(string name = "spi_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : spi_driver

function void spi_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction : build_phase

function void spi_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction : connect_phase

task spi_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
