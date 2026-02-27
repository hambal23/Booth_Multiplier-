module booth_controlpath

(
input clk,start,q_0,qm1,eqz,rst,
output reg ld_A,ld_Q,ld_M,ld_cnt,clr_A,clr_Q,clr_ff,sft_Q,sft_A,add_sub,decrement,done
);

reg [2:0] state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;

always@(posedge clk)
begin 

if(rst)
state <= S0;

else 
begin

case(state)

S0 :

if(start)
state <= S1;

S1 : state <= S2;

S2 : begin 

if( {q_0,qm1} == 2'b01 )
state <= S3;
else if( {q_0,qm1} == 2'b10)
state <= S4;
else
state <= S5;

end

S3 : state <= S5;
S4 : state <= S5;

S5 : begin 

if( ({q_0,qm1} == 2'b01) && !eqz)
state <= S3;
else if ( ({q_0,qm1} == 2'b10) && !eqz)
state <= S4;
else if(eqz)
state <= S6;

end

S6 : state <= S6;

default : state <= S0;

endcase 
end 

end    

always@(state)
begin 

case(state)

S0 : begin 

clr_A = 0; 
ld_A = 0;
sft_A = 0;
clr_Q = 0;
ld_Q = 0;
sft_Q = 0;
ld_M = 0;
clr_ff = 0;
done = 0 ;
decrement = 0;

end 

S1 : begin 

clr_A  = 1;
clr_ff = 1;
ld_cnt = 1;
ld_M = 1;
ld_Q = 1;

end 

S2 : begin 

clr_A = 0;
clr_ff = 0;
ld_cnt = 0;
ld_M = 0;
ld_Q = 0;

end 

S3 : begin

ld_A = 1; 
add_sub = 1 ; // ADDITION
sft_A = 0;
ld_Q = 0;
sft_Q = 0;
decrement = 0;

end 

S4 : begin 

ld_A = 1;
add_sub = 0; // SUBTRACTION 
sft_A = 0;
ld_Q = 0;
sft_Q = 0;
decrement = 0;

end 

S5 : begin 

ld_A = 0;
sft_A = 1;
ld_Q = 0;
sft_Q = 1;
decrement = 1;

end 

S6 : begin 

done = 1;

end 

default : begin 

clr_A = 0; 
ld_A = 0;
sft_A = 0;
clr_Q = 0;
ld_Q = 0;
sft_Q = 0;
ld_M = 0;
clr_ff = 0;
done = 0 ;
decrement = 0;

end 

endcase

end 

endmodule 