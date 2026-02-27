module booth_datapath
(
input clk,rst,ld_A,ld_Q,ld_M,ld_cnt,clr_A,clr_Q,clr_ff,sft_A,sft_Q,add_sub,decrement,
input [7:0] multiplier,multiplicand,
output eqz,qm1,q_0,
output [15:0] final_product
);

wire [7:0] A,M,Q,Z;
wire [3:0] count;

assign q_0 = Q[0];

assign eqz = ~|count ; // to check whether counter reaches 0 or not 

shiftreg AR(clk,rst,Z,A[7],ld_A,clr_A,sft_A,A);
shiftreg QR(clk,rst,multiplier,A[0],ld_Q,clr_Q,sft_Q,Q);
D_FF Q_1(clk,rst,q_0,clr_ff,qm1);
PIPO MR(clk,multiplicand,ld_M,M);
ALU A1(A,M,add_sub,Z);
COUNTER CNT(clk,rst,count,ld_cnt,decrement);

assign final_product = {A,Q};

endmodule

module shiftreg(clk,rst,data_in,serial_in,ld_A,clr_A,sft_A,data_out);
input clk,rst,serial_in,ld_A,clr_A,sft_A;
input [7:0] data_in;
output reg [7:0] data_out;

always@(posedge clk)
begin

if(rst)
data_out <= 1'b0;

else if(clr_A)
data_out <= 1'b0;

else if(ld_A)
data_out <= data_in;

else if(sft_A)
data_out <= {serial_in , data_out[7:1]};

end

endmodule  

module PIPO(clk,data_in,load,data_out);
input clk,load;
input [7:0] data_in;
output reg [7:0] data_out;

always@(posedge clk)
begin

if(load)
data_out <= data_in;

end 

endmodule

module D_FF(clk,rst,d,clr,q);
input clk,d,clr,rst;
output reg q;

always@(posedge clk)

if(rst || clr)
q <= 1'b0;

else 
q <= d;

endmodule

module ALU(in1,in2,sel,out);
input [7:0] in1,in2;
input sel;
output reg [7:0] out;

always@(*)

out = (sel) ? (in1 + in2) : (in1-in2) ;

endmodule 

module COUNTER(clk,rst,data_out,ld_cnt,decrement);
input clk,ld_cnt,decrement,rst;
output reg [7:0] data_out;

always@(posedge clk)
begin 

if(rst)
data_out <= 1'b0;

else if(ld_cnt)
data_out <= 4'b1000;  // initially , set the counter to 8 and then allow decement on further clock cycles 
else if(decrement)
data_out <= data_out -1;

end 

endmodule 


