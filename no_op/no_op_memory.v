`include "testing.v"
`include "config.v"

/*
  memory emulator
    return NOOP for addresses <= 16, HALT afterwards
*/

module no_op_memory(
  mem_address,
  mem_value,
  mem_read,
  mem_ready
);

input  [`ARCH_SIZE:0] mem_address;
output [`ARCH_SIZE:0] mem_value;
output mem_ready;
input mem_read;

reg [`ARCH_SIZE:0] mem_value;
reg mem_ready;

always @(mem_read)
begin
  if( mem_read == 0 )
  begin
    mem_ready <= 0;
  end else
  begin
    if( mem_address <= 16 )
      mem_value <= `NOOP;
    else
      mem_value <= `HALT;
    mem_ready <= 1;
  end
end

initial
begin
  mem_ready = 0;
end

endmodule