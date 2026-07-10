`include "../design/apb_master.sv" 
`include "apb_package.sv" 
`include "apb_interface.sv" 

module apb_top(); 

    import apb_package::*;  
    
	bit PCLK; 
    bit PRESETn; 
 
 	initial PCLK = 1'b0;
  	initial forever #5 PCLK = ~PCLK; // Period is 20ns --> Frequency is 50Mhz 
  
  	initial begin 
  	PRESETn = 0;
  	repeat(1) @(posedge PCLK);
    PRESETn = 1;
    //repeat(4) @(posedge PCLK);
    //repeat(40) @(posedge PCLK);
    //PRESETn = 1;
    //repeat(150) @(posedge PCLK);
    //PRESETn = 0;
    
    end 

	apb_inf inf(PCLK,PRESETn); 
	
	apb_master DUV_apb_master( 	.PCLK(PCLK), .PRESETn(PRESETn),
								.transfer(inf.transfer), .write_read(inf.write_read), .addr_in(inf.addr_in), .wdata_in(inf.wdata_in), .strb_in(inf.strb_in), 
								.rdata_out(inf.rdata_out), .transfer_done(inf.transfer_done), .error(inf.error), 
								.PADDR(inf.PADDR), .PSEL(inf.PSEL), .PENABLE(inf.PENABLE), .PWRITE(inf.PWRITE), .PWDATA(inf.PWDATA), .PSTRB(inf.PSTRB), 
								.PRDATA(inf.PRDATA), .PREADY(inf.PREADY), .PSLVERR(inf.PSLVERR)
							); 
						

	initial begin 
		apb_test test_1;
		test_1 = new(inf, inf); 
		test_1.run(); 
		$finish;
	end 
	
	initial begin 
		#80;
		$finish;
	end 

endmodule 
