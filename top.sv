module top;

	test h_test;

	bit PCLK;
	always #5 PCLK++;	//------clock generation

	apb_interface apb_intf(PCLK);	//----------interface call

	APB_INTERFACE_V6 DUT(		//----------DUT instantiation
							.reset_n(apb_intf.PRESETn),
							.pclock(apb_intf.PCLK),
							.pselx(apb_intf.PSELx),
							.paddr(apb_intf.PADDR),
							.penable(apb_intf.PENABLE),
							.pwrite(apb_intf.PWRITE),
							.pprot(apb_intf.PPROT),
							.pstrobe(apb_intf.PSTRB),
							.pw_data(apb_intf.PWDATA),
      .pslverror(apb_intf.cb_monitor.PSLVERR),
      .pready(apb_intf.cb_monitor.PREADY),
      .pr_data(apb_intf.cb_monitor.PRDATA) );

	initial begin
		h_test = new(apb_intf);		//----------connecting top with interface
		h_test.run;					//----------randomizing by calling run task in test class
	end
	
	initial begin
		 #5000
 		$finish;
	end
endmodule
