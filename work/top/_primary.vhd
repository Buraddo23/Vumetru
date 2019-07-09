library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        BOARD_FREQ      : integer := 100000000;
        BAUD_RATE       : integer := 115200;
        VGA_FREQ        : integer := 25000000
    );
    port(
        rx              : in     vl_logic;
        clk_board       : in     vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic;
        h_sync          : out    vl_logic;
        v_sync          : out    vl_logic;
        red             : out    vl_logic_vector(2 downto 0);
        green           : out    vl_logic_vector(2 downto 0);
        blue            : out    vl_logic_vector(1 downto 0)
    );
end top;
