module top_level (
    input logic start,clk, reset,
    input logic [1:0] dest_address,
    input logic [1:0] packet_type,
    input logic [7:0] payload,
    input logic end_of_packet,
    output logic complete,
    output logic [12:0] output_packet
);


logic output_packet;

logic src_valid, src_ready, dest_ready;
logic transfer_en;

packet_generator pg (.start(start),
                     .dest_address(dest_address),
                     .packet_type(packet_type),
                     .payload(payload),
                     .end_of_packet(end_of_packet),
                     .src_ready(src_ready),
                     .dest_ready(dest_ready),
                     .src_valid(src_valid),
                     .complete(complete),
                     .packet(packet),
                     .transfer_en(transfer_en));


assign output_packet = packet;

noc network_on_chip (.packet(output_packet),
                     .clk(clk),
                     .reset(reset),
                     .src_valid(src_valid),
                     .transfer_en(transfer_en),
                     .src_ready(src_ready),
                     .dest_ready(dest_ready),
                     );
    
endmodule



