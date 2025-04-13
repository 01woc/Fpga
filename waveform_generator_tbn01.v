`timescale 1ns / 1ps

module waveform_generator_tbn01;

    // Khai báo các tín hiệu
    reg clk;
    reg reset;
    reg [3:0] switches;
    reg button_freq_inc;
    reg button_freq_dec;
    reg [2:0] waveform_select;
    reg noise_enable;
    reg [7:0] duty_cycle;
    reg [1:0] shift_sel;
    wire [23:0] waveform_out;
	wire [23:0] waveform_fir_out;
    // Khởi tạo module waveform_generator
    waveform_generator uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .button_freq_inc(button_freq_inc),
        .button_freq_dec(button_freq_dec),
        .waveform_select(waveform_select),
        .noise_enable(noise_enable),
        .shift_sel(shift_sel),
        .duty_cycle(duty_cycle),
        .waveform_out(waveform_out),
		  .waveform_fir_out(waveform_fir_out)
    );

    // Tạo xung clock với chu kỳ 10ns (T = 10ns, f = 100MHz)
    always #10 clk = ~clk;

    // Khởi tạo testbench
    initial begin
        // Khởi tạo tín hiệu đầu vào
        clk = 0;
        reset = 1;
        switches = 4'b0000;
        button_freq_inc = 0;
        button_freq_dec = 0;
        waveform_select = 3'b000;  // Chọn sóng Sin ban đầu
        noise_enable = 0;          // Tắt nhiễu ban đầu
        duty_cycle = 8'd50;        // Biên độ sóng vuông
        shift_sel = 2'b00;

        // Reset hệ thống
        #20 reset = 0;

        // Kiểm tra từng dạng sóng và bật/tắt nhiễu
        #200000 waveform_select = 3'b000; // Chọn sóng Sin
        #8000000 noise_enable = 1; shift_sel = 2'b01;
		  #8000000 shift_sel = 2'b11;
        #8000000 noise_enable = 0;
    	/*
			#100000 waveform_select = 3'b001; // Chọn sóng Vuông
        #4000000 noise_enable = 1; shift_sel = 2'b11;
        #4000000 noise_enable = 0;
	
        #400000 waveform_select = 3'b010; // Chọn sóng Tam giác
        #4000000 noise_enable = 1; shift_sel = 2'b11;
        #4000000 noise_enable = 0;
        
        #400000 waveform_select = 3'b011; // Chọn sóng ECG
		  #4000000 noise_enable = 1; shift_sel = 2'b11;
		  #4000000 noise_enable = 0;
  
        
        #100000 waveform_select = 3'b100; // Chọn sóng Răng cưa
        #4000000 noise_enable = 1; shift_sel = 2'b11;
        #4000000 noise_enable = 0;

        // Kiểm tra thay đổi tần số
        #100000 button_freq_inc = 1;
        #100000 button_freq_inc = 0;
        #100000 button_freq_dec = 1;
        #100000 button_freq_dec = 0;
*/
        // Kết thúc mô phỏng
        #100000 $finish;
    end

endmodule
