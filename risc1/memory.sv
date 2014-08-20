`ifndef _H_MEMORY_
`define _H_MEMORY_

`include "conf.sv"

interface MemoryAccessor();
  logic [`ARCH_SIZE_1:0] address;
  logic [7:0] value;
  logic read;
  logic write;
  logic ready;
  
  initial
  begin
    write = 0;
    read  = 0;
    ready = 0;
  end
endinterface


`endif /* _H_MEMORY_ */