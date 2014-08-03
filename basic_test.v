`include "testing.v"
    
module hello_world;

// 4 bit register
reg [3:0] counter;

always @(clock)
  begin
    counter = counter+1;
  end
  
reg clock;

initial begin
  counter = 0;
  clock = 0;
  
  repeat (10) #1 clock = !clock;
  `ASSERT_EQUALS(10, counter);
  
  repeat (5) #1 clock = !clock;
  `ASSERT_EQUALS(15, counter);
  
  repeat (2) #1 clock = !clock;
  `ASSERT_EQUALS(1, counter);
end

endmodule