`timescale 1ns / 1ps
///////////////////////////////////vanding machine/////////////////////////////////////////////////////////////////////////////
module item #(n=6'd63,s0=3'd0,s1=3'd1,s2=3'd2,s3=3'd3,s4=3'd4)(clk,reset,select,given_data,Result);
input clk,reset; //////1bit external//// only use 1 bit////use for enabvle purpose////////
input[1:0]select;  // 2bit// select=01 means itemtype_select ///select=10 means itemno_select////select=11 means rest_item///////////
input [5:0] given_data; ////6bit/////////only we will take 6 bit at a time from the user////////////////////////////////////////
output reg[5:0]Result;     ///////// 6bit result values will be shown on the display////////////////////////////////////////////
////////////////////////////////////////////////////////////input/output decleration completed//////////////////////////////////
reg [2:0]ns;
reg[5:0]itemtype;   /////only use 6 bits(total number of item in stock is 63)
reg[5:0]itemno;  //////(in our stock total number of maximum items is 63)
reg[5:0]pay;    /////// maximam_payable amount=31`
/////////////////////////////////////////////////////////63/////////////////////////////////////////////////////////////////////
reg[5:0]itemtype1[0:7];      /// here we can set maximum 63 items type ///this kind of flixblity we have.
reg[5:0]itemper_cost1[0:7];
reg[5:0]stock_item[0:7];
reg[5:0]item_per_cost_temp;
reg[5:0]total_cost_all_item;
reg[5:0]reamining_specifited_stock_item;
reg[5:0]i,k,l;
reg done;
always @(posedge clk) begin
        if(reset) begin
               itemtype1[0]<=6'd0; itemtype1[1]<=6'd1; itemtype1[2]<=6'd2; itemtype1[3]<=6'd3;///pen,paper,pencile,.....gum./////item type///
               itemtype1[4]<=6'd4; itemtype1[5]<=6'd5; itemtype1[6]<=6'd6; itemtype1[7]<=6'd7;//0 means pen ,1 means paper///////////////////
               ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
               itemper_cost1[0]<=6'd2;itemper_cost1[1]<=6'd3;itemper_cost1[2]<=6'd4;itemper_cost1[3]<=6'd3; //////itemper_cost/////////
               itemper_cost1[4]<=6'd3;itemper_cost1[5]<=6'd1;itemper_cost1[6]<=6'd3;itemper_cost1[7]<=6'd5;
               ////////////////////////////////////////////////////////////////////////////////////////////////avaliable iteams////////////////////////
               stock_item[0]<=n;stock_item[1]<=n;stock_item[2]<=n;stock_item[3]<=n;stock_item[4]<=n;
               stock_item[5]<=n;stock_item[6]<=n;stock_item[7]<=n;
               ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
               i<=0;
               k<=0;
               l<=0;
               Result=0;
               ns<=s0;
               end
               else begin
                  case(ns)
/////////////////////////////////////////////////////////////////////////////                  
               s0:begin
                  if(select==2'b01)  begin  /////itemtype_select///////////
                     itemtype<=given_data;
                     i<=i+1;
                     if(itemtype>=i-1) begin
                         ns<=s1;
                     end
                    end 
                    else
                      ns<=s0; 
                  end
 ////////////////////////////////////////////////////////////////////////////              
              s1:begin
                  Result<=itemper_cost1[itemtype];/////itemper_cost is send to Result which will be showing in fpga led board/////////////
                  item_per_cost_temp<=itemper_cost1[itemtype];  ///i_temp //temporal storeing result value//means here stored cost value of that iteam 
                  if(select==2'b10) begin  ////itenno_select///means how many number of that product user wants to buy//
                     k<=k+1;
                     itemno<=given_data;
                     if(itemno>=k) begin
                          //k<=0;
                          ns<=s2;
                      end
                  end
                  else
                     ns<=s1;
                 end
////////////////////////////////////////////////////////////////////////////////////////////////////                 
             s2:begin
                 Result<=itemno*item_per_cost_temp;   //// total_cost isa sent to Result
                 total_cost_all_item<=itemno*item_per_cost_temp;
                 stock_item[itemtype]<=n-itemno; //updatetion of stock item/////////////
                if(select==2'b11) begin  /////////payment selection////////////////////////////////
                   pay<=given_data;
                   l<=l+1;
                   if(pay>=l) begin
                       ns<=s3;
                   end
                end
                else
                  ns<=s2;
///////////////////////////////////////////////////////////////////////////
             end     
              s3:begin
                   Result<=stock_item[itemtype]; ///////result value always shown in fpga board//
                   reamining_specifited_stock_item<=stock_item[itemtype];
                   done<=1;
                   ns<=s4;
                end
              s4:begin
                   i<=0;
                   k<=0;
                   l<=0;
                   done<=0;
                   ns<=s0;
              end  
///////////////////////////////////////////////////////////////////////////// completed//////////////////////////////
          endcase    
          end
        end
endmodule
