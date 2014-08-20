/* verilator lint_off WIDTH */
/* verilator lint_off COMBDLY */
/* verilator lint_off UNOPTFLAT */

`include "conf.sv"
`include "memory.sv"

module FixedMemory(MemoryAccessor accessor);

  bit [7:0] memory [127:0];

  always @(*)
  begin
    if (accessor.read)
    begin
      $display("read");
      accessor.value = memory[ accessor.address ];    
      accessor.ready = 1;
    end
  end
  
  always @(*)
  begin
    if (accessor.write)
    begin
      $display("write");
      memory[ accessor.address ] = accessor.value;
      accessor.ready = 1;
    end
  end
  
  always @(*)
  begin
    if ( !(accessor.read|accessor.write) )
      accessor.ready = 0;
  end

endmodule

`include "../common/testing.v"
module test;

  int stage;
  int randomValue;
  int randomAddress;
  
  MemoryAccessor accessor;
  FixedMemory mem(accessor);

  initial
  begin
    $display("Staring memory test");
    randomValue = 123;
    randomAddress = 102;
    stage = 1;
  end

  always @(posedge accessor.ready)
  begin
    case (stage)
      1: begin
        `ASSERT_EQUALS( 1, accessor.ready );
        accessor.value = 0;
        accessor.write = 0;        
        stage++;
      end
      2: begin
        `ASSERT_EQUALS( 1, accessor.ready );
        `ASSERT_EQUALS( randomValue, accessor.value );
        stage++;
      end
    endcase      
  end

  always @(stage)
  begin  
    $display("stage %d, val %d, addr %d, write %d, read %d, ready %d", stage, accessor.value, accessor.address, accessor.write, accessor.read, accessor.ready );
    case (stage)
      1: begin
        accessor.value = randomValue;
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