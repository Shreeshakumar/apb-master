class apb_scoreboard;
	
	apb_transaction trans;
	mailbox #(apb_transaction)mbx_ms;

	int match, miss;
	
	function new(mailbox #(apb_transaction)mbx_ms);
		this.mbx_ms = mbx_ms;
	endfunction

	task start();
		do begin
			//trans = new();
			fork
			begin
				mbx_ms.get(trans);
				miss ++;
				$display("%m SCB REFERENCE \t%d \t\t\ttime = %0t",miss,$time);
				//$display("PADDR=%0d \nPSEL=%0d",trans_ref.PADDR,trans_ref.PSEL); 
				//$display("PENABLE=%0d \nPWRITE=%0d",trans_ref.PENABLE,trans_ref.PWRITE); 
				//$display("PWDATA=%0h \nPSTRB=%0d",trans_ref.PWDATA,trans_ref.PSTRB); 
				//$display("rdata_out=%0h \ntransfer_done=%0d \nerror=%d",trans_ref.rdata_out,trans_ref.transfer_done,trans_ref.error); 
			end
			begin
				//	mbx_ms.get(trans_mon);
				apb_transaction::count = apb_transaction::count +1;
				$display("********************************************************************************    apb_transaction::count = %d",apb_transaction::count);
				if(apb_transaction::count %4 == 0) apb_transaction::send = !apb_transaction::send;
			end
			join
			//compare();
		end while (apb_transaction::count != `num_of_trans);
	endtask
/*
	task compare();
     	if(	(trans_ref.PADDR	== trans_mon.PADDR)		&&	(trans_ref.PSEL				== trans_mon.PSEL)			&&
    		(trans_ref.PENABLE	== trans_mon.PENABLE)	&&	(trans_ref.PWRITE   		== trans_mon.PWRITE)  		&&
    		(trans_ref.PWDATA   == trans_mon.PWDATA)    &&	(trans_ref.PSTRB   			== trans_mon.PSTRB)    		&&
    		(trans_ref.rdata_out == trans_mon.rdata_out)  &&	(trans_ref.transfer_done 	== trans_mon.transfer_done) &&
    		(trans_ref.error    == trans_mon.error)
			)
        begin
    		match++;
            $display("***********************************************************************************************************************       DATA MATCH SUCCESSFUL MATCH=%d",match);
        end
		else
        begin
        	miss++;
            $display("***********************************************************************************************************************       DATA MATCH FAILED MISMATCH=%d",miss);
        end
	endtask*/
	
	task summary();
        begin
            $display("*************************************************************************************************************************************");
            $display("****************     TOTAL MATCH = %0d        ***************************************    TOTAL MISMATCH = %0d    ***********************",match,miss);
            $display("*************************************************************************************************************************************");
        end
	endtask

endclass

