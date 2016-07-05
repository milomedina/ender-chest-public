/***************************************************************/
/*                                                             */
/*   MIPS-32 Instruction Level Simulator                       */
/*                                                             */
/*   CS311 KAIST                                               */
/*   parse.c                                                   */
/*                                                             */
/***************************************************************/

#include <stdio.h>

#include "util.h"
#include "parse.h"

int text_size;
int data_size;

/**************************************************************/
/*                                                            */
/* Procedure : parsing_instr                                  */
/*                                                            */
/* Purpose   : parse binary format instrction and return the  */
/*             instrcution data                               */
/*                                                            */
/* Argument  : buffer - binary string for the instruction     */
/*             index  - order of the instruction              */
/*                                                            */
/**************************************************************/
instruction parsing_instr(const char *buffer, const int index) {
    instruction i = {0, };
    
    uint32_t b = fromBinary((char*)buffer);
    mem_write_32(MEM_TEXT_START + index, b);

    i.value = b;
    i.opcode = (short)(b >> 26);
    if (i.opcode == 0x02 || i.opcode == 0x03) { // J Type
	i.r_t.target = b << 6 >> 6;
	return i;
    }
    
    // R Type and I Type
    uint16_t rsrt = b << 6 >> 22;
    i.r_t.r_i.rs = rsrt >> 5;
    i.r_t.r_i.rt = rsrt & 0x1F;
    
    uint16_t low16 = b << 16 >> 16;
    if (i.opcode == 0x00) { // R Type
	i.func_code = low16 & 0x3F;
	i.r_t.r_i.r_i.r.rd = low16 >> 11;
	i.r_t.r_i.r_i.r.shamt = (low16 & 0x7C0) >> 6;
    } else // I Type
	i.r_t.r_i.r_i.imm = low16;
 
    return i;
}

/**************************************************************/
/*                                                            */
/* Procedure : parsing_data                                   */
/*                                                            */
/* Purpose   : parse binary format data and store data into   */
/*             the data region                                */
/*                                                            */
/* Argument  : buffer - binary string for data                */
/*             index  - order of data                         */
/*                                                            */
/**************************************************************/
void parsing_data(const char *buffer, const int index) {
    uint32_t b = fromBinary((char*)buffer);
    mem_write_32(MEM_DATA_START + index, b);
}
