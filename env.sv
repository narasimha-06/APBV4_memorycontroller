class environment;

//	transaction		h_trans;
	generator 		h_gen;
	driver 			h_driver;

	virtual apb_interface	apb_intf;

	mailbox			mbx_in,mbx_out;
	mailbox			mbx_gen2dr;

	ip_monitor		h_ipmonitor;
	op_monitor		h_opmonitor;

	scoreboard		h_scoreboard;

//	apb_coverage	h_coverage;

	function new(virtual apb_interface apb_intf);
		
		this.apb_intf	= apb_intf;

      mbx_gen2dr 		= new(1);
      mbx_in			= new(1);
      mbx_out			= new(1);

		h_gen			= new(mbx_gen2dr);
		h_driver 		= new(mbx_gen2dr,apb_intf);
		
		h_ipmonitor		= new(apb_intf,mbx_in);
		h_opmonitor		= new(apb_intf,mbx_out);
		
		h_scoreboard	= new(mbx_in,mbx_out);
		
//		h_coverage		= new(apb_intf);

	endfunction

	task run;

		fork
			run_all;
//			h_gen.run;
			h_driver.run;
			h_ipmonitor.run;
			h_opmonitor.run;
			h_scoreboard.run;
//			h_coverage.run;

		join
	endtask

task run_all;

				h_gen.TC0_reset;
  				h_gen.TC1_basicwrite(rw) ;			  
					
//				h_gen.TC2_setupreset ;					
//				h_gen.TC3_accessreset ;					
//				h_gen.TC4_dspmem ;	  						
//				h_gen.TC5_cspmem;	  						
//				h_gen.TC6_dnsnpmem ;							
//				h_gen.TC7_apb3mem ;							
/*				h_gen.TC8_b2bwrite ;			 	
				h_gen.TC9_pstrbwrite ;				 	
				h_gen.TC10_unaligned_dspwrite;
				h_gen.TC11_unaligned_cspwrite ;
				h_gen.TC12_unaligned_dnsnpwrite ;
				h_gen.TC13_invalidpprot_dsp ;
				h_gen.TC14_invalidpprot_csp ;
                h_gen.TC15_invalidpprot_dnsnp ;
                h_gen.TC16_invalidpprot_apb3 ;
				h_gen.TC17_unstable ;
				h_gen.C18_no_pstrb ;
				h_gen.TC19_out_of_range ;
				h_gen.TC20_toggle_reset ;
*/


		/*
        •	 
		
		*/          

        endtask
endclass
