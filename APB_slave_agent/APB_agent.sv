class apb_agent extends uvm_agent;
	`uvm_component_utils(apb_agent)
	
	apb_driver drvh;
	apb_sequencer seqrh;
	apb_monitor monh;

	function new(string name = "apb_agent", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : apb_agent

function void apb_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	drvh = apb_driver::type_id::create("drvh",this);
	seqrh = apb_sequencer::type_id::create("seqrh",this);
	monh = apb_monitor::type_id::create("monh",this);
endfunction : build_phase

function void apb_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction : connect_phase
