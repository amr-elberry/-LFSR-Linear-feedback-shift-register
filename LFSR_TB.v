/********************************time scale *****************************/
`timescale 1ns/1ps
/************************************************************************/

module LFSR_TB ;
/****************************declare parameter****************************/
parameter LFSR_WIDTH_TB = 8 ;
parameter clock_period  = 10 ;
parameter test_case     = 5 ;
/*************************************************************************/


/*******************************decalre testbench signal******************/
reg [LFSR_WIDTH_TB-1:0] seed_tb;
reg                     clk_tb;
reg                     rst_tb;
reg                     enable_tb;
reg                     out_enable_tb;
wire                    out_tb;
wire                    valid_tb;
/*************************************************************************/


/******************************variable loop******************************/
integer  x ;

/*************************************************************************/


//*******************************memories**************************************//
reg    [LFSR_WIDTH_TB:0]   test_seed   [test_case-1:0] ;
reg    [LFSR_WIDTH_TB:0]   expect_out   [test_case-1:0] ;
/*****************************************************************************/

/********************************intial block*********************************/
initial
begin
    //system function
    $dumpfile("LFSR_dump.vcd");
    $dumpvars; 
    ///////////////////////////////

    //read file
 $readmemb("Seeds_b.txt", test_seed);
 $readmemb("Expec_Out_b.txt", expect_out);
    ///////////////////////////////

    // initialization
        initializer();
    ///////////////////////////
    
    //******************************test cases***********************************//
    for(x = 0 ; x < test_case ; x = x + 1)
    begin
        do_operation(test_seed[x]);
        do_check(expect_out[x],x);
    end
    #100;
    $finish;

    /****************************************************************************/

end

/*****************************************************************************/

/********************************TASKS****************************************/

// task intialization
task initializer ;
begin
    seed_tb        = 'b10010011;
    clk_tb         = 'b0;
    rst_tb         ='b0;
    enable_tb      ='b0;
    out_enable_tb  ='b0;
end
endtask

// task restart
task reset;
begin
    rst_tb  ='b1;
    #(clock_period)
    rst_tb  ='b0;
    #(clock_period)
    rst_tb  ='b1;
end
endtask

// do operarion
task do_operation;
input [LFSR_WIDTH_TB-1:0] seed_in;
begin
    seed_tb = seed_in;
    reset();
    #(clock_period)
    enable_tb  ='b1;
    #(10*clock_period)
    enable_tb  ='b0;
end
endtask
// do check
task do_check;
input reg [LFSR_WIDTH_TB-1:0] expect_out;
input integer test_number;
integer z;

reg [LFSR_WIDTH_TB-1:0] generate_out;
begin
    enable_tb  ='b0;
    #(clock_period)
    out_enable_tb  ='b1;
    @(posedge valid_tb)
    for(z=0;z<8;z=z+1)
    begin
        #(clock_period) generate_out[z] = out_tb;
    end
    if(generate_out==expect_out)
    begin
        $display("Test Case %d is succeeded",test_number);
    end
    else
    begin
        $display("Test Case %d is failed",test_number);
    end
    out_enable_tb = 1'b0;

end
endtask




/*****************************************************************************/
/*******************************clock generator*******************************/
//always #(clock_period/2) clk_tb = ~clk_tb;
always 
begin
    #(clock_period/2)
    clk_tb = 1'b0;
    #(clock_period/2)
    clk_tb = 1'b1;
end
/*****************************************************************************/
/*******************************DUT instantion*****************************/
LFSR DUT (
    .seed(seed_tb),
    .clk(clk_tb),
    .rst(rst_tb),
    .enable(enable_tb),
    .out_enable(out_enable_tb),
    .out(out_tb),
    .valid(valid_tb)
);
/****************************************************************************/
endmodule