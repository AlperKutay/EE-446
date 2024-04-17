import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue



@cocotb.test()
async def CTRL_TEST(dut):
    """Setup testbench and run a test."""
    # Generate the clock
    await cocotb.start(Clock(dut.CLK, 10, 'us').start(start_high=False))

    # set clkedge as the falling edge for triggers
    clkedge = RisingEdge(dut.CLK)
    # wait until the falling edge
    #dut.reset.value = 1
    await clkedge

    print(" ~~~~~~~~~~~~~~~~~~ \n")


    print("Testing ADD OPeration... \n")
    dut.RESET.value = 1    
    dut.PC_SRC.value = 0
    dut.INSTR.value = 0b11100011101000000001000000010011
    dut.ALU_RESULT.value = 0
    dut.ALU_SRC.value = 0
    dut.MEM_to_REG.value = 0
    dut.REG_WRITE.value = 1
    dut.MEM_WRITE.value = 0
    dut.IMM_SRC.value = 0
    dut.REG_SRC.value = 0
    dut.ALU_CONTROL.value = 0b1101
    dut.Debug_Source_select.value
    dut.Debug_out.value 
    dut.ALU_RESULT.value 
    
    
    await clkedge
    dut.RESET.value = 0
    for _ in range(10):
        print(f'PC: {dut.PC.value}\n')
        print(f'INSTR: {dut.INSTR.value}\n')
        print(f'PC_SRC: {dut.PC_SRC.value}\n')
        await clkedge
    1101

    





