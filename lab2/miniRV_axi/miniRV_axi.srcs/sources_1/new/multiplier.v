`timescale 1ns / 1ps

module multiplier (
    input  wire         clk,
	input  wire         rst,        // high active
	input  wire [31:0]  x,          // multiplicand
	input  wire [31:0]  y,          // multiplier
	input  wire         start,      // 1 - multiplication should begin
	output reg  [63:0]  z,          // product
	output reg          busy        // 1 - performing multiplication; 0 - multiplication ends
);

reg [64:0] temp_z;
reg [31:0] x_r;
reg [31:0] y_r;
wire [31:0] x_inv;
wire [1:0] check;

assign x_inv = ~x_r + 32'h1;
assign check = temp_z[1:0];

// counter
reg [31:0] cnt;
always @(posedge clk or negedge rst) begin // cnt
    if (rst == 1'b1) begin
        cnt <= 32'h0;
    end
    else if (busy == 1'b0) begin
        cnt <= 32'h0;
    end
    else begin
        if(cnt == 32'hffffffff) begin cnt <= 32'h0; end
        else begin cnt <= cnt + 32'h1; end
    end
end

always @(posedge clk or negedge rst) begin // busy
    if (rst == 1'b1) begin 
        busy <= 1'b0;
    end 
    else if (busy == 1'b0) begin 
        if(start == 1'b1) begin 
            busy <= 1'b1;
        end
        else begin 
            busy <= busy;
        end
    end
    else begin
        if (cnt == 32'd32) begin 
            busy <= 1'b0;
        end
        else begin 
            busy <= busy;
        end
    end
end

always @(posedge clk or negedge rst) begin // save
    if (rst == 1'b1) begin 
        x_r <= 32'b0;
        y_r <= 32'b0;
    end 
    else if (busy == 1'b0) begin 
        if(start == 1'b1) begin 
            x_r <= x;
            y_r <= y;
        end
        else begin 
            x_r <= x_r;
            y_r <= y_r;
        end
    end
end

always @(posedge clk or negedge rst) begin // main
    if (rst == 1'b1) begin 
        temp_z <= 65'b0;
    end
    else if (busy == 1'b0) begin 
        if(start == 1'b1) begin 
            temp_z <= {32'h0, y, 1'b0};
        end
    end
    else if(cnt == 32'd32) begin
        z <= temp_z[64:1];
//        $display("temp_z: %h.", temp_z[64:1]);
    end
    else begin // busy == 1'b1
        if (temp_z[1:0] == 2'b01) begin
            temp_z <= ($signed(temp_z +  {x_r, 33'b0}) >>> 1'b1);
        end
        else if(temp_z[1:0] == 2'b10) begin 
            temp_z <= ($signed(temp_z +  {x_inv, 33'b0}) >>> 1'b1);
        end
        else begin
            temp_z <= ($signed(temp_z) >>> 1'b1);
        end
//        $display("cnt: %d.", cnt);
//        $display("temp_z: %b.", temp_z);
//        z <= temp_z[64:1];
    end
end

    // TODO
    
    
endmodule
