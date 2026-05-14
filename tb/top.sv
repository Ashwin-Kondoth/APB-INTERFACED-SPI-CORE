module top;
	import test_pkg::*;
	import uvm_pkg::*;

	parameter period = 10;

	bit clock;
	int count = 1;
	apb_if APB_IF(clock);
	spi_if SPI_IF(clock);

	APB_interfaced_SPI DUV(.PCLK(APB_IF.PCLK),
						   .PRESET_n(APB_IF.PRESET_n),
						   .PADDR(APB_IF.PADDR),
						   .PWRITE(APB_IF.PWRITE),
						   .PSEL(APB_IF.PSEL),
						   .PENABLE(APB_IF.PENABLE),
						   .PWDATA(APB_IF.PWDATA),
						   .PRDATA(APB_IF.PRDATA),
						   .PREADY(APB_IF.PREADY),
						   .PSLVERR(APB_IF.PSLVERR),
						   .miso(SPI_IF.miso),
						   .ss(SPI_IF.ss),
						   .sclk(SPI_IF.sclk),
						   .mosi(SPI_IF.mosi));

	initial
		begin
			clock = 1'b0;
			forever #(period/2) clock = ~clock;
		end

	initial 
		begin
			for(int i = 0;i < count;i++)
				begin
					uvm_config_db #(virtual apb_if)::set(null,"*",$sformatf("vif[%0d]",i),APB_IF);
					uvm_config_db #(virtual spi_if)::set(null,"*",$sformatf("vif[%0d]",i),SPI_IF);
				end
			run_test();
		end

endmodule
