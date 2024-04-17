import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue



@cocotb.test()
async def CTRL_TEST(dut):
    """Setup testbench and run a test."""
    # Generate the clock
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))

    # set clkedge as the falling edge for triggers
    clkedge = RisingEdge(dut.clk)
    # wait until the falling edge
    #dut.reset.value = 1
    

    dut.reset.value = 1    
    dut.PC_SRC.value
    dut.INSTR.value 
    dut.COND.value
    dut.OP.value
    dut.FUNCT.value
    dut.REG_WRITE.value
    dut.MEM_WRITE.value
    dut.MEM_to_REG.value
    dut.ALU_SRC.value
    dut.IMM_SRC.value
    dut.REG_SRC.value
    dut.ALU_CONTROL.value
    dut.debug_reg_out.value
    dut.Write_Z_ENABLE.value
    dut.reset.value = 0
    await clkedge
    for i in range(20):
        print(i)
        print(f'fetchPC: {dut.fetchPC.value}\n')
        print(f'INSTR: {dut.INSTR.value}\n')
        print(f'COND: {dut.COND.value}')
        print(f'OP: {dut.OP.value}')
        print(f'FUNCT: {dut.FUNCT.value}')
        print(f'Z_FLAG: {dut.Z_FLAG.value}\n')
        print(f'Write_Z_ENABLE: {dut.Write_Z_ENABLE.value}\n')
        if(dut.OP.value == 0):
            ins=dut.INSTR.value 
            #print(f"{((ins >> 28) & 0b1111 ):b} {((ins >> 26) & 0b11) :b} {((ins >> 20) & 0b111111) :b} {((ins >> 16) & 0b1111) :b} {((ins >> 12) & 0b1111) :b} {((ins ) & 0b111111111111) :b }")
            print(f"DP  COND:{((ins >> 28) & 0b1111 ):b} OP:{((ins >> 26) & 0b11) :b} FUNC:{((ins >> 20) & 0b111111) :b} Rn:{((ins >> 16) & 0b1111) } Rd:{((ins >> 12) & 0b1111) } SRC:{((ins) & 0b111111111111) :b}")
        if(dut.OP.value == 1):
            ins=dut.INSTR.value 
            #print(f"{((ins >> 28) & 0b1111 ):b} {((ins >> 26) & 0b11) :b} {((ins >> 20) & 0b111111) :b} {((ins >> 16) & 0b1111) :b} {((ins >> 12) & 0b1111) :b} {((ins ) & 0b111111111111) :b }")
            print(f"Memory  COND:{((ins >> 28) & 0b1111 ):b} OP:{((ins >> 26) & 0b11) :b} FUNC:{((ins >> 20) & 0b111111) :b} Rn:{((ins >> 16) & 0b1111) } Rd:{((ins >> 12) & 0b1111) } SRC:{((ins) & 0b111111111111) :b}")
        if(dut.OP.value == 2):
            ins=dut.INSTR.value 
            #print(f"{((ins >> 28) & 0b1111 ):b} {((ins >> 26) & 0b11) :b} {((ins >> 20) & 0b111111) :b} {((ins >> 16) & 0b1111) :b} {((ins >> 12) & 0b1111) :b} {((ins ) & 0b111111111111) :b }")
            print(f"Branch  COND:{((ins >> 28) & 0b1111 ):b} OP:{((ins >> 26) & 0b11) :b} FUNC:{((ins >> 24) & 0b11) :b} IMM24: {((ins )& 0b111111111111111111111111):b}")
        print(f'PC_SRC: {dut.PC_SRC.value}')
        print(f'REG_WRITE: {dut.REG_WRITE.value}')
        print(f'MEM_WRITE: {dut.MEM_WRITE.value}')
        print(f'MEM_to_REG: {dut.MEM_to_REG.value}')
        print(f'ALU_SRC: {dut.ALU_SRC.value}')
        print(f'IMM_SRC: {dut.IMM_SRC.value}')
        print(f'REG_SRC: {dut.REG_SRC.value}')
        print(f'ALU_CONTROL: {dut.ALU_CONTROL.value}\n')
        print(f'debug_reg_select: {dut.debug_reg_select.value}\n')
        print(f'debug_reg_out: {dut.debug_reg_out.value}\n')
        print("---------------------------------------------------------------")
        dut.debug_reg_select.value=((ins >> 12) & 0b1111)
        await clkedge
