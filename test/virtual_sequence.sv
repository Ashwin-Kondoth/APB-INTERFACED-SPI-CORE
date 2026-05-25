/*======================================================================
========================VIRTUAL SEQUENCE CLASS==========================
=======================================================================*/

//Base virtual sequence class
class virtual_base_sequence extends uvm_sequence #(uvm_sequence);
    `uvm_object_utils(virtual_base_sequence)

	//virtual sequencer handle
    virtual_sequencer  virt_seqr;

	//sequencer handles
    apb_sequencer      apb_seqr[];
    spi_sequencer      spi_seqr[];

	//sequence handles
    apb_reset_sequence apb_reset_seq;
    apb_write_sequence apb_wr_seq;
    apb_read_sequence  apb_rd_seq;
    spi_write_sequence spi_wr_seq;

	//env config handle
    env_config         cfg;

    function new(string name = "virtual_base_sequence");
        super.new(name);
    endfunction : new

    extern task body();
endclass : virtual_base_sequence

task virtual_base_sequence::body();
    if(!uvm_config_db #(env_config)::get(null,get_full_name,"env_config",cfg))
        `uvm_fatal("VIRTUAL SEQ","Get failed for env_config")

	if(!$cast(virt_seqr,m_sequencer))
		`uvm_fatal("VIRTUAL SEQ","cast failed for virtual sequencer")
	apb_seqr = new[cfg.num_of_apb_agents];
	spi_seqr = new[cfg.num_of_spi_agents];
	for(int i = 0;i < cfg.num_of_apb_agents;i++)
		apb_seqr[i] = virt_seqr.apb_seqr[i];
	for(int i = 0;i < cfg.num_of_spi_agents;i++)
		spi_seqr[i] = virt_seqr.spi_seqr[i];
endtask : body


//virtual apb reset sequence class
class virtual_apb_reset_sequence extends virtual_base_sequence;
	`uvm_object_utils(virtual_apb_reset_sequence)

	function new(string name = "virtual_apb_reset_sequence");
		super.new(name);
	endfunction : new

	extern task body();

endclass : virtual_apb_reset_sequence

task virtual_apb_reset_sequence::body();
	apb_reset_seq = apb_reset_sequence ::type_id::create("apb_reset_seq");
	super.body();
	for(int i = 0;i < cfg.num_of_apb_agents;i++)
		apb_reset_seq.start(apb_seqr[i]);
endtask : body


//virtual apb read sequence class
class virtual_apb_read_sequence extends virtual_base_sequence;
	`uvm_object_utils(virtual_apb_read_sequence)

	function new(string name = "virtual_apb_read_sequence");
		super.new(name);
	endfunction : new

	extern task body();

endclass : virtual_apb_read_sequence

task virtual_apb_read_sequence::body();
	apb_rd_seq = apb_read_sequence ::type_id::create("apb_rd_seq");
	super.body();
	for(int i = 0;i < cfg.num_of_apb_agents;i++)
		apb_rd_seq.start(apb_seqr[i]);
endtask : body


//virtual apb write sequence class
class virtual_apb_write_sequence extends virtual_base_sequence;
	`uvm_object_utils(virtual_apb_write_sequence)

	function new(string name = "virtual_apb_write_sequence");
		super.new(name);
	endfunction : new

	extern task body();

endclass : virtual_apb_write_sequence

task virtual_apb_write_sequence::body();
	apb_wr_seq = apb_write_sequence ::type_id::create("apb_wr_seq");
	super.body();
	for(int i = 0;i < cfg.num_of_apb_agents;i++)
		apb_wr_seq.start(apb_seqr[i]);
endtask : body


//virtual spi write sequence class
class virtual_spi_write_sequence extends virtual_base_sequence;
	`uvm_object_utils(virtual_spi_write_sequence)

	function new(string name = "virtual_spi_write_sequence");
		super.new(name);
	endfunction : new

	extern task body();

endclass : virtual_spi_write_sequence

task virtual_spi_write_sequence::body();
	spi_wr_seq = spi_write_sequence ::type_id::create("spi_wr_seq");
	super.body();
	for(int i = 0;i < cfg.num_of_spi_agents;i++)
		spi_wr_seq.start(spi_seqr[i]);
endtask : body
