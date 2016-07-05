/***************************************************************/
/*                                                             */
/*   MIPS-32 Instruction Level Simulator                       */
/*                                                             */
/*   CS311 KAIST                                               */
/*   run.c                                                     */
/*                                                             */
/***************************************************************/

#include <stdio.h>

#include "util.h"
#include "run.h"

// DEBUG FLAG
//#define __DEBUG__

// get empty instruction
instruction empty_instr() {
    instruction i;
    i.value = 0;
    i.opcode = 0;
    i.func_code = 0;
    i.r_t.r_i.rs = 0;
    i.r_t.r_i.rt = 0;
    i.r_t.r_i.r_i.r.rd = 0;
    i.r_t.r_i.r_i.imm = 0;
    i.r_t.r_i.r_i.r.shamt = 0;
    i.r_t.target = 0;
    return i;
}

// make bubbles for count times
void stall_bubble(int count) {
    if (CURRENT_STATE.BUBBLE_COUNT || CURRENT_STATE.FLUSH_COUNT) {
	return;
    }

#ifdef __DEBUG__
    printf("* BUBBLE INSERTED: %d\n", count);
#endif

    CURRENT_STATE.BUBBLE_COUNT = count;
    CURRENT_STATE.PC_WRITE = 1;
    CURRENT_STATE.IF_WRITE = 1;
    CURRENT_STATE.ID_FLUSH = 1;
}

// PC core logic
uint32_t get_PC() {
    pc_logic PC_LOGIC = CURRENT_STATE.PC_LOGIC;
    
    // boundary check
    if (CURRENT_STATE.PC < MEM_TEXT_START || CURRENT_STATE.PC >= (MEM_TEXT_START + (NUM_INST * 4))) {
	    return CURRENT_STATE.PC;
    }

    // PC write check
    if (CURRENT_STATE.PC_WRITE) {
	    CURRENT_STATE.PC_WRITE = 0;
	    return CURRENT_STATE.PC;
    }

    uint32_t pc = CURRENT_STATE.PC + 4;
    if (PC_LOGIC.CPCJump)
	    pc = PC_LOGIC.JumpAddr;
    else if (PC_LOGIC.CPCBranch) {
	    pc = PC_LOGIC.BranchAddr;
    }
    return pc;
}

// IF stage core logic
if_id_latch execute_IF() {
    if_id_latch latch;
    
    // boundary check
    if ((CURRENT_STATE.PC < MEM_TEXT_START || CURRENT_STATE.PC >= (MEM_TEXT_START + (NUM_INST * 4))) || CURRENT_STATE.IF_FLUSH) {
	    CURRENT_STATE.IF_FLUSH = 0;
	    latch.NPC = 0;
	    latch.PC = 0;
	    latch.Instr = empty_instr();
    	return latch;
    }
    
    // IF write check
    if (CURRENT_STATE.IF_WRITE) {
	    CURRENT_STATE.IF_WRITE = 0;
	    return CURRENT_STATE.IF_ID;
    }

    latch.PC = CURRENT_STATE.PC;
    latch.NPC = CURRENT_STATE.PC + 4;
    latch.Instr = INST_INFO[(CURRENT_STATE.PC - MEM_TEXT_START) >> 2];

    return latch;
}

