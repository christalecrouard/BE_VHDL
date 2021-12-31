----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2021 16:16:05
-- Design Name: 
-- Module Name: Test_Ethernet - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Ethernet is
--  Port ( );
end Test_Ethernet;

architecture Behavioral of Test_Ethernet is

COMPONENT Ethernet 
PORT( 
    RESETN : in STD_LOGIC;
    CLK : in STD_LOGIC;
    RBYTEP : out STD_LOGIC;
    RCLEANP : out STD_LOGIC;
    RCVNGP : out STD_LOGIC;
    RDATAO : out STD_LOGIC_VECTOR (7 downto 0);
    RDATAI : in STD_LOGIC_VECTOR (7 downto 0);
    RDONEP : out STD_LOGIC;
    RENABP : in STD_LOGIC;
    RSMATIP : out STD_LOGIC;
    RSTARTP : out STD_LOGIC;
    
    TABORTP : in STD_LOGIC;
    TAVAILP : in STD_LOGIC;
    TDATAI : in STD_LOGIC_VECTOR (7 downto 0);
    TDATAO : out STD_LOGIC_VECTOR (7 downto 0);
    TDONEP : out STD_LOGIC;
    TFINISHP : in STD_LOGIC;
    TREADDP : out STD_LOGIC;
    TRNSMTP : out STD_LOGIC;
    TSTARTP : out STD_LOGIC;
    
    TSOCOLP : out STD_LOGIC
   
    ); 
END COMPONENT;

--Inputs
signal RDATAI :   std_logic_vector(7 downto 0):= (others => '0');
signal RESETN :  std_logic := '0'; 
signal CLK :  std_logic := '0'; 
signal RENABP:   std_logic := '0';

signal TABORTP : std_logic := '0';
signal TAVAILP : std_logic:= '0';
signal TDATAI : std_logic_vector (7 downto 0):=(others=>'0');
signal TFINISHP : std_logic:='0';

--Outputs
signal RBYTEP:   std_logic; 
signal RCLEANP :   std_logic; 
signal RCVNGP : std_logic; 
signal RDATAO :   std_logic_vector(7 downto 0) :=(others=>'0');
signal RDONEP :  std_logic; 
signal RSMATIP :   std_logic;
signal RSTARTP :   std_logic;

signal TDATAO : std_logic_vector (7 downto 0):=(others=>'0');
signal TDONEP : std_logic;
signal TREADDP : std_logic;
signal TRNSMTP : std_logic:='0';
signal TSTARTP : std_logic;

signal TSOCOLP : STD_LOGIC;

--Clock Period Definition
constant Clock_period : time := 100 ns; 

begin

-- Instantiate the Unit Under Test (UUT) 
uut: Ethernet PORT MAP ( 
      RESETN => RESETN, 
      CLK => CLK, 
      RBYTEP => RBYTEP, 
      RCLEANP => RCLEANP, 
      RCVNGP => RCVNGP, 
      RDATAO => RDATAO, 
      RDATAI => RDATAI,
      RDONEP => RDONEP,
      RENABP => RENABP,
      RSMATIP => RSMATIP,
      RSTARTP => RSTARTP,
      
      TABORTP => TABORTP,
      TAVAILP => TAVAILP,
      TDATAI => TDATAI,
      TDATAO => TDATAO,
      TDONEP => TDONEP,
      TFINISHP => TFINISHP,
      TREADDP => TREADDP,
      TRNSMTP => TRNSMTP,
      TSTARTP => TSTARTP,
      
      TSOCOLP => TSOCOLP
    ); 

-- Clock process definitions 
Clock_process :process 
begin 
    CLK <= not(CLK); 
    wait for Clock_period/2; 
end process;

-- Stimulus process 
     
 
  -- insert stimulus here 
    RESETN<= '0', '1' after 500 ns, '0' after 50000ns;
    --RENABP<='0', '1' after 2200ns, '0' after 16500ns;
    --RDATAI<= "11111110", "10101011" after 8600ns, "11111111" after 9400ns, "01010101" after 14200ns, "00110011" after 15000ns, "10101011" after 15800ns;
    
    TAVAILP<='0', '1' after 1600ns, '0' after 2400ns;
    TDATAI<= X"33" after 2400ns,
             X"FA" after 3200ns,
             X"55" after 8000ns,
             X"FA" after 12800ns,
             X"12" after 13600ns,
             X"25" after 14400ns,
             X"88" after 15200ns,
             X"00" after 16000ns;
                      
    TFINISHP<='1' after 17200ns, '0' after 18000ns;
    --TABORTP<='1' after 13000ns, '0' after 13800ns;
    
    
 

end Behavioral;
