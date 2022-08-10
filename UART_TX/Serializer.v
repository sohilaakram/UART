module Serializer
#(parameter DATA_WIDTH=8)

(
    output  wire                            o_data,            
    input   wire    [DATA_WIDTH-1:0]        i_data,
    input   wire                            i_load_enable,
    input   wire                            i_shift_enable,
    input   wire                            i_clk,
    input   wire                            i_rst_n
);

    reg [DATA_WIDTH-1:0]    internal_buffer=0;
    reg [DATA_WIDTH-1:0]    data_shifted=0;


    always@(posedge i_load_enable )
        begin

            internal_buffer<=i_data;
        end


    always@(posedge i_clk or negedge i_rst_n)
        begin
            if(!i_rst_n)
            
                internal_buffer<={ (DATA_WIDTH){1'b0} };

            else if (i_shift_enable)
                begin
                    internal_buffer<=data_shifted;
                end        
        end

    always@(*)
        begin
            data_shifted<=internal_buffer>>1;
        end

    assign o_data=internal_buffer[0];

    endmodule