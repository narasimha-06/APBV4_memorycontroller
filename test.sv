class test;
	virtual apb_interface 	apb_intf;
	environment 			h_env;

	function new (virtual apb_interface apb_intf);
		this.apb_intf	= apb_intf ;
		h_env = new (apb_intf) ;
	endfunction

	task run ();
		h_env.run ();
		$display($time,"\t -----------> run task in test is completed ");
		
	endtask
endclass
