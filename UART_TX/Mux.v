module Mux
    #(parameter selection=3  )

(
    output  reg                         o_uart_tx,
    input   wire                        i_start_bit,
    input   wire                        i_data,
    input   wire                        i_parity_bit,
    input   wire                        i_stop_bit,
    input   wire    [selection-1:0]     i_sel,
    input   wire                        i_clk,
    input   wire                        i_rst_n
);

    localparam  [2:0]   IDLE    =3'b000,
                        START   =3'b001,
                        DATA    =3'b011,
                        PARITY  =3'b010,
                        STOP    =3'b110;

    //reg     o_mux;

    always@(*)
        begin
            case(i_sel)

                IDLE : o_uart_tx<=1'b1;

                START : o_uart_tx<=i_start_bit;
                
                DATA : o_uart_tx<=i_data;
                
                PARITY : o_uart_tx<=i_parity_bit;
                
                STOP : o_uart_tx<=i_stop_bit;

                default : o_uart_tx<=1'b1;
            endcase
        
        end
    /*
    always @(posedge i_clk or negedge i_rst_n)
        begin
            if (!i_rst_n)
                o_uart_tx<=1'b0;
            else
                o_uart_tx<=o_mux;
        end
    */
endmodule