// ID stage core logic
id_ex_latch execute_ID() {
    if_id_latch IF_ID = CURRENT_STATE.IF_ID;
    id_ex_latch ID_EX = CURRENT_STATE.ID_EX;
    ex_mem_latch EX_MEM = CURRENT_STATE.EX_MEM;
    id_ex_latch latch;
    
    instruction instr = IF_ID.Instr;
    short op = instr.opcode;
    short funct = instr.func_code;
    
    // decode instruction
    latch.NPC = IF_ID.NPC;
    latch.RegRS = instr.r_t.r_i.rs;
    latch.RegRT = instr.r_t.r_i.rt;
    latch.RegRD = instr.r_t.r_i.r_i.r.rd;
    if (op == 0x03) // jal
	    latch.RegRD = 31;

    latch.IMM = instr.r_t.r_i.r_i.imm;
    if (op == 0x0c || // andi
	        op == 0x0d) // ori
	    latch.IMM = instr.r_t.r_i.r_i.imm & 0xffff;
        latch.SHAMT = instr.r_t.r_i.r_i.r.shamt;

    // register read
    latch.RegV1 = CURRENT_STATE.REGS[latch.RegRS];
    latch.RegV2 = CURRENT_STATE.REGS[latch.RegRT]; 

    // load use hazard detection
    if (ID_EX.CMemR && (
	        (ID_EX.RegRT == latch.RegRS) ||
	        (ID_EX.RegRT == latch.RegRT))) {
	    stall_bubble(1);
    }
    
    // make bubbles if forward disabled
    if (!ON_FORWARD) {
	    int bubble1 = 0, bubble2 = 0;
	    unsigned char ID_EX_RegWAddr = ID_EX.CRegDst ? ID_EX.RegRD : ID_EX.RegRT;
	    if (ID_EX.CRegW && ID_EX_RegWAddr != 0 && (ID_EX_RegWAddr == latch.RegRS))
	        bubble1 = 2;
        else if (EX_MEM.CRegW && EX_MEM.RegWAddr != 0 && (EX_MEM.RegWAddr == latch.RegRS))
	        bubble1 = 1;
    
    	if (ID_EX.CRegW && ID_EX_RegWAddr != 0 && (ID_EX_RegWAddr == latch.RegRT))
	        bubble2 = 2;
    	else if (EX_MEM.CRegW && EX_MEM.RegWAddr != 0 && (EX_MEM.RegWAddr == latch.RegRT))
	        bubble2 = 1;
	
	int max = bubble1 > bubble2 ? bubble1 : bubble2;
	if (max)
	    stall_bubble(max);
    }
    
    // flush if bp disabled
    if (!CURRENT_STATE.BUBBLE_COUNT && !ON_BRANCH &&
	        (op == 0x04 || // beq
	        op == 0x05)) { // bne
	    CURRENT_STATE.PC_WRITE = 1;
	    CURRENT_STATE.IF_FLUSH = 1;
	    CURRENT_STATE.FLUSH_COUNT = 3;
    }

    // flush and goto garget if bp enabled
    if (!CURRENT_STATE.BUBBLE_COUNT && ON_BRANCH &&
            (op == 0x04 || // beq
	        op == 0x05)) { // bne
	    CURRENT_STATE.BRANCH_PC = latch.NPC + (latch.IMM << 2);
	    CURRENT_STATE.IF_FLUSH = 1;
    }

    // jump
    CURRENT_STATE.PC_LOGIC.CPCJump = 0;
    if (op == 0x02 || // j
	        op == 0x03) { // jal
	    uint32_t jump_addr = latch.NPC & 0xf0000000;
	    jump_addr = jump_addr | (instr.r_t.target << 2);
	    CURRENT_STATE.PC_LOGIC.JumpAddr = jump_addr;
	    CURRENT_STATE.PC_LOGIC.CPCJump = 1;
    } else if (op == 0x00 && funct == 0x08) { // jr
	    CURRENT_STATE.PC_LOGIC.JumpAddr = latch.RegV1;
	    CURRENT_STATE.PC_LOGIC.CPCJump = 1;
    }
    
    // need one flush for jump
    if (op == 0x02 || // j
	        op == 0x03 || // jal
	        (op == 0x00 && funct == 0x08)) { // jr
	    CURRENT_STATE.IF_FLUSH = 1;
    }

    // set control value to 0 if ID flush
    if (CURRENT_STATE.ID_FLUSH) {
	        CURRENT_STATE.ID_FLUSH = 0;
    	latch.CALUOp = 0;
	    latch.CALUSrc = 0;
	    latch.CRegDst = 0;
	    latch.CBranch = 0;
	    latch.CMemR = 0;
	    latch.CMemW = 0;
	    latch.CRegW = 0;
	    latch.CMemToReg = 0;
	    latch.PC = 0;
    	return latch;
    }

    // control signal generation
    if (op == 0x09 || // addiu
	        op == 0x23 || // lw
	        op == 0x2b || // sw
	        (op == 0x00 && funct == 0x21)) // addu
	    latch.CALUOp = 1; // +
    else if (op == 0x0c || // andi
	        (op == 0x00 && funct == 0x24)) // and
	    latch.CALUOp = 2; // &
    else if (op == 0x0d || // ori
	        (op == 0x00 && funct == 0x25)) // or
	    latch.CALUOp = 3; // |
    else if (op == 0x04 || // beq
	        (op == 0x00 && funct == 0x23)) // subu
	    latch.CALUOp = 4; // -
    else if (op == 0x05) // bne
	    latch.CALUOp = 5; // minus with inv 0
    else if (op == 0x00 && funct == 0x27) // nor
	    latch.CALUOp = 6; // nor
    else if (op == 0x0b || // sltiu
	        (op == 0x00 && funct == 0x2b)) // sltu
	    latch.CALUOp = 7; // < ? 1 : 0;
    else if (op == 0x00 && funct == 0x00) // sll
	    latch.CALUOp = 8; // <<
    else if (op == 0x00 && funct == 0x02) // srl
	    latch.CALUOp = 9; // >>
    else if (op == 0x0f) // lui
	    latch.CALUOp = 10; // << 16 & 0xffff0000
    else if (op == 0x03) // jal
	    latch.CALUOp = 11;

    latch.CALUSrc = (op == 0x09 || // addiu
	    	    op == 0x0c || // andi
		        op == 0x0f || // lui
		        op == 0x0d || // ori
		        op == 0x0b || // sltiu
		        op == 0x23 || // lw
		        op == 0x2b) // sw
		        ? 1 : 0;
    latch.CRegDst = (op == 0x00 || // r type
		        op == 0x03) // jal
	            ? 1 : 0;

    latch.CBranch = (op == 0x04 || op == 0x05) ? 1 : 0; // beq, bne
    latch.CMemR = (op == 0x23) ? 1 : 0; //lw
    latch.CMemW = (op == 0x2b) ? 1 : 0; //sw

    latch.CRegW = (op == 0x00 || // r type
		    op == 0x09 || // addiu
		    op == 0x0c || // andi
		    op == 0x0f || // lui
		    op == 0x0d || // ori
		    op == 0x0b || // sltiu
		    op == 0x23 || // lw
	        op == 0x03) // jal
	        ? 1 : 0;
    latch.CMemToReg = (op == 0x23) ? 1 : 0; // lw

    latch.PC = IF_ID.PC;
    return latch;
}

