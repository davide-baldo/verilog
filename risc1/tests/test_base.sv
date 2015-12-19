`include "conf.sv"
`include "cpu.sv"
`include "memory.sv"
`include "testing.sv"
`include "opcode.sv"

module test(
  input clock,
  output stop_clock,
  
  input ready,
  output [`ARCH_SIZE_1:0] address,
  
  output read,
  input [7:0] read_value,
  
  output write,  
  output [7:0] write_value
);
  int stage;
  byte randomValue;
  bit [`ARCH_SIZE_1:0] randomAddress;

  Opcode opcode;
  
  MemoryAccessor accessor(
    ready, 
    address, 
    read,
    read_value, 
    write, 
    write_value
  );
  
  cpu cpu(
    clock,
    stop_clock,
    accessor
  );
endmodule