library verilog;
use verilog.vl_types.all;
entity top_clk_gen is
    generic(
        board_freq      : integer := 10000;
        baud_rate       : integer := 9600
    );
    port(
        clk_board       : in     vl_logic;
        clk_out_uart    : out    vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic
    );
end top_clk_gen;
