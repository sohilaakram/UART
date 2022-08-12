module UART_RX 
#( parameter DATA_WIDTH =8,
             PRESCALE   =8,
             BYTE_WIDTH =8) 
(
    output  wire                                o_data_valid,
    output  wire    [DATA_WIDTH-1:0]            o_P_DATA,
    input   wire    [$clog2(PRESCALE)-1:0]      i_Prescale,
    input   wire                                i_data,
    input   wire                                i_parity_enable,
    input   wire                                i_parity_type,
    input   wire                                i_clk,
    input   wire                                i_rst_n

);

    wire    [DATA_WIDTH-1:0]                            parallel_data;
    wire                                                count_enable,sampling_enable,deserializer_enable,sampled_bit;
    wire                                                start_check_enable,parity_check_enable,stop_check_enable;
    wire                                                start_bit_checked,stop_bit_checked,parity_bit_checked;
    wire    [$clog2(PRESCALE)-1:0]                      edge_count;
    wire    [$clog2(BYTE_WIDTH)-1:0]                    bit_count;



Counter Counter (.o_edge_counter(edge_count),
                 .o_bit_counter(bit_count),
                 .i_count_enable(count_enable),
                 .i_Prescale(i_Prescale),
                 .i_clk(i_clk),
                 .i_rst_n(i_rst_n)
                );

 

RX_ControlUnit RX_ControlUnit  (.o_count_enable(count_enable),
                                .o_deserializer_enable(deserializer_enable),
                                .o_sampling_enable(sampling_enable),
                                .o_start_check_enable(start_check_enable),
                                .o_parity_check_enable(parity_check_enable),
                                .o_stop_check_enable(stop_check_enable),
                                .o_data_valid(o_data_valid),
                                .i_start_bit_checked(start_bit_checked),
                                .i_stop_bit_checked(stop_bit_checked),
                                .i_parity_bit_checked(parity_bit_checked),
                                .i_parity_enable(i_parity_enable),
                                .i_edge_count(edge_count),
                                .i_bit_count(bit_count),
                                .i_data(i_data),
                                .i_clk(i_clk),
                                .i_rst_n(i_rst_n)
                                );

Start_Check START_CHECK (.o_start_bit_checked(start_bit_checked),
                         .i_start_check_enable(start_check_enable),
                         .i_sampled_bit(sampled_bit),                  
                         .i_clk(i_clk),
                         .i_rst_n(i_rst_n)
                        );


Stop_Check STOP_CHECK ( .o_stop_bit_checked(stop_bit_checked),
                        .i_stop_check_enable(stop_check_enable),
                        .i_sampled_bit(sampled_bit),                        
                        .i_clk(i_clk),
                        .i_rst_n(i_rst_n)
                      );


Parity_Check PARITY_CHECK ( .o_parity_bit_checked(parity_bit_checked),
                            .i_parity_check_enable(parity_check_enable),
                            .i_parity_type(i_parity_type),
                            .i_data_parallel(parallel_data),
                            .i_sampled_bit(sampled_bit),                     
                            .i_clk(i_clk),
                            .i_rst_n(i_rst_n)
                          );


Deserializer Deserializer ( .o_data(parallel_data),
                            .i_deserializer_enable(deserializer_enable),
                            .i_sampled_bit(sampled_bit),                     
                            .i_clk(i_clk),
                            .i_rst_n(i_rst_n)
                          );
            
Data_sampling DATA_SAMPLING ( .o_sampled_bit(sampled_bit),
                            .i_sampling_enable(sampling_enable),
                            .i_Prescale(i_Prescale),
                            .i_data(i_data),
                            .i_edge_count(edge_count),                     
                            .i_clk(i_clk),
                            .i_rst_n(i_rst_n)
                          );



endmodule