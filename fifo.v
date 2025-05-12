module fifo (
    input wire clk,
    input wire rstn,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output wire full,
    output wire empty
);

    reg [7:0] mem [0:3];
    reg [1:0] w_ptr, r_ptr;
    // reg [2:0] count;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            w_ptr <= 0;
                           
        end else begin
            // Escrita
            if (wr_en && !full) begin
                mem[w_ptr] <= data_in;
                w_ptr <= w_ptr + 1;
              //  count <= count + 1;
            end

            // Atualiza flags
           // full <= ((count == 3 && wr_en && !rd_en) || (count == 4 && !rd_en));
          //  empty <= ((count == 1 && rd_en && !wr_en) || (count == 0 && !wr_en));
        end
    end

     always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            r_ptr <= 0;
            data_out <= 8'bx;
        end else begin
            // Leitura
            if (rd_en && !empty) begin
                data_out <= mem[r_ptr];
                r_ptr <= r_ptr + 1;
               // count <= count - 1;
            
            end

            // Atualiza flags
           // full <= ((count == 3 && wr_en && !rd_en) || (count == 4 && !rd_en));
          //  empty <= ((count == 1 && rd_en && !wr_en) || (count == 0 && !wr_en));
        end
    end

    assign empty = (r_ptr == w_ptr);
    assign full = (w_ptr + 1 == r_ptr) || (w_ptr == 3 && r_ptr == 0 );

endmodule
