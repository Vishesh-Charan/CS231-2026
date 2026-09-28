module crc8_update (
    input  [7:0] crc_in,
    input        data_bit,
    output [7:0] crc_out
);
    wire feedback;
    assign feedback = crc_in[7] ^ data_bit;
    assign crc_out  = feedback ? ({crc_in[6:0], 1'b0} ^ 8'hD5)
                               :  {crc_in[6:0], 1'b0};
    // TODO

endmodule


module crc8_serial (
    input        clk,
    input        rst,
    input        data_bit,
    input        data_valid,
    input        data_last,
    output [7:0] crc,
    output       crc_valid
);
    reg [7:0] crc_in;
    wire [7:0] crc_upin;
    assign crc_upin=crc_in;
    wire [7:0] crc_out;
    reg valid;
    crc8_update uu(
        .crc_in(crc_upin),
        .data_bit(data_bit),
        .crc_out(crc_out)
    );
    always @(posedge clk ) begin
        if(rst) begin
            crc_in<=8'hFF;
            valid<=1'b0;
        end
        else begin
            valid<=1'b0;
            if(data_valid) begin
                crc_in<=crc_out;
            end
            if(data_last) begin
                valid<=1'b1;            
            end
        end
    end
    assign crc=crc_in;
    assign crc_valid=valid;
    
    // TODO

endmodule
