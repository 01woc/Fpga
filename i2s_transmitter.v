// Module truyền dữ liệu I2S
module i2s_transmitter (
    input wire clk,              // Clock hệ thống 50 MHz
    input wire reset,            // Reset tín hiệu thấp
    input wire bclk,             // Bit clock (2.304 MHz)
    input wire daclrc,           // Left-Right Clock (48 kHz)
    input wire [23:0] audio_data, // Dữ liệu âm thanh 24-bit
    output reg dacdat             // Dữ liệu truyền đi
);

    reg [5:0] bit_cnt;  // Đếm 32 bit (6-bit đủ để đếm tới 31)
    reg [31:0] shift_reg; // Thanh ghi dịch dữ liệu

    always @(negedge bclk or negedge reset) begin
        if (!reset) begin
            bit_cnt <= 0;
            shift_reg <= 32'b0;
            dacdat <= 0;
        end else begin
            if (bit_cnt == 31) begin
                bit_cnt <= 0;
                shift_reg <= {audio_data, 8'b0}; // Chuyển dữ liệu 24-bit sang 32-bit (I2S yêu cầu 32 bit)
            end else begin
                bit_cnt <= bit_cnt + 1;
                shift_reg <= {shift_reg[30:0], 1'b0}; // Dịch bit
            end
            dacdat <= shift_reg[31]; // Xuất bit MSB trước
        end
    end

endmodule
