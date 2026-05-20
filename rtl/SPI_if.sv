interface spi_if ();
	logic ss;
	logic sclk;
	logic mosi;
	logic miso;

	// Positive edge driving block
    clocking spi_drv_cb_pos @(posedge sclk);
        default input #1 output #1;
        input ss, mosi;
        output miso;
    endclocking

    // Negative edge driving block
    clocking spi_drv_cb_neg @(negedge sclk);
        default input #1 output #1;
        input ss, mosi;
        output miso;
    endclocking

	 clocking spi_mon_cb_pos @(posedge sclk);
        default input #1 output #1;
        input ss, mosi;
        input miso;
    endclocking

    // Negative edge monitoring block
    clocking spi_mon_cb_neg @(negedge sclk);
        default input #1 output #1;
        input ss, mosi;
        input miso;
    endclocking

	modport SPI_DRV_MP (clocking spi_drv_cb_pos, clocking spi_drv_cb_neg);
	modport SPI_MON_MP (clocking spi_mon_cb_pos, clocking spi_mon_cb_neg);

endinterface : spi_if
