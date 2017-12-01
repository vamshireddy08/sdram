`timescale 1ns / 1ps
module delay_generator(countout,tlat,program_data,clk,reset,load_twait,load_tpre,load_tburst,load_tcas );

output reg [2:0]tlat=0;
output  reg [9:0]countout;
input clk,reset,load_twait,load_tpre,load_tburst,load_tcas;
input [9:0]program_data;

reg [9:0]twait=10'd3;
reg [9:0]tburst=0;
reg [9:0]tpre=10'd3;
reg [9:0]tcas=10'd3;
reg [9:0]count=0;
integer power,latency=0;

always@(posedge clk)
begin
countout <= countout -1;

if(reset)
            begin
                    countout=10'd0;tlat <=3'd0;
            end
else
    begin              
                power <=program_data[2:0];
                    $display("power",power);
                        if(power==3'b111)
                    tburst <= 10'd1023;
                    else
                    tburst <=2**power;  
                                  latency =program_data[5:4]+2;
                                          tlat =latency; 
                                                   
    if(load_tpre)
        countout <=tpre;
    else if(load_twait)
    countout <=twait;
    else if(load_tcas)
    countout <=tcas;
    else if(load_tburst)
    countout <=tburst;
    end            
                end
endmodule