`timescale 1ns / 1ps

module mux(selrow,selcol,clk,program_data,addr10,addr20,A );
input selrow,selcol,clk;
input [9:0]program_data,addr10,addr20;
output reg [9:0]A;

always@(posedge clk)
begin
if(selrow==0 && selcol==0)
A=program_data;
else if(selrow==0 && selcol==1)
A= addr10;
else if(selrow==1 && selcol==0)
A= addr20;
else
A=10'hzzz;
end

endmodule
