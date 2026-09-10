module encoder (
    input  [3:0] data,
    input        enable,
    output [4:0] encoded
);

    // TODO: Implement the 4B/5B encoder using combinational logic.
    // Derive the output equations using Karnaugh maps.
    wire [4:0] expected;
    assign expected[4] = data[3] | (~data[2] & data[1]) | (~data[2] & ~data[0]);
    assign expected[3] = data[2] | (~data[3] & ~data[1]);
    assign expected[2] = data[1] | (~data[3] & ~data[2] & ~data[0]);
    assign expected[1] = (data[3] & ~data[2]) | (~data[3] & data[2]) |
                         (data[2] & ~data[1]) | (~data[1] & ~data[0]);
    assign expected[0] = data[0];
    assign encoded= (enable)?expected:5'b0;

endmodule
