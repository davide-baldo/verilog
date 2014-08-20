
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

`include "../common/testing.v"
module test;

  int stage;
  byte randomValue;
  bit [`ARCH_SIZE_1:0] randomAddress;
  
  MemoryAccessor accessor;
  FixedMemory mem(accessor);

  initial
  begin
    $display("Staring memory test");
    randomValue = 123;
    randomAddress = 102;
    stage = 1;
  end

  always_ff @(posedge accessor.ready)
  begin
    case (stage)
      1: begin
        `ASSERT_EQUALS( 1, accessor.ready );
        accessor.write = 0;
        stage = stage+1;
      end
      2: begin
        `ASSERT_EQUALS( 1, accessor.ready );
        `ASSERT_EQUALS( randomValue, accessor.read_value );
        stage = stage+1;
      end
    endcase      
  end

  always_ff @(stage)
  begin  
    $display("stage %d, read_value %d, write_value %d, addr %d, write %d, read %d, ready %d", stage, accessor.read_value, accessor.write_value, accessor.address, accessor.write, accessor.read, accessor.ready );
    case (stage)
      1: begin
        accessor.write_value = randomValue;
        accessor.address = randomAddress;
        accessor.write = 1; 
      end
      2: begin     
        accessor.address = randomAddress;
        accessor.read = 1;
      end
      
      3: begin
        $finish();
      end
    endcase
  end

endmodule