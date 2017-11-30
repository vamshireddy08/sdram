`timescale 1ns / 1ps
module control_unit(cs_bar,ras_bar,cas_bar,we_bar,selrow,selcol,EnWdata,EnRdata,storeReg,ready,load_tpre,load_tcas,load_tburst,load_twait,
write,status,size,countout,biwen,biren,burst,clk,tlat,reset);
    output  cs_bar,ras_bar,cas_bar,we_bar,selrow,selcol,EnWdata,EnRdata,storeReg,ready,load_tpre,load_tcas,load_tburst,load_twait; 
    input [1:0] status,size;
    input write,clk,biwen,biren,reset;
    input [9:0]countout;
    input [3:0]burst;
    input [9:0]tlat;
    reg [3:0]countw,countr ;
    initial begin countw =0; countr=0; end
    
    always@(posedge clk or posedge reset)
    begin
    if(reset) begin
            countw<=4'd0;            
           countr <=4'd0;
           end
                     else if(countw==4'd9)
                     countw <=4'd10;
            else if(status==2'd2 && countout==1 && countw!=8)
               countw <=4'd1;
               else if(countw==4'd8 && countout ==1)
               countw <=countw +1;
              else if(countr==4'd9)
                                    countr <=4'd10;
                           else if(status==2'd2 && countout==1 && countr!=8)
                              countr <=4'd1;
                              else if(countw==4'd8 && countout ==2)
                              countr <=countr +1;
               if(write==1)
               begin 
             if((countw==4'd6 ||countw==4'd7) && countout>1)
            countw <=countw+1;
    else if((status==2'b11 ||countout >1) && countw!=4'd4 &&countw!=4'd2 && countw!=4'd9  )
        countw<=countw;
        else if(countw==4'd6 && countout==10'd1)
         countw <=countw+1; 
        else if((countout==10'd1 && countw==4'd3))
                 countw <=countw;
    else if((status==2'b00 &&biwen==1) ||status==2'b01 ||status==2'd2  )
         countw <=countw+1;
         end            
         else
         begin
           if(countr==4'd5 && countout >=1)
                         countr <=countr; 
         else if(countr==4'd6 ||countr==4'd7 || (countr==4'd5 &&countout ==0))
                     countr <=countr+1;
         else if(status==2'b11 ||(countout >1 && countr!=4'd4 &&countr!=4'd2 && countr!=4'd9 )  )
                 countr<=countr;
                  
         else if((countout==10'd1 && countr==4'd3))
                 countr <=countr;
                  else if((status==2'b00 &&biren==1) ||status==2'b01 ||status==2'd2  )
                  countr <=countr+1;
         
                  end
         $display("count read:  ",countr);       
    end
    
assign load_twait=(countw==4'd9 ||countr==4'd9);
assign storeReg= (countw==4'd2||countr==4'd2);  
   assign load_tpre= (countw==4'd2||countr==4'd2);
assign load_tcas= (countw==4'd4||countr==4'd4);
 assign selrow= (countw==4'd4||countr==4'd4);
assign selcol= (countw==4'd7||countr==4'd6);
 assign load_tburst=(countw==4'd6||countr==5'd7);
 assign ready= (countw==4'd7||countw==4'd8||countw==4'd6|| countr==4'd8||countr==4'd9);
 assign EnWdata= (countw==4'd7||countw==4'd8||countw==4'd9);
  assign EnRdata= (countr==4'd8||countr==4'd9);

 assign cs_bar= (countw==4'd3||countw==4'd5||countw==4'd8||countw==4'd10||countw==4'd9||countw==4'd6||countr==4'd3||
 countr==4'd5||countr==4'd7||countr==4'd8||countr==4'd10||countr==4'd9) ;
 assign ras_bar= (countw==4'd7||countr==4'd6);
 assign cas_bar= (countw==4'd2||countw==4'd4||countr==4'd2||countr==4'd4);
 assign we_bar= (countw==4'd4||countr==4'd6||countr==4'd4);
 
 


      endmodule