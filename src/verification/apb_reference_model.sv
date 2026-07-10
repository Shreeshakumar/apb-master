class apb_reference_model;

	apb_transaction trans;
	mailbox#(apb_transaction)mbx_dr;
	mailbox#(apb_transaction)mbx_rs;
	virtual apb_inf.REFERENCE vif;

	function new(mailbox #(apb_transaction) mbx_dr, mailbox #(apb_transaction) mbx_rs, virtual apb_inf.REFERENCE vif );
    	this.mbx_dr = mbx_dr;
    	this.mbx_rs = mbx_rs;
    	this.vif 	= vif;
   	endfunction

	task start();
		repeat(4) @(vif.cb_reference);	
		for(int i=0; i<`num_of_trans; i++)
     	begin
      		trans = new();
      		mbx_dr.get(trans);
			if (vif.cb_reference.PRESETn == 0) 
      		begin
				@(vif.cb_reference);
				trans.PADDR 		= trans.addr_in;
				trans.PSEL 			= 0;
				trans.PENABLE 		= 0;
				trans.PWRITE 		= trans.write_read;
				trans.PWDATA 		= trans.wdata_in;
				trans.PSTRB 		= trans.strb_in;

				trans.rdata_out 	= trans.PRDATA;
				trans.transfer_done = 0;
				trans.error 		= 0;
			end
			else
			begin
				trans.PSEL 		= 0;			//IDLE
				trans.PENABLE 	= 0;
				
				if (trans.transfer)
				begin
					@(vif.cb_reference);		//SETUP
						trans.PSEL 		= 1;
						trans.PENABLE 	= 0;
						trans.PADDR		=trans.addr_in;
						trans.PWRITE	=trans.write_read;
						trans.PWDATA	=trans.wdata_in;
						trans.PSTRB		=trans.strb_in;
					
					@(vif.cb_reference);		//ACCESS
						trans.PSEL 		= 1;
						trans.PENABLE 	= 1;
						@(vif.cb_reference);

					wait(trans.PREADY);			//transfer_done
						trans.PSEL 		= 0;
						trans.PENABLE 	= 0;
						trans.rdata_out 	= trans.PRDATA;
						trans.transfer_done = 1;
						trans.error 		= trans.PSLVERR;
				end
			end
		end

		endtask
endclass

						
								
						
				
				
					

				
				
