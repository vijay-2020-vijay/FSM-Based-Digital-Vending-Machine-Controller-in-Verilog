`timescale 1ns/1ps
module testbench;

    // Testbench signals
    reg clk;
    reg reset;
    reg [1:0] select;
    reg [5:0] given_data;
    wire [5:0] Result;

    // Instantiate DUT
    item DUT (
        .clk(clk),
        .reset(reset),
        .select(select),
        .given_data(given_data),
        .Result(Result)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 1;
        reset = 1;
        
             // Apply reset
        #100 reset = 0;
        select = 2'b00;
        given_data = 6'd0;
   

        // -------------------------------
        // 1. Select item type (pen, cost=2)
        // -------------------------------
        #200 
        select = 2'b01;   // itemtype_select
        given_data = 6'd0;  // select itemtype[0] = pen
        // -------------------------------
        // 2. Enter quantity (3 pens)
        // -------------------------------
        #200 select = 2'b10;   // itemno_select
            given_data = 6'd3; // quantity = 3


        // -------------------------------
        // 3. Make payment
        // -------------------------------
        #200 select = 2'b11;   // payment
            given_data = 6'd6; // paying 6

        // -------------------------------
        // 4. Select another item (gum, cost=5)
        // -------------------------------
        #200 select = 2'b01;
            given_data = 6'd7; // gum


        #200 select = 2'b10;
            given_data = 6'd2; // 2 gums

        #200 select = 2'b11;
            given_data = 6'd10; // pay 10
        #200;

        // Finish simulation
     
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Reset=%b | Select=%b | Data=%d | Result=%d",
                  $time, reset, select, given_data, Result);
    end

endmodule
