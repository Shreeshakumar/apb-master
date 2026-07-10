`include "../design/apb_master.v" 
`include "apb_package.sv" 
`include "apb_interface.sv" 

module apb_top(); 

    import apb_package::*;  
    
	logic PCLK; 
    logic PRESETn; 
 
 	initial PCLK = 1'b0;
  	initial forever #10 PCLK = ~PCLK; // Period is 20ns --> Frequency is 50Mhz 
  
  	initial begin 
  	//repeat(2) @(posedge PCLK);
    PRESETn = 1;
    repeat(4) @(posedge PCLK);
    //repeat(40) @(posedge PCLK);
    PRESETn = 1;
    //repeat(150) @(posedge PCLK);
    //PRESETn = 0;
    
    end 

	apb_inf intrf(PCLK,PRESETn); 
	
	apb_master DUV_apb_master( 	.transfer(intrf.transfer), .write_read(intrf.write_read), .addr_in(intrf.addr_in), .wdata_in(intrf.wdata_in), .strb_in(intrf.strb_in), 
								.rdata_out(intrf.rdata_out), .transfer_done(intrf.transfer_done), .error(intrf.error), 
								.PADDR(intrf.PADDR), .PSEL(intrf.PSEL), .PENABLE(intrf.PENABLE), .PWRITE(intrf.PWRITE), .PWDATA(intrf.PWDATA), .PSTRB(intrf.PSTRB), 
								.PRDATA(intrf.PRDATA), .PREADY(intrf.PREADY), .PSLVERR(intrf.PSLVERR)
							); 

	initial begin 
		apb_test test_1;
		test_1 = new(intrf.DRIVER, intrf.MONITOR, intrf.REFERENCE ); 
		test_1.run(); 
		$finish;
	end 

endmodule 
