`timescale 1ns / 1ps

// This is a silly divider
module divider (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] x,
    input  wire [7:0] y,
    input  wire       start,
    output wire [7:0] z,
    output reg  [7:0] r,
    output reg        busy
);

reg x_sign;
reg [7:0] x_abs;
reg [7:0] y_abs;
wire [7:0] y_abs_inv;

reg [13:0] temp_r;
reg [6:0] temp_z;
reg sign;
reg [7:0] cnt;

assign y_abs_inv = ~y_abs + 1'b1;
assign z = {sign, temp_z};

always @(posedge clk or negedge rst) begin // cnt
    if (rst == 1'b1) begin
        cnt <= 8'h0;
    end
    else if (busy == 1'b0) begin
        cnt <= 8'h0;
    end
    else begin
        if(cnt == 8'hff) begin cnt <= 8'h0; end
        else begin cnt <= cnt + 8'h01; end
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
        if (cnt == 8'd8) begin
            busy <= 1'b0;
        end
        else begin 
            busy <= busy;
        end
    end
end

always @(posedge clk or negedge rst) begin // abs
    if (rst == 1'b1) begin 
        x_abs <= 7'b0;
        y_abs <= 7'b0;
        x_sign <= 1'b0;
    end 
    else if (busy == 1'b0) begin 
        if(start == 1'b1) begin 
            x_abs <= {1'b0, x[6:0]};
            y_abs <= {1'b0, y[6:0]};
            x_sign <= x[7];
        end
        else begin 
            x_abs <= x_abs;
            y_abs <= y_abs;
            x_sign <= x_sign;
        end
    end
end

always @(posedge clk or negedge rst) begin
    if (rst == 1'b1) begin 
        r <= 8'b0;
    end 
    else begin
        r <= {x_sign,temp_r[12:6]};
    end
end

always @(posedge clk or negedge rst) begin // main
    if (rst == 1'b1) begin 
        temp_r <= 14'b0;
        sign <= 1'b0;
        temp_z <= 8'b0;
    end
    else if (busy == 1'b0) begin 
        if(start == 1'b1) begin 
            sign <= x[7] ^ y[7];
            temp_r <= {7'b0, x[6:0]};
            temp_z <= 8'b0;
        end
    end
    else begin // busy == 1'b1
        if (cnt == 8'h0) begin
            temp_r <= (temp_r + {y_abs_inv, 6'b0});
        end
        else if (cnt == 8'd7) begin
            if(temp_r[13] == 1'b0) begin
                temp_r <= temp_r;
                temp_z <= temp_z + 7'h01;
            end
            else begin 
                temp_r <= temp_r + {y_abs, 6'b0}; // retrieve r at last
                temp_z <= temp_z;
            end
        end
        else if (cnt == 8'd8) begin end
        else begin
            if(temp_r[13] == 1'b0) begin
                temp_r <= (temp_r << 1'b1) + {y_abs_inv, 6'b0};
                temp_z <= (temp_z + 7'h01) << 1'b1;
            end
            else begin 
                temp_r <= (temp_r << 1'b1) + {y_abs, 6'b0};
                temp_z <= (temp_z + 7'h00) << 1'b1;
            end
        end
    end
end
	
endmodule
