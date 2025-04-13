/*module fir (
    input clk,
    input reset,
    input signed [23:0] data_in,
    output signed [23:0] data_out
);

    // Hệ số FIR Q1.15 chuẩn, đối xứng, tổng ~1.0
    // Tạo bằng Python/MATLAB, windowed sinc low-pass
    wire signed [15:0] coeffs [0:15];
    assign coeffs[ 0] = 16'sd262;    // ≈ 0.0080
    assign coeffs[ 1] = 16'sd524;
    assign coeffs[ 2] = 16'sd1310;
    assign coeffs[ 3] = 16'sd2097;
    assign coeffs[ 4] = 16'sd3146;
    assign coeffs[ 5] = 16'sd4194;
    assign coeffs[ 6] = 16'sd4717;
    assign coeffs[ 7] = 16'sd5240;
    assign coeffs[ 8] = 16'sd5240;
    assign coeffs[ 9] = 16'sd4717;
    assign coeffs[10] = 16'sd4194;
    assign coeffs[11] = 16'sd3146;
    assign coeffs[12] = 16'sd2097;
    assign coeffs[13] = 16'sd1310;
    assign coeffs[14] = 16'sd524;
    assign coeffs[15] = 16'sd262;

    // Bộ nhớ trễ
    reg signed [23:0] shift_reg [0:15];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                shift_reg[i] <= 0;
        end else begin
            shift_reg[0] <= data_in;
            for (i = 1; i < 16; i = i + 1)
                shift_reg[i] <= shift_reg[i-1];
        end
    end

    // Nhân hệ số
    reg signed [39:0] products [0:15]; // 24b * 16b = 40b
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                products[i] <= 0;
        end else begin
            for (i = 0; i < 16; i = i + 1)
                products[i] <= shift_reg[i] * coeffs[i];
        end
    end

    // Pipeline cộng theo tầng (adder tree)
    reg signed [40:0] sum1 [0:7];
    reg signed [41:0] sum2 [0:3];
    reg signed [42:0] sum3 [0:1];
    reg signed [43:0] sum4;
    reg signed [23:0] data_out_reg;
    assign data_out = data_out_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) sum1[i] <= 0;
            for (i = 0; i < 4; i = i + 1) sum2[i] <= 0;
            for (i = 0; i < 2; i = i + 1) sum3[i] <= 0;
            sum4 <= 0;
            data_out_reg <= 0;
        end else begin
            for (i = 0; i < 8; i = i + 1)
                sum1[i] <= products[2*i] + products[2*i+1];

            for (i = 0; i < 4; i = i + 1)
                sum2[i] <= sum1[2*i] + sum1[2*i+1];

            sum3[0] <= sum2[0] + sum2[1];
            sum3[1] <= sum2[2] + sum2[3];

            sum4 <= sum3[0] + sum3[1];

            // Shift về đúng Q1.23 → Q1.23 (Q1.15 nhân Q1.23 = Q2.38)
            data_out_reg <= sum4[38:15]; // giữ nguyên biên
        end
    end

endmodule
*/
/*module noise_injection (
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
*/
module fir_filter(
	input clk,	reset,
	input [15:0] in,
	output reg [15:0] out
	 );
	
	reg [15:0] coef [18:0];
	reg [15:0] shift [18:0];
	reg [35:0] mulsum;
	reg [6:0] cnt;
	integer i, j;
	
	always @(posedge clk) begin
		if (reset) begin
			coef[0] = 26;
			coef[1] = 270;
			coef[2] = 963;
			coef[3] = 2424;
			coef[4] = 4869;
			coef[5] = 8259;
			coef[6] = 12194;
			coef[7] = 15948;
			coef[8] = 18666;
			coef[9] = 19660;
			coef[10] = 18666;
			coef[11] = 15948;
			coef[12] = 12194;
			coef[13] = 8259;
			coef[14] = 4869;
			coef[15] = 2424; 
			coef[16] = 963;
			coef[17] = 270;
			coef[18] = 26;
			cnt <= 0;
		end
		else begin 
			if (cnt < 19) begin
				shift[cnt] <= in;
				cnt <= cnt + 1;
			end
			else begin
				for (i=18; i>0; i=i-1) 
					shift[i-1] <= shift[i];
					shift[18] <= in;
			end
		end
	end
	
	always @(posedge clk) begin	
			if (cnt > 18) begin
				mulsum = 0;
				for (j=0; j<19; j=j+1)
					mulsum = mulsum + (coef[j] * shift[j]);
				for (j=0; j<16; j=j+1)
					out[j] = mulsum [20+j];
			end
	end

endmodule