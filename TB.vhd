LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
 
ENTITY TB IS
END TB;
 
ARCHITECTURE behavior OF TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uut
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         miso : IN  std_logic;
         scl : IN  std_logic_vector(3 downto 0);
         tx_data : IN  std_logic_vector(7 downto 0);
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
   signal scl : std_logic_vector(3 downto 0) := (others => '0');
   signal tx_data : std_logic_vector(7 downto 0) := (others => '0');

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
          scl => scl,
          tx_data => tx_data,
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
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '0'; wait for 2*clk_period;
		reset <= '1'; wait for 2*clk_period;
		tx_data <= "10110110"; wait for clk_period; 
		scl <= "0101"; wait for 9.5*clk_period;
		
		miso <= '1'; wait for clk_period;
		miso <= '1'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		miso <= '1'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		miso <= '1'; wait for clk_period;
		miso <= '0'; wait for clk_period*0.5;
		scl <= "1111"; wait for clk_period*0.5;
		
		miso <= '0'; wait for 3*clk_period;
		scl <= "1011"; wait for 5*clk_period;
		reset <= '0'; wait for 2*clk_period;
		
		reset <= '1'; wait for 2*clk_period; 
		scl <= "0111"; wait for 10*clk_period;
		
		miso <= '1'; wait for clk_period;
		miso <= '1'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		miso <= '1'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		miso <= '1'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		miso <= '1'; wait for clk_period;
		miso <= '0'; wait for clk_period;
		scl <= "1111"; wait for 4*clk_period;
		
	assert false severity failure;
   end process;

END;
