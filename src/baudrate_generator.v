module baudrate_generator 
    #(parameter NB_COUNT = 8,
      parameter N_TICKS  = 163) //preguntar 
    (input wire i_clock,
     input wire i_reset,
     output wire o_br_clock);

reg [NB_COUNT - 1:0] counter;

always @(posedge i_clock) begin
    if(i_reset)begin
        counter <= {NB_COUNT{1'b0}};
    end
    if(counter < N_TICKS)
        counter <= counter + 1;
    else
        counter <= {NB_COUNT{1'b0}};
end


assign o_br_clock = (counter==N_TICKS)? 1'b1 : 1'b0;
    
endmodule

// 19200 baudrate (bits/segundo)
// 16 ticks por baudio
// clock 50 MHz
// s_tick cada 19200*16 = 307200 ticks por segundo
// 