class transaction;
//---------------------------master o/p signals--------------------------

	rand 	bit PRESETn;
	rand 	bit PSELx;
	randc 	bit [31:0] PADDR;
	rand 	bit PENABLE;
	rand 	bit PWRITE;
	rand	bit [2:0] PPROT;
	rand 	bit [3:0] PSTRB;
	rand 	bit [31:0] PWDATA ;

//----------------------------master i/p signals--------------------------

	bit PSLVERR;
	bit PREADY ;
	bit [31:0] PRDATA;

//----------------------------rand declarations----------------------------
 	
	typedef enum {ALIGNED, UNALINGED_3, UNALINGED_2, UNALINGED_1} select_align;
 	typedef enum {DSP_RANGE, CSP_RANGE, DNSNP_RANGE, APB_3_RANGE} select_addr_range;
 	typedef enum {READ, WRITE} select_read_write;
 	typedef enum {reset_n, D_reset_n} reset_mode;

  	rand select_align        	align_type;
  	rand select_addr_range  	addr_range_type;
 	rand select_read_write 		rw_type;
 	rand reset_mode         	reset_type;
	

//---------------------------- pre randomization ---------------------------	

  
	function void pre_randomize();
				
				PRESETn		= 0;
				PWDATA 		= 0;
				PENABLE 	= 0 ;
				PSELx 		= 0 ;
				PADDR 		= 0 ;
				PWRITE		= 1'b1 ;
				PSTRB 		= 4'b1111 ;
				PPROT 		= 3'b000 ;
	endfunction


//----------------------------- constraints --------------------------------

  constraint memory_legal_range {
    if (addr_range_type == DSP_RANGE)
      soft PADDR inside {['h0:'h63]};			//----- 0 to 99
    else if (addr_range_type == CSP_RANGE)	
      soft PADDR inside {['h64:'hC7]};			//----- 100 to 199
    else if (addr_range_type == DNSNP_RANGE)
      soft PADDR inside {['hC8:'h18F]};			//----- 200 to 399
    else if (addr_range_type == APB_3_RANGE)
      soft PADDR inside {['h190:'hFFF]};		//----- 400 to 4095
  }

  constraint pprot_legal_range {
    if (addr_range_type == DSP_RANGE)
      soft PPROT == 3'b001;
    else if (addr_range_type == CSP_RANGE)
      soft PPROT == 3'b101;
    else if (addr_range_type == DNSNP_RANGE)
      soft PPROT == 3'b010;
    else if (addr_range_type == APB_3_RANGE)
      soft PPROT == 3'b000;
  }

  constraint paddr_legal_range {
    if (align_type == ALIGNED)
      soft (PADDR % 4) == 0;
    else if (align_type == UNALINGED_1)
      soft (PADDR % 4) == 1;
    else if (align_type == UNALINGED_2)
      soft (PADDR % 4) == 2;
    else if (align_type == UNALINGED_3)
      soft (PADDR % 4) == 3;
  }

  constraint pstrb_legal_range {
    if (align_type == ALIGNED)
      soft PSTRB dist {4'hF:/80, [4'h0:4'hE]:/20};
    else if (align_type == UNALINGED_1)
      soft (PSTRB % 2) == 0;
    else if (align_type == UNALINGED_2)
      soft (PSTRB % 4) == 0;
    else if (align_type == UNALINGED_3) {
      soft PSTRB dist {4'h8:/80, 4'h0:/20};
      soft (PSTRB % 8) == 0;
    }
  }

  constraint APB_3_valid_address {
    if (addr_range_type == APB_3_RANGE)
      align_type == ALIGNED;
  }

  constraint rw_mode {
    if (rw_type == READ)
      soft PWRITE == 1'b0;
    else if (rw_type == WRITE)
      soft PWRITE == 1'b1;
  }

  constraint rst_type {
    if (reset_type == reset_n)
      soft PRESETn == 1'b0;
    else if (reset_type == D_reset_n)
      soft PRESETn == 1'b1;
  }

//-------------------deep copy method--------------------

  function void copy(transaction h_tr);
   	 if (h_tr == null) return;
   		 PRESETn  = h_tr.PRESETn;
   	 	 PSELx    = h_tr.PSELx;
    	 PWRITE   = h_tr.PWRITE;
   		 PADDR    = h_tr.PADDR;
   		 PWDATA   = h_tr.PWDATA;
   		 PSTRB    = h_tr.PSTRB;
   		 PPROT    = h_tr.PPROT;
   		 PENABLE  = h_tr.PENABLE;
   		 PREADY   = h_tr.PREADY;
   		 PRDATA   = h_tr.PRDATA;
   		 PSLVERR  = h_tr.PSLVERR;
  endfunction

endclass

