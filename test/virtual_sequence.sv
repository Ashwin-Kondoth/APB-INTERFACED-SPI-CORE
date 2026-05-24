class virtual_base_sequence extends uvm_sequence #(uvm_sequence);
    `uvm_object_utils(virtual_base_sequence)

    virtual_sequencer  virt_seqr;
    apb_sequencer      apb_seqr;
    spi_sequencer      spi_seqr;
    apb_reset_sequence apb_reset_seq;
    apb_write_sequence apb_wr_seq;
    apb_read_sequence  apb_rd_seq;
    spi_write_sequence spi_wr_seq;

    env_config         cfg;

    function new(string name = "virtual_base_sequence");
        super.new(name);
    endfunction : new

    extern task body();
endclass : virtual_base_sequence

task virtual_base_sequence::body();
    if(!uvm_config_db #(env_config)::get(null,get_full_name,"env_config",cfg))
        `uvm_fatal("VIRTUAL SEQ","Get failed for env_config")
endtask : body
    