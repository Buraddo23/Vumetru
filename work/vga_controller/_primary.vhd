library verilog;
use verilog.vl_types.all;
entity vga_controller is
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
        disp_enable     : out    vl_logic;
        row             : out    vl_logic_vector;
        column          : out    vl_logic_vector
    );
end vga_controller;
