`default_nettype none

module seven_segment_seconds (
	input wire clk,
    input wire reset,
	output wire [6:0] led_out
);

    // external clock is 16MHz, so need 24 bit counter
    reg [23:0] counter = 0;
    reg [3:0] seconds = 0;

    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("seven_segment_seconds.vcd");
            $dumpvars (0, seven_segment_seconds);
            #1;
        end
        localparam MAX_COUNT = 100;
    `else
        localparam MAX_COUNT = 16_000_000;
    `endif


    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            counter <= 0;
            seconds <= 0;
        end else begin
            // if up to 16e6
            if (counter == MAX_COUNT) begin
                // reset
                counter <= 0;

                // increment seconds
                seconds <= seconds + 1;

                // only count from 0 to 9
                if (seconds == 9)
                    seconds <= 0;

            end else
                // increment counter
                counter <= counter + 1;
        end
    end

    // instantiate segment display
    seg7 seg7(.counter(seconds), .segments(led_out));

endmodule

/*
      -- 1 --
     |       |
     6       2
     |       |
      -- 7 --
     |       |
     5       3
     |       |
      -- 4 --
*/

module seg7 (
    input wire clk,
    input wire [3:0] counter,
    output reg [6:0] segments
);

	always @(*) begin
        case(counter)
            //             1234567
            0:  segments = 7'b1111111;
            1:  segments = 7'b0110000;
            2:  segments = 7'b1101101;
            3:  segments = 7'b1111001;
            4:  segments = 7'b0110011;
            5:  segments = 7'b1011011;
            6:  segments = 7'b0011111;
            7:  segments = 7'b1110000;
            8:  segments = 7'b1111111;
            9:  segments = 7'b1110011;
            default:    
                segments = 7'b0000000;
        endcase
    end

endmodule
