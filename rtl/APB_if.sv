interface apb_if (input bit clock);
	logic PCLK;
	logic PRESET_n;
	logic [2:0] PADDR;
	logic PWRITE;
	logic PSEL;
	logic PENABLE;
	logic [7:0] PWDATA;
	logic [7:0] PRDATA;
	logic PREADY;
	logic PSLVERR;
	logic spi_interrupt_request;
	assign PCLK = clock;
	
	clocking apb_drv_cb @(posedge clock);
		default input #1 output #1;
		output PRESET_n;
		output PADDR;
		output PWRITE;
		output PSEL;
		output PENABLE;
		output PWDATA;
		input PRDATA;
		input PREADY;
		input PSLVERR;
	endclocking : apb_drv_cb

	clocking apb_mon_cb @(posedge clock);
		default input #1 output #1;
		input PRESET_n;
		input PADDR;
		input PWRITE;
		input PSEL;
		input PENABLE;
		input PWDATA;
		input PRDATA;
		input PREADY;
		input PSLVERR;
	endclocking : apb_mon_cb

	modport APB_DRV_MP (clocking apb_drv_cb);
	modport APB_MON_MP (clocking apb_mon_cb);

endinterface : apb_if