// EX stage core logic
ex_mem_latch execute_EX() {
    id_ex_latch ID_EX = CURRENT_STATE.ID_EX;
    ex_mem_latch EX_MEM = CURRENT_STATE.EX_MEM;
    mem_wb_latch MEM_WB = CURRENT_STATE.MEM_WB;
    ex_mem_latch latch;

    // select ALU inputs
    uint32_t ALUIn1 = ID_EX.RegV1;
    uint32_t ALUIn2 = ID_EX.RegV2;
   
    // forwarding if forward enabled
    if (ON_FORWARD) {
   	    if (EX_MEM.CRegW && EX_MEM.RegWAddr != 0 && (EX_MEM.RegWAddr == ID_EX.RegRS))
	        ALUIn1 = EX_MEM.ALUOut;
    	else if (MEM_WB.CRegW && MEM_WB.RegWAddr != 0 && (MEM_WB.RegWAddr == ID_EX.RegRS))
	        ALUIn1 = MEM_WB.ALUOut; 
    
    	if (EX_MEM.CRegW && EX_MEM.RegWAddr != 0 && (EX_MEM.RegWAddr == ID_EX.RegRT))
	        ALUIn2 = EX_MEM.ALUOut;
    	else if (MEM_WB.CRegW && MEM_WB.RegWAddr != 0 && (MEM_WB.RegWAddr == ID_EX.RegRT))
	        ALUIn2 = MEM_WB.ALUOut;
    }

    // select second ALU input
    if (ID_EX.CALUSrc)
        ALUIn2 = ID_EX.IMM;
    
    // ALU calculation
    latch.CALUBranch = 0;
    switch (ID_EX.CALUOp) {
	case 1:
	    latch.ALUOut = ALUIn1 + ALUIn2; break;
	case 2:
	    latch.ALUOut = ALUIn1 & ALUIn2; break;
	case 3:
	    latch.ALUOut = ALUIn1 | ALUIn2; break;
	case 4:
	    latch.ALUOut = ALUIn1 - ALUIn2;
	    latch.CALUBranch = latch.ALUOut == 0 ? 1 : 0; break;
	case 5:
	    latch.ALUOut = ALUIn1 - ALUIn2;
	    latch.CALUBranch = latch.ALUOut != 0 ? 1 : 0; break;
	case 6:
	    latch.ALUOut = ~(ALUIn1 | ALUIn2); break;
	case 7:
	    latch.ALUOut = (ALUIn1 < ALUIn2) ? 1 : 0; break;
	case 8:
	    latch.ALUOut = ALUIn2 << ID_EX.SHAMT; break;
	case 9:
	    latch.ALUOut = ALUIn2 >> ID_EX.SHAMT; break;
	case 10:
	    latch.ALUOut = (ALUIn2 << 16) & 0xffff0000; break;
	case 11:
	    latch.ALUOut = ID_EX.NPC; break;
    }

    // control signal generation
    latch.BranchAddr = ID_EX.NPC + (ID_EX.IMM << 2);
    latch.WData = ID_EX.RegV2;
    latch.RegWAddr = ID_EX.CRegDst ? ID_EX.RegRD : ID_EX.RegRT;

    // control signal forward
    latch.CBranch = ID_EX.CBranch;
    latch.CMemR = ID_EX.CMemR;
    latch.CMemW = ID_EX.CMemW;

    latch.CRegW = ID_EX.CRegW;
    latch.CMemToReg = ID_EX.CMemToReg;

    latch.PC = ID_EX.PC;
    return latch;
}

