module properties (
    input clk,
    input reset,
    input wire [6:0] led_out
);
    // initial reset
    reg reset_req = 1;

    always @(posedge clk) begin
        if (reset_req)
            assume (reset);
        reset_req <= 0;
    end

    default clocking @(posedge clk); endclocking
    default disable iff (reset);

    no_change_reset:        assert property (reset |=> led_out == 7'b0111111);
    digits_zero_on_reset:   assert property (reset |=> seven_segment_seconds.digit == 0);
    digits_in_range:        assert property (seven_segment_seconds.digit <= 9);
    seconds_overflow:       assert property (seven_segment_seconds.second_counter == seven_segment_seconds.compare - 1 |=> seven_segment_seconds.second_counter == 0);

endmodule

bind seven_segment_seconds properties checker_inst (.*);
