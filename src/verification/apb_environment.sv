class apb_environment; 

	virtual apb_inf.DRIVER drv; 
  	virtual apb_inf.MONITOR mon;

	mailbox #(apb_transaction) mbx_gd; 
	mailbox #(apb_transaction) mbx_ms; 

	apb_generator		gen;
	apb_driver			drvv; 
	apb_monitor         monn; 
	apb_scoreboard 		scb; 

	function new (virtual apb_inf.DRIVER drv, virtual apb_inf.MONITOR mon ); 
		this.drv = drv; 
		this.mon = mon; 
	endfunction 

	task build(); 
	begin 
		mbx_gd = new(); 
		mbx_ms = new(); 

		gen  = new(mbx_gd); 
		drvv  = new(mbx_gd, drv); 
		monn  = new(mbx_ms, mon); 
		scb  = new(mbx_ms); 
	end 
	endtask 

	task start(); 
		fork 
			gen.start(); 
			drvv.start(); 
			monn.start(); 
			//scb.start();
		join 
		//scb.summary(); 
	endtask 

endclass 
