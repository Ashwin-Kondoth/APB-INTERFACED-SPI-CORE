class core_sb extends uvm_scoreboard;
	`uvm_component_utils(core_sb)
	
	uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo;
	uvm_tlm_analysis_fifo #(spi_xtn) spi_fifo;
	apb_xtn apb_data, apb_cov_data;
	spi_xtn spi_data, spi_cov_data;

	int unsigned mosi_data_verified;
	int unsigned miso_data_verified;

	covergroup cg_apb;
	option.per_instance = 1;
		PRESET  : coverpoint apb_cov_data.PRESET_n;
		PSEL    : coverpoint apb_cov_data.PSEL;
		PENABLE : coverpoint apb_cov_data.PENABLE;
		PWRITE  : coverpoint apb_cov_data.PWRITE;
		PADDR   : coverpoint apb_cov_data.PADDR {
													bins ADDR[] = {0,1,2,3,5};
												}
		DATA    : coverpoint apb_cov_data.PWDATA {
													bins LOW = {[0:8'h80]};
													bins HIGH = {[8'h80:8'hff]};
												}
		PADDR_X_DATA : cross PADDR,DATA;
	endgroup : cg_apb

	covergroup cg_spi;
		SS : coverpoint spi_cov_data.ss;
		MOSI : coverpoint spi_cov_data.mosi {
												bins LOW = {[0:8'h80]};
												bins HIGH = {[8'h80:8'hff]};
											}
		MISO : coverpoint spi_cov_data.miso {
												bins LOW = {[0:8'h80]};
												bins HIGH = {[8'h80:8'hff]};
											}
	endgroup : cg_spi
		

	function new(string name = "core_sb",uvm_component parent);
		super.new(name,parent);
		apb_fifo = new("apb_fifo",this);
		spi_fifo = new("spi_fifo",this);
		cg_apb = new();
		cg_spi = new();
	endfunction : new
	extern task run_phase(uvm_phase phase);
	extern task compare_data();
	extern function void report_phase(uvm_phase phase);

endclass : core_sb

task core_sb::run_phase(uvm_phase phase);
	
		
			fork
				begin
					forever begin
					spi_fifo.get(spi_data);
					spi_cov_data = new spi_data;
					cg_spi.sample();
					end
				end
				begin
					forever begin
					apb_fifo.get(apb_data);
					apb_cov_data = new apb_data;
					cg_apb.sample();
					if(apb_data.PWRITE == 0)
						compare_data;
					end
				end
			join
		
endtask : run_phase

task core_sb::compare_data;
//MOSI DATA COMPARISION
	if(apb_data.PWDATA == spi_data.mosi)
		begin
			`uvm_info("SB:",$sformatf("MOSI DATA COMPARED SUCCESSFULLY. SENT DATA = %0h, RECEIVED DATA = %0h",apb_data.PWDATA,spi_data.mosi),UVM_LOW)
			mosi_data_verified++;
		end
	else
		`uvm_error("SB:",$sformatf("MOSI DATA MISMATCH. SENT DATA = %0h, RECEIVED DATA = %0h",apb_data.PWDATA,spi_data.mosi))

//MISO DATA COMPARISION
	if(apb_data.PRDATA == spi_data.miso)
		begin
			`uvm_info("SB:",$sformatf("MISO DATA COMPARED SUCCESSFULLY. SENT DATA = %0h, RECEIVED DATA = %0h",spi_data.miso,apb_data.PRDATA),UVM_LOW)
			miso_data_verified++;
		end
	else
		`uvm_error("SB:",$sformatf("MISO DATA MISMATCH. SENT DATA = %0h, RECEIVED DATA = %0h",spi_data.miso,apb_data.PRDATA))
		
endtask : compare_data

function void core_sb::report_phase(uvm_phase phase);
	$display("\n================================================SCOREBOARD REPORT================================================");
	$display("\t \t \t \t \tNumber of MOSI data verified is : %0d",mosi_data_verified);
	$display("\t \t \t \t \tNumber of MISO data verified is : %0d",miso_data_verified);
	$display("=================================================================================================================");
endfunction : report_phase
