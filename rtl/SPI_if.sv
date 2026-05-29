interface spi_if (input bit PCLK,input bit PRESET_n);
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

// Internal tracking variables
    bit detected_cpol;
    bit detected_cpha;
    bit transfer_active = 1'b0;
    reg reset_done = 1'b0;

    always @(posedge PCLK) begin
        if (!PRESET_n) begin
            reset_done <= 1'b0;
        end else begin
            // Wait 3 clock cycles after PRESET_n goes high to enable
            // (Adjust the cycle count to match 30ns based on your PCLK frequency)
            repeat(6) @(posedge PCLK); 
            reset_done <= 1'b1;
        end
    end
    //======================================================================
    // 1. ROBUST ACTIVE-LOW MODE DETECTION
    //======================================================================
    always @(posedge PCLK) begin
        if (!PRESET_n) begin
            detected_cpol   <= 1'b0;
        end else begin
            // Detect the end of a transfer (Active-Low rising edge)
            if (ss == 1'b1) begin
                detected_cpol   <= sclk;
            end

        end
    end

    //======================================================================
    // 2. SYNCHRONOUS ASSERTIONS (USING STANDARD $error)
    //======================================================================
    // ASSERTION 1: Clock Gating Check
    // SCLK must remain completely stable when SS is inactive (1)
    property p_sclk_gated_by_ss;
        @(posedge PCLK) disable iff (!PRESET_n || !reset_done)
        (ss == 1'b1) && $stable(ss) |-> $stable(sclk);
    endproperty
    assert_sclk_gated: assert property (p_sclk_gated_by_ss)
                $info("ASSERTION PASSED : SLCK is glitch free");
        else $error("[SPI_SVA_ERR] Protocol Violation: SCLK leaked/glitched while SS was high (IDLE)!");
    
    CHECK1 : cover property (p_sclk_gated_by_ss);

    // ASSERTION 2: Idle Polarity Level Check
    // When SS is inactive (1), SCLK must stay locked at the detected CPOL level
    property p_cpol_level_check;
        @(posedge PCLK) disable iff (!PRESET_n || !reset_done)
        (ss == 1'b1) |-> (sclk == detected_cpol);
    endproperty
    assert_cpol_level: assert property (p_cpol_level_check)
        $info("ASSERTION 2 PASSED");
        else $error("[SPI_SVA_ERR] Protocol Violation: SCLK is (%0b) drifted away from its expected CPOL idle level (%0b) while SS was high!", sclk,detected_cpol);
    
    CHECK2 : cover property (p_cpol_level_check);

endinterface : spi_if
