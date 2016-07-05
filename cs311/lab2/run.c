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

/***************************************************************/
/*                                                             */
/* Procedure: process_instruction                              */
/*                                                             */
/* Purpose: Process one instrction                             */
/*                                                             */
/***************************************************************/
instruction fetch() {
    int n = (CURRENT_STATE.PC - MEM_TEXT_START) >> 2;
    if (n < NUM_INST) {
	CURRENT_STATE.PC += 4;
        if (n == NUM_INST-1) {
	    RUN_BIT = FALSE;
	    printf("Run bit unset pc: %x\n", CURRENT_STATE.PC);
	}
    }
    return INST_INFO[n];
}

void process_r_type(instruction i) {
    short funct = i.func_code;
    uint32_t rs = CURRENT_STATE.REGS[i.r_t.r_i.rs];
    uint32_t rt = CURRENT_STATE.REGS[i.r_t.r_i.rt];
    unsigned char shamt = i.r_t.r_i.r_i.r.shamt;

    uint32_t result = 0;
    switch (funct) {
	case 0x21: // addu
            result = rs + rt; break;
	case 0x24: // and
	    result = rs & rt; break;
	case 0x27: // nor
	    result = ~(rs | rt); break;
	case 0x25: // or
	    result = rs | rt; break;
	case 0x2b: // sltu
	    result = (rs < rt) ? 1 : 0; break;
	case 0x00: // sll
	    result = rt << shamt; break;
	case 0x02: // srl
	    result = rt >> shamt; break;
	case 0x23: // subu
	    result = rs - rt; break;
	case 0x08: // jr
	    CURRENT_STATE.PC = rs; return;
	default:
	    printf("ERROR:FALLTHROUGH_R_TYPE\n");
    }
    CURRENT_STATE.REGS[i.r_t.r_i.r_i.r.rd] = result;
}

void process_j_type(instruction i) {
    uint32_t jump_addr = (CURRENT_STATE.PC >> 28 << 28) | (i.r_t.target << 2);
    if (i.opcode == 0x02) // j
	CURRENT_STATE.PC = jump_addr;
    else if (i.opcode == 0x03) { // jal
	CURRENT_STATE.REGS[31] = CURRENT_STATE.PC + 4;
	CURRENT_STATE.PC = jump_addr;
    } else
    	printf("ERROR:FALLTHROUGH_J_TYPE\n");
}

void process_i_type(instruction i) {
    short opcode = i.opcode;
    uint32_t rs = CURRENT_STATE.REGS[i.r_t.r_i.rs];
    uint32_t rt = CURRENT_STATE.REGS[i.r_t.r_i.rt];
    uint32_t imm = i.r_t.r_i.r_i.imm;

    uint32_t sign_ext = imm;
    uint32_t zero_ext = imm & 0xffff;
    uint32_t branch_addr = imm << 2;

    uint32_t result = 0;
    switch (opcode) {
	case 0x09: // addiu
	    result = rs + sign_ext; break;
	case 0x0c: // andi
	    result = rs & zero_ext; break;
	case 0x0f: // lui
	    result = imm << 16; break;
	case 0x23: // lw
	    result = mem_read_32(rs + sign_ext); break;
	case 0x0d: // ori
	    result = rs | zero_ext; break;
	case 0x0b: // sltiu
	    result = (rs < sign_ext) ? 1 : 0; break;
	case 0x2b: // sw
	    mem_write_32(rs + sign_ext, rt); return;
	case 0x04: // beq
	    if (rs == rt)
		CURRENT_STATE.PC += branch_addr;
	    return;
	case 0x05: // bne
	    if (rs != rt)
		CURRENT_STATE.PC += branch_addr;
	    return;
	default:
	    printf("ERROR:FALLTHROUGH_I_TYPE\n");
    }
    CURRENT_STATE.REGS[i.r_t.r_i.rt] = result;
}

void process_instruction(){
    instruction i = fetch();

    if (i.opcode == 0x00)
    	process_r_type(i);
    else if (i.opcode == 0x02 || i.opcode == 0x03)
	process_j_type(i);
    else
        process_i_type(i);
}
