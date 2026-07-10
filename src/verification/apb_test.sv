class apb_test; 
  	virtual apb_inf.DRIVER drv; 
  	virtual apb_inf.MONITOR mon;

  	apb_environment env; 
	
  	function new(virtual apb_inf.DRIVER drv, virtual apb_inf.MONITOR mon ); 
    	this.drv = drv; 
    	this.mon = mon;
  	endfunction 

  	task run(); 
     	env = new(drv, mon ); 
     	env.build; 
     	env.start; 
  	endtask 

endclass 
