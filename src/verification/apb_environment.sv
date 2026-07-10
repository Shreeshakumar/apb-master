class apb_environment; 

	virtual apb_inf.DRIVER vif_drv; 
	virtual apb_inf.MONITOR vif_mon; 
	virtual apb_inf.REFERENCE vif_ref; 

	mailbox #(apb_transaction) mbx_gd; 
	mailbox #(apb_transaction) mbx_dr; 
	mailbox #(apb_transaction) mbx_rs; 
	mailbox #(apb_transaction) mbx_ms; 

	apb_generator		gen;
	apb_driver			drv; 
	apb_monitor         mon; 
	apb_reference_model	reff; 
	apb_scoreboard 		scb; 

	function new (virtual apb_inf vif_drv, virtual apb_inf vif_mon, virtual apb_inf vif_ref ); 
		this.vif_drv = vif_drv; 
		this.vif_mon = vif_mon; 
		this.vif_ref = vif_ref; 
	endfunction 

	task build(); 
	begin 
		mbx_gd = new(); 
		mbx_dr = new(); 
		mbx_rs = new(); 
		mbx_ms = new(); 

		gen  = new(mbx_gd); 
		drv  = new(mbx_gd, mbx_dr, vif_drv ); 
		mon  = new(mbx_ms, vif_mon); 
		reff = new(mbx_dr, mbx_rs, vif_ref ); 
		scb  = new(mbx_rs, mbx_ms); 
	end 
	endtask 

	task start(); 
		fork 
			gen.start(); 
			drv.start(); 
			mon.start(); 
			scb.start(); 
			reff.start(); 
		join 
		scb.summary(); 
	endtask 

endclass 
