`ifndef _H_UNIT_TESTING_
`define _H_UNIT_TESTING_

`define ASSERT_EQUALS(x,y) \
    repeat(1)\
    begin\
        if( (x) !== (y) ) \
        begin\
            $write( "%s:%d failed: excepted %d but was %d\n", `__FILE__, `__LINE__, (x), (y) );\
            $finish;\
        end\
    end 

`endif