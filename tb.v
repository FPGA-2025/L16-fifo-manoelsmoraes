`timescale 1ns/1ps

module tb();

    reg clk = 0;
    reg rstn;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;

    reg [10:0] file_data [0:8];

    fifo f(
        .clk(clk),
        .rstn(rstn),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #1 clk = ~clk;


    integer i;
    initial begin
        $monitor("rstn=%b, wr_en=%b, rd_en=%b, data_in=%b, data_out=%b, full=%b, empty=%b", 
                    rstn, wr_en, rd_en, data_in, data_out, full, empty);

        $readmemb("teste.txt", file_data);
        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        for (i = 0; i < 9; i = i + 1) begin
            rstn = file_data[i][10];
            wr_en = file_data[i][9];
            rd_en = file_data[i][8];
            data_in = file_data[i][7:0];
            #2;
        end

         $finish;         
    end
endmodule