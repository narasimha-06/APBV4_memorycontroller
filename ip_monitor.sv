class ip_monitor;

	typedef enum bit[1:0]{IDLE,SETUP_PHASE,ACCESS_PHASE} current_state;
	typedef enum bit[1:0]{PPROT_WAIT,PPROT_VALID,PPROT_INVALID} protection_valid;
	typedef enum bit[2:0]{NULL_MEM_RANGE,MEM_RANGE_1,MEM_RANGE_2,MEM_RANGE_3,MEM_RANGE_4} memory_range;

	current_state		NEXT_STATE;
	protection_valid	protection_state;
	memory_range		mem_range_state;

//--------------------transaction class instance
	transaction		h_trans_collect,h_trans_in,h_trans_drive;
	transaction		temp_trans;

	mailbox			mbx_in2scb;

	virtual apb_interface apb_intf;

  	bit [31:0] memory_DSP	[511:0];
  	bit [31:0] memory_CSP	[511:0];
  	bit [31:0] memory_DNSNP [511:0];
  	bit [31:0] memory_APB_3 [1023:0];

   //constructor----------------
	function new(virtual apb_interface intf,mailbox mbx_in2scb);
		this.mbx_in2scb		= mbx_in2scb;
		apb_intf			= intf;
  		h_trans_collect		= new;
      	h_trans_in			= new;
		h_trans_drive 		= new;
		temp_trans			= new;
	endfunction
		
	task run;

      forever @(apb_intf.cb_monitor)begin
     
		h_trans_collect.PRESETn		= apb_intf.cb_monitor.PRESETn;
		h_trans_collect.PSELx		= apb_intf.cb_monitor.PSELx;
		h_trans_collect.PWRITE		= apb_intf.cb_monitor.PWRITE;
		h_trans_collect.PWDATA		= apb_intf.cb_monitor.PWDATA;
		h_trans_collect.PSTRB		= apb_intf.cb_monitor.PSTRB;
		h_trans_collect.PENABLE		= apb_intf.cb_monitor.PENABLE;
		h_trans_collect.PPROT		= apb_intf.cb_monitor.PPROT;
		h_trans_collect.PREADY		= apb_intf.cb_monitor.PREADY;
		h_trans_collect.PADDR		= apb_intf.cb_monitor.PADDR;
        
        $display($time,"\t ---------------------------->INPUT MONITOR collected samples from interface");
        $display($time,"\t PRESETn = %0h,\tPSELx = %0h,\tPWRITE = %0h,\tPADDR = %0d,\tPWDATA = %0d,\tPSTRB = %b,\tPPROT = %b,\tPENABLE = %0h\t"
                     ,h_trans_collect.PRESETn,h_trans_collect.PSELx,h_trans_collect.PWRITE,h_trans_collect.PADDR,h_trans_collect.PWDATA,h_trans_collect.PSTRB,h_trans_collect.PPROT,h_trans_collect.PENABLE);
        
        
      	h_trans_collect.PRDATA	= h_trans_drive.PRDATA;				// drive or normal for h_trans_in 
     	h_trans_in.copy(h_trans_collect);
 
        fsm;		//self check task invoking
        
      end
	endtask

	task fsm();

		if (!h_trans_in.PRESETn) begin
			idle_state();			
			NEXT_STATE	= IDLE;
		end
      
		else if	(h_trans_in.PRESETn)
		begin
			case(NEXT_STATE)
			
            	IDLE		: if(h_trans_in.PSELx && !h_trans_in.PENABLE) begin
									NEXT_STATE = SETUP_PHASE;
									set_phase();				
								end
							 	else begin
									NEXT_STATE = IDLE;
									idle_state();
								end

            	SETUP_PHASE	: if(h_trans_in.PSELx && h_trans_in.PENABLE) begin
									NEXT_STATE = ACCESS_PHASE;
									access_phase();	
								end	// block for wait pulse

								else if(!h_trans_in.PSELx) begin
								 	NEXT_STATE = IDLE;
									idle_state();
								end
              					else NEXT_STATE = SETUP_PHASE;

            	ACCESS_PHASE: if(h_trans_in.PSELx && !h_trans_in.PENABLE) begin
									NEXT_STATE = SETUP_PHASE;
									set_phase();
								end
							 	else if (!h_trans_in.PSELx)	begin
									NEXT_STATE = IDLE;
									idle_state();
								end
							 	else NEXT_STATE	= ACCESS_PHASE;
			
			endcase
		end

		else reset_z;
	endtask


	task reset_z;
      mbx_in2scb.put(h_trans_drive);
	endtask

