module decoder (
    input  [4:0] encoded,
    input        enable,
    output [3:0] data,
    output       valid
);

    // TODO: Implement the inverse 4B/5B mapping using combinational logic.
    // valid should indicate whether encoded is a valid data codeword.
    wire [3:0] out;
    assign out[3] = (encoded[4] & ~encoded[2]) |
                (encoded[1] & ~encoded[3]) |
                (encoded[3] & encoded[2] & ~encoded[1]);

    assign out[2] = (encoded[1] & ~encoded[4]) |
                (encoded[3] & encoded[2] & ~encoded[1]) |
                (encoded[3] & encoded[1] & ~encoded[2]);

    assign out[1] = (encoded[2] & ~encoded[4]) |
                (encoded[2] & ~encoded[3]) |
                (encoded[2] & ~encoded[1]);

    assign out[0] = encoded[0];

    assign valid = ((~encoded[4] & encoded[3] & encoded[1]) |
               (~encoded[4] & encoded[3] & ~encoded[2] & encoded[0]) |
               (encoded[4] & ~encoded[2] & encoded[1]) |
               (encoded[4] & encoded[2] & ~encoded[1]) |
               (encoded[4] & encoded[2] & encoded[1] & ~encoded[0]) |
               (encoded[4] & ~encoded[3] & encoded[2] & encoded[1] & encoded[0]))&enable;
    assign data= valid?out:4'b0;
endmodule
