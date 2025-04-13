module waveform_generator(
    input wire clk,                 // Xung clock hệ thống
    input wire reset,               // Đặt lại hệ thống
    input wire [3:0] switches,      // Công tắc điều khiển tần số hoặc biên độ
    input wire button_freq_inc,     // Nút tăng tần số
    input wire button_freq_dec,     // Nút giảm tần số
    input wire [2:0] waveform_select, // Chọn loại sóng: 000-Sine, 001-Square, 010-Triangle, 011-ECG, 100-Sawtooth
    input wire noise_enable,        // Bật/tắt nhiễu
	 input [1:0] shift_sel,  
    input [7:0] duty_cycle,         // Biên độ sóng vuông
    output wire [23:0] waveform_out, // Tín hiệu sóng ra 24 bit
	 output wire [23:0] waveform_fir_out, 
    inout wire i2c_sda,        // Dữ liệu I2C
    output wire i2c_scl,       // Clock I2C
    output wire bclk,          // Bit Clock (2.304 MHz)
    output wire daclrc,        // Left-Right Clock (48 kHz)
    output wire dacdat         // Dữ liệu I2S
);

    // Các tín hiệu giữa các module
    wire [23:0] sine_wave, square_wave, triangle_wave, ecg_wave, sawtooth_wave;
    wire [23:0] noise_wave, final_wave;
    wire [31:0] phase_step;  // Thay đổi tần số thành bước pha
	 wire [31:0] phase_acc;
    wire [7:0] amplitude;  // Biên độ sóng
    wire config_done;          // Trạng thái cấu hình xong WM8731
	  // Module tính toán pha (quản lý phase_acc bên ngoài)
	  	wire [23:0] filtered_wave;
	fir fir_filter (
    .clk(clk),
    .reset(reset),
    .data_in(waveform_out),
    .data_out(filtered_wave)
);
    phase_accumulator phase_gen (
        .clk(clk),
        .reset(reset),
        .phase_step(phase_step),
        .phase_acc(phase_acc)
    );

    
    // Các module con
    // Module tạo clock
    clock_generator clk_gen (
        .clk_in(clk),
        .reset(reset),
        .bclk(bclk),
        .lrclk(daclrc)
    );

    // Module cấu hình WM8731
    wm8731_config codec_config (
        .clk(clk),
        .reset(reset),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda),
        .config_done(config_done),
        .waveform_out(audio_data)  // Dữ liệu đầu vào cho I2S
    );

    // Module truyền dữ liệu I2S
    i2s_transmitter i2s_tx (
        .clk(clk),
        .reset(reset),
        .bclk(bclk),
        .daclrc(daclrc),
        .audio_data(audio_data),
        .dacdat(dacdat)
    );

    sine_wave_gen sine_gen (
        .clk(clk),
        .reset(reset),
        .phase_acc(phase_acc),
        .sine_wave(sine_wave)
    );

    square_wave_gen square_gen (
        .clk(clk),
        .reset(reset),
        .phase_acc(phase_acc),
        .duty_cycle(duty_cycle),
        .square_wave(square_wave)
    );

    triangle_wave_gen triangle_gen (
        .clk(clk),
        .reset(reset),
        .phase_acc(phase_acc),
        .triangle_wave(triangle_wave)
    );

    ecg_wave_gen ecg_gen (
        .clk(clk),
        .reset(reset),
        .phase_acc(phase_acc),
        .ecg_wave(ecg_wave)
    );

    // Module tạo sóng răng cưa
    sawtooth_wave_gen sawtooth_gen (
        .clk(clk),
        .reset(reset),
        .phase_acc(phase_acc),
        .sawtooth_wave(sawtooth_wave)
    );

    // Module điều khiển (phase_step và amplitude)
    control control_unit (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .button_freq_inc(button_freq_inc),
        .button_freq_dec(button_freq_dec),
        .phase_step(phase_step),
        .amplitude(amplitude)
    );

    // Lựa chọn sóng
    reg [23:0] selected_wave;
    always @(*) begin
        case (waveform_select)
            3'b000: selected_wave = sine_wave;               // Chọn sóng sin
            3'b001: selected_wave = square_wave;             // Chọn sóng vuông
            3'b010: selected_wave = triangle_wave;           // Chọn sóng tam giác
            3'b011: selected_wave = ecg_wave;                // Chọn sóng ECG
            3'b100: selected_wave = sawtooth_wave;           // Chọn sóng răng cưa
            default: selected_wave = 24'b0;                  // Giá trị mặc định là 0
        endcase
    end

    // Module tạo nhiễu
    noise_injection noise_gen (
        .clk(clk),
        .reset(reset),
        .input_wave(selected_wave),   // Nhận sóng đã chọn
        .noise_enable(noise_enable),   // Cập nhật nhiễu nếu có
		  .phase_acc(phase_acc),
		  .shift_sel(shift_sel),
        .output_wave(noise_wave)       // Tạo nhiễu từ sóng
    );

    // Lựa chọn sóng cuối cùng (sóng đã chọn + nhiễu nếu có)
    assign final_wave = noise_enable ? noise_wave : selected_wave;

    // Đưa sóng ra ngoài
    assign waveform_out = final_wave;
	 assign waveform_fir_out = filtered_wave; 

endmodule