/* verilator lint_off UNOPTFLAT */
`ifndef _H_MEMORY_
`define _H_MEMORY_

`include "conf.sv"

interface MemoryAccessor(
  input read_ready,
  output read_address,
  
  input write_ready,
  output write_address,
  
  output read,
  input read_value,
  
  output write,  
  output write_value
);

  logic read_ready;
  logic [`ARCH_SIZE_1:0] read_address;
  
  logic write_ready;
  logic [`ARCH_SIZE_1:0] write_address;
  
  logic read;
  logic [15:0] read_value;
  
  logic write;  
  logic [15:0] write_value;
  
endinterface


`endif /* _H_MEMORY_ */