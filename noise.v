module lfsr_updown #(parameter WIDTH = 24) (
    input wire clk,       // Clock input
    input wire reset,     // Reset input
    input wire enable,    // Enable input
    input wire up_down,   // Up/Down control input (1 for up, 0 for down)
    output reg [WIDTH-1:0] count, // LFSR count output
    output wire overflow  // Overflow output
);

    // Feedback taps for LFSR (example for 24-bit LFSR)
    // These tap positions are based on a maximal-length polynomial for 24-bit LFSR
    localparam TAPS_UP   = 24'b000000000000000000100011; // Example for counting up
    localparam TAPS_DOWN = 24'b000000000000000000110101; // Example for counting down

    // Overflow logic
    assign overflow = (up_down) ? (count == {1'b1, {(WIDTH-1){1'b0}}}) : // Overflow when counting up
                                (count == {{(WIDTH-1){1'b0}}, 1'b1});    // Overflow when counting down

    // LFSR logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= {WIDTH{1'b0}}; // Reset LFSR to all zeros
        end
        else if (enable) begin
            if (up_down) begin
                // Count up: XOR feedback for counting up
          count <= {^(count[WIDTH-1:0] & TAPS_UP), count[WIDTH-1:1]};

            end
            else begin
                // Count down: XOR feedback for counting down
                count <= {count[WIDTH-2:0], ^(count & TAPS_DOWN)};
            end
        end
    end

endmodule