class apb_scoreboard;
	
	apb_transaction tt;
	mailbox #(apb_transaction)mbx_ms;

	static int match, miss;
	int comp, cnt;
	
	function new(mailbox #(apb_transaction)mbx_ms);
		this.mbx_ms = mbx_ms;
	endfunction

	task start();
		do begin
			tt = new();
			mbx_ms.get(tt);	cnt++;
			
			$display("%m SCOREBOARD  \t\t\t\ttime = %0t",$time);
			$display("ERROR WARNING ERROR WARNING ERROR WARNING transfer_done=%0d   trans_cnt=%0d    cnt=%0d",tt.transfer_done,apb_transaction::count,cnt);
			
			if(tt.PREADY) tt.send = !tt.send;
			compare();
			
			if (cnt ==4)cnt = 1;
			if (!tt.transfer) cnt =0;
			if(tt.transfer && cnt == 3 && tt.write_read && tt.PREADY) cnt =1
		end while (apb_transaction::count <= (`num_of_trans*3)+3);
	endtask

	task compare();
		comp = 1;
		if(tt.transfer && cnt == 1)	if(!(!tt.PSEL && !tt.PENABLE))	begin comp = 0; $display("cnt 1 error"); end
     	
     	if(tt.transfer && cnt == 2 && tt.write_read)	if(!(tt.PSEL && !tt.PENABLE))	begin comp = 0; $display("cnt 2 error"); end
     		
     	if(tt.transfer && cnt == 3 && tt.write_read && tt.PREADY)
     	if(!(tt.PADDR==tt.addr_in && tt.PSEL && tt.PENABLE && tt.PWRITE && tt.PWDATA==tt.wdata_in && tt.PSTRB==tt.strb_in && tt.rdata_out==tt.PRDATA && !tt.transfer_done && tt.error==tt.PSLVERR))
     		begin comp = 0; $display("cnt 3 and PREADY error"); end
     		
     	if(tt.transfer && cnt ==4)
		if(!tt.transfer_done)   
			begin comp = 0; $display("cnt 4 and PREADY error"); end   	
     		
     	if (comp) 	begin	match++	;
     	$display("***************************************************************************************************       DATA COMPARE SUCCESSFUL MATCH=%d",match);
     	end
     	else 	begin	miss++;
     	$display("***************************************************************************************************       DATA COMPARE SUCCESSFUL MISSMATCH=%d",miss);
     	end	
   
	endtask
	
	task summary();
        begin
        	wait(apb_transaction::summary);
            $display("**********************************************************************************************************************************");
            $display("****************     TOTAL MATCH = %0d        *******************************    TOTAL MISMATCH = %0d    ***********************",match,miss);
            $display("**********************************************************************************************************************************");
        end
	endtask

endclass

