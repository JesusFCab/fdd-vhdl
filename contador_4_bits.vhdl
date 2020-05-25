library ieee;

use ieee.std_logic_1164.all ;
use work.std_ari th.all ;

entity cont4 is port (
    elk: in std_logic;
    Q: inout std_logic_vector(3 downto 0)
);
end cont4;

architecture arqeont of cont4 is begin

    process (elk) begin

    if (elk'event and elk = '1') then
        Q <= Q + 1;

    end if;

    end process ;

end arqeont; 