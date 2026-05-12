class core_sb extends uvm_scoreboard;
	`uvm_component_utils(core_sb)
	
	uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo;
	uvm_tlm_analysis_fifo #(spi_xtn) spi_fifo;

	function new(string name = "core_sb",uvm_component parent);
		super.new(name,parent);
		apb_fifo = new("apb_fifo",this);
		spi_fifo = new("spi_fifo",this);
	endfunction : new

endclass : core_sb
