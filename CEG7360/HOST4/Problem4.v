/**************** Verilog Code **********************/
/* The circuit removes noises on the ready signal (or cleans up the
ready signal) by considering a signal change only after four
consistent readings. It uses a 4-bit shift register with the signal
shifted in every, say, two micro-seconds, or 500 KHz (= 50 MHz/100).
A slower shift register (at 50MHz/2,000) was found to work too. */
// The LED vector displays one byte of input data at a time.
// The CLK signal is to be connected to the 50 MHz on board clock.
module Problem4(input data, input ready, input reset, input CLK, output wire [2:0] LED);

reg [19:0] buff; // data buffer
reg [3:0] ready_samples;
reg ready_clean; // the "cleaned up" ready signal
integer temp = 0;
integer index = 0;
integer isEvenWord;

parityCounter myParityCounter(.buffer(buff), .numEven(LED));

initial
begin
	integer i;
	for(i=0; i<20; i=i+1) buff[i] = 0;
	for(i=0; i<4; i=i+1) ready_samples[i] = 0;
	ready_clean = 0;
end

always@(negedge reset or posedge CLK)
begin
	if(!reset) temp = 0;
	else
		begin
			temp = temp + 1;
			if(temp == 100) // 2,000 also worked
				begin
					ready_samples = {ready_samples[2:0], ready};
					temp = 0;
					if((ready_clean == 0) && (ready_samples == 4'b1111))
						ready_clean = 1;
					else if((ready_clean == 1) && (ready_samples == 4'b0000))
						ready_clean = 0;
				end
		end
end

always@(negedge reset or posedge ready_clean)
begin
	if(!reset) 
		buff = 20'b0;
	else 
		buff = {buff[18:0], data};
		index = index + 1;
end



endmodule


module parityCounter(input [19:0] buffer, output wire [2:0] numEven);
		
	 assign numEven = !(buffer[4]^buffer[3]^buffer[2]^buffer[1]^buffer[0])
							+!(buffer[9]^buffer[8]^buffer[7]^buffer[6]^buffer[5])
							+!(buffer[14]^buffer[13]^buffer[12]^buffer[11]^buffer[10])
							+!(buffer[19]^buffer[18]^buffer[17]^buffer[16]^buffer[15]);


endmodule