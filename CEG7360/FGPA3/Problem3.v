module Problem3(input clock, input reset, input increment, output wire [2:0] out);

	reg [4:0] count;
	
	initial
	begin
		count = 5'b00000;
	end

	always@(negedge reset or posedge increment) //async reset
	begin
		if(!reset)
			count = 5'b00000;
		else if(increment)
			count = count + 5'b00001;
		end
	
	Problem3ROM accessROM(.address(count), .clock(clock), .q(out));

endmodule