// MEM stage core logic
mem_wb_latch execute_MEM() {
    ex_mem_latch EX_MEM = CURRENT_STATE.EX_MEM;
    mem_wb_latch MEM_WB = CURRENT_STATE.MEM_WB;
    mem_wb_latch latch;
    
    // branch logic
    if (ON_BRANCH) { // bp enabled
	    // branch misprediction
	    if (EX_MEM.CBranch && !(EX_MEM.CALUBranch && EX_MEM.CBranch)) {

#ifdef __DEBUG__
	        printf("BRANCH MIS PRED\n");
#endif

	        CURRENT_STATE.IF_FLUSH = 1;
	        CURRENT_STATE.ID_FLUSH = 1;
	        CURRENT_STATE.PC = EX_MEM.PC; 
	    }
    } else { // bp disabled
        CURRENT_STATE.PC_LOGIC.BranchAddr = EX_MEM.BranchAddr;
        CURRENT_STATE.PC_LOGIC.CPCBranch = EX_MEM.CALUBranch && EX_MEM.CBranch;
    }

    // latch data forward
    latch.ALUOut = EX_MEM.ALUOut;
    latch.RegWAddr = EX_MEM.RegWAddr;

    uint32_t MemIn = EX_MEM.WData;

    // forwarding if forward enabled
    if (ON_FORWARD) {
        if (MEM_WB.CMemToReg && EX_MEM.CMemW && (EX_MEM.RegWAddr == MEM_WB.RegWAddr))
	        MemIn = MEM_WB.MemOut;
    }

    // memory write
    if (EX_MEM.CMemW)
	    mem_write_32(EX_MEM.ALUOut, MemIn);

    // memory read
    latch.MemOut = EX_MEM.CMemR ? mem_read_32(EX_MEM.ALUOut) : 0;
    latch.ALUOut = EX_MEM.CMemR ? latch.MemOut : latch.ALUOut;

    // control signal forward
    latch.CRegW = EX_MEM.CRegW;
    latch.CMemToReg = EX_MEM.CMemToReg;

    latch.PC = EX_MEM.PC;
    return latch;
}

