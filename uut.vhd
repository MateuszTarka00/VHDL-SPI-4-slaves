LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity uut is
	port( clk : in std_logic;
			reset : in std_logic;
			scl: in std_logic_vector(3 downto 0);
			tx_data : in std_logic_vector(7 downto 0);
			miso : in std_logic;
			mosi: out std_logic;
			sclk: out std_logic;			
			rx_data: out std_logic_vector(7 downto 0);
			scl_out: out std_logic_vector(3 downto 0));
end uut;

architecture uut_arch of uut is

type STANY is ( ready, standby, execute );
signal stan, stan_nast : STANY;

signal stop : std_logic;
signal start : std_logic;
signal data_buf : std_logic_vector(7 downto 0);
signal counter : std_logic_vector(4 downto 0);
signal slave : std_logic_vector(3 downto 0);

begin

reg: process(clk, stan_nast)
begin
	if(reset = '0') then
		stan <= standby;
	elsif( clk'Event and clk = '1') then
		stan <= stan_nast;
	end if;
		
end process reg;

komb: process(stan, start, slave, stop)
begin

	stan_nast <= stan;
	
	case stan is
		when ready =>
			if(slave < "1111") then
					stan_nast <= execute;
			end if;
				
		when execute =>
			if( stop =  '1') then
				stan_nast <= standby;
			end if;
			
		when standby =>
			if (start = '1') then
				stan_nast <= ready;
			end if;
			
		end case;
		
end process komb;
					
send_rec: process(stan, clk, reset, counter )
begin

	if (reset = '0') then
		data_buf <= (others => '0');
		counter <= (others => '0');
		slave <= (others => '1');
		rx_data <= (others => '0');
		mosi <= 'Z';
		start <= '0';
		stop <= '0';
		scl_out <= (others => '0');
	elsif( clk'Event and clk = '1') then
		case stan is
			when execute =>
	
					start <= '0';
					scl_out <= slave;
				
					if(counter < "01000") then
						mosi <= data_buf(7);
						data_buf <= data_buf(6 downto 0) & '0';
						counter <= counter + "01";
			
					elsif(counter >= "01000" and counter <= 10000) then
						mosi <= 'Z';
						
						if(counter = "10000") then
							rx_data <= data_buf;
							stop <= '1';
						else
							data_buf <=  data_buf(6 downto 0) & '0';
							data_buf(0) <= miso;
							counter <= counter + "01";
					end if;
				end if;
			
		when standby =>
			data_buf <= (others => '0');
			stop <= '0';
			counter <= (others => '0');
			slave <= (others => '1');
			start <= '1';
		
		when ready =>
			if(scl > "0000") then
				if( (scl = "0111") or (scl = "1011") or (scl = "1101") or (scl = "1110") ) then
					slave <= scl;
				else
					slave <= "1110";
				end if;
			else 
				slave <= "0000";
			end if;
			
			data_buf <= tx_data;
			
		end case;
		
	end if;

end process send_rec;

sclk_gen: process(stan,clk,counter)
begin
	if (reset = '0') then
		sclk <= '0';
	elsif( clk'Event and clk = '1') then
		elsif (stan = execute and counter > "00000" and counter < "10001" ) then
				sclk <= clk;
			else
				sclk <= '0';
		end if;
end process sclk_gen;

end architecture uut_arch;

