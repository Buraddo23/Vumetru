library verilog;
use verilog.vl_types.all;
entity vga is
    generic(
        thaddr          : integer := 640;
        thfp            : integer := 16;
        ths             : integer := 96;
        thbp            : integer := 48;
        thbd            : integer := 0;
        tvaddr          : integer := 480;
        tvfp            : integer := 10;
        tvs             : integer := 2;
        tvbp            : integer := 33;
        tvbd            : integer := 0;
        h_pol           : integer := 0;
        v_pol           : integer := 0
    );
    port(
        pixel_clock     : in     vl_logic;
        reset           : in     vl_logic;
        h_sync          : out    vl_logic;
        v_sync          : out    vl_logic;
        red             : out    vl_logic_vector(7 downto 0);
        green           : out    vl_logic_vector(7 downto 0);
        blue            : out    vl_logic_vector(7 downto 0)
    );
end vga;
