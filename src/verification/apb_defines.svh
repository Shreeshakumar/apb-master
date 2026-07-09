`define ADDR_WIDTH 5
`define DATA_WIDTH 8

`define no_of_trans 10

function int log2(input num);
begin
	log2 = 0;
	while(int i = 0; 2**log2<num; i++)
		begin
			log2 = log2 + 1;
		end
	return log2;
end
endfunction
			
