module control(
    input wire clk,
    input wire reset,
    input wire [3:0] switches,  // Công tắc điều khiển tần số và biên độ
    input wire button_freq_inc, // Nút tăng tần số
    input wire button_freq_dec, // Nút giảm tần số
    output reg [31:0] phase_step, // Thay đổi từ frequency thành phase_step
    output reg [7:0] amplitude   // Biên độ điều khiển
);

    reg [31:0] base_phase_step;

    // Khởi tạo giá trị mặc định
    initial begin
        base_phase_step = 32'd10000; // Giá trị phase_step mặc định
        phase_step = base_phase_step;
        amplitude = 8'd255; // Biên độ mặc định (tối đa)
    end

    // Điều khiển phase_step và biên độ từ công tắc và nút bấm
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            base_phase_step <= 32'd10000; // Reset phase_step về giá trị mặc định
            phase_step <= base_phase_step;
            amplitude <= 8'd255; // Reset biên độ về giá trị tối đa
        end else begin
            // Điều chỉnh phase_step khi nhấn nút
            if (button_freq_inc)
                base_phase_step <= base_phase_step + 32'd1000; // Tăng step
            if (button_freq_dec)
                base_phase_step <= base_phase_step - 32'd1000; // Giảm step

            // Điều chỉnh phase_step theo giá trị công tắc (switches) với sự điều chỉnh nhỏ hơn
            phase_step <= base_phase_step + (switches * 32'd100);

            // Điều chỉnh biên độ theo switches (0 ~ 255)
            amplitude <= (switches == 4'b0000) ? 8'd255 : (switches * 8'd16);
        end
    end

endmodule
