
module no_op_cpu
(
  clock,
  stop_clock,  
  mem_address,
  mem_value,
  mem_read,
  mem_ready
);


input clock;
output stop_clock;
reg stop_clock;

/*
  memory registers
*/
output [`ARCH_SIZE:0] mem_address;
reg    [`ARCH_SIZE:0] mem_address;
input  [`ARCH_SIZE:0] mem_value;
output mem_read;
reg    mem_read;
input  mem_ready;

/*
  cpu registers
*/
integer cpu_ip;
integer stage;
reg [`ARCH_SIZE:0] cpu_current_opcode;

task fetch_instruction;
  input  [`ARCH_SIZE:0] address;
  output [`ARCH_SIZE:0] destination;
  begin
    `ASSERT_EQUALS(0,mem_read);
    mem_address <= address;
    mem_read <= 1;
  end
endtask

always @(posedge mem_ready)
begin
  if( mem_read )
  begin
    `ASSERT_EQUALS(1,mem_read);
    cpu_current_opcode <= mem_value;    
    mem_read <= 0;
  end
end

task exec_opcode;
  input opcode;
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
    0:if( !mem_read )
      begin
        fetch_instruction(cpu_ip, cpu_current_opcode);
        stage <= 1;
        cpu_ip <= cpu_ip + 2;
      end
      
    1:if( !mem_read )
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
  mem_read = 0;
end

endmodule