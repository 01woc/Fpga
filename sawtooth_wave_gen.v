module sawtooth_wave_gen (
    input clk,                // Xung clock hệ thống
    input reset,              // Tín hiệu reset
    input [31:0] phase_acc,   // Bộ tích lũy pha từ bên ngoài
    output reg [23:0] sawtooth_wave // Tín hiệu sóng răng cưa 24-bit
);

    // Tạo sóng răng cưa bằng cách sử dụng 24 bit cao của phase_acc
    always @(posedge clk) begin
        if (reset)
            sawtooth_wave <= 24'd0; // Reset tín hiệu đầu ra
        else
            sawtooth_wave <= phase_acc[31:8]; // Chỉ lấy 24 bit cao để làm giá trị đầu ra
    end

endmodule
