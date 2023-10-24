////////////////////////////////////////
/////		 Test Macros 	       /////
////////////////////////////////////////
`timescale 1ns/1ps
`define delay   10
`define CLK_PER 100
parameter Data_Width = 256;


class sequencer;

  rand bit [Data_Width - 1:0] rand_A, rand_b, rand_c, rand_d;					// 4 random variables 
  constraint value_A {rand_A inside {[256'd1:256'd96]};}							// take a value from 1 to 96
  constraint value_b {rand_b inside {[256'd1:256'd96]};}							// take a value from 1 to 96
  constraint value_c {rand_c inside {[256'd1:256'd180]};}							// take a value from 1 to 180
  constraint value_d {rand_d inside {[256'd1:256'd180]};}							// take a value from 1 to 180
  
endclass //sequencer


module SSMM_tb ;

logic                      tb_clk	;     
logic                      tb_rst_n  ;
logic                      tb_load	; 
logic [Data_Width - 1 : 0] tb_a      ;    	 
logic [Data_Width - 1 : 0] tb_b      ;	 
logic [Data_Width - 1 : 0] tb_m	    ;
logic                      tb_ready  ; 
logic                      tb_busy   ;	 
logic [Data_Width - 1 : 0] tb_p      ; 



// Sequencer Class Instance
sequencer seq;


// DUT Instantiation
shift_sub_mod_mul #(

            .Data_Width(Data_Width)
            
        ) DUT (

            .i_clk	 (tb_clk  ), 
            .i_rst_n (tb_rst_n),
            .i_load	 (tb_load ), 
            .i_a	 (tb_a    ),
            .i_b	 (tb_b    ),
            .i_m	 (tb_m	  ),
            .o_ready (tb_ready), 
            .o_busy	 (tb_busy ),
            .o_p     (tb_p    )

        );


///////////////////////////////////////////////////////
////////	Dump Changes into the .VCD File	   ////////
///////////////////////////////////////////////////////
	initial 
	begin

	  $dumpfile("SSMMdump.vcd");
	  $dumpvars;

	  #500000

	  $finish;

	end


///////////////////////////////////////////////
////////	Clock Generation Block	   ////////
///////////////////////////////////////////////
always #(`CLK_PER/2) tb_clk = ~tb_clk;




///////////////////////////////////////////////////////
////////		Applying Test Stimulus 	   		///////
///////////////////////////////////////////////////////
initial 
begin

  tb_m    = 256'd97;															// Set the Prime Number to decimal = 97
  tb_clk  = 1'b1;  																// initialize tb_clk
  
  		// Reset the System
	#10	tb_rst_n = 0;
	#10 tb_rst_n = 1;
  // Sequencer Class Handle
  seq = new();

    repeat(30) 
	begin


		tb_load = 1'b0;

		// Randomize the integer values using randomization
        seq.randomize();
        #1000 tb_a = seq.rand_A;
             tb_b = seq.rand_b;
   
   
	
		// De-assert the reset signal 
		@(posedge tb_clk)  #`delay;
        tb_load = 1'b1;
		
        #`CLK_PER tb_load = 1'b0;

        
        
        #900 $display("i_a = %d\ni_b = %d\ni_m = %d\no_P = %d",tb_a,tb_b,tb_m,tb_p);
		     $display("\n *********************************************************** \n");

    end


    #10000 tb_m    = 256'd181;
    
    repeat(30) 
	begin

		// Randomize the integer values using randomization
        seq.randomize();
        #2000 tb_a = seq.rand_c;
             tb_b = seq.rand_d;
   
   
	
		// De-assert the reset signal 
		@(posedge tb_clk)  #`delay;
        tb_load = 1'b1;
		
        #`CLK_PER tb_load = 1'b0;

        
        
        #1500 $display("i_a = %d\ni_b = %d\ni_m = %d\no_P = %d",tb_a,tb_b,tb_m,tb_p);
		     $display("\n *********************************************************** \n");

    end

$finish;

end

endmodule
