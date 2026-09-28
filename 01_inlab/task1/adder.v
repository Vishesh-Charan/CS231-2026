module adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire cout,
    output wire sum
);
    assign cout=a&b|((~a&b)|(a&~b))&cin;
    assign sum=(((~a&b)|(a&~b))&(~cin))|(((a|~b)&(~a|b))&cin);

endmodule