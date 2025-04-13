module phase_accumulator (
    input clk,               // System clock
    input reset,             // Reset signal
    input [31:0] phase_step, // Phase step control
    output reg [31:0] phase_acc // Phase accumulator output
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            phase_acc <= 0;
        else
            phase_acc <= phase_acc + phase_step;
    end

endmodule
