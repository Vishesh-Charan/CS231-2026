module fourbit_adder (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
  wire[3:0] carry;
  assign carry[0]=cin;
  adder uu0(
    .a(a[0]),
    .b(b[0]),
    .cin(carry[0]),
    .cout(carry[1]),
    .sum(sum[0])
  );
  adder uu1(
    .a(a[1]),
    .b(b[1]),
    .cin(carry[1]),
    .cout(carry[2]),
    .sum(sum[1])
  );
  adder uu2(
    .a(a[2]),
    .b(b[2]),
    .cin(carry[2]),
    .cout(carry[3]),
    .sum(sum[2])
  );
  adder uu3(
    .a(a[3]),
    .b(b[3]),
    .cin(carry[3]),
    .cout(cout),
    .sum(sum[3])
  );
  
endmodule