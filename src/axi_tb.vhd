--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:51:05 05/07/2017
-- Design Name:   
-- Module Name:   D:/BME/MSC1/RA/HF/axi/axi_1/axi_tb.vhd
-- Project Name:  axi_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: axi
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY axi_tb IS
END axi_tb;
 
ARCHITECTURE behavior OF axi_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT axi
    PORT(
         S_AXI_ACLK : IN  std_logic;
         S_AXI_ARESETN : IN  std_logic;
         S_AXI_AWADDR : IN  std_logic_vector(31 downto 0);
         S_AXI_AWVALID : IN  std_logic;
         S_AXI_AWREADY : OUT  std_logic;
         S_AXI_WDATA : IN  std_logic_vector(31 downto 0);
         S_AXI_WSTRB : IN  std_logic_vector(3 downto 0);
         S_AXI_WVALID : IN  std_logic;
         S_AXI_WREADY : OUT  std_logic;
         S_AXI_ARADDR : IN  std_logic_vector(31 downto 0);
         S_AXI_ARVALID : IN  std_logic;
         S_AXI_ARREADY : OUT  std_logic;
         S_AXI_RDATA : OUT  std_logic_vector(31 downto 0);
         S_AXI_RRESP : OUT  std_logic_vector(1 downto 0);
         S_AXI_RVALID : OUT  std_logic;
         S_AXI_RREADY : IN  std_logic;
         S_AXI_BRESP : OUT  std_logic_vector(1 downto 0);
         S_AXI_BVALID : OUT  std_logic;
         S_AXI_BREADY : IN  std_logic;
         spi_dev_sel : OUT  std_logic_vector(0 downto 0);
         spi_send_data : OUT  std_logic_vector(23 downto 0);
         spi_rec_data : IN  std_logic_vector(23 downto 0);
         spi_busy : IN  std_logic;
         spi_valid : IN  std_logic;
         spi_en : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal S_AXI_ACLK : std_logic := '0';
   signal S_AXI_ARESETN : std_logic := '0';
   signal S_AXI_AWADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal S_AXI_AWVALID : std_logic := '0';
   signal S_AXI_WDATA : std_logic_vector(31 downto 0) := (others => '0');
   signal S_AXI_WSTRB : std_logic_vector(3 downto 0) := (others => '0');
   signal S_AXI_WVALID : std_logic := '0';
   signal S_AXI_ARADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal S_AXI_ARVALID : std_logic := '0';
   signal S_AXI_RREADY : std_logic := '0';
   signal S_AXI_BREADY : std_logic := '0';
   signal spi_rec_data : std_logic_vector(23 downto 0) := (others => '0');
   signal spi_busy : std_logic := '0';
   signal spi_valid : std_logic := '0';

 	--Outputs
   signal S_AXI_AWREADY : std_logic;
   signal S_AXI_WREADY : std_logic;
   signal S_AXI_ARREADY : std_logic;
   signal S_AXI_RDATA : std_logic_vector(31 downto 0);
   signal S_AXI_RRESP : std_logic_vector(1 downto 0);
   signal S_AXI_RVALID : std_logic;
   signal S_AXI_BRESP : std_logic_vector(1 downto 0);
   signal S_AXI_BVALID : std_logic;
   signal spi_dev_sel : std_logic_vector(0 downto 0);
   signal spi_send_data : std_logic_vector(23 downto 0);
   signal spi_en : std_logic;

   -- Clock period definitions
   constant S_AXI_ACLK_period : time := 62.5 ns; --16Mhz -> 1/16Mhz = 0.0625 us = 62.5 ns
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: axi PORT MAP (
          S_AXI_ACLK => S_AXI_ACLK,
          S_AXI_ARESETN => S_AXI_ARESETN,
          S_AXI_AWADDR => S_AXI_AWADDR,
          S_AXI_AWVALID => S_AXI_AWVALID,
          S_AXI_AWREADY => S_AXI_AWREADY,
          S_AXI_WDATA => S_AXI_WDATA,
          S_AXI_WSTRB => S_AXI_WSTRB,
          S_AXI_WVALID => S_AXI_WVALID,
          S_AXI_WREADY => S_AXI_WREADY,
          S_AXI_ARADDR => S_AXI_ARADDR,
          S_AXI_ARVALID => S_AXI_ARVALID,
          S_AXI_ARREADY => S_AXI_ARREADY,
          S_AXI_RDATA => S_AXI_RDATA,
          S_AXI_RRESP => S_AXI_RRESP,
          S_AXI_RVALID => S_AXI_RVALID,
          S_AXI_RREADY => S_AXI_RREADY,
          S_AXI_BRESP => S_AXI_BRESP,
          S_AXI_BVALID => S_AXI_BVALID,
          S_AXI_BREADY => S_AXI_BREADY,
          spi_dev_sel => spi_dev_sel,
          spi_send_data => spi_send_data,
          spi_rec_data => spi_rec_data,
          spi_busy => spi_busy,
          spi_valid => spi_valid,
          spi_en => spi_en
        );

   -- Clock process definitions
   S_AXI_ACLK_process :process
   begin
		S_AXI_ACLK <= '0';
		wait for S_AXI_ACLK_period/2;
		S_AXI_ACLK <= '1';
		wait for S_AXI_ACLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	

      wait for S_AXI_ACLK_period*2;

      -- insert stimulus here 
		
		-- WRITE TRANSACTION
		 S_AXI_AWADDR <= X"30000001";
		 S_AXI_AWVALID <= '1';
		 S_AXI_WDATA <= X"aabb02cc"; --WRITE opcode: 0000 0010
		 S_AXI_WVALID <= '1';
		 wait for 2*S_AXI_ACLK_period;
		 S_AXI_AWADDR <= X"00000000"; 
		 S_AXI_WDATA <= X"00000000";
		 S_AXI_AWVALID <= '0'; 
       S_AXI_WVALID <= '0'; 
		 wait for 2*S_AXI_ACLK_period;
		 
		 -- READ TRANSACTION
		 S_AXI_ARADDR <= X"03400000"; --READ opcode: 0000 0011
		 S_AXI_ARVALID <= '1';
		 wait for 2*S_AXI_ACLK_period;
		 S_AXI_ARADDR <= X"00000000"; 
		 S_AXI_ARVALID <= '0';
		 wait for 2*S_AXI_ACLK_period;
	
		-- WRITE + READ TRANSACTION
		 S_AXI_AWADDR <= X"30000001";
		 S_AXI_AWVALID <= '1';
		 S_AXI_WDATA <= X"aabb02cc"; --WRITE opcode: 0000 0010
		 S_AXI_WVALID <= '1';
		 
		 S_AXI_ARADDR <= X"03400000"; --READ opcode: 0000 0011
		 S_AXI_ARVALID <= '1';
		 wait for 2*S_AXI_ACLK_period;
		 S_AXI_AWADDR <= X"00000000"; 
		 S_AXI_WDATA <= X"00000000";
		 S_AXI_AWVALID <= '0'; 
       S_AXI_WVALID <= '0'; 
		 
		 S_AXI_ARADDR <= X"00000000"; 
		 S_AXI_ARVALID <= '0';

		 wait for 2*S_AXI_ACLK_period;
		--
	
      wait;
   end process;

END;
