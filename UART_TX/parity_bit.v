module parity_bit
#(parameter Data_WIDTH=8)
(
    output  reg                         o_parity_bit,
    input   wire                        i_parity_type,
    input   wire                        i_parity_enable,
    input   wire                        i_data_valid,
    input   wire    [Data_WIDTH-1:0]    i_data,
    input   wire                        i_clk,
    input   wire                        i_rst_n
);

    reg     parity_bit_reg;


    always @(*)
        begin

            if (i_parity_enable)
                begin

                    if (i_data_valid)
                        begin

                            if (i_parity_type)

                                parity_bit_reg<=~^i_data;
                            else

                                parity_bit_reg<=^i_data;
                        end

                end
        end




    always @(posedge i_clk or negedge i_rst_n)
        begin

            if (!i_rst_n)
                o_parity_bit<=1'b0;

            else
                begin

                    if (i_parity_enable)
                        o_parity_bit<=parity_bit_reg;

                end
        end
        
endmodule
