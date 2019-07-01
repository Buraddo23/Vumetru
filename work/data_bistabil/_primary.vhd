library verilog;
use verilog.vl_types.all;
entity data_bistabil is
    port(
        clock           : in     vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic;
        data_in         : in     vl_logic_vector(7 downto 0);
        load            : in     vl_logic;
        error           : in     vl_logic;
        data_out        : out    vl_logic_vector(7 downto 0)
    );
end data_bistabil;
