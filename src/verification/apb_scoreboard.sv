class apb_scoreboard;
	
	apb_transaction trans, tt;
	mailbox #(apb_transaction)mbx_ms;

	int match, miss;
	int comp, cnt;
	
	function new(mailbox #(apb_transaction)mbx_ms);
		this.mbx_ms = mbx_ms;
	endfunction

	task start();
		do begin
			tt = new();
			trans = new();
			mbx_ms.get(tt);
			trans = tt;
			$display("%m SCOREBOARD \t%d \t\t\ttime = %0t",miss,$time);
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
			
			
			
			//$display("********************************************************    apb_transaction::count =%d\t%d",apb_transaction::count,apb_transaction::send);
			cnt++;
			apb_transaction::count = apb_transaction::count +1;
			$display("tual %d %d",tt.transfer_done,cnt);
			if(tt.PREADY) tt.send = !tt.send;
			if(tt.transfer_done) cnt = 0;
			compare();
		end while (apb_transaction::count <= (`num_of_trans*2 )+2);
	endtask



	task compare();
		comp = 1;
		if(tt.transfer && cnt == 0)
     	if(!(!tt.PADDR && !tt.PSEL && !tt.PENABLE && !tt.PWRITE && !tt.PWDATA && !tt.PSTRB && !tt.rdata_out && !tt.transfer_done && !tt.error))
     		begin comp = 0; $display("cnt o error"); end
     	
     	if(tt.transfer && cnt == 1 && tt.write_read)
     	if(!(tt.PADDR && tt.PSEL && !tt.PENABLE && !tt.PWRITE && !tt.PWDATA && !tt.PSTRB && !tt.rdata_out && !tt.transfer_done && !tt.error))
     		begin comp = 0; $display("cnt 1 error"); end
     		
     	if(tt.transfer && cnt == 1 && tt.write_read && tt.PREADY)
     	if(!(!tt.PADDR==tt.addr_in && tt.PSEL && tt.PENABLE && tt.PWRITE && tt.PWDATA==tt.wdata_in && tt.PSTRB==tt.strb_in && !tt.rdata_out && !tt.transfer_done && !tt.error))
     		begin comp = 0; $display("cnt 1 and PREADY error"); end
     		
     	if (comp) 	begin	match++	;
     	$display("***************************************************************************************************       DATA MATCH SUCCESSFUL MATCH=%d",match);
     	end
     	else 	begin	miss++;
     	$display("***************************************************************************************************       DATA MATCH SUCCESSFUL MISSMATCH=%d",miss);
     	end	
   
	endtask
	
	task summary();
        begin
            $display("**********************************************************************************************************************************");
            $display("****************     TOTAL MATCH = %0d        *******************************    TOTAL MISMATCH = %0d    ***********************",match,miss);
            $display("**********************************************************************************************************************************");
        end
	endtask

endclass