//================================ IDLE OR RESET STATE ===============================================================		 
		 

	//if reset_n is set go to the initial state with default set values
	task idle_state();
      		$display($time,"\t IDLE_PHASE_OPERATION\n");

      /*
			temp_trans.PRESETn	= h_trans_in.PRESETn;
			temp_trans.PSELx	= h_trans_in.PSELx;
			temp_trans.PWRITE	= h_trans_in.PWRITE;
			temp_trans.PADDR	= h_trans_in.PADDR;
			temp_trans.PWDATA	= h_trans_in.PWDATA;
			temp_trans.PSTRB	= h_trans_in.PSTRB;
			temp_trans.PENABLE	= h_trans_in.PENABLE;
			temp_trans.PPROT	= h_trans_in.PPROT;
  */    
		
      		h_trans_in.PSELx	= 'h0;
			h_trans_in.PWRITE	= 'h1;
			h_trans_in.PADDR	= 'h0;
			h_trans_in.PWDATA	= 'h0;
			h_trans_in.PSTRB	= 'h0;
			h_trans_in.PENABLE	= 'h0;
			h_trans_in.PPROT	= 'h0;
      
      		h_trans_in.PREADY  	= 'h0;
      		h_trans_in.PSLVERR 	= 'h0;
      		h_trans_in.PRDATA	= 'h0;

		     temp_trans.copy(h_trans_in);
      
      
      h_trans_drive.copy(h_trans_in);
      mbx_in2scb.put(h_trans_drive);
	endtask


		 		
