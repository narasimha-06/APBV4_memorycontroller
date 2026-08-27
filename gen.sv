class generator;
	transaction h_trans_idle, h_trans_setup, h_trans_access;
	mailbox mbx_gen2dr;

  function new(mailbox mbx_gen2dr);
    	this.mbx_gen2dr = mbx_gen2dr;
    	h_trans_idle   = new();
    	h_trans_setup  = new();
    	h_trans_access = new();
  endfunction

//====================================================
  	task send_idle(bit rst);
    	h_trans_idle.randomize with {
      	reset_type == (rst ? D_reset_n : reset_n);
      	PSELx == 0;
      	PENABLE == 0;
    	};
    	mbx_gen2dr.put(h_trans_idle);
  	endtask
/*
	task send_access;
  		h_trans_access.copy(h_trans_setup);
  		h_trans_access.PENABLE = 1;
  		mbx_gen2dr.put(h_trans_access);
	endtask
 */

  //====================================================
  task TC_0_RESET_CONDITION;
 //   send_idle(0);

       	h_trans_idle.randomize with {
		PRESETn == reset_n;
      	PSELx == 0;
      	PENABLE == 0;


    	};
   
    	mbx_gen2dr.put(h_trans_idle);
    $display($time,"\t GENERATOR TC0:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {

	  PRESETn == reset_n;
      PSELx == 1;
      PENABLE == 0;
      PSTRB == 4'b1111;
      PPROT == 3'b000 ;
    };
    mbx_gen2dr.put(h_trans_setup);

    $display($time,"\t SETUP TC0:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    
    mbx_gen2dr.put(h_trans_access);
    
    $display($time,"\t ACCESS TC0 :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

  endtask
  
  
  task TC_1_BASIC_WRITE(bit rw);

 //   send_idle(0);
   	h_trans_idle.randomize with {

      	PSELx == 0;
      	PENABLE == 0;
      	PADDR == 512;

	 	 PWDATA == 123456 ;
    	};
   
    	mbx_gen2dr.put(h_trans_idle);
    $display($time,"\t GENERATOR TC1:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {

      reset_type == D_reset_n;
      PWRITE 	== rw;
      PSELx 	== 1;
      PENABLE 	== 0;

    };
    mbx_gen2dr.put(h_trans_setup);

    $display($time,"\t SETUP TC1:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    $display($time,"\t ACCESS TC1:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

  endtask

  //====================================================
  task TC_2_RESET_ON_SETUP;

 //   send_idle(0);
					$display($time,"\t GENERATOR TC2:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
					$display($time,"\t SETUP TC2:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );


    h_trans_access.copy(h_trans_setup);
    h_trans_access.PRESETn = 0;
    mbx_gen2dr.put(h_trans_access);
					$display($time,"\t ACCESS TC2:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

  endtask

  //====================================================
  task TC_3_RESET_ON_ACCESS;

  //  send_idle(0);
					$display($time,"\t GENERATOR TC3:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
					$display($time,"\t SETUP TC3:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
					$display($time,"\t ACCESS TC3:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

 //   send_idle(0);

  endtask

  //====================================================
  task TC_4_DSP_RANGE;

    	send_idle(1);
					$display($time,"\t GENERATOR TC4:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
					$display($time,"\t SETUP TC4:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
					$display($time,"\t ACCESS TC4:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

	if(read) begin
	    h_trans_setup.copy(h_trans_access);
	    h_trans_setup.PWRITE = 0;
	    h_trans_setup.PENABLE = 0;
	    mbx_gen2dr.put(h_trans_setup);

    	h_trans_access.copy(h_trans_setup);
   		h_trans_access.PENABLE = 1;
    	mbx_gen2dr.put(h_trans_access);
	end
  endtask

  //====================================================
  task TC_5_CSP_RANGE;

   	 send_idle(1);
					$display($time,"\t GENERATOR TC5:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == CSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
					$display($time,"\t SETUP TC5:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
					$display($time,"\t ACCESS TC5:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

	if(read) begin
   		h_trans_setup.copy(h_trans_access);
    	h_trans_setup.PWRITE = 0;
    	h_trans_setup.PENABLE = 0;
    	mbx_gen2dr.put(h_trans_setup);

    	h_trans_access.copy(h_trans_setup);
    	h_trans_access.PENABLE = 1;
    	mbx_gen2dr.put(h_trans_access);
	end
  endtask

  //====================================================
  task TC_6_DNSNP_RANGE(bit read);

    	send_idle(1);
					$display($time,"\t GENERATOR TC6:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DNSNP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
      PSTRB == 4'b1110;
    };
    mbx_gen2dr.put(h_trans_setup);
					$display($time,"\t SETUP TC6:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
    
    
					$display($time,"\t ACCESS TC6:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

	if(read) begin
   		h_trans_setup.copy(h_trans_access);
    	h_trans_setup.PWRITE = 0;
    	h_trans_setup.PENABLE = 0;
    	mbx_gen2dr.put(h_trans_setup);

    	h_trans_access.copy(h_trans_setup);
    	h_trans_access.PENABLE = 1;
    	mbx_gen2dr.put(h_trans_access);
	end

  endtask

  //====================================================
  task TC_7_APB_3_RANGE;

 //   send_idle(0);
					$display($time,"\t GENERATOR TC7:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == APB_3_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

					$display($time,"\t SETUP TC7:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_setup.PRESETn , h_trans_setup.PSELx, h_trans_setup.PADDR ,h_trans_setup.PENABLE ,h_trans_setup.PWRITE ,h_trans_setup.PPROT ,h_trans_setup.PSTRB ,h_trans_setup.PWDATA );

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

					$display($time,"\t ACCESS TC7:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_access.PRESETn , h_trans_access.PSELx, h_trans_access.PADDR ,h_trans_access.PENABLE ,h_trans_access.PWRITE ,h_trans_access.PPROT ,h_trans_access.PSTRB ,h_trans_access.PWDATA );

	if(read) begin
   		h_trans_setup.copy(h_trans_access);
    	h_trans_setup.PWRITE = 0;
    	h_trans_setup.PENABLE = 0;
    	mbx_gen2dr.put(h_trans_setup);

    	h_trans_access.copy(h_trans_setup);
    	h_trans_access.PENABLE = 1;
    	mbx_gen2dr.put(h_trans_access);
	end

  endtask

  //====================================================
  task TC_8_BACK_TO_BACK_TRANSFER;

  //  send_idle(0);
					$display($time,"\t GENERATOR TC8:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    repeat (2) begin
      h_trans_setup.copy(h_trans_idle);
      h_trans_setup.randomize with {
        addr_range_type == DSP_RANGE;
        align_type == ALIGNED;
        reset_type == D_reset_n;
        rw_type == WRITE;
        PSELx == 1;
        PENABLE == 0;
        PWRITE == 1;
      };
      mbx_gen2dr.put(h_trans_setup);

      h_trans_access.copy(h_trans_setup);
      h_trans_access.PENABLE = 1;
      mbx_gen2dr.put(h_trans_access);
    end

  endtask

  //====================================================
  task TC_9_PSTRB_BASED_WRITE;

 //   send_idle(0);
					$display($time,"\t GENERATOR TC9:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
      PSTRB == 4'b1100;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    h_trans_setup.copy(h_trans_access);
    h_trans_setup.PWRITE = 0;
    h_trans_setup.PENABLE = 0;
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

 task TC_10_UNALIGNED_WRITE_DSP;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC10:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == UNALINGED_1;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

  task TC_11_UNALIGNED_WRITE_CSP;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC11:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == CSP_RANGE;
      align_type == UNALINGED_2;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

  task TC_12_UNALIGNED_WRITE_DNSNP;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC12:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DNSNP_RANGE;
      align_type == UNALINGED_3;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

  task TC_13_INVALID_PPROT_DSP;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC13:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      PPROT != 3'b001;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

  task TC_14_INVALID_PPROT_CSP;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC14:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == CSP_RANGE;
      align_type == ALIGNED;
      PPROT != 3'b101;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

//========================================================================
  task TC_15_INVALID_PPROT_DNSNP;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC14:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DNSNP_RANGE;
      align_type == ALIGNED;
      PPROT != 3'b101;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask
  
  task TC_16_INVALID_PPROT_APB_3_RANGE;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC14:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == APB_3_RANGE;
      align_type == ALIGNED;
      PPROT != 3'b101;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask
  
//========================================================================
  task TC_17_SETUP_ACCESS_MISMATCH;
    //    send_idle(1);
					$display($time,"\t GENERATOR TC15:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED; rw_type == WRITE;
      PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    h_trans_access.copy(h_trans_setup);
    h_trans_access.PADDR += 4;
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

  task TC_18_NULL_STROBE_WRITE;
    //   send_idle(1);
					$display($time,"\t GENERATOR TC16:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      PSTRB == 4'b0000;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

  task TC_19_OUT_OF_RANGE_ACCESS;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC17:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == APB_3_RANGE;
      align_type == ALIGNED;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

  task TC_20_RESET_TOGGLE_ACCESS;
 //   send_idle(0);
					$display($time,"\t GENERATOR TC18:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    h_trans_access.copy(h_trans_setup);
    h_trans_access.PRESETn = 0;
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

	task run;
		begin
		
//			if(h_trans_idle.randomize());
				$display($time,"\t ------------------>sanity  sample generated by generator \n ");

				$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

				mbx_gen2dr.put(h_trans_idle);
				$display($time,"\t -------> sanity sample is put into mailbox \n");

			end

//		run_tc;
		
	endtask
	
endclass




/*
class generator;
	transaction h_trans_idle, h_trans_setup, h_trans_access;
	mailbox mbx_gen2dr;

  function new(mailbox mbx_gen2dr);
    	this.mbx_gen2dr = mbx_gen2dr;
    	h_trans_idle   = new();
    	h_trans_setup  = new();
    	h_trans_access = new();
  endfunction

//====================================================
  	task send_idle(bit rst);
    	h_trans_idle.randomize with {
      	reset_type == (rst ? D_reset_n : reset_n);
      	PSELx == 0;
      	PENABLE == 0;
    	};
    	mbx_gen2dr.put(h_trans_idle);
  	endtask

	task send_access;
  		h_trans_access.deep_copy(h_trans_setup);
  		h_trans_access.PENABLE = 1;
  		mbx_gen2dr.put(h_trans_access);
	endtask
  

  //====================================================
  task TC_1_RESET_CONDITION;
    send_idle(0);
					$display($time,"\t GENERATOR TC1 :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

  endtask

  //====================================================
  task TC_2_RESET_ON_SETUP;

    send_idle(0);
					$display($time,"\t GENERATOR TC2:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);


    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PRESETn = 0;
    mbx_gen2dr.put(h_trans_access);

  endtask

  //====================================================
  task TC_3_RESET_ON_ACCESS;

    send_idle(0);
					$display($time,"\t GENERATOR TC3:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    send_idle(0);

  endtask

  //====================================================
  task TC_4_DSP_RANGE;

    send_idle(0);
					$display($time,"\t GENERATOR TC4:\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    h_trans_setup.deep_copy(h_trans_access);
    h_trans_setup.PWRITE = 0;
    h_trans_setup.PENABLE = 0;
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

  //====================================================
  task TC_5_CSP_RANGE;

    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == CSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    h_trans_setup.deep_copy(h_trans_access);
    h_trans_setup.PWRITE = 0;
    h_trans_setup.PENABLE = 0;
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

  //====================================================
  task TC_6_DNSNP_RANGE;

    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DNSNP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
      PSTRB == 4'b1110;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    h_trans_setup.deep_copy(h_trans_access);
    h_trans_setup.PWRITE = 0;
    h_trans_setup.PENABLE = 0;
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

  //====================================================
  task TC_7_APB_3_RANGE;

    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == APB_3_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    h_trans_setup.deep_copy(h_trans_access);
    h_trans_setup.PWRITE = 0;
    h_trans_setup.PENABLE = 0;
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

  //====================================================
  task TC_8_BACK_TO_BACK_TRANSFER;

    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    repeat (2) begin
      h_trans_setup.deep_copy(h_trans_idle);
      h_trans_setup.randomize with {
        addr_range_type == DSP_RANGE;
        align_type == ALIGNED;
        reset_type == D_reset_n;
        rw_type == WRITE;
        PSELx == 1;
        PENABLE == 0;
        PWRITE == 1;
      };
      mbx_gen2dr.put(h_trans_setup);

      h_trans_access.deep_copy(h_trans_setup);
      h_trans_access.PENABLE = 1;
      mbx_gen2dr.put(h_trans_access);
    end

  endtask

  //====================================================
  task TC_9_PSTRB_BASED_WRITE;

    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      reset_type == D_reset_n;
      rw_type == WRITE;
      PSELx == 1;
      PENABLE == 0;
      PWRITE == 1;
      PSTRB == 4'b1100;
    };
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

    h_trans_setup.deep_copy(h_trans_access);
    h_trans_setup.PWRITE = 0;
    h_trans_setup.PENABLE = 0;
    mbx_gen2dr.put(h_trans_setup);

    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);

  endtask

 task TC_10_UNALIGNED_WRITE_DSP;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == UNALINGED_1;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    send_access;
  endtask

  task TC_11_UNALIGNED_WRITE_CSP;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == CSP_RANGE;
      align_type == UNALINGED_2;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    send_access;
  endtask

  task TC_12_UNALIGNED_WRITE_DNSNP;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DNSNP_RANGE;
      align_type == UNALINGED_3;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    send_access;
  endtask

  task TC_13_INVALID_PPROT_DSP;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      PPROT != 3'b001;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    send_access;
  endtask

  task TC_14_INVALID_PPROT_CSP;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == CSP_RANGE;
      align_type == ALIGNED;
      PPROT != 3'b101;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    send_access;
  endtask

  task TC_15_SETUP_ACCESS_MISMATCH;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED; rw_type == WRITE;
      PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PADDR += 4;
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

  task TC_16_NULL_STROBE_WRITE;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      PSTRB == 4'b0000;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    send_access;
  endtask

  task TC_17_OUT_OF_RANGE_ACCESS;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == APB_3_RANGE;
      align_type == ALIGNED;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    send_access;
  endtask

  task TC_18_RESET_TOGGLE_ACCESS;
    send_idle(0);
					$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

    h_trans_setup.deep_copy(h_trans_idle);
    h_trans_setup.randomize with {
      addr_range_type == DSP_RANGE;
      align_type == ALIGNED;
      rw_type == WRITE; PSELx == 1; PENABLE == 0; PWRITE == 1;
    };
    mbx_gen2dr.put(h_trans_setup);
    h_trans_access.deep_copy(h_trans_setup);
    h_trans_access.PRESETn = 0;
    h_trans_access.PENABLE = 1;
    mbx_gen2dr.put(h_trans_access);
  endtask

	task run;
		begin
		
			if(h_trans_idle.randomize());
				$display($time,"\t ------------------>sanity  sample generated by generator \n ");

				$display($time,"\t GENERATOR :\t PRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-------in generator ",h_trans_idle.PRESETn , h_trans_idle.PSELx, h_trans_idle.PADDR ,h_trans_idle.PENABLE ,h_trans_idle.PWRITE ,h_trans_idle.PPROT ,h_trans_idle.PSTRB ,h_trans_idle.PWDATA );

				mbx_gen2dr.put(h_trans_idle);
				$display($time,"\t -------> sanity sample is put into mailbox \n");

			end

//		run_tc;
		
	endtask
	
endclass



*/
