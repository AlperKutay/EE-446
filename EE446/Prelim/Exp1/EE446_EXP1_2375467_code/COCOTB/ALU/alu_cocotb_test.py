
import random
import warnings

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge,RisingEdge



@cocotb.test()
async def mux_basic_test(dut):
    """Setup testbench and run a test."""
    #Generate the clock
    await cocotb.start(Clock(dut.CLK, 10, 'us').start(start_high=False))

    #set clkedge as the falling edge for triggers
    clkedge = RisingEdge(dut.CLK)
    #wait until the falling edge
    await clkedge
    # Check MUX
    print("Overflow Test")
    dut.CIN.value= 0
    dut.ALU_CTRL.value= 4
    dut.SRC_A.value= 4
    dut.SRC_B.value= 5
    dut.CO.value
    dut.OVF.value
    dut.Z.value
    dut.N.value
    dut.ALU_RESULT.value 
    dut.PRE_RESULT.value 
    await clkedge
    print(f'CIN : {dut.CIN.value}')
    print(f'ALU_CTRL : {dut.ALU_CTRL.value}')
    print(f'SRC_A : {dut.SRC_A.value}')
    print(f'SRC_B     : {dut.SRC_B.value}')
    print(f'CO : {dut.CO.value}')
    print(f'OVF : {dut.OVF.value}')
    print(f'Z : {dut.Z.value}')
    print(f'N : {dut.N.value}')
    print(f'ALU_RESULT : {dut.ALU_RESULT.value}')
    print(f'PRE_RESULT : {dut.PRE_RESULT.value}')
    assert dut.OVF.value == 1
    print('------')
    await clkedge
    
    print("Carry Out and Negative Test")
    dut.CIN.value= 0
    dut.ALU_CTRL.value= 4
    dut.SRC_A.value= -3
    dut.SRC_B.value= -5
    dut.CO.value
    dut.OVF.value
    dut.Z.value
    dut.N.value
    dut.ALU_RESULT.value 
    await clkedge
    print(f'CIN : {dut.CIN.value}')
    print(f'ALU_CTRL : {dut.ALU_CTRL.value}')
    print(f'SRC_A : {dut.SRC_A.value}')
    print(f'SRC_B     : {dut.SRC_B.value}')
    print(f'CO : {dut.CO.value}')
    print(f'OVF : {dut.OVF.value}')
    print(f'Z : {dut.Z.value}')
    print(f'N : {dut.N.value}')
    print(f'ALU_RESULT : {dut.ALU_RESULT.value}')
    print(f'PRE_RESULT : {dut.PRE_RESULT.value}')
    assert dut.CO.value == 1
    print('------')
    await clkedge
    
    print("Zero Test")
    dut.CIN.value= 0
    dut.ALU_CTRL.value= 3
    dut.SRC_A.value= 4
    dut.SRC_B.value= 4
    dut.CO.value
    dut.OVF.value
    dut.Z.value
    dut.N.value
    dut.ALU_RESULT.value 
    await clkedge
    print(f'CIN : {dut.CIN.value}')
    print(f'ALU_CTRL : {dut.ALU_CTRL.value}')
    print(f'SRC_A : {dut.SRC_A.value}')
    print(f'SRC_B     : {dut.SRC_B.value}')
    print(f'CO : {dut.CO.value}')
    print(f'OVF : {dut.OVF.value}')
    print(f'Z : {dut.Z.value}')
    print(f'N : {dut.N.value}')
    print(f'ALU_RESULT : {dut.ALU_RESULT.value}')
    print(f'PRE_RESULT : {dut.PRE_RESULT.value}')
    assert dut.Z.value == 1
    print('------')
    await clkedge
    