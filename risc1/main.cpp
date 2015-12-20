//#include "Vfixed_memory.h"
#include "Vtest.h"
#include "Vtest_MemoryAccessor.h"
#include "verilated.h"
#include "opcode.h"
#include <assert.h>

#define TOP Vtest
#define MEMORY Vtest_MemoryAccessor

#include <stdlib.h>


void vl_finish (const char* filename, int linenum, const char* hier)
{
  if( !Verilated::gotFinish() )
  {
    VL_PRINTF("==== %s:%d -- Finish ====\n", filename, linenum);
    Verilated::gotFinish(true);
    Verilated::flushCall();
    exit(EXIT_SUCCESS);
  }
}


class Memory
{
  public:
    Memory( unsigned int size )
    : mSize(size)
    {
      mRawMemory = (char *)malloc(mSize);
    }
    
    ~Memory()
    {
      free(mRawMemory);
    }
    
    void initialize( TOP *top )
    {
      top->read_ready = 0;
      top->write_ready = 0;
      top->read = 0;
      top->write = 0;
      top->read_address = 0;
      top->write_address = 0;
      top->read_value = 0;
      top->write_value = 0;
    }
    
    void emulate( TOP *top )
    {
      //printf("read: %i write: %i address: %lx ready: %i\n", top->read, top->write, top->address, top->ready);
      
      if( top->write )
      {
        printf("writing: addr: %02llx value: %02x\n", top->write_address, top->write_value);
        assert( top->write_address+1 < mSize-1 );
        mRawMemory[top->write_address] = top->write_value;
        mRawMemory[top->write_address+1] = (top->write_value >> 8) & 0xFF;
        top->write_ready = 1;
      }
      else
      {
        top->write_ready = 0;
      }
      
      if( top->read )
      {
        assert( top->read_address + 1 < mSize );
        top->read_value = mRawMemory[top->read_address] << 8 |
                          mRawMemory[top->read_address+1];
        top->read_ready = 1;
      }
      else
      {
        top->read_ready = 0;
      }
    }
    
    void dump(int howMany)
    {
      for(int count=0; count < howMany; ++count)
      {
        if( count % 16 == 0 )
        {
          printf("\n");
        }
        printf("%02x ", mRawMemory[howMany]);
      }
      printf("\n");
      
      fflush(stdout);
    }
    
    int read8(unsigned int address)
    {
      assert( address < mSize-1 );
      return mRawMemory[address];
    }
    
    void write16(unsigned int address, int value)
    {
      assert( address < mSize-1 );
      printf("Writig in 0x%02x: 0x%02x\n",address, value);
      mRawMemory[address] = value & 0xff;
      mRawMemory[address+1] = (value << 8) & 0xff;
    }
    
    void writeOpcode(
      unsigned int address,
      OpcodeId id,
      OpcodeCondition cond
    )
    {
      write16(
        address,
        (id & 0x1F) | ((cond & 0x07) << 5)
      );
    }
    
    void writeOpcode(
      unsigned int address,
      OpcodeId id,
      OpcodeCondition cond,
      int arg1,
      int arg2
    )
    {
      write16(
        address,
        (id & 0x1F) | ((cond & 0x07) << 5) |
        ((arg1 & 0x0F) >> 8) | ((arg1 & 0x0F) >> 12)
      );
    }
    
    void writeOpcode(
      unsigned int address,
      OpcodeId id,
      OpcodeCondition cond,
      int argWhole
    )
    {
      write16(
        address,
        (id & 0x1F) | ((cond & 0x07) << 5) |
        ((argWhole & 0xFF) >> 8)
      );
    }
    
    void writeOpcode(
      unsigned int address,
      Opcode opcode
    )
    {
      char buffer[2];
      opcode.write(buffer);
      
      assert( address < mSize-1 );
      printf("Writig in 0x%02x: 0x%02x - 0x%02x\n",address, buffer[0], buffer[1]);
      mRawMemory[address] = buffer[0];
      mRawMemory[address+1] = buffer[1];
    }
      
    
  private:
    const unsigned int mSize;
    char *mRawMemory;
};

#include "current_test.h"

#ifndef MAX_TICKS
#define MAX_TICKS 25
#endif

int main(int argc, char **argv, char **env)
{
  printf("sizeof(Opcode): %i\n",sizeof(Opcode));

  Verilated::commandArgs(argc, argv);
  
  TOP* top = new TOP;  
  top->clock = 0;
  top->stop_clock = 0;  
  
  Memory memory(128);
  memory.initialize(top);

  initMemory(memory);
  
  int n=MAX_TICKS;
  for (; n >0; --n)
  {
    top->clock = !top->clock;
    top->eval();
    
    if( top->stop_clock )
      break;

    if( Verilated::gotFinish() )
      break;
    
    memory.emulate(top);
  }
  
  delete top;
 
  assertMemory(memory);
  
/*
 if( !Verilated::gotFinish() )
  {
    return EXIT_FAILURE;
  }
 */
  
  return EXIT_SUCCESS;
}
