class apb_coverage;

//------------------virtual interface---------------
	virtual apb_interface	apb_intf;
                       
//-----------------covergroups----------------------
	covergroup cg_APB4;
	
	//-------------single bit signals
		cp_rst 		: coverpoint apb_intf.PRESETn {
						bins presetn_low 	= {0};
						bins presetn_high 	= {1};
					
						}

		cp_selx		: coverpoint apb_intf.PSELx  {
						bins psel_low		= {0};
						bins psel_high		= {1};
					
						}

		cp_en 		: coverpoint apb_intf.PENABLE {
						bins penable_low	= {0};
						bins penable_high	= {1};
					
						}

	//-------------multi bit signals
		cp_addr		: coverpoint apb_intf.PADDR {
						bins paddr_mem1		= {[0:99]};
						bins paddr_mem2		= {[100:199]};
						bins paddr_mem3		= {[200:399]};
						bins paddr_mem4		= {[400:4095]};
						}
						
		cp_strb		: coverpoint apb_intf.PSTRB {
						bins addr_aligned 		= 	{4'b1111} iff (apb_intf.PADDR % 4 == 0);
						bins addr_unaligned_1 	= 	{4'b1110} iff (apb_intf.PADDR % 4 == 1);
						bins addr_unaligned_2	=	{4'b1100} iff (apb_intf.PADDR % 4 == 2);
						bins addr_unaligned_3	= 	{4'b1000} iff (apb_intf.PADDR % 4 == 3);
					
						}
		cp_pprot	: coverpoint apb_intf.PPROT {
						bins valid_pprot_mem1	= 	{3'b001} iff (apb_intf.PADDR >= 0 	&& apb_intf.PADDR <=  99 );
						bins valid_pprot_mem2	= 	{3'b101} iff (apb_intf.PADDR >= 100 && apb_intf.PADDR <= 199 );
						bins valid_pprot_mem3	= 	{3'b010} iff (apb_intf.PADDR >= 200	&& apb_intf.PADDR <= 399 );
						bins valid_pprot_mem4	= 	{3'b000} iff (apb_intf.PADDR >= 400	&& apb_intf.PADDR <= 4059);

						}



	  	//paddr_range_in_CSP
		CP_PADDR_DSP: coverpoint apb_intf.PADDR	iff(apb_intf.PRESETn)
												{
//-----------------------------------------------------DSP address ranges

													bins paddr_DSP_low1 = { [0:9] };	bins paddr_DSP_low2	= { [10:19] };	bins paddr_DSP_low3	= { [20:29] };
													bins paddr_DSP_med1	= { [30:39] };	bins paddr_DSP_med2	= { [40:59] };	bins paddr_DSP_med3	= { [60:69] };
													bins paddr_DSP_high1= { [70:79] };	bins paddr_DSP_high2= { [80:89] };	bins paddr_DSP_high3= { [90:99] };

												}

	  	//paddr_range_in_CSP
		CP_PADDR_CSP: coverpoint apb_intf.PADDR	iff(apb_intf.PRESETn)
												{

//-----------------------------------------------------CSP address ranges -
												  	bins paddr_CSP_low1 = {[100:119]};	bins paddr_CSP_low2	= {[120:139]};	
													bins paddr_CSP_med1	= {[140:159]};	
													bins paddr_CSP_high1= {[160:179]};	bins paddr_CSP_high2= {[180:199]};
												}
	  	//paddr_range_in_DNSNP
		CP_PADDR_DNSNP: coverpoint apb_intf.PADDR	iff(apb_intf.PRESETn)
												{

//-----------------------------------------------------DNSNP address ranges 
												  	bins paddr_DNSNP_low1	= {[200:239]};	bins paddr_DNSNP_low2	= {[240:279]};	
													bins paddr_DNSNP_med1	= {[280:319]};		
													bins paddr_DNSNP_high1	= {[320:359]};	bins paddr_DNSNP_high2	= {[360:399]};	

												}

	  	//paddr_range_in_APB_3												
		CP_PADDR_APB_3: coverpoint apb_intf.PADDR	iff(apb_intf.PRESETn)	
												{
												  
//-----------------------------------------------------APB_3 address ranges 
													bins paddr_APB_3_low1	= {[400:999]};	bins paddr_APB_3_low2	= {[1000:1599]};	
													bins paddr_APB_3_med1	= {[1600:2199]};bins paddr_APB_3_med2	= {[2200:2799]};
													bins paddr_APB_3_high1	= {[2800:3399]};bins paddr_APB_3_high2	= {[3400:4095]};
												}

	  	//paddr_range_out_of_range
		CP_PADDR_OUT_OF_RANGE: coverpoint apb_intf.PADDR	iff(apb_intf.PRESETn)	
												{
												  //out of range address  ------------------------------------------------------------------------------------------------------
													bins paddr_out_of_range	= { [4096:$] };
												}


	  //pstrb for only zero
		CP_PSTRB_0		: coverpoint apb_intf.PSTRB	iff(apb_intf.PRESETn)
												{	bins pstrb0 = {'h0};
												}
	
	  //pstrb except zero
		CP_PSTRB_ALL	: coverpoint apb_intf.PSTRB	iff(apb_intf.PRESETn)
												{	bins pstrb1	= {'h1};	bins pstrb2	= {'h2};	bins pstrb3	= {'h3};	bins pstrb4	= {'h4};	bins pstrb5	= {'h5};	bins pstrb6	= {'h6};
													bins pstrb7	= {'h7};	bins pstrb8	= {'h8};	bins pstrb9	= {'h9};	bins pstrb10= {'ha};	bins pstrb11= {'hb};	bins pstrb12= {'hc};
													bins pstrb13= {'hd};	bins pstrb14= {'he};	bins pstrb15= {'hf};
												}


		CR_READ_PSTRB	: cross CP_PWRITE,CP_PSTRB_ALL	iff(apb_intf.PRESETn && apb_intf.PSELx)
												{	illegal_bins read_ignore_strobe = binsof(CP_PWRITE.pwrite_low_value) &&	binsof(CP_PSTRB_ALL);
												}


		CR_APB_3_PSTRB_PPROT	: cross CP_PADDR_APB_3,/*CP_PSTRB_ALL,CP_PSTRB_0,*/CP_PPROT	iff(apb_intf.PRESETn && apb_intf.PSELx)
												{	ignore_bins apb_3_ignore_pstrobe_pprot	= binsof(CP_PADDR_APB_3) && /*( binsof(CP_PSTRB_0) || binsof(CP_PSTRB_ALL) ) &&*/ binsof(CP_PPROT);
												}


		CR_PADDR_DNSNP_IGNORE_PPROT	: cross CP_PADDR_DNSNP,CP_PPROT	iff(apb_intf.PRESETn && apb_intf.PSELx)
												{	illegal_bins dnsnp	= binsof(CP_PADDR_DNSNP)	&& (binsof(CP_PPROT.pprot4)	|| binsof(CP_PPROT.pprot5)	|| binsof(CP_PPROT.pprot6)	||
																										binsof(CP_PPROT.pprot7)	);
												}

		CR_PADDR_DSP_IGNORE_PPROT	: cross CP_PADDR_DSP,CP_PPROT	iff(apb_intf.PRESETn && apb_intf.PSELx)
												{	illegal_bins dsp	= binsof(CP_PADDR_DSP)	&& (binsof(CP_PPROT.pprot0)	|| binsof(CP_PPROT.pprot2)	|| binsof(CP_PPROT.pprot3)	||
																									binsof(CP_PPROT.pprot4)	|| binsof(CP_PPROT.pprot5)	|| binsof(CP_PPROT.pprot6)	||
																									binsof(CP_PPROT.pprot7)	);
												}


		CR_PADDR_CSP_IGNORE_PPROT	: cross CP_PADDR_CSP,CP_PPROT	iff(apb_intf.PRESETn && apb_intf.PSELx)
												{	illegal_bins csp	= binsof(CP_PADDR_CSP)	&& (binsof(CP_PPROT.pprot0)	|| binsof(CP_PPROT.pprot1)	|| binsof(CP_PPROT.pprot2)	||
																									binsof(CP_PPROT.pprot3)	|| binsof(CP_PPROT.pprot4)	|| binsof(CP_PPROT.pprot6)	||
																									binsof(CP_PPROT.pprot7)	);
												}

	
	endgroup

//-----------------constructor----------------------
	function new (virtual apb_interface apb_intf);
		this.apb_intf 	= apb_intf; 
		cg_APB4 		= new();
	endfunction

//-----------------run task-------------------------
	task run;
		forever @(apb_intf.cb_driver) begin
			cg_APB4.sample();
			$display($time,"\t COVERAGE PERCENTAGE : %f",cg_APB4.get_coverage);
		end
	endtask
endclass

