class apb_scoreboard;
	
	apb_transaction tt;
	mailbox #(apb_transaction)mbx_ms;

	int match, miss;
	int comp, cnt;
	
	function new(mailbox #(apb_transaction)mbx_ms);
		this.mbx_ms = mbx_ms;
	endfunction

	task start();
		do begin
			tt = new();
			mbx_ms.get(tt);
			miss ++;
			$display("%m SCB REFERENCE \t%d \t\t\ttime = %0t",miss,$time);
			//compare();
			//$display("********************************************************    apb_transaction::count =%d\t%d",apb_transaction::count,apb_transaction::send);
			cnt++;
			apb_transaction::count = apb_transaction::count +1;
			$display("tual %d",tt.transfer_done);
			if(tt.PREADY) tt.send = !tt.send;
			if(tt.transfer_done) cnt = 0;
			compare();
		end while (apb_transaction::count <= `num_of_trans*2);
	endtask



	task compare();
		comp = 1;
		if(tt.transfer && cnt == 0)
     	if(!(!tt.PADDR && !tt.PSEL && !tt.PENABLE && !tt.PWRITE && !tt.PWDATA && !tt.PSTRB && !tt.rdata_out && !tt.transfer_done && !tt.error))
     		comp = 0;
     	
     	if(tt.transfer && cnt == 1 && tt.write_read)
     	if(!(tt.PADDR && tt.PSEL && !tt.PENABLE && !tt.PWRITE && !tt.PWDATA && !tt.PSTRB && !tt.rdata_out && !tt.transfer_done && !tt.error))
     		comp = 0;
     		
     	if(tt.transfer && cnt == 1 && tt.write_read && tt.PREADY)
     	if(!(!tt.PADDR==tt.addr_in && tt.PSEL && tt.PENABLE && tt.PWRITE && tt.PWDATA==tt.wdata_in && tt.PSTRB==tt.strb_in && !tt.rdata_out && !tt.transfer_done && !tt.error))
     		comp = 0;
     		
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

