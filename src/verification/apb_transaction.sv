class apb_transaction;
	
	//inputs from user to master
	rand bit 						transfer, write_read;
	rand bit [`ADDR_WIDTH-1:0]		addr_in;
	rand bit [`DATA_WIDTH-1:0]		wdata_in;
	rand bit [(`DATA_WIDTH/8)-1:0]	strb_in;
	
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
	
	//constraint wr_rd_value {{write_enb,read_enb} inside {[0:3]};	}
	//constraint wr_rd_ve { data_in != 0;	}
	//constraint wr_rd_not_equal {{write_enb,read_enb} != 2'b11;		}

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

endclass
