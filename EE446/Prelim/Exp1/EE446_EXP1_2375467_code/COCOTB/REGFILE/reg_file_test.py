
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
    dut.RESET.value=1
    await clkedge
    # Check MUX
    dut.IN.value=11
    for i in range(0,16):
        dut.REGISTERS[i].value=random.randrange(2**32)
    dut.WE.value = 1
    dut.DEST_ADDRESS.value=1
    dut.SOURCE_ADDRESS_1.value=random.randrange(16)
    dut.SOURCE_ADDRESS_2.value=4
    dut.REGISTERS_ENB.value
    dut.RD1.value
    dut.RD2.value
    dut.RESET.value=0
    await clkedge
    print("Reading Test Begins....")
    for _ in range(10): 
        print(f'IN : {dut.IN.value}')
        print(f'RESET : {dut.RESET.value}')
        print(f'WE : {dut.WE.value}')
        print(f'DEST_ADDRESS     : {dut.DEST_ADDRESS.value}')
        print(f'SOURCE_ADDRESS_1 : {dut.SOURCE_ADDRESS_1.value}')
        print(f'SOURCE_ADDRESS_2 : {dut.SOURCE_ADDRESS_2.value}')
        for i in range(16):
            print(f'REGISTERS  {i} : {dut.REGISTERS[i].value}')
        print(f'REGISTERS_ENB : {dut.REGISTERS_ENB.value}')
        print(f'RD1 : {dut.RD1.value} REGISTER {int(dut.SOURCE_ADDRESS_1.value)}')
        print(f'RD2 : {dut.RD2.value}')
        assert dut.RD1.value == dut.REGISTERS[int(dut.SOURCE_ADDRESS_1.value)].value,f"REGISTER {int(dut.SOURCE_ADDRESS_1.value)} is not found correct "
        dut.SOURCE_ADDRESS_1.value=random.randrange(16)
        print('-----------------------------------------------------------------------------------')
        await clkedge
        
        
    print("Writing Test Begins....")
    for _ in range(10): 
        dut.IN.value=random.randrange(2**32)
        dut.DEST_ADDRESS.value=random.randrange(16)
        await clkedge
        print(f'IN : {dut.IN.value}')
        print(f'RESET : {dut.RESET.value}')
        print(f'WE : {dut.WE.value}')
        print(f'DEST_ADDRESS     : {dut.DEST_ADDRESS.value}')
        await clkedge
        print(f'SOURCE_ADDRESS_1 : {dut.SOURCE_ADDRESS_1.value}')
        print(f'SOURCE_ADDRESS_2 : {dut.SOURCE_ADDRESS_2.value}')
        for i in range(16):
            print(f'REGISTERS  {i} : {dut.REGISTERS[i].value}')
        print(f'REGISTERS_ENB : {dut.REGISTERS_ENB.value}')
        print(f'RD1 : {dut.RD1.value} REGISTER {int(dut.SOURCE_ADDRESS_1.value)}')
        print(f'RD2 : {dut.RD2.value}')
        assert dut.IN.value == dut.REGISTERS[int(dut.DEST_ADDRESS.value)].value
        dut.SOURCE_ADDRESS_1.value=random.randrange(16)
        print('-----------------------------------------------------------------------------------')
        