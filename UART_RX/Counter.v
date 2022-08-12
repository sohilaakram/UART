module Counter
#(parameter PRESCALE =8,
            BYTE_WIDTH=8) 
(
    output  reg         [$clog2(PRESCALE)-1:0]      o_edge_counter,
    output  reg         [$clog2(BYTE_WIDTH)-1:0]    o_bit_counter,
    input   wire                                    i_count_enable,
    input   wire        [$clog2(PRESCALE)-1:0]      i_Prescale,
    input   wire                                    i_clk,
    input   wire                                    i_rst_n
);

    reg     [$clog2(BYTE_WIDTH)-1:0]    bit_counter=0;
    reg     [$clog2(PRESCALE)-1:0]      edge_counter=0;
    reg                                 overflow=0;


always@(posedge i_clk or negedge i_rst_n)
    begin
        
        if (!i_rst_n)
            begin
                edge_counter<= {      (PRESCALE)      {1'b0} };
                bit_counter<=  { ($clog2(BYTE_WIDTH)) {1'b0} };
                overflow<=1'b0;
            end
            
        else 
            begin

                if (i_count_enable)
                    begin
        
                        if (overflow)
                            begin
                                edge_counter<= { (PRESCALE) {1'b0} };
                                bit_counter<=bit_counter+1;                                
                            end

                        else 
                            begin
                                edge_counter<=o_edge_counter;
                                bit_counter<=bit_counter;
                            end

                    end
                    
            end

    end

always@(*)

    begin
            {overflow , o_edge_counter }=edge_counter+1;
            o_bit_counter=bit_counter;
    end

endmodule