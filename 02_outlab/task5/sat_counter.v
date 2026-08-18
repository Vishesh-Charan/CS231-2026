module sat_counter (
    input wire clk,
    input wire rst,
    input wire up,
    input wire down,
    output reg [3:0] count
);
    // Design this module yourself, following the pattern from Task 3/4:
    // a combinational block (a wire) computes the next value of count,
    // and a sequential block registers it on the clock edge.
    //
    // Behavior:
    //   - synchronous rst forces count to 0, overriding everything else
    //   - if up=1 and down=0: count increments, but saturates at 15 (stays
    //     at 15 instead of wrapping to 0)
    //   - if down=1 and up=0: count decrements, but saturates at 0 (stays
    //     at 0 instead of wrapping to 15)
    //   - if up and down are equal (00 or 11): count holds its value
    wire [3:0] expected;
    wire [3:0] num;
    wire[3:0] sum;
    assign expected[0]=(up^down) ? 1:0;
    assign expected[3:1]=3'b000;
    assign num[3:0]=down? expected[3:0]^4'b1111:expected[3:0];
    assign sum= count+((down&&count!=4'b0000) ? (num+4'b0001):((up&&count!=4'b1111) ? num:4'b0000));
    always @(posedge clk ) begin
        if(rst) begin
            count<=4'b0000;
        end
        else begin
            count<=sum;
        end
    end


endmodule