// WB stage core logic
void execute_WB() {
    mem_wb_latch MEM_WB = CURRENT_STATE.MEM_WB;
    
    // register write
    uint32_t data = MEM_WB.CMemToReg ? MEM_WB.MemOut: MEM_WB.ALUOut;
    if (MEM_WB.CRegW)
    	CURRENT_STATE.REGS[MEM_WB.RegWAddr] = data;
}


/***************************************************************/
/*                                                             */
/* Procedure: process_instruction                              */
/*                                                             */
/* Purpose: Process one instrction                             */
/*                                                             */
/***************************************************************/
void process_instruction() {
    uint32_t limit_addr = MEM_REGIONS[0].start + (NUM_INST * 4);

    CURRENT_STATE.PIPE[0] = CURRENT_STATE.PC;
    CURRENT_STATE.PIPE[1] = CURRENT_STATE.IF_ID.PC;
    CURRENT_STATE.PIPE[2] = CURRENT_STATE.ID_EX.PC;
    CURRENT_STATE.PIPE[3] = CURRENT_STATE.EX_MEM.PC;
    CURRENT_STATE.PIPE[4] = CURRENT_STATE.MEM_WB.PC;

    if (CURRENT_STATE.PC >= limit_addr)
        CURRENT_STATE.PIPE[0] = 0;

    if_id_latch IF_ID;
    id_ex_latch ID_EX;
    ex_mem_latch EX_MEM;
    mem_wb_latch MEM_WB;
    uint32_t PC;

    // set pc, if write disabled if flush set
    if (CURRENT_STATE.FLUSH_COUNT) {
	    CURRENT_STATE.PIPE[0] = 0;
	    CURRENT_STATE.PC_WRITE = 1;
	    CURRENT_STATE.IF_WRITE = 1;
    }

    // set pc, if write and id flush if bubble set
    if (CURRENT_STATE.BUBBLE_COUNT) {
    	CURRENT_STATE.PC_WRITE = 1;
	    CURRENT_STATE.IF_WRITE = 1;
	    CURRENT_STATE.ID_FLUSH = 1;
    }

    MEM_WB = execute_MEM();
             execute_WB();
    ID_EX  = execute_ID();
    EX_MEM = execute_EX();
    IF_ID  = execute_IF();

    // set pc write disabled if flush and branch taken
    if (CURRENT_STATE.FLUSH_COUNT && CURRENT_STATE.PC_LOGIC.CPCBranch)
	    CURRENT_STATE.PC_WRITE = 0;

    PC = get_PC();
    
    CURRENT_STATE.MEM_WB = MEM_WB;
    CURRENT_STATE.EX_MEM = EX_MEM;
    CURRENT_STATE.ID_EX = ID_EX;
    CURRENT_STATE.IF_ID = IF_ID;
    CURRENT_STATE.PC = PC;

    // change pc if bp enabled
    if (CURRENT_STATE.BRANCH_PC) {
	    CURRENT_STATE.PC = CURRENT_STATE.BRANCH_PC;
	    CURRENT_STATE.BRANCH_PC = 0;
    }

#ifdef __DEBUG__
    printf("BUBBLE,FLUSH: %d,%d\n", CURRENT_STATE.BUBBLE_COUNT, CURRENT_STATE.FLUSH_COUNT);
#endif

    if (CURRENT_STATE.BUBBLE_COUNT)
	    CURRENT_STATE.BUBBLE_COUNT--;

    if (CURRENT_STATE.FLUSH_COUNT)
	    CURRENT_STATE.FLUSH_COUNT--;
 
    // halt condition
    if (CURRENT_STATE.PIPE[4])
	    E_INSTR_COUNT++;

    if (CURRENT_STATE.PC < MEM_REGIONS[0].start ||
            (CURRENT_STATE.PC >= limit_addr &&
	        !CURRENT_STATE.IF_ID.PC &&
	        !CURRENT_STATE.ID_EX.PC &&
	        !CURRENT_STATE.EX_MEM.PC &&
	        !CURRENT_STATE.MEM_WB.PC) ||
	        (E_INSTR_COUNT >= E_INSTR_LIMIT))
	    RUN_BIT = FALSE;
}
