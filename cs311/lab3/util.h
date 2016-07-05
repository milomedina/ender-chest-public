/***************************************************************/
/*                                                             */
/*   MIPS-32 Instruction Level Simulator                       */
/*                                                             */
/*   CS311 KAIST                                               */
/*   util.h                                                    */
/*                                                             */
/***************************************************************/

#ifndef _UTIL_H_
#define _UTIL_H_

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define FALSE 0
#define TRUE  1

/* Basic Information */
#define MEM_TEXT_START	0x00400000
#define MEM_TEXT_SIZE	0x00100000
#define MEM_DATA_START	0x10000000
#define MEM_DATA_SIZE	0x00100000
#define MIPS_REGS	32
#define BYTES_PER_WORD	4
#define PIPE_STAGE	5

typedef struct inst_s {
    short opcode;
    
    /*R-type*/
    short func_code;

    union {
        /* R-type or I-type: */
        struct {
	    unsigned char rs;
	    unsigned char rt;

	    union {
	        short imm;

	        struct {
		    unsigned char rd;
		    unsigned char shamt;
		} r;
	    } r_i;
	} r_i;
        /* J-type: */
        uint32_t target;
    } r_t;

    uint32_t value;
    
    //int32 encoding;
    //imm_expr *expr;
    //char *source_line;
} instruction;


typedef struct pc_logic_s {
    uint32_t JumpAddr;
    uint32_t BranchAddr;
    uint32_t PC;

    char CPCJump;
    char CPCBranch;
} pc_logic;


typedef struct if_id_l_s {
    uint32_t PC;
    uint32_t NPC;
    
    instruction Instr;
} if_id_latch;


typedef struct id_ex_l_s {
    uint32_t PC;
    uint32_t NPC;

    unsigned char RegRS;
    unsigned char RegRT;
    unsigned char RegRD;
    uint32_t IMM;
    unsigned char SHAMT;

    uint32_t RegV1;
    uint32_t RegV2;

    char CALUOp;
    char CALUSrc;
    char CRegDst;

    char CBranch;
    char CMemR;
    char CMemW;

    char CRegW;
    char CMemToReg;
} id_ex_latch;


typedef struct ex_mem_l_s {
    uint32_t PC;
    uint32_t ALUOut;
    char CALUBranch;
    uint32_t BranchAddr;
    uint32_t WData;
    unsigned char RegWAddr;

    char CBranch;
    char CMemR;
    char CMemW;

    char CRegW;
    char CMemToReg;
} ex_mem_latch;


typedef struct mem_wb_l_s {
    uint32_t PC;
    uint32_t ALUOut;
    unsigned char RegWAddr;
    uint32_t MemOut;
    
    char CRegW;
    char CMemToReg;
} mem_wb_latch;


typedef struct CPU_State_Struct {
    uint32_t PC;		/* program counter */
    uint32_t REGS[MIPS_REGS];	/* register file */
    uint32_t PIPE[PIPE_STAGE];	/* pipeline stage */
    pc_logic PC_LOGIC;
    if_id_latch IF_ID;
    id_ex_latch ID_EX;
    ex_mem_latch EX_MEM;
    mem_wb_latch MEM_WB;
    
    char BUBBLE_COUNT;
    char FLUSH_COUNT;

    uint32_t BRANCH_PC;

    char PC_WRITE;
    char IF_FLUSH;
    char IF_WRITE;
    char ID_FLUSH;
} CPU_State;

typedef struct {
    uint32_t start, size;
    uint8_t *mem;
} mem_region_t;

/* For PC * Registers */
extern CPU_State CURRENT_STATE;

/* For Instructions */
extern instruction *INST_INFO;
extern int NUM_INST;

/* For Memory Regions */
extern mem_region_t MEM_REGIONS[2];

/* For Execution */
extern int RUN_BIT;	/* run bit */
extern int INSTRUCTION_COUNT;
extern int E_INSTR_COUNT;
extern int E_INSTR_LIMIT;
extern int ON_FORWARD;
extern int ON_BRANCH;

/* Functions */
char**		str_split(char *a_str, const char a_delim);
int		fromBinary(char *s);
uint32_t	mem_read_32(uint32_t address);
void		mem_write_32(uint32_t address, uint32_t value);
void		cycle();
void		run(int num_cycles);
void		go();
void		mdump(int start, int stop);
void		rdump();
void		init_memory();
void		init_inst_info();

/* YOU IMPLEMENT THIS FUNCTION */
void	process_instruction();

#endif
