/* verilator lint_off UNOPTFLAT */
`ifndef _H_MEMORY_
`define _H_MEMORY_

`include "conf.sv"

interface MemoryAccessor(
  input ready,
  output address,
  
  output read,
  input read_value,
  
  output write,  
  output write_value
);

  logic ready;
  logic [`ARCH_SIZE_1:0] address;
  
  logic read;
  logic [7:0] read_value;
  
  logic write;  
  logic [7:0] write_value;
  
endinterface


`endif /* _H_MEMORY_ */