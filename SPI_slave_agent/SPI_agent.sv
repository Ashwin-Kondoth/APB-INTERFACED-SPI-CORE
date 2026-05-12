class spi_agent extends uvm_agent;
	`uvm_component_utils(spi_agent)
	
	spi_driver drvh;
	spi_sequencer seqrh;
	spi_monitor monh;

	function new(string name = "spi_agent", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : spi_agent

function void spi_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	drvh = spi_driver::type_id::create("drvh",this);
	seqrh = spi_sequencer::type_id::create("seqrh",this);
	monh = spi_monitor::type_id::create("monh",this);
endfunction : build_phase

function void spi_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction : connect_phase
