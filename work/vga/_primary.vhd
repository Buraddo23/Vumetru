library verilog;
use verilog.vl_types.all;
entity vga is
    generic(
        THADDR          : integer := 640;
        THFP            : integer := 16;
        THS             : integer := 96;
        THBP            : integer := 48;
        THBD            : integer := 0;
        TVADDR          : integer := 480;
        TVFP            : integer := 10;
        TVS             : integer := 2;
        TVBP            : integer := 33;
        TVBD            : integer := 0;
        H_POL           : integer := 0;
        V_POL           : integer := 0;
        C_SIZE          : integer := 9
    );
    port(
        pixel_clock     : in     vl_logic;
        reset           : in     vl_logic;
        h_sync          : out    vl_logic;
        v_sync          : out    vl_logic;
        red             : out    vl_logic_vector(2 downto 0);
        green           : out    vl_logic_vector(2 downto 0);
        blue            : out    vl_logic_vector(1 downto 0)
    );
end vga;
