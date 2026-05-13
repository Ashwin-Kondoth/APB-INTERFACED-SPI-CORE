class core_env extends uvm_env;
	`uvm_component_utils(core_env)

	apb_agent apb_agth;
	spi_agent spi_agth;
	core_sb sbh;

	function new(string name = "core_env",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : core_env

function void core_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	apb_agth = apb_agent::type_id::create("abp_agth",this);
	spi_agth = spi_agent::type_id::create("spi_agth",this);
	sbh = core_sb::type_id::create("sbh",this);
endfunction : build_phase

function void core_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	apb_agth.monh.monitor_port.connect(sbh.apb_fifo.analysis_export);
	spi_agth.monh.monitor_port.connect(sbh.spi_fifo.analysis_export);
endfunction : connect_phase
