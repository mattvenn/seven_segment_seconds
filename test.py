import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

PERIOD = 10

@cocotb.test()
async def test(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())
    dut.reset <= 1;
    await ClockCycles(dut.clk, 10)
    dut.reset <= 0;
    await ClockCycles(dut.clk, 1)
    assert dut.digit == 0
   
    # update compare
    await RisingEdge(dut.clk)
    dut.compare_in <= PERIOD 
    dut.update_compare <= 1;
    await RisingEdge(dut.clk)
    dut.compare_in <= 0
    dut.update_compare <= 0;

    for i in range(10):
        assert dut.digit == i
        await ClockCycles(dut.clk, PERIOD)

