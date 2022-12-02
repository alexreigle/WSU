module Problem3(input a, input clock, output reg a_not);

always@(posedge clock)
begin
	if(a > 1'b0)
		a_not = 1'b0;
	else
		a_not = 1'b1;
//	a_not = !a;
end

endmodule