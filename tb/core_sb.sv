/*======================================================================
============================SCOREBOARD CLASS============================
=======================================================================*/
class core_sb extends uvm_scoreboard;
	`uvm_component_utils(core_sb)
	
	//Analysis FIFO declaration to store data from monitors
	uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo;
	uvm_tlm_analysis_fifo #(spi_xtn) spi_fifo;
	apb_xtn 						 apb_data; 
	apb_xtn						     apb_cov_data;
	spi_xtn 						 spi_data; 
	spi_xtn							 spi_cov_data;

	int unsigned 					 mosi_data_verified;
	int unsigned 					 miso_data_verified;
	int unsigned 					 reset_verified;

	bit 							 is_reset_test        = 1'b0;
    bit 							 reset_has_occurred   = 1'b0;

	bit 							 is_low_power_test 	  = 1'b0;

	bit [7:0]						 CR1;
	bit [7:0]						 CR2;
	env_config						 cfg;

	//REGISTER BLOCK LOCAL HANDLE
	spi_reg_block					 spi_reg_blk;
	uvm_status_e					 r_status;
//Covergroup for APB transactions for functional coverage
	covergroup cg_apb;
	option.per_instance = 1;
		PRESET  	 : coverpoint apb_cov_data.PRESET_n;
		PSEL    	 : coverpoint apb_cov_data.PSEL;
		PENABLE 	 : coverpoint apb_cov_data.PENABLE;
		PWRITE  	 : coverpoint apb_cov_data.PWRITE;
		PADDR   	 : coverpoint apb_cov_data.PADDR {
													bins ADDR[] = {0,1,2,5};
												}
		DATA    	 : coverpoint apb_cov_data.PWDATA {
													bins LOW = {[0:8'h80]};
													bins HIGH = {[8'h80:8'hff]};
												}
		PADDR_X_DATA : cross PADDR,DATA;
	endgroup : cg_apb

//Covergroup for SPI transactions for functional coverage
	covergroup cg_spi;
		SS   : coverpoint spi_cov_data.ss {bins SS = {1,0};}
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
		cg_apb   = new();
		cg_spi   = new();
	endfunction : new

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task compare_data();
	extern function void report_phase(uvm_phase phase);

endclass : core_sb

function void core_sb::build_phase(uvm_phase phase);

	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("SB:","Get failed for env config")
	spi_reg_blk = cfg.spi_reg_blk;

	if(!uvm_config_db#(bit)::get(this,"","reset_test", is_reset_test))
		is_reset_test      = 1'b0;

	if (!uvm_config_db#(bit)::get(this,"","low_power_test", is_low_power_test))
            is_low_power_test  = 1'b0;

	if(!uvm_config_db #(bit[7:0])::get(this,"","CR1",CR1))
        `uvm_fatal("APB_SEQ","get failed for CR1 !!")

    if(!uvm_config_db #(bit[7:0])::get(this,"","CR2",CR2))
        `uvm_fatal("APB_SEQ","get failed for CR2 !!")
		
endfunction : build_phase

task core_sb::run_phase(uvm_phase phase);
	if(is_low_power_test) // LOW POWER TEST CASE
		begin
			//---------------------------------------------------------
        	// LOW POWER VERIFICATION CODE
        	//---------------------------------------------------------
			fork
				//Monitor for accidental SPI activity
				begin //THREAD 1
					spi_fifo.get(spi_data);
					`uvm_error("LOW_PWR_FAIL", "Protocol Violation! SPI generated traffic/SS while in low power stop mode!")
				end
				
				// Safe Watchdog Timeout Window
				begin //THREAD 2
					#200000; // Must match or be slightly shorter than the sequence delay window
					`uvm_info("LOW_PWR_PASS", "SUCCESS: SPI stayed in Stop Mode. No SS or clock transitions detected.", UVM_LOW)
				end
			join_any
			disable fork;
		end
	else //NORMAL and RESET TEST CASE
		begin
			fork
				begin //THREAD1
					forever 
						begin
							spi_fifo.get(spi_data);
							spi_cov_data = new spi_data;
							cg_spi.sample();
						end
				end
				begin //THREAD2
					forever 
						begin
							apb_fifo.get(apb_data);
							apb_cov_data = new apb_data;
							cg_apb.sample();
							if (apb_data.PRESET_n == 1'b0)  //FOR RESET TEST CASE
								begin
									`uvm_info("SB_RESET", "Reset Transaction detected in Scoreboard!", UVM_LOW)
									apb_fifo.flush();
									spi_fifo.flush();
									if(is_reset_test)
										begin
											#5; //delay for process reset
											compare_data;
										end
									continue;
								end
							if(apb_data.PWRITE == 1 && apb_data.PADDR == 3'b101 && apb_data.PWDATA == 8'h00) //RESET in NORMAL TEST CASE
								begin
									`uvm_info("SB_SKIP", "Detected data register write of 8'h00. Skipping comparison pipeline.", UVM_LOW)
									continue;
								end
							if(apb_data.PWRITE == 0) //NORMAL CASE
								compare_data;
						end	
				end
			join
		end
endtask : run_phase

task core_sb::compare_data;
//RESET TEST CHECK
	if(is_reset_test)
		begin
			bit[7:0] reset_data;

			//READING CONTENTS OF CONTROL REGISTER 1
			spi_reg_blk.cr1.read(r_status,reset_data,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map));
			if (reset_data == 8'h04) 
				begin
            		`uvm_info("SB_RESET_PASS", "RESET VERIFIED: Control Register 1 successfully cleared to 8'h04.", UVM_LOW)
            		reset_verified++;
        		end
			else 
				begin
            		`uvm_error("SB_RESET_FAIL", $sformatf("RESET MISMATCH: Control Register 1 should be 8'h04 but read back as 8'h%0h!",reset_data))
        		end

			//READING CONTENTS OF CONTROL REGISTER 2
			spi_reg_blk.cr2.read(r_status,reset_data,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map));
			if (reset_data == 8'h00)
				begin
            		`uvm_info("SB_RESET_PASS", "RESET VERIFIED: Control Register 2 successfully cleared to 8'h00.", UVM_LOW)
            		reset_verified++;
        		end
			else 
				begin
            		`uvm_error("SB_RESET_FAIL", $sformatf("RESET MISMATCH: Control Register 2 should be 8'h00 but read back as 8'h%0h!",reset_data))
        		end

			//READING CONTENTS OF BAUD RATE REGISTER
			spi_reg_blk.baud.read(r_status,reset_data,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map));
			if (reset_data == 8'h00)
				begin
            		`uvm_info("SB_RESET_PASS", "RESET VERIFIED: Baud Register successfully cleared to 8'h00.", UVM_LOW)
            		reset_verified++;
        		end
			else 
				begin
            		`uvm_error("SB_RESET_FAIL", $sformatf("RESET MISMATCH: Baud Register should be 8'h00 but read back as 8'h%0h!",reset_data))
        		end

			//READING CONTENTS OF STATUS REGISTER
			spi_reg_blk.status.read(r_status,reset_data,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map));
			if (reset_data == 8'h20)
				begin
            		`uvm_info("SB_RESET_PASS", "RESET VERIFIED: Status Register successfully cleared to 8'h20.", UVM_LOW)
            		reset_verified++;
        		end
			else 
				begin
            		`uvm_error("SB_RESET_FAIL", $sformatf("RESET MISMATCH: Status Register should be 8'h20 but read back as 8'h%0h!",reset_data))
        		end
			
			//READING CONTENTS OF DATA REGISTER
			spi_reg_blk.data.read(r_status,reset_data,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map));
			if (reset_data == 8'h00)
				begin
            		`uvm_info("SB_RESET_PASS", "RESET VERIFIED: Data Register successfully cleared to 8'h00.", UVM_LOW)
            		reset_verified++;
        		end
			else 
				begin
            		`uvm_error("SB_RESET_FAIL", $sformatf("RESET MISMATCH: Data Register should be 8'h00 but read back as 8'h%0h!",reset_data))
        		end

		end

	else //NORMAL TEST CHECK
		begin
		//MOSI DATA COMPARISION
		bit [7:0] data_check;
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
			
			
			spi_reg_blk.cr1.read(r_status,data_check,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map));

		//CR1 DATA COMPARISION
			if(data_check == CR1)
				begin
					`uvm_info("SB:",$sformatf("CR1 DATA COMPARED SUCCESSFULLY. CR1 DATA = %0h, RAL DATA = %0h",CR1,data_check),UVM_LOW)
				end
			else
				begin
					`uvm_error("SB:",$sformatf("CR1 DATA MISMATCH. CR1 DATA = %0h, RAL DATA = %0h",CR1,data_check))
				end

			spi_reg_blk.cr2.read(r_status,data_check,.path(UVM_BACKDOOR),.map(spi_reg_blk.spi_reg_map));
	
		//CR2 DATA COMPARISION
			if(data_check == CR2)
				begin
					`uvm_info("SB:",$sformatf("CR2 DATA COMPARED SUCCESSFULLY. CR2 DATA = %0h, RAL DATA = %0h",CR2,data_check),UVM_LOW)
				end
			else
				begin
					`uvm_error("SB:",$sformatf("CR1 DATA MISMATCH. CR2 DATA = %0h, RAL DATA = %0h",CR2,data_check))
				end

		end
endtask : compare_data

//SCOREBOARD REPORT
function void core_sb::report_phase(uvm_phase phase);
	$display("\n================================================SCOREBOARD REPORT================================================");
	$display("\t \t \t \t \tNumber of RESET data verified is : %0d",reset_verified);
	$display("\t \t \t \t \tNumber of MOSI data verified is : %0d",mosi_data_verified);
	$display("\t \t \t \t \tNumber of MISO data verified is : %0d",miso_data_verified);
	$display("=================================================================================================================");
endfunction : report_phase
