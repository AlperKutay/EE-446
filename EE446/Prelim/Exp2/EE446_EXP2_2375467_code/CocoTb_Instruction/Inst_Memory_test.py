import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue



@cocotb.test()
async def CTRL_TEST(dut):
    """Setup testbench and run a test."""
    # Generate the clock

    # set clkedge as the falling edge for triggers
    # wait until the falling edge
    #dut.reset.value = 1

    dut.ADDR.value = 0
    dut.RD.value
    for _ in range(10):
        dut.ADDR.value = 0
        print(f'ADDR: {dut.ADDR.value}')
        print(f'RD: {dut.RD.value}')
        

