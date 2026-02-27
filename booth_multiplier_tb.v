`timescale 1ns/1ps
`default_nettype none  // to avoid implicit declaration of the signals , we are using this 

module booth_multiplier_tb;

wire done;
wire [15:0] final_product;
reg clk,start,rst;
reg [7:0] multiplier , multiplicand;

wire ld_A, ld_Q, ld_M, ld_cnt;  
wire clr_A, clr_Q, clr_ff;
wire sft_A, sft_Q;
wire add_sub, decrement;
wire qm1, eqz;
wire q_0;

booth_datapath B1(clk,rst,ld_A,ld_Q,ld_M,ld_cnt,clr_A,clr_Q,clr_ff,sft_A,sft_Q,add_sub,decrement,multiplier,multiplicand,eqz,qm1,q_0,final_product);
booth_controlpath C1(clk,start,q_0,qm1,eqz,ld_A,ld_Q,ld_M,ld_cnt,clr_A,clr_Q,clr_ff,sft_Q,sft_A,add_sub,decrement,done); 


initial
begin

clk = 1'b0;
rst = 1'b1;
start = 1'b0;

multiplier = 8'd10;
multiplicand = 8'd13;

#12 rst = 1'b0;

@(posedge clk)
start = 1'b1;

@(posedge clk)
start = 1'b0;

#800 $finish;

end

always #5 clk = ~clk;

initial 
begin 

$monitor("Time=%0t Final Product =%d ",$time, final_product);

end


endmodule