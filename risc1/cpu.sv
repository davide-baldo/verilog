`include "conf.sv"
`include "testing.sv"

module cpu
(
  clock,
  stop_clock,  
  MemoryAccessor memory
);

`define NOOP 0
`define HALT 31

input clock;
output stop_clock;
reg stop_clock;

/*
  cpu registers
*/
reg[`ARCH_SIZE_1:0] cpu_ip;
integer stage;
reg [7:0] cpu_current_opcode;

task fetch_instruction;
  input  [`ARCH_SIZE_1:0] address;
  output [7:0] destination;
  begin
    `ASSERT_EQUALS(0,memory.read);
    memory.address <= address;
    memory.read = 1;
    $display("read <= 1");
  end
endtask

always @(posedge memory.ready)
begin
  if( memory.read )
  begin
    `ASSERT_EQUALS(1,memory.read);
    cpu_current_opcode = memory.read_value;    
    memory.read = 0;
    $display("read <= 0");
  end
end

task exec_opcode;
  input [7:0] opcode;
  begin
    case( opcode )
      `NOOP: ;
      `HALT: stop_clock = 1;
    endcase
  end
endtask

always @(posedge clock)
begin
  $display("stage: %d, opcode: %d, ip: %d",stage, cpu_current_opcode, cpu_ip);
  case( stage )
    0:if( !memory.read )
      begin
        fetch_instruction(cpu_ip, cpu_current_opcode);
        stage <= 1;
        cpu_ip <= cpu_ip + 2;
      end
      
    1:if( !memory.read )
      begin
        exec_opcode(cpu_current_opcode);
        stage <= 0;        
      end 
    endcase
end

initial
begin
  stage = 0;
  cpu_ip = 0;
  stop_clock = 0;
end

endmodule