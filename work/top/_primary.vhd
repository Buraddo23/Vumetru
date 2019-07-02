library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        board_freq      : integer := 50000000;
        baud_rate       : integer := 9600;
        vga_freq        : integer := 25175000
    );
    port(
        rx              : in     vl_logic;
        clk_board       : in     vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic;
        data            : out    vl_logic_vector(7 downto 0);
        h_sync          : out    vl_logic;
        v_sync          : out    vl_logic;
        red             : out    vl_logic_vector(2 downto 0);
        green           : out    vl_logic_vector(2 downto 0);
        blue            : out    vl_logic_vector(1 downto 0)
    );
end top;