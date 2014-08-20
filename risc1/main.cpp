#include "Vfixed_memory.h"
#include "verilated.h"

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


int main(int argc, char **argv, char **env)
{
  Verilated::commandArgs(argc, argv);
  
  Vfixed_memory* top = new Vfixed_memory;  
  for (int n=25; n >0; --n)
  {
    top->eval();    
    if( Verilated::gotFinish() )
      break;
  }
  
  delete top;
  
  if( !Verilated::gotFinish() )
  {
    return EXIT_FAILURE;
  }
  
  return EXIT_SUCCESS;
}
