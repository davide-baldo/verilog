
void initMemory(Memory &memory)
{
  memory.writeOpcode( 0x0, ADDI, ALWAYS, REG1, 5 );
  
  memory.writeOpcode( 0x2, STORE, ALWAYS, REG1, REG2 );
  memory.writeOpcode( 0x2, HALT, ALWAYS );
}

void assertMemory(Memory &memory)
{
  assert( memory.read8(0) == 5 );
}