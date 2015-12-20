
void initMemory(Memory &memory)
{
  memory.writeOpcode(
    0x0,
    Opcode(ALWAYS, NOOP)
  );
  
  memory.writeOpcode(
    0x2,
    Opcode(ALWAYS, HALT)
  );
}

void assertMemory(Memory &memory)
{
  
}