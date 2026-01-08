module sha3_core (
    // Note: Removemos as entradas físicas (start, data_in).
    // Só precisamos do Clock do sistema.
    input wire clk
);

    // --- SINAIS INTERNOS ---
    wire reset_n;      // Vamos controlar o reset via software também
    reg [31:0] data_in; // O dado que virá do JTAG
    wire start;        // Sinal de disparo vindo do JTAG
    reg [31:0] data_out;
    reg ready;
    reg done;

    // --- PONTE JTAG (VIRTUAL JTAG INTEL) ---
    // Isso cria o "tubo" de comunicação com o Arduino
    
    wire [31:0] jtag_data_out; // Dados saindo da FPGA
    wire tck, tdi;
    wire virtual_state_udr; // Update Data Register (Gatilho)
    wire virtual_state_sdr; // Shift Data Register (Deslocamento)
    
    // Instância do IP Virtual JTAG
    sld_virtual_jtag #(
        .sld_auto_instance_index("YES"),
        .sld_instance_index(0),
        .sld_ir_width(4)
    ) v_jtag_inst (
        .virtual_state_udr(virtual_state_udr),
        .virtual_state_sdr(virtual_state_sdr),
        .tdi(tdi),
        .tck(tck)
    );

    // Lógica para capturar os dados vindos do Arduino (Serial -> Paralelo)
    always @(posedge tck) begin
        if (virtual_state_sdr) begin
            // Shift Register: Entra bit a bit
            data_in <= {tdi, data_in[31:1]};
        end
    end

    // O sinal "start" dispara quando o Arduino termina de enviar (Update)
    assign start = virtual_state_udr;
    
    // Reset fixo por enquanto (ativo alto ou baixo dependendo da lógica)
    assign reset_n = 1'b1; 

    // --- MÁQUINA DE ESTADOS (SEU CÓDIGO ORIGINAL ADAPTADO) ---
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
                    // Lógica Dummy (Loopback com XOR)
                    // Aqui provamos que o dado foi e voltou
                    data_out <= data_in ^ 32'hDEADBEEF; 
                    state <= FINISHED;
                end

                FINISHED: begin
                    done <= 1'b1;
                    // Volta para IDLE automaticamente após um ciclo
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule