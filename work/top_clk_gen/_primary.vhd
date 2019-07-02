library verilog;
use verilog.vl_types.all;
entity top_clk_gen is
    generic(
        board_freq      : integer := 50000000;
        baud_rate       : integer := 9600;
        vga_freq        : integer := 25175000
    );
    port(
        clk_board       : in     vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic;
        clk_out_uart    : out    vl_logic;
        clk_out_vga     : out    vl_logic
    );
end top_clk_gen;
