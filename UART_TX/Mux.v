module Mux
    #(parameter Selection=3  )

(
    output  reg                         o_uart,
    input   wire                        i_data,
    input   wire                        i_parity_bit,
    input   wire    [Selection-1:0]     i_sel
);

    localparam  [2:0]   IDLE = 3'b000,
                        START=3'b001,
                        DATA=3'b010,
                        PARITY=3'b011,
                        STOP=3'b100;

    always@(*)
        begin
            case(i_sel)

                IDLE : o_uart<=1'b1;

                START : o_uart<=1'b0;
                
                DATA : o_uart<=i_data;
                
                PARITY : o_uart<=i_parity_bit;
                
                STOP : o_uart<=1'b1;

                default : o_uart<=1'b1;
            endcase
        
        end

endmodule