class apb_monitor;

	apb_transaction trans;
	mailbox#(apb_transaction)mbx_ms;
	virtual apb_inf.MONITOR vif;

	function new(mailbox #(apb_transaction)mbx_ms, virtual apb_inf.MONITOR vif);
		this.mbx_ms = mbx_ms;
		this.vif = vif;	
	endfunction

	task start();
		repeat(3) @(vif.cb_monitor);
		do begin
			trans = new();
			trans.transfer    = vif.cb_monitor.transfer;
			trans.write_read  = vif.cb_monitor.write_read;
			trans.addr_in     = vif.cb_monitor.addr_in;
			trans.wdata_in    = vif.cb_monitor.wdata_in;
			trans.strb_in     = vif.cb_monitor.strb_in;

			trans.PADDR = vif.cb_monitor.PADDR; 
			trans.PSEL = vif.cb_monitor.PSEL;
			trans.PENABLE = vif.cb_monitor.PENABLE;
			trans.PWRITE = vif.cb_monitor.PWRITE;
			trans.PWDATA = vif.cb_monitor.PWDATA;
			trans.PSTRB = vif.cb_monitor.PSTRB;
			
			trans.PRDATA   = vif.cb_monitor.PRDATA;
			trans.PREADY   = vif.cb_monitor.PREADY;
			trans.PSLVERR  = vif.cb_monitor.PSLVERR;
	
			trans.rdata_out = vif.cb_monitor.rdata_out;
			trans.transfer_done = vif.cb_monitor.transfer_done;
			trans.error = vif.cb_monitor.error;

			$display("\n%m MONITOR\t\t\t\t\ttime =%0t",$time);
			$display("***** INPUTS*****\ntransfer      = %0d",trans.transfer);
			$display("write_read    = %0d",trans.write_read);
			$display("addr_in       = 'h%0h",trans.addr_in);
			$display("wdata_in      = 'h%0h",trans.wdata_in);
			$display("strb_in       = 'h%0h",trans.strb_in);
			$display("PRDATA        = 'h%0h",trans.PRDATA);
			$display("PREADY        = %0d",trans.PREADY);
			$display("PSLVERR       = %0d \n",trans.PSLVERR);
			$display("****** OUTPUTS ******\nPADDR         = 'h%0h \nPSEL          = %0d",trans.PADDR,trans.PSEL); 
			$display("PENABLE       = %0d \nPWRITE        = %0d",trans.PENABLE,trans.PWRITE); 
			$display("PWDATA        = 'h%0h \nPSTRB         = 'h%0h",trans.PWDATA,trans.PSTRB); 
			$display("rdata_out     = 'h%0h \ntransfer_done = %0d \nerror         = %d",trans.rdata_out,trans.transfer_done,trans.error); 
			mbx_ms.put(trans);
			@(vif.cb_monitor);
   		end while (apb_transaction::count <= (`num_of_trans*4)+2);
   		$finish;
	endtask
	
endclass
