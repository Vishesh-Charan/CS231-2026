// ================================================================
// Part A: CRC-8 (fixed width=8, polynomial=0xD5)
// ================================================================

module crc8_update (
    input  [7:0] crc_in,
    input        data_bit,
    output [7:0] crc_out
);

    // TODO
    wire feedback;
    assign feedback= crc_in[7]^data_bit;
    assign crc_out= {crc_in[6:0],1'b0}^((feedback==1'b1)?8'hD5:8'h0);

endmodule


module crc8_serial (
    input        clk,
    input        rst,
    input        data_bit,
    input        data_valid,
    input        data_last,
    output reg[7:0] crc,
    output       crc_valid
);

    // TODO
    wire [7:0] crc_old;
    wire [7:0] crc_out;
    assign crc_old=crc;
    assign crc_valid=data_last;
    
    crc8_update uu(
        .crc_in(crc_old),
        .data_bit(data_bit),
        .crc_out(crc_out)
    );
    always @(posedge clk ) begin
        if(rst) begin
            crc<=8'hFF;
        end
        else begin
            if(data_valid) begin
                crc<=crc_out;
            end
        end
    end



endmodule


// ================================================================
// Part B: Parametric CRC (general WIDTH and POLY)
// ================================================================

module crc_update #(
    parameter             WIDTH = 8,
    parameter [WIDTH-1:0] POLY = 8'hD5
) (
    input  [WIDTH-1:0] crc_in,
    input              data_bit,
    output [WIDTH-1:0] crc_out
);

    // TODO
    wire feedback;
    assign feedback= crc_in[WIDTH-1]^data_bit;
    assign crc_out= {crc_in[WIDTH-2:0],1'b0}^((feedback==1'b1)?POLY:{WIDTH{1'b0}});
endmodule


module crc_serial #(
    parameter             WIDTH = 8,
    parameter [WIDTH-1:0] POLY = 8'hD5,
    parameter [WIDTH-1:0] INIT = {WIDTH{1'b1}}
) (
    input                  clk,
    input                  rst,
    input                  data_bit,
    input                  data_valid,
    input                  data_last,
    output reg[WIDTH-1:0]     crc,
    output                 crc_valid
);

    // TODO
    wire [WIDTH-1:0] crc_old;
    wire [WIDTH-1:0] crc_out;
    assign crc_old=crc;
    assign crc_valid=data_last;
    
    crc_update #(
        .WIDTH(WIDTH),
        .POLY(POLY)
    ) 
    uu(
        .crc_in(crc_old),
        .data_bit(data_bit),
        .crc_out(crc_out)
    );
    always @(posedge clk ) begin
        if(rst) begin
            crc<=INIT;
        end
        else begin
            if(data_valid) begin
                crc<=crc_out;
            end
        end
    end
endmodule


// ================================================================
// Part C: Parallel CRC (DATA_WIDTH bits per clock)
// ================================================================

module crc_parallel #(
    parameter                    WIDTH      = 8,
    parameter [WIDTH-1:0]        POLY       = 8'hD5,
    parameter                    DATA_WIDTH = 8
) (
    input  [WIDTH-1:0] crc_in,
    input  [DATA_WIDTH-1:0] data,
    output [WIDTH-1:0] crc_out
);

    // TODO
    wire[WIDTH-1:0] crc_ini[0:DATA_WIDTH-1];
    wire[WIDTH-1:0] crc_outi[0:DATA_WIDTH-1];
    assign crc_ini[0]=crc_in;
    genvar i;
    generate
        for (i = 0;i<DATA_WIDTH ;i=i+1 ) begin
            crc_update #(
        .WIDTH(WIDTH),
        .POLY(POLY)
    ) 
    uu(
        .crc_in(crc_ini[i]),
        .data_bit(data[i]),
        .crc_out(crc_outi[i])
    );
        end
    endgenerate
    assign crc_out=crc_outi[DATA_WIDTH-1];
endmodule


module crc_parallel_serial #(
    parameter                    WIDTH      = 8,
    parameter [WIDTH-1:0]        POLY       = 8'hD5,
    parameter [WIDTH-1:0]        INIT       = {WIDTH{1'b1}},
    parameter                    DATA_WIDTH = 8
) (
    input                     clk,
    input                     rst,
    input  [DATA_WIDTH-1:0]  data,
    input                     data_valid,
    input                     data_last,
    output reg[WIDTH-1:0]        crc,
    output                    crc_valid
);

    // TODO
     wire [WIDTH-1:0] crc_old;
    wire [WIDTH-1:0] crc_out;
    assign crc_old=crc;
    assign crc_valid=data_last;
    
    crc_parallel #(
        .WIDTH(WIDTH),
        .POLY(POLY),
        .DATA_WIDTH(DATA_WIDTH)
    ) 
    uu(
        .crc_in(crc_old),
        .data(data),
        .crc_out(crc_out)
    );
    always @(posedge clk ) begin
        if(rst) begin
            crc<=INIT;
        end
        else begin
            if(data_valid) begin
                crc<=crc_out;
            end
        end
    end
endmodule