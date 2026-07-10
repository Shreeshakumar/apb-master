class apb_driver;
	
	apb_transaction trans;
	mailbox#(apb_transaction)mbx_gd;
	virtual apb_inf.DRIVER vif;
	
	bit rst;

	function new( mailbox#(apb_transaction)mbx_gd, virtual apb_inf.DRIVER vif );
		this.mbx_gd = mbx_gd;
		this.vif = vif;
	endfunction

	task start();
		repeat(2) @(vif.cb_driver);
		for(int i =0; i<`num_of_trans; i++)
		begin
			mbx_gd.get(trans);
			@(vif.cb_driver);
			fork
			begin
				@(vif.cb_driver);
				$display("\n%m Driver ran at iteration %0d\t\ttime = %0t",i,$time);
				$display("STARTING DRIVER TRASANCTION");
			end
			join_none

			rst = vif.cb_driver.PRESETn ;
				vif.cb_driver.transfer <= trans.transfer;
				vif.cb_driver.write_read <= trans.write_read;
				vif.cb_driver.addr_in<= trans.addr_in;
				vif.cb_driver.wdata_in <= trans.wdata_in;
				vif.cb_driver.strb_in <= trans.strb_in;
				vif.cb_driver.PRDATA <= trans.PRDATA;
				vif.cb_driver.PREADY <= trans.PREADY;
				vif.cb_driver.PSLVERR <= trans.PSLVERR;
			
				/*$display("********************************************************************************************************************************");
				$display("******** driver_sending time= %0t **********",$time);
				if(!rst) begin repeat(8) $write("\tRESET"); $display(); end/*
				$display("transfer   = %0d",trans.transfer);
				$display("write_read = %0d",trans.write_read);
				$display("addr_in    = 'h%0h",trans.addr_in);
				$display("wdata_in   = 'h%0h",trans.wdata_in);
				$display("strb_in    = 'h%0h",trans.strb_in);
				$display("PRDATA     = 'h%0h",trans.PRDATA);
				$display("PREADY     = %0d",trans.PREADY);
				$display("PSLVERR    = %0d",trans.PSLVERR);
				$display("*********************************");*/
				
			mbx_gd.get(trans);
			@(vif.cb_driver);@(vif.cb_driver);
			fork
			begin
				@(vif.cb_driver);
				$display("\n%m Driver ran at iteration %0d\t\ttime = %0t",i,$time);
				$display("STARTING DRIVER TRASANCTION");
			end
			join_none

			rst = vif.cb_driver.PRESETn ;
				vif.cb_driver.transfer <= trans.transfer;
				vif.cb_driver.write_read <= trans.write_read;
				vif.cb_driver.addr_in<= trans.addr_in;
				vif.cb_driver.wdata_in <= trans.wdata_in;
				vif.cb_driver.strb_in <= trans.strb_in;
				vif.cb_driver.PRDATA <= trans.PRDATA;
				vif.cb_driver.PREADY <= trans.PREADY;
				vif.cb_driver.PSLVERR <= trans.PSLVERR;
			wait(apb_transaction::send);
		end
	endtask

endclass
