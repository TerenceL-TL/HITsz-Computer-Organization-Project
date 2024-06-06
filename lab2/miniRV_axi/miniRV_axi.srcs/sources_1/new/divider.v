`timescale 1ns / 1ps

module divider (
    input  wire         clk,
    input  wire         rst,        // high active
    input  wire [31:0]  x,          // dividend
    input  wire [31:0]  y,          // divisor
    input  wire         start,      // 1 - division should begin
    output reg  [31:0]  z,          // quotient
    output reg  [31:0]  r,          // remainder
    output reg          busy        // 1 - performing division; 0 - division ends
);

reg x_sign;
reg [31:0] x_abs;
reg [31:0] y_abs;
wire [31:0] y_abs_inv;

reg [61:0] temp_r;
reg [30:0] temp_z;
reg sign;
reg [31:0] cnt;

assign y_abs_inv = ~y_abs + 1'b1;

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

always @(posedge clk or negedge rst) begin // abs
    if (rst == 1'b1) begin 
        x_abs <= 32'b0;
        y_abs <= 32'b0;
        x_sign <= 1'b0;
    end 
    else if (busy == 1'b0) begin 
        if(start == 1'b1) begin 
            x_abs <= {1'b0, x[30:0]};
            y_abs <= {1'b0, y[30:0]};
            x_sign <= x[31];
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
        r <= 32'b0;
        z <= 32'b0;
    end 
    else begin
        r <= {x_sign,temp_r[60:30]};
        z <= {sign, temp_z};
    end
end

always @(posedge clk or negedge rst) begin // main
    if (rst == 1'b1) begin 
        temp_r <= 62'b0;
        sign <= 1'b0;
        temp_z <= 31'b0;
    end
    else if (busy == 1'b0) begin 
        if(start == 1'b1) begin 
            sign <= x[31] ^ y[31];
            temp_r <= {31'b0, x[30:0]};
            temp_z <= 31'b0;
        end
    end
    else begin // busy == 1'b1
        if (cnt == 32'h0) begin
            temp_r <= (temp_r + {y_abs_inv, 30'b0});
        end
        else if (cnt == 32'd31) begin
            if(temp_r[61] == 1'b0) begin
                temp_r <= temp_r;
                temp_z <= temp_z + 31'h1;
            end
            else begin 
                temp_r <= temp_r + {y_abs, 30'b0}; // retrieve r at last
                temp_z <= temp_z;
            end
        end
        else if (cnt == 32'd32) begin end
        else begin
            if(temp_r[61] == 1'b0) begin
                temp_r <= (temp_r << 1'b1) + {y_abs_inv, 30'b0};
                temp_z <= (temp_z + 31'h1) << 1'b1;
            end
            else begin 
                temp_r <= (temp_r << 1'b1) + {y_abs, 30'b0};
                temp_z <= (temp_z + 31'h0) << 1'b1;
            end
        end
    end
end



    // TODO
    

endmodule
