/*======================================================================
==========================VIRTUAL SEQUENCER CLASS=======================
=======================================================================*/
class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(virtual_sequencer)

    apb_sequencer apb_seqr[];
    spi_sequencer spi_seqr[];

    function new(string name = "virtual_sequencer",uvm_component parent);
        super.new(name,parent);
    endfunction : new

endclass : virtual_sequencer
