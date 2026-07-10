class apb_scoreboard;
	
	apb_transaction trans_ref, trans_mon;
	mailbox #(apb_transaction)mbx_rs;
	mailbox #(apb_transaction)mbx_ms;

	int match, miss;
	
	function new(mailbox #(apb_transaction)mbx_rs, mailbox #(apb_transaction)mbx_ms);
		this.mbx_rs = mbx_rs;
		this.mbx_ms = mbx_ms;
	endfunction

	task start();
	for(int i=0; i<`num_of_trans; i++)
		begin
			trans_ref = new();
			trans_mon = new();
			fork
			begin
				mbx_rs.get(trans_ref);
				$display("%m SCB REFERENCE");
				$display("PADDR=%0d \t\t PSEL=%0d",trans_ref.PADDR,trans_ref.PSEL,$time); 
				$display("PENABLE=%0d \t\t PWRITE=%0d",trans_ref.PENABLE,trans_ref.PWRITE,$time); 
				$display("PWDATA=%0d \t\t PSTRB=%0d",trans_ref.PWDATA,trans_ref.PSTRB,$time); 
				$display("rdata_out=%0d \t\t transfer_done=%0d \t\t error=%d",trans_ref.rdata_out,trans_ref.transfer_done,trans_ref.error,$time); 
			end
			begin
				mbx_ms.get(trans_mon);
			end
			join
			compare();
		end
	endtask

	task compare();
     	if(	(trans_ref.PADDR	== trans_mon.PADDR)		&&	(trans_ref.PSEL				== trans_mon.PSEL)			&&
    		(trans_ref.PENABLE	== trans_mon.PENABLE)	&&	(trans_ref.PWRITE   		== trans_mon.PWRITE)  		&&
    		(trans_ref.PWDATA   == trans_mon.PWDATA)    &&	(trans_ref.PSTRB   			== trans_mon.PSTRB)    		&&
    		(trans_ref.rdata_out == trans_mon.rdata_out)  &&	(trans_ref.transfer_done 	== trans_mon.transfer_done) &&
    		(trans_ref.error    == trans_mon.error)
			)
        begin
    		match++;
            $display("*********************************************************************************       DATA MATCH SUCCESSFUL MATCH=%d",match);
        end
		else
        begin
        	miss++;
            $display("*********************************************************************************       DATA MATCH FAILED MISMATCH=%d",miss);
        end
	endtask
	
	task summary();
        begin
            $display("*************************************************************************************************************************************");
            $display("****************     TOTAL MATCH = %0d        ***************************************    TOTAL MISMATCH = %0d    ***********************",match,miss);
            $display("*************************************************************************************************************************************");
        end
	endtask

endclass

