class op_monitor;

	virtual apb_interface apb_intf ;	//-------monitor interface handle
	mailbox mbx_out2scb;
	transaction h_trans_out,h_trans_collect;

//-------------constructor----------------
	function new(virtual apb_interface apb_intf, mailbox mbx_out2scb);
		this.apb_intf 		= apb_intf;
		this.mbx_out2scb 	= mbx_out2scb;
		h_trans_out 	 	= new;
		h_trans_collect	 	= new;

	endfunction

	task run;
		h_trans_collect	= new;
		h_trans_out	=new;
	
      
		forever @(apb_intf.cb_monitor) begin
          
//---------------------------------Collect the DUT outputs from the interface and update onto the output monitor
           
         	if(apb_intf.cb_monitor.PRESETn && apb_intf.cb_monitor.PSELx && apb_intf.cb_monitor.PENABLE) begin

              	wait(apb_intf.cb_monitor.PREADY) begin						//---------wait for ready signal
           		
					h_trans_collect.PSELx		= apb_intf.cb_monitor.PSELx;		          
          			h_trans_collect.PENABLE		= apb_intf.cb_monitor.PENABLE;
          			h_trans_collect.PRESETn		= apb_intf.cb_monitor.PRESETn;
          			h_trans_collect.PWRITE		= apb_intf.cb_monitor.PWRITE;				
          			h_trans_collect.PADDR		= apb_intf.cb_monitor.PADDR;				
          			h_trans_collect.PWDATA		= apb_intf.cb_monitor.PWDATA; 				
          			h_trans_collect.PSTRB		= apb_intf.cb_monitor.PSTRB;
          			h_trans_collect.PPROT		= apb_intf.cb_monitor.PPROT;             				
          			h_trans_collect.PREADY 		= apb_intf.cb_monitor.PREADY;				
          			h_trans_collect.PRDATA		= apb_intf.cb_monitor.PRDATA;				
          			h_trans_collect.PSLVERR		= apb_intf.cb_monitor.PSLVERR;
                  
                  
                  //Make a copy the collecting the samples onto the another handle--------------
          			h_trans_out.copy(h_trans_collect);
				
          		  //Sample copy handle put into the mailbox----------------------------------
          			mbx_out2scb.put(h_trans_out);
           		end
         	end
         	else begin
          			h_trans_collect.PSELx		= apb_intf.cb_monitor.PSELx;		          
          			h_trans_collect.PENABLE		= apb_intf.cb_monitor.PENABLE;
          			h_trans_collect.PRESETn		= apb_intf.cb_monitor.PRESETn;
          			h_trans_collect.PWRITE		= apb_intf.cb_monitor.PWRITE;				
          			h_trans_collect.PADDR		= apb_intf.cb_monitor.PADDR;				
          			h_trans_collect.PWDATA		= apb_intf.cb_monitor.PWDATA; 				
          			h_trans_collect.PSTRB		= apb_intf.cb_monitor.PSTRB;
          			h_trans_collect.PPROT		= apb_intf.cb_monitor.PPROT;             				
          			h_trans_collect.PREADY 		= apb_intf.cb_monitor.PREADY;				
          			h_trans_collect.PRDATA		= apb_intf.cb_monitor.PRDATA;				
          			h_trans_collect.PSLVERR		= apb_intf.cb_monitor.PSLVERR;
                  
                  //Make a copy the collecting the samples onto the another handle--------------
          			h_trans_out.copy(h_trans_collect);
				
          		  //Sample copy handle put into the mailbox----------------------------------
          			mbx_out2scb.put(h_trans_out);
     		end          
        end
      
 
	endtask

endclass
