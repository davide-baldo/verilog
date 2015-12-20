`include "conf.sv"
`include "testing.sv"
`include "opcode.sv"

module cpu
(
  clock,
  stop_clock,  
  MemoryAccessor memory
);

input clock;
output stop_clock;
reg stop_clock;

/*
  cpu registers
*/
reg [`ARCH_SIZE_1:0] [15:0] registers;
reg [`ARCH_SIZE_1:0] cpu_ip;
integer stage;
Opcode cpu_current_opcode;

task fetch_instruction;
  input  [`ARCH_SIZE_1:0] address;
  output [15:0] destination;
  begin
    `ASSERT_EQUALS(0,memory.read);
    memory.read_address <= address;
    memory.read = 1;
    $display("read <= 1");
  end
endtask

always @(posedge memory.read_ready)
begin
  if( memory.read )
  begin
    `ASSERT_EQUALS(1,memory.read);
    cpu_current_opcode = memory.read_value;    
    memory.read = 0;
    $display("read <= 0");
  end
end

always @(posedge memory.write_ready)
begin
  if( memory.write )
  begin  
    memory.write = 0;
  end
end

task exec_opcode;
  input Opcode opcode;
  begin
  
    case( opcode.id )
      NOOP: ;
      HALT: stop_clock = 1;
      ADDI:
      begin
        $display(
          "ADDI reg%d = %d + %d",
          opcode.args.splitted.arg1,
          registers[opcode.args.splitted.arg1],
          opcode.args.splitted.arg2
        );
        registers[opcode.args.splitted.arg1] = 
          registers[opcode.args.splitted.arg1] +
          opcode.args.splitted.arg2;
        $display("Result: %d", registers[opcode.args.splitted.arg1]);
      end
      
      STORE:
      begin
        $display(
          "STORE addr %d <= %d",
          registers[opcode.args.splitted.arg1],
          registers[opcode.args.splitted.arg2]
        );
        memory.write_address[15:0] <= registers[opcode.args.splitted.arg1];
        memory.write_value <= registers[opcode.args.splitted.arg2];
        memory.write = 1;
      end
      
      XOR:
      begin
        registers[opcode.args.splitted.arg1] = 
          registers[opcode.args.splitted.arg1] ^ 
          registers[opcode.args.splitted.arg2];
      end
    endcase
  end
endtask

always @(posedge clock)
begin
  $display("stage: %d, opcode: %x, id: %d, ip: %d", stage, cpu_current_opcode, cpu_current_opcode.id, cpu_ip);
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