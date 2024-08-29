module noc (
    input logic [12:0] packet
    input logic clk, reset,
    input logic src_valid,
    output logic transfer_en,
    output logic src_ready,
    output logic dest_ready
);

// mem array

logic [9:0] noc_mem [1:0];
logic [9:0] data;
logic [1:0] dest_address;
logic [1:0] packet_type;
logic [7:0] payload;
logic end_of_packet;
logic stop;

// controller 
valid_ready_noc_controller nop_controller (.reset(reset),
                                           .clk(clk),
                                           .src_valid(src_valid),
                                           .stop(stop),
                                           .src_ready(src_ready),
                                           .dest_ready(dest_ready),
                                           .transfer_en(transfer_en),
                                           .get_packet(get_packet));

always_comb begin 
    dest_address = packet[1:0];
    packet_type = packet[3:2];
    payload = packet[11:4];
    end_of_packet = packet[12];   
end

// storing logic 

always_comb begin 
    if (get_packet)
    begin
        case (dest_address) 
            2'b00: begin
                noc[0] = data;
                stop = 1'b1;
            end 
            2'b00: begin
                noc[1] = data;
                stop = 1'b1;
            end
            2'b10: begin
                noc[2] = data;
                stop = 1'b1;
            end
            default: begin 
                noc[3] = 10'b0;
                stop = 1'b0;
            end
            
        endcase
    end
end


    
endmodule