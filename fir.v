module fir (
    input clk,
    input reset,
    input signed [23:0] data_in,
    output reg signed [23:0] data_out
);

    parameter TAP_NUM = 15;

    reg signed [23:0] buffer [0:TAP_NUM-1];
    reg signed [39:0] acc [0:TAP_NUM-1];
    wire signed [15:0] taps [0:TAP_NUM-1];

    reg [3:0] buff_cnt;
    reg enable_fir;

    // Tap hệ số (Fixed-point Q1.15)
    assign taps[0]  = 16'hFC9C; // -0.0265
    assign taps[1]  = 16'h0000;
    assign taps[2]  = 16'h05A5; // 0.0441
    assign taps[3]  = 16'h0000;
    assign taps[4]  = 16'hF40C; // -0.0934
    assign taps[5]  = 16'h0000;
    assign taps[6]  = 16'h282D; // 0.3139
    assign taps[7]  = 16'h4000; // 0.5
    assign taps[8]  = 16'h282D;
    assign taps[9]  = 16'h0000;
    assign taps[10] = 16'hF40C;
    assign taps[11] = 16'h0000;
    assign taps[12] = 16'h05A5;
    assign taps[13] = 16'h0000;
    assign taps[14] = 16'hFC9C;

    integer i;
    reg signed [39:0] sum; // Khai báo sum ngoài khối always

    // Buffer control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buff_cnt <= 4'd0;
            enable_fir <= 1'b0;
        end else begin
            buff_cnt <= (buff_cnt == TAP_NUM-1) ? 4'd0 : buff_cnt + 1;
            enable_fir <= (buff_cnt == TAP_NUM-1);
        end
    end

    // Shift buffer
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < TAP_NUM; i = i + 1)
                buffer[i] <= 24'd0;
        end else begin
            buffer[0] <= data_in;
            for (i = 1; i < TAP_NUM; i = i + 1)
                buffer[i] <= buffer[i-1];
        end
    end

    // Multiply
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < TAP_NUM; i = i + 1)
                acc[i] <= 40'd0;
        end else if (enable_fir) begin
            for (i = 0; i < TAP_NUM; i = i + 1)
                acc[i] <= buffer[i] * taps[i];
        end
    end

    // Accumulate
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 24'd0;
        end else if (enable_fir) begin
            sum = 40'd0;  // Reset sum tại mỗi chu kỳ
            for (i = 0; i < TAP_NUM; i = i + 1)
                sum = sum + acc[i];  // Cộng dồn tất cả các accumulator
            data_out <= sum >>> 16;  // Chuyển giá trị sum về 24-bit sau khi tính toán
        end
    end

endmodule
