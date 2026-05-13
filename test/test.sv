class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	
	env_config cfg;
	apb_agent_config apb_cfg[];
	spi_agent_config spi_cfg[];

	bit has_apb_agent = 1;
	bit has_spi_agent = 1;	
	
	int unsigned num_of_apb_agents = 1;
	int unsigned num_of_spi_agents = 1;

	bit has_scoreboard = 1;
	bit has_virtual_sequencer = 1;

	core_env envh;
	
	function new(string name = "base_test",uvm_component parent);
		super.new(name,parent);
		cfg = env_config::type_id::create("cfg");
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void config_env();
	extern function void connect_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass : base_test

function void base_test::build_phase(uvm_phase phase);
	if(has_apb_agent)
		begin
			apb_cfg = new[num_of_apb_agents];
			foreach (apb_cfg[i]) 
				begin
					apb_cfg[i] = apb_agent_config::type_id::create($sformatf("apb_cfg[%0d]",i));
					apb_cfg[i].is_active = UVM_ACTIVE;
					if(!uvm_config_db #(virtual apb_if)::get(this,"",$sformatf("vif[%0d]",i),apb_cfg[i].vif))
						`uvm_fatal("TEST","get failed for apb_vif")
					cfg.apb_cfg[i] = apb_cfg[i];
				end
		end
	
	if(has_spi_agent)
		begin
			spi_cfg = new[num_of_spi_agents];
			foreach (spi_cfg[i]) 
				begin
					spi_cfg[i] = spi_agent_config::type_id::create($sformatf("spi_cfg[%0d]",i));
					spi_cfg[i].is_active = UVM_ACTIVE;
					if(!uvm_config_db #(virtual spi_if)::get(this,"",$sformatf("vif[%0d]",i),spi_cfg[i].vif))
						`uvm_fatal("TEST","get failed for spi_vif")
					cfg.spi_cfg[i] = spi_cfg[i];
				end
		end
	config_env();
	envh = core_env::type_id::create("envh",this);
	
endfunction : build_phase

function void base_test::config_env();
	cfg.has_apb_agent = has_apb_agent;
	cfg.has_spi_agent = has_spi_agent;	
	
	cfg.num_of_apb_agents = num_of_apb_agents;
	cfg.num_of_spi_agents = num_of_spi_agents;

	cfg.has_scoreboard = has_scoreboard;
	cfg.has_virtual_sequencer = has_virtual_sequencer;

	uvm_config_db #(env_config)::set(this,"*","env_config",cfg);

endfunction : config_env

function void base_test::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction : connect_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction : end_of_elaboration_phase

task base_test::run_phase (uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
		#10;
	phase.drop_objection(this);
endtask : run_phase
