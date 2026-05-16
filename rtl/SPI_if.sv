interface spi_if (input bit clock);
	logic ss;
	logic sclk;
	logic mosi;
	logic miso;

	/*clocking spi_drv_cb @(posedge sclk);
		default input #1 output #1;
		output miso;
		input ss;
		input sclk;
		input mosi;
	endclocking : spi_drv_cb

	clocking spi_mon_cb @(posedge clock);
		default input #1 output #1;
		input miso;
		input ss;
		input sclk;
		input mosi;
	endclocking : spi_mon_cb*/

	modport SPI_DRV_MP (output miso,input ss, sclk, mosi);
	modport SPI_MON_MP (input miso, ss, sclk, mosi);

endinterface : spi_if
