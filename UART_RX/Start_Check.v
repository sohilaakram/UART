module Start_Check (
    output  reg     o_start_bit_checked,
    input   wire    i_sampled_bit,
    input   wire    i_start_check_enable,
    input   wire    i_clk,
    input   wire    i_rst_n
);
    
    always @(posedge i_clk or negedge i_rst_n)
        begin

            if (!i_rst_n)
                o_start_bit_checked<=1'b0;

            else
                begin
                    if (i_start_check_enable)
                        o_start_bit_checked<= ~i_sampled_bit;
                    else
                        o_start_bit_checked<=1'b0;
                end
        end
endmodule