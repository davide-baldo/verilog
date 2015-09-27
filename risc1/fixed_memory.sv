
/* verilator lint_off UNOPTFLAT */

`include "conf.sv"
`include "memory.sv"

module FixedMemory(MemoryAccessor accessor);
  byte memory [127:0];
  
  always_ff @(accessor.write or accessor.read)
  begin
    if (accessor.read)
    begin
      $display("read");
      accessor.read_value = memory[ 7'(accessor.address) ];    
      accessor.ready = 1;
    end else
    if (accessor.write)
    begin
      $display("write");
      memory[ 7'(accessor.address) ] = accessor.write_value;
      accessor.ready = 1;
    end else
    begin
      accessor.ready = 0;
    end
  end

endmodule
