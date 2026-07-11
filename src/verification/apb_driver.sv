class apb_driver;
	
	apb_transaction trans;
	mailbox#(apb_transaction)mbx_gd;
	virtual apb_inf.DRIVER vif;
	
	bit rst;

	function new( mailbox#(apb_transaction)mbx_gd, virtual apb_inf.DRIVER vif );
		this.mbx_gd = mbx_gd;
		this.vif = vif;
	endfunction

	task start();
		repeat(2) @(vif.cb_driver);
		for(int i =0; i<`num_of_trans; i++)
		begin
			repeat(2)
			begin
				mbx_gd.get(trans);
				@(vif.cb_driver);
				fork begin
					@(vif.cb_driver);
					$display("\n%m Driver ran at iteration %0d\t\ttime = %0t",i,$time);
				end join_none	
	
				rst = vif.cb_driver.PRESETn ;
					vif.cb_driver.transfer <= trans.transfer;
					vif.cb_driver.write_read <= trans.write_read;
					vif.cb_driver.addr_in<= trans.addr_in;
					vif.cb_driver.wdata_in <= trans.wdata_in;
					vif.cb_driver.strb_in <= trans.strb_in;	
					vif.cb_driver.PRDATA <= trans.PRDATA;	
					vif.cb_driver.PREADY <= trans.PREADY;	
					vif.cb_driver.PSLVERR <= trans.PSLVERR;
			end
			wait(apb_transaction::send);
		end
	endtask

endclass
