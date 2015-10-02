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
      top->ready = 0;
      top->read = 0;
      top->write = 0;
      top->address = 0;
      top->read_value = 0;
      top->write_value = 0;
    }
    
    void emulate( TOP *top )
    {
      //printf("read: %i write: %i address: %lx ready: %i\n", top->read, top->write, top->address, top->ready);
      
      assert( !(top->write && top->read) );
      
      if( top->write )
      {
        assert( top->address < mSize );
        mRawMemory[top->address] = top->write_value;
        top->ready = 1;
      }
      
      if( top->read )
      {
        assert( top->address < mSize );
        top->read_value = mRawMemory[top->address];
        top->ready = 1;
      }
      
      if( !top->read && !top->write )
      {
        top->ready = 0;
      }
    }
    
    void write16(unsigned int address, int value)
    {
      assert( address < mSize-1 );
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
