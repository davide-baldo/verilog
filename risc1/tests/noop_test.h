
void initMemory(Memory &memory)
{
  memory.writeOpcode( 0x0, ADD, ALWAYS );
  memory.writeOpcode( 0x2, NOOP, ALWAYS );
  memory.writeOpcode( 0x4, NOOP, ALWAYS );
  memory.writeOpcode( 0x6, HALT, ALWAYS );
}

void assertMemory(Memory &memory)
{
  
}