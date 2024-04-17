class Timing:
    # Define how many cycles each operation takes
    Data_Processing = 4
    Memory_Load = 5
    Memory_Store = 4
    Branch = 3


#Populate the below functions as in the example lines of code to print your values for debugging
def Log_Datapath(dut,logger):
    #Log whatever signal you want from the datapath, called before positive clock edge
    logger.debug("************ DUT DATAPATH Signals ***************")
    #dut._log.info("reset:%s", hex(dut.my_datapath.reset.value.integer))
    #dut._log.info("ALUSrc:%s", hex(dut.my_datapath.ALUSrc.value.integer))
    #dut._log.info("MemWrite:%s", hex(dut.my_datapath.MemWrite.value.integer))
    #dut._log.info("RegWrite:%s", hex(dut.my_datapath.RegWrite.value.integer))
    #dut._log.info("PCSrc:%s", hex(dut.my_datapath.PCSrc.value.integer))
    #dut._log.info("MemtoReg:%s", hex(dut.my_datapath.MemtoReg.value.integer))
    #dut._log.info("RegSrc:%s", hex(dut.my_datapath.RegSrc.value.integer))
    #dut._log.info("ImmSrc:%s", hex(dut.my_datapath.ImmSrc.value.integer))
    #dut._log.info("ALUControl:%s", hex(dut.my_datapath.ALUControl.value.integer))
    #dut._log.info("CO:%s", hex(dut.my_datapath.CO.value.integer))
    #dut._log.info("OVF:%s", hex(dut.my_datapath.OVF.value.integer))
    #dut._log.info("N:%s", hex(dut.my_datapath.N.value.integer))
    #dut._log.info("Z:%s", hex(dut.my_datapath.Z.value.integer))
    #dut._log.info("CarryIN:%s", hex(dut.my_datapath.CarryIN.value.integer))
    #dut._log.info("ShiftControl:%s", hex(dut.my_datapath.ShiftControl.value.integer))
    #dut._log.info("shamt:%s", hex(dut.my_datapath.shamt.value.integer))
    #dut._log.info("PC:%s", hex(dut.my_datapath.PC.value.integer))
    #dut._log.info("Instruction:%s", hex(dut.my_datapath.Instruction.value.integer))

def Log_Controller(dut,logger):
    #Log whatever signal you want from the controller, called before positive clock edge
    logger.debug("************ DUT Controller Signals ***************")
    #dut._log.info("Op:%s", hex(dut.my_controller.Op.value.integer))
    #dut._log.info("Funct:%s", hex(dut.my_controller.Funct.value.integer))
    #dut._log.info("Rd:%s", hex(dut.my_controller.Rd.value.integer))
    #dut._log.info("Src2:%s", hex(dut.my_controller.Src2.value.integer))
    #dut._log.info("PCSrc:%s", hex(dut.my_controller.PCSrc.value.integer))
    #dut._log.info("RegWrite:%s", hex(dut.my_controller.RegWrite.value.integer))
    #dut._log.info("MemWrite:%s", hex(dut.my_controller.MemWrite.value.integer))
    #dut._log.info("ALUSrc:%s", hex(dut.my_controller.ALUSrc.value.integer))
    #dut._log.info("MemtoReg:%s", hex(dut.my_controller.MemtoReg.value.integer))
    #dut._log.info("ALUControl:%s", hex(dut.my_controller.ALUControl.value.integer))
    #dut._log.info("FlagWrite:%s", hex(dut.my_controller.FlagWrite.value.integer))
    #dut._log.info("ImmSrc:%s", hex(dut.my_controller.ImmSrc.value.integer))
    #dut._log.info("RegSrc:%s", hex(dut.my_controller.RegSrc.value.integer))
    #dut._log.info("ShiftControl:%s", hex(dut.my_controller.ShiftControl.value.integer))
    #dut._log.info("shamt:%s", hex(dut.my_controller.shamt.value.integer))
    #dut._log.info("CondEx:%s", hex(dut.my_controller.CondEx.value.integer))