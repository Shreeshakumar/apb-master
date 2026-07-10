class apb_monitor;

	apb_transaction trans;
	mailbox#(apb_transaction)mbx_ms;
	virtual apb_inf.MONITOR vif;

	function new(mailbox #(apb_transaction)mbx_ms, virtual apb_inf.MONITOR vif);
		this.mbx_ms = mbx_ms;
		this.vinf = vif;	
	endfunction

	task start();
		repeat(5) @(vinf.cb_monitor);
		for(int i=0; i<`num_of_trans; i++ )
		begin	
			trans = new();
			begin
				trans.PADDR = vinf.cb_monitor.data_out; 
				trans.PSEL = vinf.cb_monitor.address;
				trans.PENABLE = vinf.cb_monitor.address;
				trans.PWRITE = vinf.cb_monitor.address;
				trans.PWDATA = vinf.cb_monitor.address;
				trans.PSTRB = vinf.cb_monitor.address;
				
				trans.rdata_out = vinf.cb_monitor.address;
				trans.transfer_done = vinf.cb_monitor.address;
				trans.error = vinf.cb_monitor.address;
			end
			$display("%m MONITOR");
			$display("PADDR=%0d \t\t PSEL=%0d",trans.PADDR,trans.PSEL,$time); 
			$display("PENABLE=%0d \t\t PWRITE=%0d",trans.PENABLE,trans.PWRITE,$time); 
			$display("PWDATA=%0d \t\t PSTRB=%0d",trans.PWDATA,trans.PSTRB,$time); 
			$display("rdata_out=%0d \t\t transfer_done=%0d \t\t error=%d",trans.rdata_out,trans.transfer_done,trans.error,$time); 
			mbx_ms.put(trans);
			@(vif.cb_monitor);
   		end
	endtask
	
endclass
