module valid_ready_noc_controller (
    input logic reset,
    input logic clk,
    input logic src_valid,
    input logic stop, 
    output logic src_ready,
    output logic dest_ready, 
    output logic transfer_en,
    output logic get_packet  
);

typedef enum logic { 
    IDLE = 1'b0;
    PROCESS = 1'b1;
 } state_type;

 state_type current_state, next_state;

 // current state logic

 always_ff @( posedge clk or negedge reset ) begin 
    if (!reset)
    begin
        current_state <= #1 IDLE;
    end
    else 
    begin
        current_state <= #1 next_state;
    end
 end

 // next state logic 

 always_comb begin 
    case (current_state)
        IDLE: begin
            if (src_valid) 
            begin
                next_state = PROCESS;
            end
            else 
            begin
                next_state = IDLE;
            end
        end
        PROCESS: begin
            if (stop)
            begin
                next_state = IDLE;
            end
            else 
            begin
                next_state = PROCESS;
            end
        end
        default: next_state = IDLE
    endcase
 end

 // output logic 

 always_comb begin 
    case (current_state)
        IDLE: begin
            if (src_valid) 
            begin
                src_ready = 1'b1;
                dest_ready = 1'b0;
                transfer_en = 1'b1;
                get_packet = 1'b1;
            end
            else 
            begin
                src_ready = 1'b0;
                dest_ready = 1'b0;
                transfer_en = 1'b0;
                get_packet = 1'b0;
            end
        end
        PROCESS: begin
            if (stop)
            begin
                src_ready = 1'b0;
                dest_ready = 1'b1;
                transfer_en = 1'b0;
                get_packet = 1'b0;
            end
            else 
            begin
                src_ready = 1'b0;
                dest_ready = 1'b0;
                transfer_en = 1'b1;
                get_packet = 1'b1;
            end
        end
        default: begin
            src_ready = 1'b0;
            dest_ready = 1'b0;
            transfer_en = 1'b0;
            get_packet = 1'b0;
        end
    endcase
 end
    
endmodule
    
