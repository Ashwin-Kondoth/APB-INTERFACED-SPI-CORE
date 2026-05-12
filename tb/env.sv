class core_env extends uvm_env;
	`uvm_component_utils(core_env)

	apb_agent apb_agth;
	spi_agent spi_agth;
	core_sb sbh;
	env_config cfg;
	apb_agent_config apb_cfg;
	spi_agent_config spi_cfg;

	bit has_apb_agent = 1;
	bit has_spi_agent = 1;	
	
	int unsigned num_of_apb_agents = 1;
	int unsigned num_of_spi_agents = 1;

	bit has_scoreboard = 1;
	bit has_virtual_sequencer = 1;

	function new(string name = "core_env",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass : core_env

function void core_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(has_apb_agent)
		begin
			apb_agth = apb_agent::type_id::create("abp_agth",this);
		end
	spi_agth = spi_agent::type_id::create("spi_agth",this);
	sbh = core_sb::type_id::create("sbh",this);
endfunction : build_phase

function void core_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	apb_agth.monh.monitor_port.connect(sbh.apb_fifo.analysis_export);
	spi_agth.monh.monitor_port.connect(sbh.spi_fifo.analysis_export);
endfunction : connect_phase
