/*======================================================================
==============================REGISTER CLASS============================
=======================================================================*/

//CONTROL REGISTER 1
class ctrl_reg_1 extends uvm_reg;
	`uvm_object_utils(ctrl_reg_1)

	//Field declaration
	rand uvm_reg_field LSBFE; //bit0
	rand uvm_reg_field SSOE;  //bit1
	rand uvm_reg_field CPHA;  //bit2
	rand uvm_reg_field CPOL;  //bit3
	rand uvm_reg_field MSTR;  //bit4
	rand uvm_reg_field SPTIE; //bit5
	rand uvm_reg_field SPE;   //bit6
	rand uvm_reg_field SPIE;  //bit7


	function new (string name = "ctrl_reg_1");
		super.new(name,8,UVM_CVR_ALL);
	endfunction : new

	function void build();
	
		//create objects for the fields
		LSBFE = uvm_reg_field::type_id::create("LSBFE");
		SSOE  = uvm_reg_field::type_id::create("SSOE");
		CPHA  = uvm_reg_field::type_id::create("CPHA");
		CPOL  = uvm_reg_field::type_id::create("CPOL");
		MSTR  = uvm_reg_field::type_id::create("MSTR");
		SPTIE = uvm_reg_field::type_id::create("SPTIE");
		SPE   = uvm_reg_field::type_id::create("SPE");
		SPIE  = uvm_reg_field::type_id::create("SPIE");

	//Configure the fields
	//                  parent  size  position  access  volatile  reset_val  has_reset  is_rand  bit_accessibility
		LSBFE.configure( this,   1,      0,      "RW"     ,0        ,1'b0      ,1        ,1            ,1);
		SSOE.configure(  this,   1,      1,      "RW"     ,0        ,1'b0      ,1        ,1            ,1);
		CPHA.configure(  this,   1,      2,      "RW"	  ,0	    ,1'b1	   ,1	     ,1	    	   ,1);
		CPOL.configure(  this,	 1,	     3,		 "RW"	  ,0		,1'b0	   ,1		 ,1			   ,1);
		MSTR.configure(  this,	 1,	 	 4,		 "RW"	  ,0		,1'b0	   ,1		 ,1			   ,1);
		SPTIE.configure( this,	 1,		 5,		 "RW"	  ,0		,1'b0	   ,1		 ,1			   ,1);
		SPE.configure(   this,	 1,		 6,		 "RW"	  ,0		,1'b0	   ,1		 ,1			   ,1);
		SPIE.configure(  this,	 1,		 7,		 "RW"	  ,0		,1'b0	   ,1		 ,1			   ,1);

	endfunction : build

endclass : ctrl_reg_1


//CONTROL REGISTER 2
class ctrl_reg_2 extends uvm_reg;
	`uvm_object_utils(ctrl_reg_2)

	//Field declaration
	rand uvm_reg_field SPC0;     //bit0
	rand uvm_reg_field SPISWAI;  //bit1
	     uvm_reg_field RESERVED1;//bit2
	rand uvm_reg_field BIDIROE;  //bit3
	rand uvm_reg_field MODFEN;   //bit4
	     uvm_reg_field RESERVED2;//bit[5:7]


	function new (string name = "ctrl_reg_2");
		super.new(name,8,UVM_CVR_ALL);
	endfunction : new

	function void build();
	//create objects for the fields

		SPC0       = uvm_reg_field::type_id::create("SPC0");
		SPISWAI    = uvm_reg_field::type_id::create("SPISWAI");
		RESERVED1  = uvm_reg_field::type_id::create("RESERVED1");
		BIDIROE    = uvm_reg_field::type_id::create("BIDIROE");
		MODFEN     = uvm_reg_field::type_id::create("MODFEN");
		RESERVED2  = uvm_reg_field::type_id::create("RESERVED2");

	//Configure the fields
	//                  	parent  size  position  access  volatile  reset_val  has_reset  is_rand  bit_accessibility
		SPC0.configure( 	 this,   1,      0,      "RW"     ,0        ,1'b0      ,1        ,1            ,1);
		SPISWAI.configure(   this,   1,      1,      "RW"     ,0        ,1'b0      ,1        ,1            ,1);
		RESERVED1.configure( this,   1,      2,      "RO"	  ,0	    ,1'b0	   ,0	     ,0	    	   ,0);
		BIDIROE.configure(   this,	 1,	     3,		 "RW"	  ,0		,1'b0	   ,1		 ,1			   ,1);
		MODFEN.configure(    this,	 1,	 	 4,		 "RW"	  ,0		,1'b0	   ,1		 ,1			   ,1);
		RESERVED2.configure( this,	 3,		 5,		 "RO"	  ,0		,3'b0	   ,0		 ,0			   ,0);

	endfunction : build

endclass : ctrl_reg_2


//BAUD RATE REGISTER
class baud_reg extends uvm_reg;
	`uvm_object_utils(baud_reg)

	//Field declaration
	rand uvm_reg_field SPR;       //bit[0:2]
	     uvm_reg_field RESERVED1; //bit3
	rand uvm_reg_field SPPR;      //bit[4:6]
	     uvm_reg_field RESERVED2; //bit7


	function new (string name = "baud_reg");
		super.new(name,8,UVM_CVR_ALL);
	endfunction : new

	function void build();
	//create objects for the fields

		SPR        = uvm_reg_field::type_id::create("SPR");
		RESERVED1  = uvm_reg_field::type_id::create("RESERVED1");
		SPPR       = uvm_reg_field::type_id::create("SPPR");
		RESERVED2  = uvm_reg_field::type_id::create("RESERVED2");

	//Configure the fields
	//                  	parent  size  position  access  volatile  reset_val  has_reset  is_rand  bit_accessibility
		SPR.configure( 	 	 this,   3,      0,      "RW"     ,0        ,3'b0      ,1        ,1            ,1);
		RESERVED1.configure( this,   1,      3,      "RO"	  ,0	    ,1'b0	   ,0	     ,0	    	   ,0);
		SPPR.configure(   	 this,	 3,	     4,		 "RW"	  ,0		,3'b0	   ,1		 ,1			   ,1);
		RESERVED2.configure( this,	 1,		 7,		 "RO"	  ,0		,1'b0	   ,0		 ,0			   ,0);

	endfunction : build

endclass : baud_reg


//STATUS REGISTER
class status_reg extends uvm_reg;
	`uvm_object_utils(status_reg)

	//Field declaration
	     uvm_reg_field RESERVED1; //bit[0:3]
	     uvm_reg_field MODF;      //bit4
	     uvm_reg_field SPTEF;     //bit5
	     uvm_reg_field RESERVED2; //bit6
	     uvm_reg_field SPIF;      //bit7


	function new (string name = "status_reg");
		super.new(name,8,UVM_CVR_ALL);
	endfunction : new

	function void build();
	//create objects for the fields

		RESERVED1   = uvm_reg_field::type_id::create("RESERVED1");
		MODF        = uvm_reg_field::type_id::create("MODF");
		SPTEF       = uvm_reg_field::type_id::create("SPTEF");
		RESERVED2   = uvm_reg_field::type_id::create("RESERVED2");
		SPIF        = uvm_reg_field::type_id::create("SPIF");

	//Configure the fields
	//                  	parent  size  position  access  volatile  reset_val  has_reset  is_rand  bit_accessibility
		RESERVED1.configure( this,   4,      0,      "RO"	  ,0	    ,4'b0	   ,0	     ,0	    	   ,0);
		MODF.configure( 	 this,   1,      4,      "RO"     ,0        ,1'b0      ,1        ,0            ,1);
		SPTEF.configure(   	 this,	 1,	     5,		 "RO"	  ,0		,1'b1	   ,1		 ,1			   ,1);
		RESERVED2.configure( this,	 1,		 6,		 "RO"	  ,0		,1'b0	   ,0		 ,0			   ,0);
		SPIF.configure( 	 this,   1,      7,      "RO"     ,0        ,1'b0      ,1        ,0            ,1);

	endfunction : build

endclass : status_reg


//DATA REGISTER
class data_reg extends uvm_reg;
	`uvm_object_utils(data_reg)

    //Field declaration
	rand uvm_reg_field DATA;    //bit[0:7]

	function new (string name = "data_reg");
		super.new(name,8,UVM_CVR_ALL);
	endfunction : new

	function void build();
	//create objects for the fields

		DATA  = uvm_reg_field::type_id::create("DATA");

	//Configure the fields
	//                  parent  size  position  access  volatile  reset_val  has_reset  is_rand  bit_accessibility
		DATA.configure(  this,   8,      0,      "RW"     ,0        ,8'b0      ,1        ,1            ,1);
		
	endfunction : build

endclass : data_reg
