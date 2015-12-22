#ifndef _H_OPCODE_
#define _H_OPCODE_

enum OpcodeId
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
  HALT   = 31,
  XOR    = 32
};

enum RegisterId
{
  REG1 = 0,
  REG2 = 1
};

enum OpcodeCondition
{
  ALWAYS             = 0,
  EQUALS_OR_OVERFLOW = 1,
  POSITIVE           = 2,
  NEGATIVE           = 3
};
/*
  EQUALS_POSITIVE = 5,
  EQUALS_NEGATIVE = 6,
  NEVER           = 7
*/

struct Opcode
{
  OpcodeCondition cond;
  OpcodeId id;
  
  union
  {
    struct
    {
      unsigned arg2 : 4;
      unsigned arg1 : 4;
    } splitted;    
    
    unsigned char whole;    
  } args;
  
  void write(char buffer[2])
  {
    buffer[0] = (unsigned)cond << 6;
    buffer[0] |= ((unsigned)id);
    buffer[1] = args.whole;
  }
  
  Opcode(
    OpcodeCondition cond,
    OpcodeId id
  ) :
   cond(cond), id(id)
  {
    args.whole = 0;
  }
  
  Opcode(
    OpcodeCondition cond,
    OpcodeId id,
    unsigned argWhole
  ) :
   cond(cond), id(id)
  {
    args.whole = argWhole;
  }
  
  Opcode(
    OpcodeCondition cond,
    OpcodeId id,
    unsigned arg1,
    unsigned arg2
  ) :
   cond(cond), id(id)
  {
    args.splitted.arg1 = arg1;
    args.splitted.arg2 = arg2;
  }
};

#endif /* _H_OPCODE_ */