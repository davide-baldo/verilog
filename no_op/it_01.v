`include "testing.v"
`include "config.v"

module cpu_user();

reg clock;
input stop_clock;

wire [`ARCH_SIZE:0] mem_address;
wire [`ARCH_SIZE:0] mem_value;
wire mem_read;
wire mem_ready;

no_op_cpu cpu(
  clock,
  stop_clock,
  mem_address,
  mem_value,
  mem_read,
  mem_ready
);

no_op_memory memory(
  mem_address,
  mem_value,
  mem_read,
  mem_ready
);

initial
begin  
  $display("starting cpu");  
  clock = 0;
  
  while (!stop_clock)
  begin
    $display("clock");
    clock = !clock;
    #1 clock = !clock;
  end
  
  $display("clock stopped");
  $finish();
end

endmodule