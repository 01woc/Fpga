module wm8731_config (
    input wire clk,         // Clock hệ thống
    input wire reset,       // Reset tín hiệu thấp
    output wire i2c_scl,    // Clock I2C
    inout wire i2c_sda,     // Dữ liệu I2C
    output reg config_done, // Cấu hình hoàn tất
    input wire [23:0] waveform_out // Dữ liệu đầu vào
);

    // Các địa chỉ thanh ghi của WM8731
    localparam REG_LEFT_LINE_IN   = 8'h00;
    localparam REG_RIGHT_LINE_IN  = 8'h02;
    localparam REG_LEFT_HEADPHONE = 8'h04;
    localparam REG_RIGHT_HEADPHONE = 8'h06;
    localparam REG_ANALOG_PATH    = 8'h08;
    localparam REG_DIGITAL_PATH   = 8'h0A;
    localparam REG_POWER_DOWN     = 8'h0C;
    localparam REG_DIGITAL_FORMAT = 8'h0E;
    localparam REG_SAMPLE_RATE    = 8'h10;
    localparam REG_ACTIVE_CTRL    = 8'h12;
    localparam REG_RESET          = 8'h1E;

    // Dữ liệu cấu hình
    reg [15:0] config_data [0:9];
    initial begin
        config_data[0] = {REG_RESET, 9'h00}; // Reset WM8731
        config_data[1] = {REG_LEFT_LINE_IN, 9'h17}; // Đầu vào line-in
        config_data[2] = {REG_RIGHT_LINE_IN, 9'h17};
        config_data[3] = {REG_ANALOG_PATH, 9'h12}; // Đường tín hiệu analog
        config_data[4] = {REG_DIGITAL_PATH, 9'h06}; // Đường tín hiệu digital
        config_data[5] = {REG_POWER_DOWN, 9'h00}; // Bật tất cả các khối
        config_data[6] = {REG_DIGITAL_FORMAT, 9'h04}; // I2S 24-bit
        config_data[7] = {REG_SAMPLE_RATE, 9'h00}; // 48kHz
        config_data[8] = {REG_ACTIVE_CTRL, 9'h01}; // Kích hoạt codec
    end

    // FSM điều khiển cấu hình
    reg [3:0] state;
    reg [3:0] index;
    reg start_i2c;
    wire done_i2c;

    localparam IDLE = 0, SEND = 1, WAIT = 2, DONE = 3;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= IDLE;
            index <= 0;
            start_i2c <= 0;
            config_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    start_i2c <= 1;
                    state <= SEND;
                end
                SEND: begin
                    if (done_i2c) begin
                        start_i2c <= 0;
                        state <= WAIT;
                    end
                end
                WAIT: begin
                    if (!done_i2c) begin
                        if (index < 9) begin
                            index <= index + 1;
                            start_i2c <= 1;
                            state <= SEND;
                        end else begin
                            config_done <= 1;
                            state <= DONE;
                        end
                    end
                end
                DONE: begin
                    // Giữ trạng thái hoàn tất
                end
            endcase
        end
    end

    // Module I2C để giao tiếp với WM8731
    i2c_master i2c_inst (
        .clk(clk),
        .reset(reset),
        .start(start_i2c),
        .dev_addr(7'h34), // Địa chỉ của WM8731 (7-bit)
        .reg_addr(config_data[index][15:8]),
        .data_in(waveform_out), // Gửi dữ liệu 24-bit
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda),
        .done(done_i2c)
    );


endmodule