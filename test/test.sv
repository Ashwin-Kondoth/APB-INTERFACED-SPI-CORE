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
	extern function void end_of_elaboration_phase (uvm_phase phase);
	
endclass : base_test

function void base_test::build_phase(uvm_phase phase);
	if(has_apb_agent)
		begin
			apb_cfg = new[num_of_apb_agents];
			cfg.apb_cfg = new[num_of_apb_agents];
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
			cfg.spi_cfg = new[num_of_spi_agents];
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

function void base_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction : end_of_elaboration_phase

class cpha1_cpol1_lsb_test extends base_test;
	`uvm_component_utils(cpha1_cpol1_lsb_test)
	
	bit [7:0] CR1 = 8'b11111111;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha1_cpol1_lsb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha1_cpol1_lsb_test

function void cpha1_cpol1_lsb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha1_cpol1_lsb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha1_cpol1_lsb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase

class cpha0_cpol0_lsb_test extends base_test;
	`uvm_component_utils(cpha0_cpol0_lsb_test)
	
	bit [7:0] CR1 = 8'b11110011;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha0_cpol0_lsb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha0_cpol0_lsb_test

function void cpha0_cpol0_lsb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha0_cpol0_lsb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha0_cpol0_lsb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase

class cpha1_cpol0_lsb_test extends base_test;
	`uvm_component_utils(cpha1_cpol0_lsb_test)
	
	bit [7:0] CR1 = 8'b11110111;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha1_cpol0_lsb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha1_cpol0_lsb_test

function void cpha1_cpol0_lsb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha1_cpol0_lsb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha1_cpol0_lsb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase


class cpha0_cpol1_lsb_test extends base_test;
	`uvm_component_utils(cpha0_cpol1_lsb_test)
	
	bit [7:0] CR1 = 8'b11111011;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha0_cpol1_lsb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha0_cpol1_lsb_test

function void cpha0_cpol1_lsb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha0_cpol1_lsb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha0_cpol1_lsb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase

// MSB FIRST TEST cases

class cpha1_cpol1_msb_test extends base_test;
	`uvm_component_utils(cpha1_cpol1_msb_test)
	
	bit [7:0] CR1 = 8'b11111110;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha1_cpol1_msb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha1_cpol1_msb_test

function void cpha1_cpol1_msb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha1_cpol1_msb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha1_cpol1_msb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase

class cpha0_cpol0_msb_test extends base_test;
	`uvm_component_utils(cpha0_cpol0_msb_test)
	
	bit [7:0] CR1 = 8'b11110010;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha0_cpol0_msb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha0_cpol0_msb_test

function void cpha0_cpol0_msb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha0_cpol0_msb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha0_cpol0_msb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase

class cpha1_cpol0_msb_test extends base_test;
	`uvm_component_utils(cpha1_cpol0_msb_test)
	
	bit [7:0] CR1 = 8'b11110110;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha1_cpol0_msb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha1_cpol0_msb_test

function void cpha1_cpol0_msb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha1_cpol0_msb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha1_cpol0_msb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase


class cpha0_cpol1_msb_test extends base_test;
	`uvm_component_utils(cpha0_cpol1_msb_test)
	
	bit [7:0] CR1 = 8'b11111010;
	bit [7:0] CR2 = 8'b00010000;

	apb_reset_sequence apb_reset_seq;
	apb_write_sequence apb_wr_seq;
	apb_read_sequence apb_rd_seq;
	spi_write_sequence spi_wr_seq;
	
	function new(string name = "cpha0_cpol1_msb_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass : cpha0_cpol1_msb_test

function void cpha0_cpol1_msb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(bit[7:0])::set(this,"*","CR1",CR1);
	uvm_config_db #(bit[7:0])::set(this,"*","CR2",CR2);
	
	apb_reset_seq = apb_reset_sequence::type_id::create("apb_reset_seq");
	apb_wr_seq = apb_write_sequence::type_id::create("apb_wr_seq");
	apb_rd_seq = apb_read_sequence::type_id::create("apb_rd_seq");
	spi_wr_seq = spi_write_sequence::type_id::create("spi_wr_seq");
endfunction : build_phase

function void cpha0_cpol1_msb_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task cpha0_cpol1_msb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for(int i = 0;i < cfg.num_of_apb_agents;i++)
			begin
				apb_reset_seq.start(envh.apb_top.apb_agth[i].seqrh);
				apb_wr_seq.start(envh.apb_top.apb_agth[i].seqrh);
				spi_wr_seq.start(envh.spi_top.spi_agth[i].seqrh);
				apb_rd_seq.start(envh.apb_top.apb_agth[i].seqrh);
			end
			//phase.phase_done.set_drain_time(this,250);
	phase.drop_objection(this);

endtask : run_phase