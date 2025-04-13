module sine_wave_gen (
    input clk,               // System clock
    input reset,             // Reset signal
    input [31:0] phase_acc,  // External phase accumulator
    output reg [23:0] sine_wave // 24-bit sine wave output
);

    // LUT for sine wave (1024 samples, 24-bit each)
    reg [23:0] sin_lut [0:1023];

    // Load LUT data from a file
    initial begin
        $readmemh("D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/sine_lut.dump", sin_lut);
    end

    // LUT address calculation (10-bit address)
    wire [9:0] lut_addr;
    assign lut_addr = phase_acc[31:22]; // Use top 10 bits of phase accumulator for LUT address

    // Output sine wave value from LUT
    always @(posedge clk) begin
        if (reset)
            sine_wave <= 24'd0;
        else
            sine_wave <= sin_lut[lut_addr];
    end

endmodule
