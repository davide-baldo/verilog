
void initMemory(Memory &memory)
{  
  memory.writeOpcode(
    0x0,
    Opcode(ALWAYS, XOR, REG1, REG1)
  );
  
  memory.writeOpcode(
    0x2,
    Opcode(ALWAYS, XOR, REG2, REG2)
  );
  
  memory.writeOpcode(
    0x4,
    Opcode(ALWAYS,ADDI,REG2,5)
  );
  
  memory.writeOpcode(
    0x6,
    Opcode(ALWAYS, STORE, REG1, REG2)
  );
  
  memory.writeOpcode( 
    0x8,
    Opcode(ALWAYS, HALT)
  );
}

void assertMemory(Memory &memory)
{
  assert( memory.read8(0) == 5 );
}