class apb_driver;
	
	apb_transaction trans;
	mailbox#(apb_transaction)mbx_gd;
	mailbox#(apb_transaction)mbx_dr;
	virtual apb_inf.DRIVER vif;

	function new( mailbox#(apb_transaction)mbx_gd, mailbox#(apb_transaction)mbx_dr, virtual apb_inf.DRIVER vif );
		this.mbx_gd = mbx_gd;
		this.mbx_dr = mbx_dr;
		this.vif = vif;
	endfunction

	function start();
		repeat(4) @(vif.cb_driver);
		for(int i =0; i<`num_of_trans; i++)
		begin
			$display("%m Driver ran at iteration %0d",i);
			$display("STARTING DRIVER TRASANCTION");
			trans = new();
			mbx_gd.get(trans);
			if(vif.cb_driver.PRESETn == 0)
			begin
				transfer <= 0;
				mbx_dr.put(trans);
				@(vif.cb_driver);
			end
			else if (vif.cb_driver.PRESETn == 1)
			begin
				vif.cb_driver.transfer <= trans.transfer;
				vif.cb_driver.write_read <= trans.write_read;
				vif.cb_driver.addr_in<= trans.addr_in;
				vif.cb_driver.wdata_in <= trans.wdata_in;
				vif.cb_driver.strb_in <= trans.strb_in;
				vif.cb_driver.PRDATA <= trans.PRDATA;
				vif.cb_driver.PREADY <= trans.PREADY;
				vif.cb_driver.PSLVERR <= trans.PSLVERR;
				mbx_dr.put(trans);
				@(vif.cb_driver);
			end
			$display("******** driver_sending **********");
			$display("transfer   = %0d",trans.transfer);
			$display("write_read = %0d",trans.write_read);
			$display("addr_in    = %0d",trans.addr_in);
			$display("strb_in    = %0b",trans.strb_in);
			$display("PRDATA     = %0d",trans.PRDATA);
			$display("PREADY     = %0d",trans.PREADY);
			$display("PSLVERR    = %0d",trans.PSLVERR);
			$display("*********************************");
		end
	endfunction

endclass
