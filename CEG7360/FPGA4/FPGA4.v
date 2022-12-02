module FPGA4( input reset, input clk,input increment, input hamm, output [2:0] D);

	wire [4:0] count;
	wire [4:0] counter;
	wire [4:0] counter2;
	reg [2:0] data = 3'b000;
	wire wren;
	
	counter c1(.reset(reset), .increment(increment), .count(counter));
	counter c2(.reset(reset), .increment(clk), .count(counter2));


	always@(negedge hamm or posedge clk)
	begin
		if(!hamm)
		begin
				data[2] = counter2[3]^counter2[2]^counter2[1];
				data[1] = counter2[3]^counter2[2]^counter2[0];
				data[0] = counter2[3]^counter2[1]^counter2[0];
		end
	end
	
assign count = hamm? counter: counter2;
assign wren = hamm? 1'b0: 1'b1;
Lab4FPGA myRAM (.address(count),.clock(clk), .q(D), .data(data), .wren(wren));
endmodule
