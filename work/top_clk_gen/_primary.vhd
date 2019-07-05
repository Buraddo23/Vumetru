library verilog;
use verilog.vl_types.all;
entity top_clk_gen is
    generic(
        BOARD_FREQ      : integer := 100000000;
        BAUD_RATE       : integer := 9600;
        VGA_FREQ        : integer := 25000000
    );
    port(
        clk_board       : in     vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic;
        clk_out_uart    : out    vl_logic;
        clk_out_vga     : out    vl_logic
    );
end top_clk_gen;
