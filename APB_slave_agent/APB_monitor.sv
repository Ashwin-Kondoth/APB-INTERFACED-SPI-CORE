class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)
	
	virtual apb_if.APB_MON_MP vif;
	apb_agent_config cfg;
	uvm_analysis_port #(apb_xtn) monitor_port;
	
	function new(string name = "apb_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass : apb_monitor

function void apb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_agent_config)::get(this,"","apb_agent_config",cfg))
		`uvm_fatal("APB MON","get failed for apb_agent_config")
endfunction : build_phase

function void apb_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif = cfg.vif;
endfunction : connect_phase

task apb_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever
		collect_data();
endtask : run_phase

task apb_monitor::collect_data();
	apb_xtn xtn;
	xtn = apb_xtn::type_id::create("xtn");
	wait(vif.apb_mon_cb.PENABLE && vif.apb_mon_cb.PREADY)
		xtn.PRESET_n = vif.apb_mon_cb.PRESET_n;
		xtn.PSEL = vif.apb_mon_cb.PSEL;
		xtn.PENABLE = vif.apb_mon_cb.PENABLE;
		xtn.PWRITE = vif.apb_mon_cb.PWRITE;
		xtn.PADDR = vif.apb_mon_cb.PADDR;
		if(xtn.PWRITE)
			xtn.PWDATA = vif.apb_mon_cb.PWDATA;
		else
			begin
				xtn.PRDATA = vif.apb_mon_cb.PRDATA;
				if(xtn.PRDATA != 8'h55)
					`uvm_fatal("APB_MON","DATA_MISMATCH")
			end
	xtn.print();
	@(vif.apb_mon_cb);
endtask : collect_data
