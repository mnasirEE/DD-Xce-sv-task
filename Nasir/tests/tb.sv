module tb;

    // Inputs
    logic clk, reset;
    logic start;
    logic [1:0] dest_address;
    logic [1:0] packet_type;
    logic [7:0] payload;
    logic end_of_packet;

    // Reference model output
    logic [12:0] input_packet;

    // Outputs
    logic [12:0] output_packet;
    logic complete;

    // Instantiation
   top_level UUT (.start(start),
                  .clk(clk),
                  .reset(reset),
                  .dest_address(dest_address),
                  .packet_type(packet_type),
                  .payload(payload),
                  .end_of_packet(end_of_packet),
                  .complete(complete),
                  .output_packet(output_packet));

    // Clock generation
    initial begin
        clk = #1 1;
        forever #5 clk = ~clk; // 10 ns period clock
    end


    // Dump file for waveform
    initial begin
        $dumpfile("valid_ready_noc.vcd");
        $dumpvars(0, tb);
    end

    task init_sequence; 
        begin
            // Initialize Inputs
            start = 0;
            [1:0] dest_address = 2'b00;
            [1:0] packet_type  = 2'b00;
            [7:0] payload      = 8'd0;
            end_of_packet      = 0;
        end
    endtask

    task reset_sequence; 
        begin
            // first reset apply acychronus reset
            reset = #1 0;
            // start = #1 0;
            // @(posedge clk);
            #10 reset = #1 1;
        end
    endtask

    // Task for driving inputs
    task driver(input logic [1:0] address, input [1:0] type_p, input logic [7:0] data, input logic eop, output logic input_packet);
        begin
            start = 1;
            [1:0] dest_address = address;
            [1:0] packet_type  = type_p;
            [7:0] payload      = data;
            end_of_packet      = eop;
            input_packet = {address, type_p, data, eop};
            @(posedge clk); 
            start = 0;

        end
    endtask

    // Define a task to check the condition and exit the loop
    task check_complete;
        begin
            while (!complete) begin
                @(posedge clk);
            end
        end
    endtask

    // Task for monitoring outputs
    task monitor(input logic expected_packet);
        begin
            // wait (dest_valid == 1);
            check_complete();
            // repeat(5)@(posedge clk);
            // start= 1'b0;
            if (expected_packet == output_packet) begin
                $display("Test Passed");
            end
            else begin
                $display(("Test Failed"));
            end
            
        end
    endtask


    // Directed test cases using fork-join for edge cases
    initial begin
        init_sequence();
        reset_sequence();
        fork
            driver(2'b00, 2'b00, 8'd16, 1'b1, expected_packet);
            monitor(expected_packet);
            driver(2'b01, 2'b01, 8'd20, 1'b1, expected_packet);
            monitor(expected_packet);
            driver(2'b10, 2'b10, 8'd32, 1'b1, expected_packet);
            monitor(expected_packet);
            driver(2'b11, 2'b11, 8'd25, 1'b1, expected_packet);
            monitor(expected_packet);
        join

        $finish;
    end
endmodule