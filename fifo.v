module fifo (
    input wire clk,
    input wire rstn,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);

    reg [7:0] mem [0:3];
    reg [1:0] w_ptr, r_ptr;
    reg [2:0] count;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 8'bx;
        end else begin
            // Escrita
            if (wr_en && !full) begin
                mem[w_ptr] <= data_in;
                w_ptr <= w_ptr + 1;
                count <= count + 1;
            end

            // Leitura
            if (rd_en && !empty) begin
                data_out <= mem[r_ptr];
                r_ptr <= r_ptr + 1;
                count <= count - 1;
            end else if (rd_en && empty) begin
                data_out <= 8'bx; // Leitura inválida
            end else if (!rd_en) begin
                data_out <= 8'bx; // Não está lendo
            end

            // Atualiza sinais de status com base na operação atual
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1; // Apenas escrita
                2'b01: count <= count - 1; // Apenas leitura
                2'b11: count <= count;     // Escrita e leitura ao mesmo tempo
                default: count <= count;
            endcase

            // Atualiza flags
            full <= ((count == 3 && wr_en && !rd_en) || (count == 4 && !rd_en));
            empty <= ((count == 1 && rd_en && !wr_en) || (count == 0 && !wr_en));
        end
    end

endmodule
