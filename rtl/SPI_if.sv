interface spi_if (input bit clock);
	logic ss;
	logic sclk;
	logic mosi;
	logic miso;

	

	modport SPI_DRV_MP (output miso,input ss, sclk, mosi);
	modport SPI_MON_MP (input miso, ss, sclk, mosi);

endinterface : spi_if
