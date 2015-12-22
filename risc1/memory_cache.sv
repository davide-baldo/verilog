
/*
  200 cycles for each memory wait should be a realistic
  wait for a 2.4Ghz processor which would wait about ~100ns
  
  ddr3 fetch minimum 8 bytes of data. one byte for each block of one side (that's a constant).
  Either the memory is reading or writing, not both, but you can activate the page just once.
  When you fetch you ask for an address RowXcolumn for each block, hence 8 bytes.
  (you can probably ask for ranges with batch).
  row ~= page
  In DDR3 each page is 8x1Kb or 8x2Kb or 32x4Kb relatively (2Gb, 4Gb, 8Gb rams)
  
  L1 cache timing should be 1~2 clocks
  L2 cache timing should ~14 clocks
  
*/
module MemoryCache
(
  clock,
  MemoryAccessor memory,
  input [`ARCH_SIZE_1:0] address,
  inout [`CACHE_SIZE_1:0] data,
  logic read,
  logic write,
  output done
);
begin

`define DELAY 200

logic reading;
logic writing;
int counter;

reg [`ARCH_SIZE_1:0] copiedAddress;
  
  always @(posedge clock)
  begin
    `ASSERT(!read && !write);
    
    if (done)
    begin
      done <= 0;
      return;
    end
    
    if (reading)
    begin
      if (counter == DELAY)
      begin
        data <= memory.read64( address );
        reading <= 0;
        done <= 1;
      end else
      begin
        counter <= counter+1;
      end      
      return;
    end
    
    if (read)
    begin
      counter <= 0;
      copiedAddress <= address;
      reading <= 1;
    end
    /*
    if (write)
    begin    
    end
    */
  end
  
end
