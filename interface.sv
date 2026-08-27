interface apb_interface (input bit PCLK);

//-----------master o/p signals-------------
	logic PRESETn;
	logic PSELx;
	logic [31:0] PADDR;
	logic PENABLE;
	logic PWRITE;
	logic [2:0] PPROT;
	logic [3:0] PSTRB;
	logic [31:0] PWDATA ;

//----------master i/p signals------------
	logic PSLVERR;
	bit	  PREADY;
	logic [31:0] PRDATA;

	clocking cb_driver @(posedge PCLK);

		output PRESETn;
		output PSELx;
		output PADDR;
		output PENABLE;
		output PWRITE;
		output PPROT;
		output PSTRB;
		output PWDATA ;

		input PSLVERR;
		input PREADY;
		input PRDATA;

	endclocking

	clocking cb_monitor @(posedge PCLK);

		input #0 PRESETn;
		input #0 PSELx;
		input #0 PADDR;
		input #0 PENABLE;
		input #0 PWRITE;
		input #0 PPROT;
		input #0 PSTRB;
		input #0 PWDATA ;

		input #0 PSLVERR;
		input #0 PREADY;
		input #0 PRDATA;

	endclocking


endinterface
