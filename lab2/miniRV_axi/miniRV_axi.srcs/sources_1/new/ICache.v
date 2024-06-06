`timescale 1ns / 1ps

module ICache(
    input  wire         cpu_clk,
    input  wire         cpu_rst,        // high active
    // Interface to CPU
    input  wire         inst_rreq,
    input  wire [31:0]  inst_addr,
    output reg          inst_valid,
    output reg  [31:0]  inst_out,
    // Interface to Read Bus
    input  wire         mem_rrdy,
    output reg  [ 3:0]  mem_ren,
    output reg  [31:0]  mem_raddr,
    input  wire         mem_rvalid,
    input  wire [`BLK_SIZE-1:0] mem_rdata
);

    localparam IDLE  = 2'b00;
    localparam STAT0 = 2'b01;
    localparam STAT1 = 2'b11;
    reg [1:0] state, nstat;

    always @(posedge cpu_clk or posedge cpu_rst) begin
        state <= cpu_rst ? IDLE : nstat;
    end

    always @(*) begin
        case (state)
            IDLE:    nstat = inst_rreq ? (mem_rrdy ? STAT1 : STAT0) : IDLE;
            STAT0:   nstat = mem_rrdy ? STAT1 : STAT0;
            STAT1:   nstat = mem_rvalid ? IDLE : STAT1;
            default: nstat = IDLE;
        endcase
    end

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            inst_valid <= 1'b0;
            mem_ren    <= 4'h0;
        end else begin
            case (state)
                IDLE: begin
                    inst_valid <= 1'b0;
                    mem_ren    <= (inst_rreq & mem_rrdy) ? 4'hF : 4'h0;
                    mem_raddr  <= inst_rreq ? inst_addr : 32'h0;
                end
                STAT0: begin
                    mem_ren    <= mem_rrdy ? 4'hF : 4'h0;
                end
                STAT1: begin
                    mem_ren    <= 4'h0;
                    inst_valid <= mem_rvalid ? 1'b1 : 1'b0;
                    inst_out   <= mem_rvalid ? mem_rdata[31:0] : 32'h0;
                end
                default: begin
                    inst_valid <= 1'b0;
                    mem_ren    <= 4'h0;
                end
            endcase
        end
    end

endmodule
