module control_unit 
(
    output  reg    [2:0]    o_mux_sel,
    output  reg             o_load_enable,
    output  reg             o_shift_enable,
    output  reg             o_busy_flag,
    output  reg             o_count_enable,
    input   wire            i_overflow,
    input   wire            i_parity_enable,
    input   wire            i_data_valid,
    input   wire            i_clk,
    input   wire            i_rst

);

    reg [2:0]   current_state;
    reg [2:0]   next_state;


    //gray state encoding to minimize power in each transition
    localparam  [2:0]   IDLE    = 3'b000,
                        LOAD    = 3'b001,
                        START   = 3'b011,
                        DATA    = 3'b010,
                        PARITY  = 3'b110,
                        STOP    = 3'b111;

//current state logic
always@(posedge i_clk or negedge i_rst)
    begin
        if(!i_rst)
            current_state<=IDLE;
        else
            current_state<=next_state;
    end


//next state logic
always@(*)
    begin
        case (current_state)

        IDLE: 
            begin
                if (i_data_valid )
                    next_state<=LOAD;
                else 
                    next_state<=IDLE;
            end
        
        LOAD:
            begin
                next_state<=START;
            end

        START:
            begin
                next_state<=DATA;
            end

        DATA:
            begin
                if (i_overflow)
                    next_state<=(i_parity_enable)?PARITY : STOP;
                else
                    next_state<=DATA;
            end         

        PARITY:
            begin
                next_state<=STOP;
            end

        STOP:
            begin
                next_state<=IDLE;
            end

        default: next_state<= IDLE;
        endcase
    end

//output logic 
always@(*)
    begin
        case (current_state)

        IDLE: 
            begin
                o_load_enable<=1'b0;
                o_busy_flag<=1'b0;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b000;
                o_count_enable<=1'b0;
            
            end

        LOAD: 
            begin
                o_load_enable<=1'b1;
                o_busy_flag<=1'b1;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b000;
                o_count_enable<=1'b0;

            end

        START: 
            begin
                o_load_enable<=1'b0;
                o_busy_flag<=1'b1;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b001;
                o_count_enable<=1'b0;

            end

        DATA: 
            begin
                o_load_enable<=1'b0;
                o_busy_flag<=1'b1;
                o_shift_enable<=1'b1;
                o_mux_sel<=3'b011;
                o_count_enable<=1'b1;

            end

        PARITY: 
            begin
                o_load_enable<=1'b0;
                o_busy_flag<=1'b1;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b010;
                o_count_enable<=1'b0;
            end
        STOP: 
            begin
                o_load_enable<=1'b0;
                o_busy_flag<=1'b1;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b110;
                o_count_enable<=1'b0;

            end
        default : 
            begin
                o_load_enable<=1'b0;
                o_busy_flag<=1'b0;
                o_shift_enable<=1'b0;
                o_mux_sel<=3'b000;
                o_count_enable<=1'b0;
            end
        endcase
    end
endmodule