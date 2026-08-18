// TODO: 2-3 sentence written justification goes here.
// Why is `running` a reg? Why is the carry out of sec_ones naturally a
// wire, even though it's computed from values that are themselves regs?
//'running' is a reg cause we have to invert it as posedge of start_stop(just need a toggle) which we couldn't do by making it a wire
// carry carrriers are wires because the actually depend on current values of parameters only and dont need any storing memory.
module stopwatch (
    input  wire clk,
    input  wire rst,
    input  wire start_stop,   // one clock-cycle pulse per "button press"
    output reg [3:0] sec_ones,
    output reg [3:0] sec_tens,
    output reg [3:0] min_ones,
    output reg [3:0] min_tens,
    output wire tick_out       // exposes tick_gen's tick for the testbench;
                                // a real stopwatch chip wouldn't need this pin
);
    // Instantiate tick_gen here. Use a small LIMIT (e.g. 4) so the
    // testbench doesn't have to wait forever. Connect its tick output to
    // both your internal logic and to tick_out above.
    tick_gen tt(.clk(clk),.rst(rst),.tick(tick));
    assign tick_out=tick;
    // running: a reg that toggles every time start_stop pulses high.
    // This is the only piece of state that decides whether anything
    // else in this module is allowed to change.
    reg running;
    initial begin
        running<=1'b0;
    end
    always @(posedge start_stop ) begin
        running<=running^start_stop;
    end
    // Combinational logic: for each digit, decide (a) whether it should
    // roll over back to 0 this tick, and (b) whether it should carry
    // into the next digit. sec_ones rolls over at 10 (0-9) and carries
    // into sec_tens; sec_tens rolls over at 6 (seconds only go 0-59) and
    // carries into min_ones; min_ones rolls over at 10 and carries into
    // min_tens; min_tens rolls over at 6, wrapping the whole stopwatch
    // back to 00:00.
    wire [2:0] carry;
    assign carry[0]=(sec_ones==4'b1001);
    assign carry[1]=carry[0]&&(sec_tens==4'b0101);
    assign carry[2]=carry[1]&&(min_ones==4'b1001);
    wire [3:0] digit [3:0];
    assign digit[0]=carry[0]?4'b0000:(sec_ones+4'b1);
    assign digit[1]=carry[1]?4'b0000:(sec_tens+carry[0]);
    assign digit[2]=carry[2]?4'b0000:(min_ones+carry[1]);
    assign digit[3]=(min_tens==4'b0101&&carry[2])?4'b0000:(min_tens+carry[2]);
    

    //
    // Sequential logic: on posedge clk, if rst is high, zero everything.
    // Otherwise, if running and tick, apply the next values you computed
    // combinationally above. If not running, or no tick this cycle, hold.
    always @(posedge clk ) begin
        if(rst) begin
            sec_ones<=4'b0000;
            sec_tens<=4'b0000;
            min_ones<=4'b0000;
            min_tens<=4'b0000;
        end
        else if(running&&tick) begin
            sec_ones<=digit[0];
            sec_tens<=digit[1];
            min_ones<=digit[2];
            min_tens<=digit[3];
    end
    end
endmodule
