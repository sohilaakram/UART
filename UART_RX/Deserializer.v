module Deserializer 
#(parameter DATA_WIDTH=8) 
    (
    output      wire    [DATA_WIDTH-1:0]    o_data,
    input       wire                        i_deserializer_enable,
    input       wire                        i_sampled_bit,
    input       wire                        i_clk,
    input       wire                        i_rst_n
    );

     reg    [DATA_WIDTH-1:0]     P_DATA =   0;   

    always @(posedge i_clk or negedge i_rst_n)
        begin
            if (!i_rst_n)
                P_DATA<={(DATA_WIDTH) {1'b0}};
            else
                begin
                    if (i_deserializer_enable )
                        P_DATA<={i_sampled_bit,P_DATA[DATA_WIDTH-1:1]};
                end    
        end
 
    assign o_data=P_DATA;    
endmodule