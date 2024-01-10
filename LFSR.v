module LFSR (
    input   wire        rst,clk,enable,out_enable,
    input   wire [7:0]  seed,
    output  reg         out,valid
);
/***************************structure of feedback part***********************************************/
reg [7:0] LFSR;
wire noring,feedback;

assign noring = ~|LFSR[6:0];
assign feedback = noring ^ LFSR[7];
/****************************************************************************************************/
parameter [7:0] pattern = 8'b10101010;
integer i;

/*****************************structure of shift register********************************************/
always@(posedge clk or negedge rst)
begin 
if(!rst)
begin
LFSR  <=  seed;
valid <=  1'b0;
out   <=  1'b0;
end
else if (enable)
begin
    LFSR[0] <= feedback;
    for(i=7;i>=1;i=i-1)
    begin
        if(pattern[i]==1)
        begin
            LFSR[i] <= LFSR[i-1] ^ feedback;
        end
        else
        begin
            LFSR[i] <= LFSR[i-1];
        end
    end
    /*
LFSR[0] <= feedback;
LFSR[1] <= LFSR[0] ^ feedback;
LFSR[2] <= LFSR[1]
LFSR[3] <= LFSR[2] ^ feedback;
LFSR[4] <= LFSR[3]
LFSR[5] <= LFSR[4] ^ feedback;
LFSR[6] <= LFSR[5]
LFSR[7] <= LFSR[6] ^ feedback;*/
end
else if(out_enable)
begin
valid <= 1'b1;
{LFSR[6:0],out}<=LFSR;
/*
OUT <= LFSR[0]
LFSR[0] <= LFSR[1]
LFSR[1] <= LFSR[2]
LFSR[2] <= LFSR[3]
LFSR[3] <= LFSR[4]
LFSR[4] <= LFSR[5]
LFSR[5] <= LFSR[6]
LFSR[6] <= LFSR[7]*/
end
end
endmodule




    

