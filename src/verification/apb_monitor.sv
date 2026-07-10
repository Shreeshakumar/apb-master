class apb_monitor;

	apb_transaction trans;
	mailbox#(apb_transaction)mbx_ms;
	virtual apb_inf.MONITOR vif;

	function new(mailbox #(apb_transaction)mbx_ms, virtual apb_inf.MONITOR vif);
		this.mbx_ms = mbx_ms;
		this.vif = vif;	
	endfunction

	task start();
		repeat(5) @(vif.cb_monitor);
		for(int i=0; i<`num_of_trans; i++ )
		begin	
			trans = new();
			begin
				trans.PADDR = vif.cb_monitor.PADDR; 
				trans.PSEL = vif.cb_monitor.PSEL;
				trans.PENABLE = vif.cb_monitor.PENABLE;
				trans.PWRITE = vif.cb_monitor.PWRITE;
				trans.PWDATA = vif.cb_monitor.PWDATA;
				trans.PSTRB = vif.cb_monitor.PSTRB;
				
				trans.rdata_out = vif.cb_monitor.rdata_out;
				trans.transfer_done = vif.cb_monitor.transfer_done;
				trans.error = vif.cb_monitor.error;
			end
			$display("\n%m MONITOR\t\ttime =%0t",$time);
			$display("PADDR=%0d \t\t PSEL=%0d",trans.PADDR,trans.PSEL); 
			$display("PENABLE=%0d \t\t PWRITE=%0d",trans.PENABLE,trans.PWRITE); 
			$display("PWDATA=%0d \t\t PSTRB=%0d",trans.PWDATA,trans.PSTRB); 
			$display("rdata_out=%0d \t\t transfer_done=%0d \t\t error=%d",trans.rdata_out,trans.transfer_done,trans.error); 
			mbx_ms.put(trans);
			@(vif.cb_monitor);
   		end
	endtask
	
endclass
