`timescale 1ns / 1ps
module sd_ram(data,clk,addr,cs_bar,ras_bar,cas_bar,we_bar,bs);
inout [31:0]data;
input clk,we_bar,cs_bar,ras_bar,cas_bar;
input [9:0]addr;
input [1:0]bs;
integer i=0,j=0,k=0,power=0,burst_length=0,latency=0;
reg [3:0]state;
reg [5:0]addr_mode_reg;
reg [1:0]bank_addr;
reg [9:0]row_addr,col_addr;
 reg [31:0]bank[1:0][1023:0][1023:0];
 reg [31:0]data_out;
 reg c=0;
 initial begin
 for(k=0;k<4;k=k+1)
 for(i=0;i<1024;i=i+1)
 for(j=0;j<1024;j=j+1)
 bank[k][i][j]=j;
  end
  
   assign data = ( we_bar || c ) ? data_out : 32'hzzzzzzzz; 
 
  
 always@(posedge clk)
 begin
    if(~cs_bar & ~ras_bar & ~cas_bar & ~we_bar )
    begin
    addr_mode_reg<=addr[5:0];
    power=addr[2:0];
    $display("power",power);
        if(power==3'b111)
    burst_length=1024;
    else
    burst_length =2**power;
    latency =addr[5:4]+2;
    $display("burst_length:%d", burst_length);
    $display("latency:%d", latency);
        end
       
    if(~cs_bar & ~ras_bar & ~cas_bar & we_bar )
        begin
         $display("Self Refresh");
         #10 ;
        end
        if(~cs_bar & ~ras_bar & cas_bar & ~we_bar )
            begin
            $display("Precharge");
            bank_addr <= bs;
            #10 ;
            end                      
           if(~cs_bar & ras_bar & cas_bar & ~we_bar )
                            begin
                            
                            end
                            if(~cs_bar & ras_bar & cas_bar & we_bar )
                                begin
                                $display("reserved");
                                end
                                if(cs_bar)
                                    begin
                                    
                                    $display("sd-ram deselect");
                                    end
 end
 always@(posedge clk)
 begin
  if(~cs_bar & ~ras_bar & cas_bar & we_bar )
                begin
              row_addr <= addr;
              #10 ;
                end
 end
 always@(posedge clk)
  begin
  if(~cs_bar & ras_bar & ~cas_bar & we_bar )
                        begin
                             c=1; 
                           col_addr <=addr;
                            for(i=1;i<latency;i=i+1)
                                   begin
                                           #10 data_out <= 32'hz;
                                   end
                      if(addr_mode_reg[3]==1)
                                 begin
                                            for(i=0;i<burst_length;i=i+1)
                                            begin
                                            #10 data_out <= bank[bank_addr][row_addr][col_addr+i];
                                            
                                            end
                                   end
                       else
                           begin
                           c=1;
                        #10  data_out <= bank[bank_addr][row_addr][col_addr];
                       for(i=1;i<burst_length;i=i+1)
                         begin 
                                      
                                       col_addr = col_addr+1;
                                       #10  data_out <= bank[bank_addr][row_addr][col_addr];
                            if((col_addr[0]==1'b1 && burst_length==2 )||(col_addr[1:0]==2'b11 && burst_length==4) ||(col_addr[2:0]==3'b111 && burst_length==8) ||(col_addr[3:0]==4'b1111 && burst_length==16) ||(col_addr[4:0]==5'b11111 && burst_length==32)||(col_addr[5:0]==6'b111111 && burst_length==64) ||(col_addr==1 && burst_length==1024 ) )
                                          col_addr = col_addr - burst_length;
                           end 
                      end
                   end
  end
  always@(posedge clk)
    begin
  if(~cs_bar & ras_bar & ~cas_bar & ~we_bar )
                      begin
                      c=0;
                       col_addr <= addr;
                               #5 bank[bank_addr][row_addr][col_addr] = data;
                     if(addr_mode_reg[3]==1)
                          begin
                           for(i=1;i<burst_length;i=i+1)
                               begin
                             #10     bank[bank_addr][row_addr][col_addr+i] = data;
                             $display("memory write ",i);
                               end
                          end
                      else
                          begin
                             for(i=1;i<burst_length;i=i+1)
                                   begin
                                   col_addr=col_addr+1;
                                        #10 bank[bank_addr][row_addr][col_addr]=data;
                                       if((col_addr[0]==1 && burst_length==2 )||(col_addr[1:0]==1 && burst_length==4) ||(col_addr[2:0]==1 && burst_length==8) ||(col_addr[3:0]==1 && burst_length==16) ||(col_addr[4:0]==1 && burst_length==32)||(col_addr[5:0]==1 && burst_length==64) ||(col_addr==1 && burst_length==1024 ) )
                                         col_addr=col_addr-burst_length+1;
                                       end
                           end
                      end    
    end
endmodule
