library verilog;
use verilog.vl_types.all;
entity clk_gen is
    generic(
        IN_FREQ         : integer := 100000000;
        OUT_FREQ        : integer := 25000000;
        BIT_SIZE        : integer := 10
    );
    port(
        clk_in          : in     vl_logic;
        clk_out         : out    vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic
    );
end clk_gen;
