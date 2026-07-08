class apb_test; 
  	virtual apb_inf vif_driver; 
  	virtual apb_inf vif_monitor; 
  	virtual apb_inf vif_reference; 

  	apb_environment env; 
	
  	function new(virtual apb_inf vif_driver, virtual apb_inf vif_monitor, virtual apb_inf vif_reference ); 
    	this.vif_driver = vif_driver; 
    	this.vif_monitor = vif_monitor; 
    	this.vif_reference = vif_reference; 
  	endfunction 

  	task run(); 
     	env = new(vif_driver, vif_monitor, vif_reference ); 
     	env.build; 
     	env.start; 
  	endtask 

endclass 
