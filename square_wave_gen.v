module square_wave_gen (
    input clk,
    input reset,
    input [31:0] phase_acc, // Đổi từ frequency thành phase_step
    input [7:0] duty_cycle,  // Điều chỉnh chu kỳ làm việc
    output reg [23:0] square_wave
);
    
  
    reg [23:0] square_lut10 [0:1023];
    reg [23:0] square_lut25 [0:1023];
    reg [23:0] square_lut50 [0:1023];
    
    // Load dữ liệu LUT từ file
    initial begin
        $readmemh("D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/square_lut10.dump", square_lut10);
        $readmemh("D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/square_lut25.dump", square_lut25);
        $readmemh("D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/square_lut50.dump", square_lut50);
    end
    

    
    // Tính địa chỉ LUT
    wire [9:0] lut_addr;
    assign lut_addr = phase_acc[31:22];

    // Chọn giá trị từ LUT dựa vào duty_cycle
    always @(posedge clk) begin
        case (duty_cycle)
            8'h00: square_wave <= square_lut10[lut_addr];
            8'h01: square_wave <= square_lut25[lut_addr];
            default: square_wave <= square_lut50[lut_addr];
        endcase
    end
    
endmodule
