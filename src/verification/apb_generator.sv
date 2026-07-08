class apb_generator;
	
	apb_transaction trans;
	mailbox #(apb_transaction)mbx_gd;

	function new(mailbox #(apb_transaction)mbx_gd);
		this.mbx_gd = mbx_gd; 
		trans = new();
	endfunction

	task start();
		for(int i=0; i<`num_of_trans; i++ )
		begin
			trans.randomize();
			mbx_gd.put(trans.copy());
			$display("GENERATOR randomized",$time);
			$display("transfer=%0d, write_read=%0d, addr_in=%d, wdata_in=%0d, strb_in =%0d", trans.transfer, trans.write_read, trans.addr_in, trans.wdata_in, trans.strb_in ");
			$display("PRDATA=%0d, PREADY=%0d, PSLVERR=%0d",trans.PRDATA, trans.PREADY, trans.PSLVERR);
		end
	endtask
endclass
