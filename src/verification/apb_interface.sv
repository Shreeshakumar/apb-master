interface apb_inf(input logic PCLK,PRESETn);
	
		//inputs from user to master
		logic 						transfer, write_read;
		logic [`ADDR_WIDTH-1:0]		addr_in;
		logic [`DATA_WIDTH-1:0]		wdata_in;
		logic [(`DATA_WIDTH/8)-1:0]	strb_in;
		
		//outputs to user from master
		logic [`DATA_WIDTH-1:0]		rdata_out;
		logic 						transfer_done, error;
	
		//outputs to slave from master
		logic [`ADDR_WIDTH-1:0]		PADDR;
		logic 						PSEL, PENABLE, PWRITE;
		logic [`DATA_WIDTH-1:0]		PWDATA;
		logic [(`DATA_WIDTH/8)-1:0]	PSTRB;
	
		//inputs from slave to master
		logic [`DATA_WIDTH-1:0]		PRDATA;
		logic 						PREADY, PSLVERR;

		clocking cb_driver@(posedge PCLK);
			default input #0 output #0;
			output transfer, write_read, addr_in, wdata_in, strb_in;
			input  rdata_out, transfer_done, error;
			
			input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB;
			output PRDATA, PREADY, PSLVERR;		
			
			input PRESETn;
						
		endclocking

		clocking cb_reference@(posedge PCLK);
			default input #0 output #0;
			//output transfer, write_read, addr_in, wdata_in, strb_in;
			//input  rdata_out, transfer_done, error;
			
			//input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB;
			//output PRDATA, PREADY, PSLVERR;
			
			input PRESETn;
				
		endclocking

		clocking cb_monitor@(posedge clk);
			default input #0 output #0;
			input transfer, write_read, addr_in, wdata_in, strb_in;
			input rdata_out, transfer_done, error;
			input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB;
			input PRDATA, PREADY, PLVERR;

			input PRESETn;
			
		endclocking

		modport DRIVER(clocking cb_driver);
		modport REFERENCE(clocking cb_reference);
		modport MONITOR(clocking cb_monitor);

endinterface
