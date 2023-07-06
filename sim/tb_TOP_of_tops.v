`timescale 1ns / 1ps

module tb_TOP_of_tops;

  // Parameters
  localparam  BYTE    = 8;
  localparam  DWORD   = 32;
  localparam  ADDR    = 5;
  localparam  RB_ADDR = 5;
  localparam  NB_DATA = 8;
  localparam  NB_OP   = 6;
  localparam  NB_ST   = 10;

  reg [NB_DATA-1:0] memory [255:0]; 

  // Ports
  reg               i_clock       = 1'b0;
  reg               i_clock_reset = 1'b1;
  reg               i_reset       = 1'b1;
  reg               i_rx_done     = 1'b0;
  reg               i_tx_done     = 1'b0;
  reg [BYTE-1:0]    i_rx_data     = 8'b0;

  wire o_hlt;
  wire [NB_ST-1:0]  o_state;
  wire [BYTE-1:0]   o_tx_data;
  wire              o_tx_start;
  
  integer i;
  integer inst_counter;

  TOP_of_tops #(.BYTE(BYTE),
        .DWORD(DWORD),
        .ADDR(ADDR),
        .RB_ADDR(RB_ADDR))
  TOP_dut(.i_clock(i_clock),
          .i_reset(i_reset),
          .i_rx_done(i_rx_done),
          .i_tx_done(i_tx_done),
          .i_rx_data(i_rx_data),
          .i_clock_reset(i_clock_reset),
          .o_hlt(o_hlt),
          .o_state(o_state),
          .o_tx_data(o_tx_data),
          .o_tx_start(o_tx_start)); 


  initial begin
    inst_counter    = 0;
  
    i_clock         = 1'b0;
    i_reset         = 1'b1;
    i_clock_reset   = 1'b1;
    i_rx_data       = 8'd0;
    i_rx_done       = 1'b0;

    #100
    i_clock_reset   = 1'b0;

    #650
    i_reset         = 1'b0;
    
	// Se envia cmd para escribir Instruction Mem
    #405
    i_rx_data       = 8'd1; // Escribir IM
    i_rx_done       = 1'b1;

    #20
    i_rx_done       = 1'b0;
    $monitor("[$monitor] time=%0t o_state=%b ", $time, o_state);
//    $readmemb("C:/Users/alejo/OneDrive/Documents/GitHub/TP-Final-Arquitectura-2021/GUI/instructions.mem", memory, 0, 255);
    $readmemb("/home/jime/Documents/UNC/aquitectura_de_computadoras/TP-Final-Arquitectura-2021/GUI/instructions.mem", memory, 0, 255);

	// Se envia instruccion por instruccion, byte por byte
    for (i=0; i<40; i=i+1) begin
        #550000
        $display("instructions : ",inst_counter);
        inst_counter = inst_counter+1;
    	$display("valor: ", memory[i]);
		#20
		i_rx_data	= memory[i];
		i_rx_done	= 1'b1;

		#20
		i_rx_done	= 1'b0;
    end

    // #1000
    // $display("[time=%0t] Ejecucion continua", $time);
    // i_rx_data = 8'd2; // Ejecuion continua
    // i_rx_done = 1'b1;

    // #20
    // i_rx_done = 1'b0;

    #550000
    $display("Ejecución step by step. time = %0t", $time);
    i_rx_data = 3;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;

    #100000
    $display("Ejecución step  1. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #1000
    i_rx_done = 1'b0;

    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end  
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
   
    #100000
    $display("Ejecución step 2. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución  step 3. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;

    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end 
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 

    #100000
    $display("Ejecución step 4. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step by step 5. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;

    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 

    #100000
    $display("Ejecución step by step 6. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 7. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 8. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 9. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 10. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 11. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 12. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 13. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 14. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 15. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #100000
    $display("Ejecución step 16. time = %0t", $time);
    i_rx_data = 7;
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    // #2200000 // lectura de PC
    // #80000000 // lectura de BR 
    #1000
    for (i=0; i<260; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;
    end

    #4000
    $display("[time=%0t]  Lectura de bank register.", $time);
    i_rx_data = 8'd4; // Leer bank register
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;

    for (i=0; i<128; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;

    end

    #4000
    $display("[time=%0t]  Lectura de DM.", $time);
    i_rx_data = 8'd5; // Leer data memory
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;
    #40
    for (i=0; i<128; i=i+1) begin
    
      #80
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;

    end

    #4000
    $display("[time=%0t]  Lectura de PC.", $time);
    i_rx_data = 8'd6; // Leer PC
    i_rx_done = 1'b1;

    #20
    i_rx_done = 1'b0;

    for (i=0; i<4; i=i+1) begin
    
      #20
      i_tx_done	= 1'b1;

      #20
      i_tx_done	= 1'b0;

    end


	  // Se envia cmd start para ejecucion continua
    #100

    $finish;
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
