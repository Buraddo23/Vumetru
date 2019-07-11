library verilog;
use verilog.vl_types.all;
entity rom is
    generic(
        SIZE            : integer := 8;
        \FILE\          : string  := ""
    );
    port(
        clk             : in     vl_logic;
        address         : in     vl_logic_vector(15 downto 0);
        data            : out    vl_logic_vector
    );
end rom;
