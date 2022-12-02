module Problem1(input reset, input increment, output data);
	reg [3:0] count;
	
	initial
	begin
		count = 4'b0000;
	end

	always@(posedge reset or posedge increment) //async reset
	begin
		if(reset)
			count = 4'b0000;
		else if(increment)
			count = count + 4'b0001;
		end
	
		F myF(.a(count[3]), .b(count[2]), .c(count[1]), .d(count[0]), .OUT(data));
		
endmodule

module F(input a, input b, input c, input d, output OUT);
	assign OUT = (b|!d) ? ((a&d)|c) : (a&(!c));
endmodule