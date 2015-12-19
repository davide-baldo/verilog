`ifndef _H_OPCODE_
`define _H_OPCODE_

typedef enum bit [4:0]
{
  NOOP   = 0,
  ADD    = 1,
  ADDI   = 2,
  SUB    = 3,
  SUBI   = 4,
  MUL    = 5,
  MULI   = 6,
  DIV    = 7,
  DIVI   = 8,
  JUMP   = 9,
  CMP    = 10,
  STORE  = 11,
  LOAD   = 12,
  SWAP   = 13,
  COPY   = 14,
  SHIFT0 = 15,
  SHIFT1 = 16,
  SHIFTC = 17,
  READ   = 18,
  WRITE  = 19,
  TNSET  = 20,
  CALL   = 21,
  RET    = 22,
  INT    = 23,
  INTI   = 24,
  RETIN  = 25,
  SET    = 26,
  HALT   = 31
} OpcodeId;

typedef enum bit [3:0]
{
  REG1 = 0,
  REG2 = 1
} RegisterId;

typedef enum bit [2:0]
{
  ALWAYS          = 0,
  EQUALS          = 1,
  POSITIVE        = 2,
  NEGATIVE        = 3,
  OVERFLOW        = 4,
  EQUALS_POSITIVE = 5,
  EQUALS_NEGATIVE = 6,
  UNUSED          = 7
} OpcodeCondition;

// 2 bytes opcode
typedef struct packed
{
  OpcodeCondition cond;
  OpcodeId id;
  union packed
  {
    struct packed
    {
      bit [3:0] arg1;
      bit [3:0] arg2;
    } splitted;    
    bit [7:0] whole;    
  } args;
} Opcode;


`endif /* _H_OPCODE_ */