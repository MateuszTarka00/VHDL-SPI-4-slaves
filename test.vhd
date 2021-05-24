LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uut
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         miso : IN  std_logic;
         mode : IN  std_logic;
         enable : IN  std_logic;
         scl : IN  std_logic_vector(3 downto 0);
         tx_data : IN  std_logic_vector(7 downto 0);
         sclk_div : IN  std_logic_vector(1 downto 0);
         mosi : OUT  std_logic;
         sclk : OUT  std_logic;
         rx_data : OUT  std_logic_vector(7 downto 0);
         scl_out : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal miso : std_logic := '0';
   signal mode : std_logic := '0';
   signal enable : std_logic := '0';
   signal scl : std_logic_vector(3 downto 0) := (others => '0');
   signal tx_data : std_logic_vector(7 downto 0) := (others => '0');
   signal sclk_div : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal mosi : std_logic;
   signal sclk : std_logic;
   signal rx_data : std_logic_vector(7 downto 0);
   signal scl_out : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant sclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   test: uut PORT MAP (
          clk => clk,
          reset => reset,
          miso => miso,
          mode => mode,
          enable => enable,
          scl => scl,
          tx_data => tx_data,
          sclk_div => sclk_div,
          mosi => mosi,
          sclk => sclk,
          rx_data => rx_data,
          scl_out => scl_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   sclk_process :process
   begin
		sclk <= '0';
		wait for sclk_period/2;
		sclk <= '1';
		wait for sclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		
		reset <= '0'; wait for 2*clk_period;
		reset <= '1'; wait for 2*clk_period;
		
		assert false severity failure;
      wait;
   end process;

END;
