/*
 * Project: Open RAN PQC Accelerator
 * Module: SHA-3 / Keccak Core Wrapper
 * Target: Intel Cyclone 10 LP (Arduino Vidor 4000)
 */

module sha3_core (
    input wire clk,           // Clock do sistema
    input wire reset_n,       // Reset
    
    // Controle
    input wire start,
    output reg ready,
    output reg done,
    
    // Dados (32-bits)
    input wire [31:0] data_in,
    input wire data_valid,
    output reg [31:0] data_out
);

    // Estados
    localparam IDLE = 2'b00;
    localparam PROCESS = 2'b01;
    localparam FINISHED = 2'b10;
    
    reg [1:0] state;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            ready <= 1'b1;
            done <= 1'b0;
            data_out <= 32'h0;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 1'b1;
                    done <= 1'b0;
                    if (start) begin
                        state <= PROCESS;
                        ready <= 1'b0;
                    end
                end

                PROCESS: begin
                    // Lógica Dummy (Bypass) para teste inicial
                    if (data_valid) begin
                        data_out <= data_in ^ 32'hDEADBEEF; 
                        state <= FINISHED;
                    end
                end

                FINISHED: begin
                    done <= 1'b1;
                    if (!start) state <= IDLE;
                end
            endcase
        end
    end
endmodule