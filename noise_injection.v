module noise_injection (
    input clk,               // Xung clock hệ thống
    input reset,             // Tín hiệu reset
    input [23:0] input_wave, // Sóng đầu vào
    input noise_enable,      // Bật/tắt nhiễu
    input [31:0] phase_acc,  // Điều khiển tần số biến đổi của nhiễu
    input [1:0] shift_sel,   // Chọn mức dịch bit cho nhiễu
    output reg [23:0] output_wave // Sóng đầu ra (có nhiễu)
);

    // Bộ nhớ ROM chứa 1024 giá trị nhiễu
    reg [23:0] noise_lut [0:1023];

    // Bộ LFSR 24-bit sinh số ngẫu nhiên
    reg [23:0] lfsr;
    integer i;

    // Khởi tạo LUT một lần khi khởi động
    initial begin
        lfsr = 24'hACE1; // Giá trị khởi tạo LFSR
        for (i = 0; i < 1024; i = i + 1) begin
            lfsr = {lfsr[22:0], lfsr[23] ^ lfsr[18] ^ lfsr[17] ^ lfsr[14]};
            noise_lut[i] = lfsr;
        end
    end

    // Sinh số ngẫu nhiên LFSR mỗi xung clock
    always @(posedge clk or posedge reset) begin
        if (reset)
            lfsr <= 24'hACE1; // Reset về giá trị ban đầu
        else
            lfsr <= {lfsr[22:0], lfsr[23] ^ lfsr[18] ^ lfsr[17] ^ lfsr[14]}; // LFSR hoạt động
    end

    // Truy xuất giá trị nhiễu từ LUT
    wire [9:0] lut_addr = phase_acc[31:22]; 
    wire [23:0] noise = noise_lut[lut_addr] >> shift_sel;

    // Cộng nhiễu vào sóng đầu vào, tránh tràn số
    always @(posedge clk or posedge reset) begin
        if (reset)
            output_wave <= 24'd0;
        else if (noise_enable)
            output_wave <= input_wave + noise >>1 ;
			else
            output_wave <= input_wave;
    end

endmodule
