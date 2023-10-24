`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Mahmoud Magdi
// 
// Create Date:     10/24/2023 10:24:04 PM
// Design Name:     Modular Multiplier
// Module Name:     shift_sub_mod_mul
// Project Name:    
// Target Devices: 
// Tool Versions: 
// Description:     This design performs the modular multiplicatio 
//                  operation using Shift-Sub Modular Multiplicatio Algorithm 
//                  Inputs: A, B, and m 
//                  Ouput : P = A*B mod(m)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module shift_sub_mod_mul #(

	parameter Data_Width = 256
	
)(

////////////////////////
//       Inputs       //
////////////////////////
  
	input  logic 				  	          i_clk		,                   // System Clock Signal 
	input  logic 				  	          i_rst_n	,                   // System Asynchronous active-low reset siganl 
	input  logic 				  	          i_load	,                   // Load signals that samples the input data into the internal signals 
  input  logic [Data_Width - 1 : 0] i_a		  ,                   // Input Operand A  -->  should be < m
  input  logic [Data_Width - 1 : 0] i_b		  ,                   // Input Operand B  -->  Should be < m
  input  logic [Data_Width - 1 : 0] i_m		  ,                   // Input Operand M  -->  where m is an odd number && m < 2^(n) 

  
////////////////////////
//       Outpus       //
////////////////////////
	output logic 				  	          o_ready	,                   // Ouptut ready Signal 
	output logic  				  	        o_busy	,                   // Output Busy Signal
  output logic [Data_Width - 1 : 0] o_p                         // Ouptut result --> o_p = i_a * i_b mod(m)

);


logic [Data_Width + 1 : 0] a_reg	 ;									// Internal Register for stroing the input a
logic [Data_Width - 1 : 0] b_reg	 ;									// Internal Register for stroing the input b
logic [Data_Width + 1 : 0] m_reg	 ;									// Internal Register for stroing the input m
logic [Data_Width + 1 : 0] p_reg	 ;									// Internal Register for stroing the output p
logic [Data_Width + 1 : 0] x1, x2	 ;
logic [Data_Width + 1 : 0] p1, p2, p3;								




always_ff @(posedge i_clk or negedge i_rst_n) begin
    
	// System Reset 
	if (!i_rst_n) 
	begin
	
        a_reg   <= 'b0;
        b_reg   <= 'b0;
        m_reg   <= 'b0;
        p_reg   <= 'b0;
        o_busy  <= 'b0;
        o_ready <= 'b0;
		
    end 
    else 
    begin
        
		o_ready <= 1'b0;
		
		// Sample the input data when the input load signal gets high 
        if (i_load) 
        begin
		
            a_reg  <= {2'b00,i_a};
            b_reg  <= i_b		 ;
            m_reg  <= {2'b00,i_m};
            p_reg  <= 'b0		 ;
            o_busy <= 1'b1		 ;
			
        end 
        else 
        begin
		
            if (o_busy) 
            begin
        
				if (b_reg == 0) 
                begin
                
					o_ready <= 1;
                    o_busy  <= 0;
                
				end 
                else 
                begin
                    
					a_reg <= x2;
                    b_reg <= {1'b0, b_reg[Data_Width - 1 : 1]};
                    p_reg <= p3;
                
				end
            end
        end
    end
end


assign p1  = b_reg[0] ? (p_reg + a_reg) : p_reg;
assign p2  = p1 - m_reg;														
assign p3  = p2[Data_Width + 1] ? p1 : p2;
assign x1  = {a_reg[Data_Width : 0],1'b0} - m_reg;								
assign x2  = x1[Data_Width + 1] ? {a_reg[Data_Width : 0] , 1'b0} : x1;

  
  // Output 
  assign o_p = p3[Data_Width - 1 : 0];

endmodule

