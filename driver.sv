class driver;
	transaction h_trans,h_trans_collect;
	mailbox mbx_gen2dr;
	virtual apb_interface apb_intf;

	function new (mailbox mbx_gen2dr,virtual apb_interface apb_intf);
		
		h_trans 		= new() ;
		h_trans_collect	= new() ;
		this.apb_intf	= apb_intf ;
		this.mbx_gen2dr = mbx_gen2dr ;
	
	endfunction

task run;
  forever  @(apb_intf.cb_driver) begin
			h_trans		 			= new;
			h_trans_collect			= new;
	
			mbx_gen2dr.get(h_trans_collect);
			h_trans.copy(h_trans_collect); 

			$display($time,"\t ---------------------------->samples got from generator  ");
			$display($time,"\t DRIVER : \tPRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-----------in driver ",h_trans.PRESETn , h_trans.PSELx, h_trans.PADDR ,h_trans.PENABLE ,h_trans.PWRITE ,h_trans.PPROT ,h_trans.PSTRB ,h_trans.PWDATA );
    
// ---------------------------- SETUP ----------------

    apb_intf.PRESETn <= h_trans.PRESETn;
    apb_intf.PSELx   <= h_trans.PSELx;
    apb_intf.PENABLE <= h_trans.PENABLE;
    apb_intf.PADDR   <= h_trans.PADDR;
    apb_intf.PWRITE  <= h_trans.PWRITE;
    apb_intf.PPROT   <= h_trans.PPROT;
    apb_intf.PSTRB   <= h_trans.PSTRB;
    apb_intf.PWDATA  <= h_trans.PWDATA;

 // -------------------------------- ACCESS ----------------
    if(h_trans.PRESETn && h_trans.PSELx && h_trans.PENABLE)begin

 // ----------------------------- WAIT FOR READY ----------------
      if (apb_intf.PREADY == 1'b1) begin
        @(apb_intf.cb_driver) begin
                  	mbx_gen2dr.get(h_trans_collect);
					h_trans.copy(h_trans_collect); 
                  
                  	    apb_intf.PRESETn <= h_trans.PRESETn;
    					apb_intf.PSELx   <= h_trans.PSELx;
    					apb_intf.PENABLE <= h_trans.PENABLE;
    					apb_intf.PADDR   <= h_trans.PADDR;
    					apb_intf.PWRITE  <= h_trans.PWRITE;
   						apb_intf.PPROT   <= h_trans.PPROT;
    					apb_intf.PSTRB   <= h_trans.PSTRB;
    					apb_intf.PWDATA  <= h_trans.PWDATA;
        
        $display($time,"\t DRIVER to INTERFACE : \tPRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-----------in driver ",h_trans.PRESETn , h_trans.PSELx, h_trans.PADDR ,h_trans.PENABLE ,h_trans.PWRITE ,h_trans.PPROT ,h_trans.PSTRB ,h_trans.PWDATA );
          
        end

  	  end
  	end
  end
endtask
endclass

/*
	task run;
		forever @(apb_intf.cb_driver) begin
//			h_trans 		= new() ;
		//	h_trans_copy	= new() ;
			mbx_gen2dr.get(h_trans);
		//	h_trans_copy.copy(h_trans);

			$display($time,"\t ---------------------------->samples got from generator  ");
			$display($time,"\t DRIVER : \tPRESETn = %0d \t PSELx = %0d \t PADDR = %0d \t PENABLE = %0d \t PWRITE = %0d \t PPROT = %b \t PSTRB = %b \t PWDATA = %0d \t //-----------in driver ",h_trans.PRESETn , h_trans.PSELx, h_trans.PADDR ,h_trans.PENABLE ,h_trans.PWRITE ,h_trans.PPROT ,h_trans.PSTRB ,h_trans.PWDATA );


//----------------------SETUP PHASE--------------------------------
			apb_intf.PRESETn <= h_trans.PRESETn ;
			apb_intf.PSELx	 <= h_trans.PSELx ;
      		apb_intf.PENABLE <= h_trans.PENABLE;
			apb_intf.PADDR 	 <=	h_trans.PADDR ;
			apb_intf.PWRITE  <= h_trans.PWRITE ; 
			apb_intf.PPROT   <= h_trans.PPROT ;
			apb_intf.PSTRB   <= h_trans.PSTRB ;
			apb_intf.PWDATA  <= h_trans.PWDATA ;

//----------------------ACCESS PHASE------------------------------
			@(apb_intf.cb_driver) begin
			
				apb_intf.PENABLE <= h_trans.PENABLE ;

//----------------------WAIT FOR READY----------------------------
      			if (h_trans.PSELx && h_trans.PENABLE) begin
        			wait (apb_intf.PREADY === 1'b1);
      			end
			end

//----------------------COMPLETED---------------------------------
		      @(apb_intf.cb_driver) begin
      					apb_intf.PSELx   <= 1'b0;
     					 apb_intf.PENABLE <= 1'b0;
					end

		end
	endtask
*/