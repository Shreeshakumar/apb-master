class apb_generator;
	
	apb_transaction trans;
	mailbox #(apb_transaction)mbx_gd;

	function new(mailbox #(apb_transaction)mbx_gd);
		this.mbx_gd = mbx_gd; 
		trans = new();
	endfunction

	task start();
		for(int i=0; i<`num_of_trans*2; i++ )
		begin
			assert(trans.randomize())
    			else $fatal("Randomization failed");
			mbx_gd.put(trans.copy());
			$display("\nGENERATOR randomized %0d \t\t\t\ttime =%0t",i,$time);$display("tula ",apb_transaction::second_send);
			$display("transfer=%0d, write_read=%0d, addr_in=%d, wdata_in=%0h, strb_in =%0d", trans.transfer, trans.write_read, trans.addr_in, trans.wdata_in, trans.strb_in );
			$display("PRDATA=%0h, PREADY=%0d, PSLVERR=%0d",trans.PRDATA, trans.PREADY, trans.PSLVERR);
		end
	endtask
endclass