//=================================SETUP PHASE OPERATION========================================================
	 
  task set_phase();
    $display($time,"\t SETUP PHASE OPERATION ");

   
			temp_trans.PRESETn	= h_trans_in.PRESETn;
			temp_trans.PSELx	= h_trans_in.PSELx;
			temp_trans.PWRITE	= h_trans_in.PWRITE;
			temp_trans.PADDR	= h_trans_in.PADDR;
			temp_trans.PWDATA	= h_trans_in.PWDATA;
			temp_trans.PSTRB	= h_trans_in.PSTRB;
			temp_trans.PENABLE	= h_trans_in.PENABLE;
			temp_trans.PPROT	= h_trans_in.PPROT;


	   //to check valid addresss with protection value
		if	( (temp_trans.PADDR >= 'h0 && temp_trans.PADDR <= 'h63) && temp_trans.PPROT == 'h1)		//-------0 to 99
			begin	mem_range_state	= MEM_RANGE_1;  	protection_state	= PPROT_VALID;	end
		else if( (temp_trans.PADDR >= 'h64 && temp_trans.PADDR <= 'hC7) && temp_trans.PPROT == 'h5)	//-------100 to 199
			begin	mem_range_state	= MEM_RANGE_2; 		protection_state	= PPROT_VALID;	end	
		else if( (temp_trans.PADDR >= 'hC8 && temp_trans.PADDR <= 'h18F) && (temp_trans.PPROT <= 'h3 && temp_trans.PPROT >= 'h0) ) 	//--------200 to 399
			begin	mem_range_state	= MEM_RANGE_3; 		protection_state	= PPROT_VALID;	end	
		else if(temp_trans.PADDR >= 'h190 && temp_trans.PADDR <= 'hFFF)					//---------400 to 4095
			begin	mem_range_state	= MEM_RANGE_4;		protection_state	= PPROT_VALID;	end	 
		else
			begin	mem_range_state	= NULL_MEM_RANGE;	protection_state	= PPROT_INVALID;end
    
    	h_trans_drive.copy(h_trans_in);
      	mbx_in2scb.put(h_trans_drive);
    
  endtask


	 
//========================================ACCESS PHASE===============================================================
 
	task access_phase();
      $display($time,"\t ACCESS PHASE OPERATION\n");
      
      wait(apb_intf.cb_monitor.PREADY)
      begin
           	h_trans_in.PREADY = apb_intf.cb_monitor.PREADY;
        $display($time,"\t from DUT : Pready = %0d \t Pslverr = %b \t prdata = %0d ", apb_intf.cb_monitor.PREADY,apb_intf.cb_monitor.PSLVERR,apb_intf.cb_monitor.PRDATA);
        
              if(	(temp_trans.PSELx	!= h_trans_in.PSELx)	||  (temp_trans.PWRITE	!= h_trans_in.PWRITE)	||
					(temp_trans.PADDR	!= h_trans_in.PADDR)	||	(temp_trans.PWDATA	!= h_trans_in.PWDATA)	||
					(temp_trans.PSTRB	!= h_trans_in.PSTRB)	||	(temp_trans.PPROT	!= h_trans_in.PPROT) 	||
                 	(protection_state 	!= PPROT_VALID)		||	(temp_trans.PADDR%4 != 0 )				||	
                 	(mem_range_state	== NULL_MEM_RANGE)  ||  (!h_trans_in.PWRITE && h_trans_in.PSTRB != 0))
				begin   h_trans_in.PSLVERR	= 1'h1;	end

				else if	((temp_trans.PSELx	== h_trans_in.PSELx)	&&	(temp_trans.PWRITE	== h_trans_in.PWRITE)	&&	
						 (temp_trans.PADDR	== h_trans_in.PADDR)	&&	(temp_trans.PWDATA	== h_trans_in.PWDATA)	&&
						 (temp_trans.PSTRB	== h_trans_in.PSTRB)	&&	(temp_trans.PPROT	== h_trans_in.PPROT))
				begin	h_trans_in.PSLVERR	= 1'h0;	end
   

//------------------------------------- READ OR WRITE OPERATION

        if( mem_range_state	!= NULL_MEM_RANGE  && temp_trans.PADDR == h_trans_in.PADDR &&	temp_trans.PADDR%4 == 0	&&
			h_trans_in.PWRITE 	&& temp_trans.PWDATA == h_trans_in.PWDATA && protection_state == PPROT_VALID)begin	

			if(mem_range_state == MEM_RANGE_1 )begin
				for(int i=0; i<4; i++)begin
					if(temp_trans.PSTRB[i]) begin 
                      	memory_DSP[temp_trans.PADDR[31:2]] [(i*8)+:8]	=	h_trans_in.PWDATA[(i*8)+:8];
                    end					
				end
              $display($time,"\tWRITE OPEARTION DONE => mem_DSP = %0d",memory_DSP[temp_trans.PADDR[31:2]] [31:0]);

			end
			if(mem_range_state == MEM_RANGE_2)begin
				for(int i=0; i<4; i++)begin
                  	if(temp_trans.PSTRB[i]) begin
                    	memory_CSP[temp_trans.PADDR[31:2]] [(i*8)+:8]	=	h_trans_in.PWDATA[(i*8)+:8];
                 	end					
				end
              $display($time,"\tWRITE OPEARTION DONE => mem_CSP = %0d",memory_CSP[temp_trans.PADDR[31:2]] [31:0]);		
			end
			if(mem_range_state == MEM_RANGE_3)begin
				for(int i=0; i<4; i++)begin
                  	if(temp_trans.PSTRB[i]) begin
                    	memory_DNSNP[temp_trans.PADDR[31:2]] [(i*8)+:8]	=	h_trans_in.PWDATA[(i*8)+:8];
                 	end										
				end 
              $display($time,"\tWRITE OPEARTION DONE => mem_DNSNP = %0d",memory_DNSNP[temp_trans.PADDR[31:2]] [31:0]);
			end
			if(mem_range_state == MEM_RANGE_4)begin
				memory_APB_3[temp_trans.PADDR[31:2]][31:0] 	= h_trans_in.PWDATA[31:0];	
              $display($time,"\tWRITE OPEARTION DONE => mem_APB_3 = %0h",memory_APB_3[temp_trans.PADDR[31:2]] [31:0]);
			end
		end
		if(  !h_trans_in.PWRITE && h_trans_in.PSTRB == 0	&& mem_range_state != NULL_MEM_RANGE && protection_state == PPROT_VALID && temp_trans.PADDR	== h_trans_in.PADDR )begin
          $display($time,"\tselected_memory_range => %p",mem_range_state);
			if(mem_range_state == MEM_RANGE_1)
              h_trans_in.PRDATA = memory_DSP[temp_trans.PADDR[31:2]][31:0];
			else if(mem_range_state == MEM_RANGE_2)
              h_trans_in.PRDATA = memory_CSP[temp_trans.PADDR[31:2]][31:0];
			else if(mem_range_state == MEM_RANGE_3)
              h_trans_in.PRDATA = memory_DNSNP[temp_trans.PADDR[31:2]][31:0];
			else if(mem_range_state == MEM_RANGE_4)
              h_trans_in.PRDATA = memory_APB_3[temp_trans.PADDR[31:2]][31:0];
	
		//when read operation to display the read data----------------------------------------------------------------------	
          if(mem_range_state == MEM_RANGE_1)
            $display($time,"\tREAD OPEARTION DONE => mem_DSP = %0h",memory_DSP[temp_trans.PADDR[31:2]][31:0]);
			else if(mem_range_state == MEM_RANGE_2)
              $display($time,"\tREAD OPEARTION DONE => mem_CSP = %0h",memory_CSP[temp_trans.PADDR[31:2]][31:0]);
			else if(mem_range_state == MEM_RANGE_3)
              $display($time,"\tREAD OPEARTION DONE => mem_DNSNP = %0h",memory_DNSNP[temp_trans.PADDR[31:2]][31:0]);
			else if(mem_range_state == MEM_RANGE_4)
              $display($time,"\tREAD OPEARTION DONE => mem_APB_3 = %0h",memory_APB_3[temp_trans.PADDR[31:2]][31:0]);
		end
      
      else 
		$display($time,"\tSIGNALS MISMATCHED SETUP & ACCESS PHASE OR ERROR DETECTED");
        
        
 			h_trans_drive.copy(h_trans_in);
      		mbx_in2scb.put(h_trans_drive);
      
      end
      
    endtask

endclass

