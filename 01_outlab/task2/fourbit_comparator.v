module fourbit_comparator (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire eq,
    output wire gt,
    output wire lt
);
wire [3:0] gtt;
wire [3:0] ltt;
wire [3:0] eqt;

comparator utt [3:0] (.a(a[3:0]),.b(b[3:0]),.eq(eqt[3:0]),.gt(gtt[3:0]),.lt(ltt[3:0]));
assign eq=eqt[0]&eqt[1]&eqt[2]&eqt[3];
assign gt=gtt[3]|eqt[3]&gtt[2]|eqt[3]&eqt[2]&gtt[1]|eqt[3]&eqt[2]&eqt[1]&gtt[0];
assign lt=ltt[3]|eqt[3]&ltt[2]|eqt[3]&eqt[2]&ltt[1]|eqt[3]&eqt[2]&eqt[1]&ltt[0];
endmodule