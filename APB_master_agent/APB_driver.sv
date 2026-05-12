class apb_driver extends uvm_driver #(apb_xtn);
	`uvm_component_utils(apb_driver)

	function new(string name = "apb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : apb_driver

function void apb_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction : build_phase

function void apb_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction : connect_phase

task apb_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
