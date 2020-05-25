library ieee;
use ieee.std_logic_1164.all;
use work.std_arith.all;

entity controlEntrada is port(
    reset: in std_logic;                                    -- Señal proveniente del controlado.
    boton: in std_logic_vector(0 to 9);                     -- Digito presionado en el teclado.
    sensor: in std_logic;                                   -- Señal que marca el paso de una pastilla.
    displayA, displayB; out std_logic_vector(0 to 6);       -- Displays de salida para mostrar el número.
    comparador: out std_logic;                              -- Comparador entre el número ingresado y la cantida de pastillas envasadas.
);
end controlEntrada;

architecture arq_controlEntrada of controlEntrada is

signal C,RA,RB: std_logic_vector(3 downto 0);               -- Codificador y registro.
signal Q, CONV: std_logic_vector(6 downto 0);               -- Contador y convertidor.
signal tecla: std_logic_vector(1 downto 0);                 -- Teclas presionadas.
signal CARRY: std_logic_vector(0 to 6);                     -- Bit de acarreo del convertidor.
signal X: std_logic_vector(0 to 1);                         -- Señal interna del convertidor.

begin

    teclado: process(boton,C, tecla)
        variable i: std_logic_vector(1 downto 0):= "00";
        begin
            if(boton = "1000000000") then
                    C <= "0000"; tecla <= i;
            if(boton = "0100000000") then
                    C <= "0001"; tecla <= i;
            if(boton = "0010000000") then
                    C <= "0010"; tecla <= i;
            if(boton = "0001000000") then
                    C <= "0011"; tecla <= i;
            if(boton = "0000100000") then
                    C <= "0100"; tecla <= i;
            if(boton = "0000010000") then
                    C <= "0101"; tecla <= i;
            if(boton = "0000001000") then
                    C <= "0110"; tecla <= i;
            if(boton = "0000000100") then
                    C <= "0111"; tecla <= i;
            if(boton = "0000000010") then
                    C <= "1000"; tecla <= i;
            else
                C <= "1001"; tecla <= i;
            end if;


            if (tecla = "00") then
                RB <= C;
            else
                RA <= C;
            end if;

            i := i+1;

            
            if (i = "10") then
                i := "00";
            end if;
    end process;

    display:process(RA, RB) begin
        case RA is                                          -- Enciende el display menos significativo, display de las unidades.
            when "0000" => displayA <= "0000001";
            when "0001" => displayA <= "1001111";
            when "0010" => displayA <= "0010010";
            when "0011" => displayA <= "0000110";
            when "0100" => displayA <= "1001100";
            when "0101" => displayA <= "0100100";
            when "0110" => displayA <= "0100000";
            when "0111" => displayA <= "0001111";
            when "1000" => displayA <= "0000000";
            when others => displayA <= "0001100";
        end case;

        case RA is                                          -- Enciende el display más significativo, display de las centenas.
            when "0000" => displayB <= "0000001";
            when "0001" => displayB <= "1001111";
            when "0010" => displayB <= "0010010";
            when "0011" => displayB <= "0000110";
            when "0100" => displayB <= "1001100";
            when "0101" => displayB <= "0100100";
            when "0110" => displayB <= "0100000";
            when "0111" => displayB <= "0001111";
            when "1000" => displayB <= "0000000";
            when others => displayB <= "0001100";
        end case;
        
    end process;

    convertidor:process (RA, RB, CARRY, X)
    variable z: std_logic := "0";
    begin
        CONV(0) <= RA(0);
        CONV(1) <= RA(1) xor RB(0);
        CARRY(0) <= RA(1) and RB(1);
        CONV(2) <= RA(2) xor RB(1) xor CARRY(0);
        CARRY(1)<= (RA(2) and RB(1)) or (CARRY(0) and (RA(2) xor RB(1)));
        X(0) <= RA(3) xor RB(0) xor CARRY(1);
        CARRY(2) <= (RA(3) and RB(0)) or (CARRY(1) and(RA(3) xor RB(1));
        CONV(3) <= X(0) xor RB(2);
        CARRY(3) <= X(0) and RB(2);
        X(1) <= CARRY(2) xor RB(1) xor CARRY(3);
        CARRY(4) <= (CARRY(2) and RB(1))or (CARRY(3) and (CARRY(2) xor RB(1)));
        CONV(4) <= X(1) xor RB(3);
        CARRY(5)<= X(1)and RB(3);
        CONV(5) <= CARRY(4) xor RB(1) xor CARRY(5);
        CARRY(6)<= (CARRY(4) andRB(1)) or(CARRY(5) and (CARRY(4) xor RB(1)));
        CONV(6) <= ( z xor RB(3) xor CARRY(6) ) ;
    end process;

    contador:process (sensor, reset, Q) begin
        if(sensor'event and sensor = "1") then
            Q <= "0000000";
            Q <= Q+1;
            if(reset = "1" or Q = "1100011") then           -- Reset en 99.
                Q <= "0000000";
            end if;
        end if;
    end process;

    -- Salida del comparador.
    comparador <= "1" when Q=CONV else "0";

    
end architecture;            