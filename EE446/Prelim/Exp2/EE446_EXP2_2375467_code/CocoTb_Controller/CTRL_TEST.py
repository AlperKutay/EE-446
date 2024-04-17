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

    print(" ~~~~~~~~~~~~~~~~~~ \n")


    print("Testing ADD OPeration... \n")

    Insraction = 0b11100000100000010010000000000001
    COND = (Insraction >> 28) & 0b1111 
    OP = (Insraction >> 26) & 0b11
    FUNCT = (Insraction >> 20) & 0b111111
    RD = (Insraction >> 12) & 0b1111 
    Z_FLAG = 0

    dut.COND.value = COND
    dut.OP.value = OP
    dut.FUNCT.value = FUNCT
    dut.RD.value = RD
    dut.Z_FLAG.value = Z_FLAG

    await clkedge

    print(f'COND: {dut.COND.value}')
    print(f'OP: {dut.OP.value}')
    print(f'FUNCT: {dut.FUNCT.value}')
    print(f'RD: {dut.RD.value}')
    print(f'Z_FLAG: {dut.Z_FLAG.value}\n')

    print(f'PC_SRC: {dut.PC_SRC.value}')
    print(f'REG_WRITE: {dut.REG_WRITE.value}')
    print(f'MEM_WRITE: {dut.MEM_WRITE.value}')
    print(f'MEM_to_REG: {dut.MEM_to_REG.value}')
    print(f'ALU_SRC: {dut.ALU_SRC.value}')
    print(f'IMM_SRC: {dut.IMM_SRC.value}')
    print(f'REG_SRC: {dut.REG_SRC.value}')
    print(f'ALU_CONTROL: {dut.ALU_CONTROL.value}\n')

    print("Testing SUB OPeration... \n")

    