
import random
import warnings

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge,RisingEdge

OP=2#You should change it !!!!!!!!!!!!

@cocotb.test()
async def mux_basic_test(dut):
    """Setup testbench and run a test."""
    #Generate the clock
    await cocotb.start(Clock(dut.ENABLE, 1000, 'ms').start(start_high=False))

    #set clkedge as the falling edge for triggers
    clkedge = RisingEdge(dut.ENABLE)
    #wait until the falling edge
    await clkedge
    # Check MUX
    dut.OPCODE.value= 0
    dut.IN.value= random.randrange(51)
    dut.CLOCK_CYCLE.value= 0
    dut.SELECT_1.value
    dut.SELECT_2.value
    dut.RESET.value
    dut.WE.value
    dut.ALU_CTRL.value
    dut.MUX_1_OUT.value 
    dut.MUX_2_OUT.value
    dut.ALU_OUT.value
    dut.OVF.value
    dut.CO.value
    dut.SHIFTER_OUTPUT.value
    dut.SHIFTER_REGISTER_OUTPUT.value
	#dut.AR_CLR.value, dut.AR_INC.value, dut.AR_LOAD.value
    #dut.PC_CLR.value, dut.PC_INC.value, dut.PC_LOAD.value
	#dut.DR_CLR.value, dut.DR_INC.value, dut.DR_LOAD.value
    #dut.AC_CLR.value, dut.AC_INC.value, dut.AC_LOAD.value,
	#dut.IR_LOAD.value,dut.IR_INC.value,dut.IR_CLR.value
	#dut.TR_CLR.value, dut.TR_INC.value, dut.TR_LOAD.value
	#dut.WRITE_ENABLE
    
    #dut.RESET.value=0
    if(OP==0):
        print("------2 s Complement Load TEST------")
        dut.IN.value= random.randrange(25)
        dut.OPCODE.value= 0
        for _ in range(3):
            await clkedge
            print(f'ENABLE : {dut.ENABLE.value}')
            print(f'CLOCK_CYCLE : {dut.CLOCK_CYCLE.value}')
            print(f'OPCODE : {dut.OPCODE.value}')
            print(f'IN     : {dut.IN.value}')
            print(f'OUT : {dut.REGISTER_OUT.value}')
            print(f'RESET : {dut.RESET.value}')
            print(f'SELECT_1 : {dut.SELECT_1.value}')
            print(f'SELECT_2 : {dut.SELECT_2.value}')
            print(f'ALU_CTRL : {dut.ALU_CTRL.value}')
            print(f'MUX_1_OUT : {dut.MUX_1_OUT.value}')
            print(f'MUX_2_OUT : {dut.MUX_2_OUT.value}')
            print(f'ALU_OUT : {dut.ALU_OUT.value}')
            print(f'WE : {dut.WE.value}')
            print('------')
        assert dut.IN.value +dut.REGISTER_OUT.value + 1 == 256
    elif(OP==1):
        print("------Multiply by 10 TEST------")
        dut.IN.value= random.randrange(25)
        dut.OPCODE.value= 1
        for _ in range(5):
            await clkedge
            print(f'ENABLE : {dut.ENABLE.value}')
            print(f'CLOCK_CYCLE : {dut.CLOCK_CYCLE.value}')
            print(f'OPCODE : {dut.OPCODE.value}')
            print(f'IN     : {dut.IN.value}')
            print(f'OUT : {dut.REGISTER_OUT.value}')
            print(f'RESET : {dut.RESET.value}')
            print(f'SELECT_1 : {dut.SELECT_1.value}')
            print(f'SELECT_2 : {dut.SELECT_2.value}')
            print(f'ALU_CTRL : {dut.ALU_CTRL.value}')
            print(f'MUX_1_OUT : {dut.MUX_1_OUT.value}')
            print(f'MUX_2_OUT : {dut.MUX_2_OUT.value}')
            print(f'ALU_OUT : {dut.ALU_OUT.value}')
            print(f'OVF : {dut.OVF.value}')
            print(f'CO : {dut.CO.value}')
            print(f'WE : {dut.WE.value}')
            print(f'SHIFTER_OUTPUT : {dut.SHIFTER_OUTPUT.value}')
            print(f'SHIFTER_REGISTER_OUTPUT : {dut.SHIFTER_REGISTER_OUTPUT.value}')
            print('------')
        assert dut.REGISTER_OUT.value == dut.IN.value * 10 
    elif(OP==2):
        print("------Duplicate the First 4-bit------")
        dut.IN.value= random.randrange(2**8)
        dut.OPCODE.value= 2
        for _ in range(5):
            await clkedge
            print(f'ENABLE : {dut.ENABLE.value}')
            print(f'CLOCK_CYCLE : {dut.CLOCK_CYCLE.value}')
            print(f'OPCODE : {dut.OPCODE.value}')
            print(f'IN     : {dut.IN.value}')
            print(f'OUT : {dut.REGISTER_OUT.value}')
            print(f'RESET : {dut.RESET.value}')
            print(f'SELECT_1 : {dut.SELECT_1.value}')
            print(f'SELECT_2 : {dut.SELECT_2.value}')
            print(f'ALU_CTRL : {dut.ALU_CTRL.value}')
            print(f'MUX_1_OUT : {dut.MUX_1_OUT.value}')
            print(f'MUX_2_OUT : {dut.MUX_2_OUT.value}')
            print(f'ALU_OUT : {dut.ALU_OUT.value}')
            print(f'OVF : {dut.OVF.value}')
            print(f'CO : {dut.CO.value}')
            print(f'WE : {dut.WE.value}')
            print(f'SHIFTER_OUTPUT : {dut.SHIFTER_OUTPUT.value}')
            print(f'SHIFTER_REGISTER_OUTPUT : {dut.SHIFTER_REGISTER_OUTPUT.value}')
            print('------')
        assert dut.REGISTER_OUT.value ==  (dut.IN.value >> 4) | (dut.IN.value & 240)#240 == 1111 0000