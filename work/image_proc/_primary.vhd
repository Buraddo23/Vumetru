library verilog;
use verilog.vl_types.all;
entity image_proc is
    generic(
        C_SIZE          : integer := 9
    );
    port(
        reset           : in     vl_logic;
        clock           : in     vl_logic;
        disp_enable     : in     vl_logic;
        row             : in     vl_logic_vector;
        column          : in     vl_logic_vector;
        red             : out    vl_logic_vector(2 downto 0);
        green           : out    vl_logic_vector(2 downto 0);
        blue            : out    vl_logic_vector(1 downto 0)
    );
end image_proc;
