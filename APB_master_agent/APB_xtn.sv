class APB_xtn extends uvm_sequence_item;
    `uvm_object_utils(APB_xtn)

	rand bit PRESETn;
	rand bit [2:0] PADDR;
	rand bit PWRITE;
	bit PSEL = 1;
	bit PENABLE = 1;
	bit [7:0] PWDATA;
    bit [7:0] PRDATA;
	bit PREADY;
	bit PSLVERR;

    constraint APB_con {PADRR inside {[0:3],5};
                        PRESETn dist {0:=1, 1:=9};}
    
    function new (string name = "APB_xtn");
        super.new(name);
    endfunction : new

    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs,uvm_comparer comparer);
    extern function void do_print(uvm_printer printer);
endclass : APB_xtn

function void APB_xtn::do_copy(uvm_object rhs);
    APB_xtn rhs_;
    if(!$cast(rhs_,rhs))
        `uvm_fatal("APB_XTN","cast failed for do_copy")
    
    super.do_copy(rhs);
    this.PRESETn = rhs_.PRESETn;
    this.PADDR = rhs_.PADDR;
    this.PWRITE = rhs_.PWRITE;
    this.PSEL = rhs_.PSEL;
    this.PENABLE = rhs_.PENABLE;
    this.PWDATA = rhs_.PWDATA;
    this.PRDATA = rhs_.PRDATA;
    this.PREADY = rhs_.PREADY;
    this.PSLVERR = rhs_.PSLVERR;
endfunction : do_copy

function bit APB_xtn::do_compare(uvm_object rhs,uvm_comparer comparer);
    APB_xtn rhs_;
    if(!$cast(rhs_,rhs))
        `uvm_fatal("APB_XTN","cast failed for do_compare")
    
    return super.do_compare(rhs,comparer) &&
    this.PRESETn == rhs_.PRESETn &&
    this.PADDR == rhs_.PADDR &&
    this.PWRITE == rhs_.PWRITE &&
    this.PSEL == rhs_.PSEL &&
    this.PENABLE == rhs_.PENABLE &&
    this.PWDATA == rhs_.PWDATA &&
    this.PRDATA == rhs_.PRDATA &&
    this.PREADY == rhs_.PREADY &&
    this.PSLVERR == rhs_.PSLVERR;
endfunction : do_compare

function void APB_xtn::do_print(uvm_printer printer);
    super.do_print(printer);
//                     STRING_NAME     VALUE      SIZE      BASE
    printer.print_field("PRESETn",  this.PRESETn,  1,     UVM_DEC);
    printer.print_field("PWRITE",   this.PWRITE,   1,     UVM_DEC);
    printer.print_field("PADDR",    this.PADDR,    3,     UVM_DEC);
    printer.print_field("PSEL",     this.PSEL,     1,     UVM_DEC);
    printer.print_field("PENABLE",  this.PENABLE,  1,     UVM_DEC);
    printer.print_field("PWDATA",   this.PWDATA,   8,     UVM_DEC);
    printer.print_field("PRDATA",   this.PRDATA,   8,     UVM_DEC);
    printer.print_field("PREADY",   this.PREADY,   1,     UVM_DEC);
    printer.print_field("PSLVERR",  this.PSLVERR,  1,     UVM_DEC);
endfunction : do_print