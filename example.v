`timescale 1ns / 1ps
module example(clk,dinout ,ctrl   );
input clk,ctrl;
inout dinout;
reg memory;
wire din;
reg dout;
assign dinout=(~ctrl)?dout:1'hz;
assign din=ctrl?dinout:1'hz;
always@(posedge clk)
begin
if(ctrl)
memory <= din;
else
dout <=memory;
end
endmodule
