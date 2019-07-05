library verilog;
use verilog.vl_types.all;
entity uart is
    generic(
        IDLE            : integer := 0;
        DET_START       : integer := 1;
        READ            : integer := 2;
        DET_STOP        : integer := 3;
        ERR             : integer := 4
    );
    port(
        rx              : in     vl_logic;
        clkx16          : in     vl_logic;
        reset           : in     vl_logic;
        data            : out    vl_logic_vector(7 downto 0);
        load            : out    vl_logic;
        error           : out    vl_logic
    );
end uart;
