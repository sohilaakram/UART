module Data_sampling 
#(parameter PRESCALE = 8,
            BYTE_WIDTH=8) 
    (
    output  reg                                 o_sampled_bit,
    input   wire                                i_sampling_enable,
    input   wire    [$clog2(PRESCALE)-1:0]      i_Prescale,
    input   wire                                i_data,
    input   wire    [$clog2(PRESCALE)-1:0]      i_edge_count,
    input   wire                                i_clk,
    input   wire                                i_rst_n
    );

    
    reg     [$clog2(BYTE_WIDTH)-1:0]    samples=0;
    reg                                 sampling_edge=0;

    always @(posedge i_clk or negedge i_rst_n)
        begin
            
            if (!i_rst_n)
                samples<= { ($clog2(BYTE_WIDTH)) {1'b1}  };

            else
                begin
                    if (sampling_edge)
                        begin
                            samples<={i_data, samples[2:1]};
                        end           

                end
        end

                            
                        
    always @(*)
        begin
            case (i_Prescale)
                'd8     :   sampling_edge = (i_edge_count==2 || i_edge_count==3 || i_edge_count==4);
                'd16    :   sampling_edge = (i_edge_count==6 || i_edge_count==7 || i_edge_count==8);
                'd32    :   sampling_edge = (i_edge_count==13 || i_edge_count==14 || i_edge_count==15);
                
                default:    sampling_edge = (i_edge_count==2 || i_edge_count==3 || i_edge_count==4);

            endcase

        end
    
    
    always @(posedge i_clk or negedge i_rst_n)
        begin

            if (!i_rst_n)
                o_sampled_bit<=1'b0;

            else
                begin

                    if (i_sampling_enable)
                        begin

                            case (samples)
                                3'b000  :   o_sampled_bit<=1'b0;
                                3'b001  :   o_sampled_bit<=1'b0;
                                3'b010  :   o_sampled_bit<=1'b0;
                                3'b100  :   o_sampled_bit<=1'b0;
                                default :   o_sampled_bit<=1'b1; 
                            endcase
                        end
                    
                    else
                        o_sampled_bit<=1'b1;

                end
        end
endmodule