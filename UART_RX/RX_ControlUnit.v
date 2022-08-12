module RX_ControlUnit 
#(parameter PRESCALE =8,
            BYTE_WIDTH=8) 
    
    (
    output  reg                                 o_count_enable,
    output  reg                                 o_deserializer_enable,
    output  reg                                 o_sampling_enable,
    output  reg                                 o_start_check_enable,
    output  reg                                 o_parity_check_enable,
    output  reg                                 o_stop_check_enable,
    output  reg                                 o_data_valid,
    input   wire                                i_start_bit_checked,
    input   wire                                i_stop_bit_checked,
    input   wire                                i_parity_bit_checked,
    input   wire                                i_parity_enable, 
    input   wire    [$clog2(PRESCALE)-1:0]      i_edge_count,
    input   wire    [$clog2(BYTE_WIDTH)-1:0]    i_bit_count,   
    input   wire                                i_data,
    input   wire                                i_clk,
    input   wire                                i_rst_n
    );
    
    reg     [2:0]   current_state;
    reg     [2:0]   next_state;

    //states gray encoding
    localparam  IDLE = 3'b000,
                START_CHECK = 3'b001,
                DATA = 3'b011,
                PARITY_CHECK = 3'b010,
                STOP_CHECK = 3'b110,
                DATA_VALID = 3'b111;
            
    //Current state logic
    always@(posedge i_clk or negedge i_rst_n)
        begin
            if (!i_rst_n)
                current_state<=IDLE;
            else
                current_state<=next_state; 
        end


    //next state logic
    always@(*)
        begin
            case (current_state)
                IDLE : 
                    begin
                        if (!i_data)
                            next_state<=START_CHECK;
                        else
                            next_state<=IDLE; 
                    end

                START_CHECK : 
                    begin
                        if (i_bit_count==0 && i_edge_count==7)
                            begin
                                
                                if (i_start_bit_checked)
                                    next_state<=DATA;
                                else
                                    next_state<=IDLE;
                            end
                        else
                            next_state<=START_CHECK;     
                    end
                            

                DATA : 
                    begin
                        if (i_bit_count==8 && i_edge_count==7)
                            begin
                                
                                if (i_parity_enable)
                                    next_state<=PARITY_CHECK;
                                
                                else
                                    next_state<=STOP_CHECK;
                            end
                        else
                            next_state<=DATA;     
                    end 


                PARITY_CHECK : 
                    begin
                        if (i_bit_count==9 && i_edge_count==7)
                            begin
                                
                                if (i_parity_bit_checked)
                                    next_state<=STOP_CHECK;
                                else
                                    next_state<=IDLE;
                            end
                        else
                            next_state<=PARITY_CHECK;     
                    end


                STOP_CHECK : 
                    begin
                        case (i_parity_enable)
                            1'b1 :
                                begin
                                    if (i_bit_count==10 && i_edge_count==7)
                                        begin
                                            if (i_stop_bit_checked)
                                                next_state<=DATA_VALID;
                                            else
                                                next_state<=IDLE;
                                        end
                                    else
                                        next_state<=STOP_CHECK;
                                end 
                            
                            1'b0 :
                                begin
                                    if (i_bit_count==9 && i_edge_count==7)
                                        begin
                                            if (i_stop_bit_checked)
                                                next_state<=DATA_VALID;
                                            else
                                                next_state<=IDLE;
                                        end
                                    else
                                        next_state<=STOP_CHECK;
                                end
                            
                        endcase     
                    end

                DATA_VALID : 
                    begin

                        if (!i_data)
                            next_state<=START_CHECK;
                        else
                            next_state<=IDLE;
    
                    end                   
                
                default: next_state<=IDLE;
            
            endcase
        
        end

    //Output logic
    always @(*)
        begin

            case (current_state)

                IDLE : 
                    begin
                        o_count_enable=1'b0;
                        o_deserializer_enable=1'b0;
                        o_sampling_enable=1'b0;
                        o_start_check_enable=1'b0;
                        o_parity_check_enable=1'b0;
                        o_stop_check_enable=1'b0;
                        o_data_valid=1'b0;
                    end

                
                START_CHECK : 
                    begin
                        o_count_enable=1'b1;
                        o_deserializer_enable=1'b0;
                        o_sampling_enable=1'b1;
                        o_start_check_enable=1'b1;
                        o_parity_check_enable=1'b0;
                        o_stop_check_enable=1'b0;
                        o_data_valid=1'b0;
                    end


                DATA : 
                    begin
                        o_count_enable=1'b1;
                        o_deserializer_enable=1'b1;
                        o_sampling_enable=1'b1;
                        o_start_check_enable=1'b0;
                        o_parity_check_enable=1'b0;
                        o_stop_check_enable=1'b0;
                        o_data_valid=1'b0;
                    end

                
                PARITY_CHECK : 
                    begin
                        o_count_enable=1'b1;
                        o_deserializer_enable=1'b0;
                        o_sampling_enable=1'b1;
                        o_start_check_enable=1'b0;
                        o_parity_check_enable=1'b1;
                        o_stop_check_enable=1'b0;
                        o_data_valid=1'b0;
                    end


                STOP_CHECK : 
                    begin
                        o_count_enable=1'b1;
                        o_deserializer_enable=1'b0;
                        o_sampling_enable=1'b1;
                        o_start_check_enable=1'b0;
                        o_parity_check_enable=1'b0;
                        o_stop_check_enable=1'b1;
                        o_data_valid=1'b0;
                    end

                
                DATA_VALID : 
                    begin
                        o_count_enable=1'b0;
                        o_deserializer_enable=1'b0;
                        o_sampling_enable=1'b0;
                        o_start_check_enable=1'b0;
                        o_parity_check_enable=1'b0;
                        o_stop_check_enable=1'b0;
                        o_data_valid=1'b1;
                    end


                default: 
                    begin
                        o_count_enable=1'b0;
                        o_deserializer_enable=1'b0;
                        o_sampling_enable=1'b0;
                        o_start_check_enable=1'b0;
                        o_parity_check_enable=1'b0;
                        o_stop_check_enable=1'b0;
                        o_data_valid=1'b0;
                    end
            endcase
        end
endmodule
