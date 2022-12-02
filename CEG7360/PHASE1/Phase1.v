module Phase1(input arduino, input pushButton, output wire a_out, output LED);

assign LED = arduino;
assign a_out = (arduino&pushButton);

endmodule