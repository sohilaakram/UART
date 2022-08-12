module Parity_Check 
#(parameter DATA_WIDTH  =   8)
    (
    output  reg                         o_parity_bit_checked,
    input   wire                        i_parity_check_enable,
    input   wire                        i_parity_type,
    input   wire    [DATA_WIDTH-1:0]    i_data_parallel,
    input   wire                        i_sampled_bit,
    input   wire                        i_clk,
    input   wire                        i_rst_n
    );
    
    always @(posedge i_clk or negedge i_rst_n)
        begin

            if (!i_rst_n)
                o_parity_bit_checked<=1'b0;

            else
                begin

                    if (i_parity_check_enable)
                        begin

                            case (i_parity_type) 
                            1'b1    :   o_parity_bit_checked<=~(~^i_data_parallel     ^   i_sampled_bit);  
                            1'b0    :   o_parity_bit_checked<=~(^i_data_parallel    ^   i_sampled_bit);
                            endcase

                        end
                    
                    else
                        o_parity_bit_checked<=1'b0;
                end
        end
endmodule