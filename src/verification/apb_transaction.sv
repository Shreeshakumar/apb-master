class apb_transaction;
	
	//inputs from user to master
	rand bit 						transfer, write_read;
	rand bit [`ADDR_WIDTH-1:0]		addr_in;
	rand bit [`DATA_WIDTH-1:0]		wdata_in;
	rand bit [(`DATA_WIDTH/8)-1:0]	strb_in;
	bit 						prev_transfer, prev_write_read;
	bit [`ADDR_WIDTH-1:0]		prev_addr_in;
	bit [`DATA_WIDTH-1:0]		prev_wdata_in;
	bit [(`DATA_WIDTH/8)-1:0]	prev_strb_in;
	
	
	//outputs to user from master
	bit [`DATA_WIDTH-1:0]			rdata_out;
	bit 							transfer_done, error;

	//outputs to slave from master
	bit [`ADDR_WIDTH-1:0]			PADDR;
	bit 							PSEL, PENABLE, PWRITE;
	bit [`DATA_WIDTH-1:0]			PWDATA;
	bit [(`DATA_WIDTH/8)-1:0]		PSTRB;

	//inputs from slave to master
	rand bit [`DATA_WIDTH-1:0]		PRDATA;
	rand bit 						PREADY, PSLVERR;
	//bit [`DATA_WIDTH-1:0]		prev_PRDATA;
	//bit 						prev_PREADY, prev_PSLVERR;
	
	static bit send;
	static int count;
	
	static bit second_send = 1;
	
	constraint c1 {	//transfer ==1;
					write_read == 1;
					//PSLVERR == 0;
					strb_in == 0;
					//PREADY == 1;
					}
					
	constraint c2 { second_send  ->   	PREADY == 0;
					!second_send -> 	(transfer == prev_transfer &&
										addr_in == prev_addr_in  &&
										wdata_in == prev_wdata_in); 
					
					!second_send && PREADY dist {0:/15, 1:/85};
									
						PSLVERR == 0;	
					}
	
	//constraint wr_rd_value {{write_enb,read_enb} inside {[0:3]};	}
	//constraint wr_rd_ve { data_in != 0;	 						}
	//constraint wr_rd_not_equal {{write_enb,read_enb} != 2'b11;	}

	virtual function apb_transaction copy();
		copy = new();
		copy.transfer 	= this.transfer;
		copy.write_read = this.write_read;
		copy.addr_in 	= this.addr_in;
		copy.wdata_in 	= this.wdata_in;
		copy.strb_in 	= this.strb_in;
		
		copy.PRDATA 	= this.PRDATA;
		copy.PREADY 	= this.PREADY;
		copy.PSLVERR 	= this.PSLVERR;
		return copy;
	endfunction
	
	function void post_randomize();
		second_send = !second_send;
		prev_transfer = transfer;
		prev_write_read = write_read;
		prev_addr_in = addr_in;
		prev_wdata_in = wdata_in;
		prev_strb_in = strb_in;
	endfunction

endclass
