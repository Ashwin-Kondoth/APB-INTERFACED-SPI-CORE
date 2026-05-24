/*======================================================================
===========================APB SEQUENCE CLASS===========================
=======================================================================*/
class apb_sequence_base extends uvm_sequence #(apb_xtn);
    `uvm_object_utils(apb_sequence_base)

    //REGISTER BLOCK HANDLE
    spi_reg_block spi_reg_blk;

    env_config cfg;

    uvm_status_e r_status;

    function new(string name = "apb_sequence_base");
        super.new(name);
    endfunction : new

    extern task body();

endclass : apb_sequence_base

task apb_sequence_base::body();
    if(!uvm_config_db #(env_config)::get(null,get_full_name,"env_config",cfg))
        `uvm_fatal("APB SEQ","Get failed for env_config")

    spi_reg_blk = cfg.spi_reg_blk;
endtask : body


//APB RESET SEQ
class apb_reset_sequence extends apb_sequence_base;
    `uvm_object_utils(apb_reset_sequence)

    function new(string name = "apb_reset_sequence");
        super.new(name);
    endfunction : new

    extern task body;

endclass : apb_reset_sequence

task apb_reset_sequence::body();
    repeat(1)
        begin
            req = apb_xtn::type_id::create("req");
            start_item(req);
            if(!req.randomize() with {PRESET_n == 1'b0;})
                `uvm_fatal("APB_SEQ","randomization failed")
            finish_item(req);
        end
endtask : body

//APB WRITE SEQ
class apb_write_sequence extends apb_sequence_base;
    `uvm_object_utils(apb_write_sequence)
	
    
    bit [7:0] CR1;
    bit [7:0] CR2;
    rand bit [2:0] SPPR;
    rand bit [2:0] SPR;
    function new(string name = "apb_write_sequence");
        super.new(name);
    endfunction : new

    extern task body;

endclass : apb_write_sequence

task apb_write_sequence::body();
	//Getting CR1 & CR2 values from test via config db
    if(!uvm_config_db #(bit[7:0])::get(null,get_full_name,"CR1",CR1))
        `uvm_fatal("APB_SEQ","get failed for CR1 !!")
    if(!uvm_config_db #(bit[7:0])::get(null,get_full_name,"CR2",CR2))
        `uvm_fatal("APB_SEQ","get failed for CR2 !!")
    super.body();
    
    spi_reg_blk.cr1.write(r_status,CR1,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map),.parent(this));

    spi_reg_blk.cr2.write(r_status,CR2,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map),.parent(this));

    spi_reg_blk.baud.write(r_status,{1'b0,SPPR,1'b0,SPR},.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map),.parent(this));

    repeat(1)
        begin
            req = apb_xtn::type_id::create("req");
            start_item(req);
            if(!req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;})
                `uvm_fatal("APB_SEQ","randomization failed")
            finish_item(req);
        end
endtask : body

//APB READ SEQ
class apb_read_sequence extends apb_sequence_base;
    `uvm_object_utils(apb_read_sequence)

    function new(string name = "apb_read_sequence");
        super.new(name);
    endfunction : new
    extern task body;

endclass : apb_read_sequence

task apb_read_sequence::body();
    repeat(1)
        begin
            req = apb_xtn::type_id::create("req");
            start_item(req);
            if(!req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR == 3'b101;})
                `uvm_fatal("APB_SEQ","randomization failed")
            finish_item(req);
        end
endtask : body
