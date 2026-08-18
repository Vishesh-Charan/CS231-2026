// Corrected versions of reg_bug1..reg_bug4 from buggy_regs.v.
// Each module should behave like Task 3's loadable_reg: synchronous reset
// takes priority over load, and q holds its value when load is low.

module reg_bug1_fixed (
    input wire clk,
    input wire rst,
    input wire load,
    input wire d,
    output reg q
);
reg next_q;

    always @(*) begin
        if (load)
            next_q = d;
        else
            next_q = q;
    end

    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= next_q;
    end
endmodule

module reg_bug2_fixed (
    input wire clk,
    input wire rst,
    input wire load,
    input wire d,
    output reg q
);
reg next_q;

    always @(*) begin
        if (load)
            next_q = d;
        else
            next_q = q;
    end

    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= next_q;
    end
endmodule

module reg_bug3_fixed (
    input wire clk,
    input wire rst,
    input wire load,
    input wire d,
    output reg q
);

endmodule

module reg_bug4_fixed (
    input wire clk,
    input wire rst,
    input wire load,
    input wire d,
    output reg q
);

endmodule
