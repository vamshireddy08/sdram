`timescale 1ns / 1ps

module main(reset,clk,size,burst,write,status,addr,wdata,rdata,ready,program_data);
 input [9:0]program_data;
input clk,write,reset;
input [3:0]burst ;
input [1:0] size,status;
output [32:0]rdata;
output ready;
input [32:0] wdata,addr;
reg [31:0]addr_reg=0;

wire load_tpre,load_tcas,load_tburst,load_twait,and_biwen,and_biren,storeReg,cs_bar,ras_bar,cas_bar,we_bar,selrow,selcol,EnWdata,EnRdata;

wire [9:0]addr10;

assign and_biwen= (status & write & addr_reg[31:28]);
assign and_biren= (status & (~write) & addr_reg[31:28]);

control_unit   c(.cs_bar(cs_bar),.ras_bar(ras_bar),.cas_bar(cas_bar),.we_bar(we_bar),.selrow(selrow),.selcol(selcol),.EnWdata(EnWdata),.EnRdata(EnRdata),
.storeReg(storeReg),.ready(ready),.load_tpre(load_tpre),.load_tcas(load_tcas),.load_tburst(load_tburst),.load_twait(load_twait),.write(write),
.status(status),.size(size),.countout(countout),.biwen(biwen),.biren(biren),.burst(burst),.clk(clk),.tlat(tlat),.reset(reset));

sd_ram  s(.data(data),.clk(clk),.addr(addr10),.cs_bar(cs_bar),.ras_bar(ras_bar),.cas_bar(cas_bar),.we_bar(we_bar),.bs(bs));

delay_generator dg(.countout(countout),.tlat(tlat),.program_data(program_data),.clk(clk),.reset(reset),.load_twait(load_twait),
.load_tpre(load_tpre),.load_tburst(load_tburst),.load_tcas(load_tcas) );


always @(posedge clk)
begin

if(storeReg==1)
 addr_reg=addr;

end
endmodule
