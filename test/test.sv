class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	
	core_env envh;
	
	function new(string name = "base_test",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass : base_test

function void base_test::build_phase(uvm_phase phase);
	envh = core_env::type_id::create("envh",this);
endfunction : build_phase

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
