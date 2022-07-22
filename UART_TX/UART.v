module UART 
#(parameter DATA_WIDTH=8)
(
    output  wire                        o_uart,
    output  wire                        o_busy_flag,
    input   wire    [DATA_WIDTH-1:0]    i_data,
    input   wire                        i_parity_type,
    input   wire                        i_parity_enable,
    input   wire                        i_data_valid,
    input   wire                        i_clk,i_rst
);

    wire    load_enable,shift_enable,count_enable;
    wire    overflow,data_out,parity_bit;
    wire    [2:0]   sel;
control_unit Control_Unit 
                         (.o_load_enable(load_enable),
                          .o_shift_enable(shift_enable),
                          .o_busy_flag(o_busy_flag),
                          .o_count_enable(count_enable),
                          .o_mux_sel(sel),
                          .i_overflow(overflow),
                          .i_parity_enable(i_parity_enable),
                          .i_data_valid(i_data_valid),
                          .i_clk(i_clk),
                          .i_rst(i_rst)
                         );

parity_bit Parity_Bit 
                     (.o_parity_bit(parity_bit),
                      .i_parity_type(i_parity_type),
                      .i_data(i_data)
                     );

Mux Output_Mux 
              (.o_uart(o_uart),
               .i_data(data_out),
               .i_parity_bit(parity_bit),
               .i_sel(sel)
              );

Counter Counter 
               (.o_overflow(overflow),
                .i_count_enable(count_enable),
                .i_clk(i_clk),
                .i_rst(i_rst)
               );

Serializer Serializer 
                     (.o_data(data_out),
                      .i_data(i_data),
                      .i_load_enable(load_enable),
                      .i_shift_enable(shift_enable),
                      .i_clk(i_clk),
                      .i_rst(i_rst)
                     );


     
         

endmodule