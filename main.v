`timescale 1ns / 1ps

module main(reset,clk,size,burst,write,status,addr,wdata,rdata,ready,program_data,load_tpre,load_tcas,load_tburst,load_twait,and_biwen,
and_biren,storeReg,cs_bar,ras_bar,cas_bar,we_bar,selrow,selcol,EnWdata,EnRdata,bs,countout);

input [9:0]program_data;
input clk,write,reset;
input [3:0]burst ;
input [1:0] size,status;
output [32:0]rdata;
output ready;
input [32:0] wdata,addr;

reg [31:0]addr_reg=0;
wire [9:0]rowaddr=addr[19:10];
wire [9:0]coladdr=addr[9:0];
output wire [1:0]bs;
output wire load_tpre,load_tcas,load_tburst,load_twait,storeReg,cs_bar,ras_bar,cas_bar,we_bar,selrow,selcol,EnWdata,EnRdata;
output  and_biwen,and_biren;
wire [9:0]A;
assign bs=addr[21:20];
assign rdata=(EnRdata)?rdata:32'hzzzzzzzz;
assign wdata=(EnWdata)?wdata:32'hzzzzzzzz;
output wire [9:0]countout;
 

  assign and_biwen=(status==2'b00 && write==1)?1:0;
    assign and_biren=(status==2'b00 && write==0)?1:0;

control_unit   c(.cs_bar(cs_bar),.ras_bar(ras_bar),.cas_bar(cas_bar),.we_bar(we_bar),.selrow(selrow),.selcol(selcol),.EnWdata(EnWdata),.EnRdata(EnRdata),
.storeReg(storeReg),.ready(ready),.load_tpre(load_tpre),.load_tcas(load_tcas),.load_tburst(load_tburst),.load_twait(load_twait),.write(write),
.status(status),.size(size),.countout(countout),.biwen(and_biwen),.biren(and_biren),.burst(burst),.clk(clk),.tlat(tlat),.reset(reset));

sd_ram  s(.rdata(rdata),.wdata(wdata),.clk(clk),.addr(A),.cs_bar(cs_bar),.ras_bar(ras_bar),.cas_bar(cas_bar),.we_bar(we_bar),.bs(bs));

delay_generator dg(.countout(countout),.tlat(tlat),.program_data(program_data),.clk(clk),.reset(reset),.load_twait(load_twait),
.load_tpre(load_tpre),.load_tburst(load_tburst),.load_tcas(load_tcas) );

mux m(.selrow(selrow),.selcol(selcol),.clk(clk),.program_data(program_data),.addr10(coladdr),.addr20(rowaddr),.A(A) );

always @(posedge clk)
begin

if(storeReg==1)
 addr_reg=addr;
end
endmodule
