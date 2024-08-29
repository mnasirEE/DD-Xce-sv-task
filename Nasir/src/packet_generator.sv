module packet_generator (
    input logic start,
    input logic [1:0] dest_address,
    input logic [1:0] packet_type,
    input logic [7:0] payload,
    input logic end_of_packet,
    input logic src_ready,
    input logic dest_ready,
    output logic src_valid,
    output logic complete,
    output logic [12:0] packet,
    input logic transfer_en
);

// generate packet
logic [12:0] packet_generated;
assign packet_generated = {end_of_packet, payload, packet_type, dest_address};

// start signal by testbench

always_comb begin
    if (start) 
    begin
        src_ready = 1'b1;
    end
    else 
    begin
        src_ready = 1'b0;
    end
end

// if transfer complete and dest_valid

always_comb begin
    if (transfer_en) 
    begin
        packet = packet_generated;
    end
    else 
    begin
        packet = 13'd12; 
    end
end


// end of transmission
always_comb begin
    if (dest_ready) 
    begin
        complete = 1'b1;
    end
    else 
    begin
        complete = 1'b0;
    end
end
    
endmodule