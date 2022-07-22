module Serializer 
#(parameter Register_Width=8)

(
    output  wire                            o_data,            
    input   wire    [Register_Width-1:0]    i_data,
    input   wire                            i_clk,
    input   wire                            i_rst,
    input   wire                            i_load_enable,
    input   wire                            i_shift_enable

);

    reg [Register_Width-1:0]    internal_buffer;
    reg [Register_Width-1:0]    data_shifted;


    always@(posedge i_load_enable )
        begin
            internal_buffer<=i_data;
        end


    always@(posedge i_clk or negedge i_rst)
        begin
            if(!i_rst)
            
            internal_buffer<={ (Register_Width){1'b0} };

            else if (i_shift_enable)
            begin
                internal_buffer<=data_shifted;
            end        
        end

    always@(*)
        begin
            data_shifted<=internal_buffer<<1;
        end

    assign o_data=internal_buffer[Register_Width-1];       

    endmodule