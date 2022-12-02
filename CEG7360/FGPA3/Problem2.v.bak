module Problem2(input enable, input reset, input clock, output reg[2:0] count);

initial
begin
	count = 3'b111;
end

always@(negedge reset or posedge clock) //async reset
begin
	if(!reset)
		count = 3'b111;
	else if(enable && clock)
		count = count - 3'b001;
	end
endmodule