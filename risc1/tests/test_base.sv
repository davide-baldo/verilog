`include "conf.sv"
`include "cpu.sv"
`include "memory.sv"
`include "testing.sv"
`include "opcode.sv"

module test(
  input clock,
  output stop_clock,
  
  input read_ready,
  output [`ARCH_SIZE_1:0] read_address,
  
  input write_ready,
  output [`ARCH_SIZE_1:0] write_address,
  
  output read,
  input [15:0] read_value,
  
  output write,  
  output [15:0] write_value
);
  int stage;
  byte randomValue;
  bit [`ARCH_SIZE_1:0] randomAddress;

  Opcode opcode;
  
  MemoryAccessor accessor(
    read_ready, 
    read_address, 
    write_ready,
    write_address,
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