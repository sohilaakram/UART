module parity_bit
#(parameter Data_WIDTH=8)
(
    output  wire                        o_parity_bit,
    input   wire                        i_parity_type,
    input   wire    [Data_WIDTH-1:0]    i_data
);

assign o_parity_bit= (i_parity_type)? ^i_data : ~^i_data;

endmodule
