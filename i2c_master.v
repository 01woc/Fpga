module i2c_master (
    input wire clk,          // Clock hệ thống
    input wire reset,        // Reset tín hiệu thấp
    input wire start,        // Bắt đầu giao tiếp I2C
    input wire [6:0] dev_addr, // Địa chỉ thiết bị I2C (7-bit)
    input wire [7:0] reg_addr, // Địa chỉ thanh ghi cần ghi
    input wire [23:0] data_in, // Dữ liệu cần ghi (24-bit)
    output reg i2c_scl,      // Clock I2C
    inout wire i2c_sda,      // Dữ liệu I2C
    output reg done          // Ghi dữ liệu hoàn tất
);

    // Trạng thái FSM
    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg sda_out;
    
    // Các trạng thái FSM
    localparam IDLE       = 4'b0000,
               START      = 4'b0001,
               SEND_ADDR  = 4'b0010,
               SEND_REG   = 4'b0011,
               SEND_DATA1 = 4'b0100,  // Gửi byte cao
               SEND_DATA2 = 4'b0101,  // Gửi byte giữa
               SEND_DATA3 = 4'b0110,  // Gửi byte thấp
               STOP       = 4'b0111,
               DONE       = 4'b1000;
    
    // Trạng thái SDA (open-drain)
    assign i2c_sda = (sda_out) ? 1'bz : 1'b0;
    
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= IDLE;
            done <= 0;
            i2c_scl <= 1;
            sda_out <= 1;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        sda_out <= 0; // Start Condition
                        state <= START;
                    end
                end
                
                START: begin
                    i2c_scl <= 0;
                    shift_reg <= {dev_addr, 1'b0}; // Địa chỉ thiết bị + bit ghi
                    bit_count <= 8;
                    state <= SEND_ADDR;
                end
                
                SEND_ADDR: begin
                    if (bit_count > 0) begin
                        sda_out <= shift_reg[7]; 
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count - 1;
                    end else begin
                        state <= SEND_REG;
                        shift_reg <= reg_addr;
                        bit_count <= 8;
                    end
                end

                SEND_REG: begin
                    if (bit_count > 0) begin
                        sda_out <= shift_reg[7];
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count - 1;
                    end else begin
                        state <= SEND_DATA1;
                        shift_reg <= data_in[23:16]; // Byte cao của dữ liệu 24-bit
                        bit_count <= 8;
                    end
                end

                SEND_DATA1: begin
                    if (bit_count > 0) begin
                        sda_out <= shift_reg[7];
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count - 1;
                    end else begin
                        state <= SEND_DATA2;
                        shift_reg <= data_in[15:8]; // Byte giữa của dữ liệu 24-bit
                        bit_count <= 8;
                    end
                end

                SEND_DATA2: begin
                    if (bit_count > 0) begin
                        sda_out <= shift_reg[7];
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count - 1;
                    end else begin
                        state <= SEND_DATA3;
                        shift_reg <= data_in[7:0]; // Byte thấp của dữ liệu 24-bit
                        bit_count <= 8;
                    end
                end

                SEND_DATA3: begin
                    if (bit_count > 0) begin
                        sda_out <= shift_reg[7];
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count - 1;
                    end else begin
                        state <= STOP;
                    end
                end

                STOP: begin
                    sda_out <= 1; // Thả SDA về mức cao
                    i2c_scl <= 1;
                    state <= DONE;
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
