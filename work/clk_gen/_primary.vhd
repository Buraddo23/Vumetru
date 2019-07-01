library verilog;
use verilog.vl_types.all;
entity clk_gen is
    generic(
        in_freq         : integer := 1;
        out_freq        : integer := 1;
        bit_size        : integer := 13
    );
    port(
        clk_in          : in     vl_logic;
        clk_out         : out    vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic
    );
end clk_gen;
