class scoreboard;
	transaction 	h_trans_in,h_trans_out;
	transaction 	h_trans_in_copy,h_trans_out_copy;
	mailbox 		mbx_in,mbx_out;

	function new(mailbox mbx_in,mailbox mbx_out);
		this.mbx_in		= mbx_in;
		this.mbx_out	= mbx_out;
	endfunction



	task run;
		h_trans_in			= new;
		h_trans_in_copy 	= new;
		h_trans_out 		= new;
		h_trans_out_copy	= new;

		forever begin
		 begin 

                    mbx_in.get(h_trans_in);
					h_trans_in_copy.copy(h_trans_in);
                 
					mbx_out.get(h_trans_out);
                   	h_trans_out_copy.copy(h_trans_out);
         end
                  
			$display("\n\n\n");

			$display($time,"\t ===================================================================> SCOREBOARD_VALUES ");

          if(h_trans_in_copy.PREADY == h_trans_out_copy.PREADY && h_trans_in_copy.PRDATA == h_trans_out_copy.PRDATA && h_trans_in_copy.PSLVERR == h_trans_out_copy.PSLVERR)
			begin
            	$display ($time,"\t ==========================================> I/P & O/P ARE MATCHED ");

            	$display($time,"\t From VIP : PREADY = %0h \tPRDATA = %0d \tPSLVERR = %0h\t ===>  PADDR = %0d \tPWRITE = %0h "
                       ,h_trans_in_copy.PREADY,h_trans_in_copy.PRDATA,h_trans_in_copy.PSLVERR
                       ,h_trans_in_copy.PADDR,h_trans_in_copy.PWRITE);

            	$display($time,"\t From IP : PREADY = %0h \tPRDATA = %0d \tPSLVERR = %0h\t ===> PADDR = %0d \tPWRITE = %0h "
                       ,h_trans_out_copy.PREADY,h_trans_out_copy.PRDATA,h_trans_out_copy.PSLVERR
                       ,h_trans_out_copy.PADDR,h_trans_out_copy.PWRITE);

				$display("\t--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n\n");
			end
			else begin
              $display ($time,"\t ============================================> NOT MATCHED");
					
              $display($time,"\t From VIP : \tPREADY = %0h \tPRDATA = %0d \tPSLVERR = %0h ===> PADDR = %0d \tPWRITE = %0h "
                       ,h_trans_in_copy.PREADY,h_trans_in_copy.PRDATA,h_trans_in_copy.PSLVERR
                       ,h_trans_in_copy.PADDR,h_trans_in_copy.PWRITE);

              $display($time,"\t From IP : \tPREADY = %0h \tPRDATA = %0d \tPSLVERR = %0h ===> PADDR = %0d \tPWRITE = %0h "
                       ,h_trans_out_copy.PREADY,h_trans_out_copy.PRDATA,h_trans_out_copy.PSLVERR
                       ,h_trans_out_copy.PADDR,h_trans_out_copy.PWRITE);
				$display("\t--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n\n");

			end
	end
	endtask

endclass
