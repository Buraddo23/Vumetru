library verilog;
use verilog.vl_types.all;
entity uart is
    generic(
        idle            : integer := 0;
        det_start       : integer := 1;
        read            : integer := 2;
        det_stop        : integer := 3;
        err             : integer := 4
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
