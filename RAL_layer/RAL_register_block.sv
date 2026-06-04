/*======================================================================
============================REGISTER BLOCK CLASS========================
=======================================================================*/
class spi_reg_block extends uvm_reg_block;
	`uvm_object_utils(spi_reg_block)
	
	//REGISTER MAP DECLARATION
	uvm_reg_map spi_reg_map;
	
	//REGISTERS HANDLE DECLARATION
	rand ctrl_reg_1 cr1;
	rand ctrl_reg_2 cr2;
	rand baud_reg 	baud;
		 status_reg status;
	rand data_reg   data;

	function new (string name = "spi_reg_block");
		super.new(name);
	endfunction : new

	function void build();

		//REGISTER OBJECT CREATION
		cr1    = ctrl_reg_1::type_id::create("cr1");
		cr2    = ctrl_reg_2::type_id::create("cr2");
		baud   = baud_reg::type_id::create("baud");
		status = status_reg::type_id::create("status");
		data   = data_reg::type_id::create("data");

		//REGISTER CONFIGURATION
		cr1.configure(this,null,"");
		cr2.configure(this,null,"");
		baud.configure(this,null,"");
		status.configure(this,null,"");
		data.configure(this,null,"");

		//CALLING BUILD METHOD OF REGISTER
		cr1.build();
		cr2.build();
		baud.build();
		status.build();
		data.build();

		//ADDING HDL PATH
		add_hdl_path("top.DUV","RTL");

		//ADDING HDL PATH SLICE
		cr1.add_hdl_path_slice("sb4.SPI_CR1",0,8);
		cr2.add_hdl_path_slice("sb4.SPI_CR2",0,8);
		baud.add_hdl_path_slice("sb4.SPI_BR",0,8);
		status.add_hdl_path_slice("sb4.SPI_SR",0,8);
		data.add_hdl_path_slice("sb4.SPI_DR",0,8);

		//CREATING OBJECT FOR REGISTER MAP
		spi_reg_map = create_map("spi_reg_map",'h0,1,UVM_LITTLE_ENDIAN,0);

		//ADDING REGISTERS TO REGISTER MAP
		spi_reg_map.add_reg(cr1,8'h0,"RW");
		spi_reg_map.add_reg(cr2,8'h1,"RW");
		spi_reg_map.add_reg(baud,8'h2,"RW");
		spi_reg_map.add_reg(status,8'h3,"RW");
		spi_reg_map.add_reg(data,8'h5,"RW");

		//LOCKING THE MODEL
		lock_model();

	endfunction : build

endclass : spi_reg_block
