----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2021 10:56:23
-- Design Name: 
-- Module Name: Ethernet - Behavioral
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

entity Ethernet is
    Port ( RESETN : in STD_LOGIC;
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
           
           
end Ethernet;

architecture Behavioral of Ethernet is

constant NOADDRI: std_logic_vector(47 downto 0):=(others=>'1');
signal auxRC : std_logic; 
signal auxMA : std_logic;
signal a : integer := 47;
signal b: integer := 40;
signal auxTR : std_logic;
signal index: integer :=1;
signal abrt: integer :=0;

signal auxC : std_logic:='0';

begin
    RCVNGP <= auxRC;
    RSMATIP <= auxMA;
    TRNSMTP <= auxTR;
    TSOCOLP<=auxC;
    
    --Reception process
    process
    
    variable temp :integer :=1;
    
       begin
           wait until CLK'event and CLK='1';
           if RESETN='1' and RENABP='1' then
                if temp=1 then
                
                    --Verification byte de start (SFD)
                    if RDATAI="10101011" and auxRC='0' and auxMA='0' then
                        auxRC <='1';
                        RSTARTP <='1';
                        a <= 47;
                        b<= 40;
                    end if;
                    
                    --vérif adresse destinataire
                    if auxMA='0' and auxRC='1' then
                        if not(RDATAI=NOADDRI(a downto b)) then
                            RCLEANP<='1';
                            auxRC <='0';
                        else
                            if b=0 then
                                auxMA <='1';
                            else
                            a <= a-8;
                            b<= b-8;
                            end if;
                        end if;
                        RBYTEP<='1';
                        
                    end if;
                    
                    --Reception de la Data
                    --Verification byte de end (EFD)
                    if auxMA='1' and auxRC='1' then
                        if not(RDATAI="10101011") then
                            RDATAO <= RDATAI;
                            RBYTEP<='1';
                        else
                            RDONEP <= '1';
                            auxRC <= '0';
                            auxMA <= '0';
                            RDATAO<="00000000";
                            RBYTEP<='1';
                        end if;
                    end if;
                    
                temp := temp+1;
                
                
                -- 7 tics d'horloge d'attente             
                else
                    temp := temp+1; 
                    RBYTEP<='0';
                    RCLEANP<='0';
                    RDONEP <='0';
                    RSTARTP <='0';
                    
                    if temp=9 then
                        temp := 1;
                    end if;
                end if;
            
            --Application du RESET
           elsif RESETN='0' then
                RBYTEP <='0';
                RCLEANP <='0';
                auxRC <='0'; 
                RDONEP <='0';
                auxMA <='0'; 
                RSTARTP <='0';
                RDATAO<="00000000";
           else
                RDATAO<="00000000";
            end if;   
    end process;

    --Transmission process
    process
    
        variable temp2 : integer := 1;
        
        begin
            wait until CLK'event and CLK='1';
            TSTARTP <='0';
            TDONEP <='0';
            if RESETN='1' and (TAVAILP='1'or auxTR='1'or index>=15) then
            
                if temp2=1 then
                
                --abort
                    if TABORTP='1' or abrt /=0 then
                     if abrt < 4 then
                         TDATAO<="10101010";
                         abrt <= abrt+1;
                         
                     else
                         TREADDP <='0';
                         TDONEP <='1';
                         auxTR <='0'; 
                         TSTARTP <='0';
                         TDATAO<="00000000";
                         abrt <= 0;
                     end if;
                     
                -- Colision
                    elsif auxC='1' then
                        auxTR <= '0';
                        TREADDP <='0';
                    
                    elsif auxTR = '0' and TAVAILP='1' then
                        auxTR <= '1';
                        TSTARTP <= '1';
                        index<=1;
                        
                    --Envoi de SFD
                    elsif TFINISHP='0' and index=1 then
                        TDATAO<=X"AB";
                        TREADDP<='1';
                        index<= index+1;
                        
                    --Envoi Addr Dest    
                    elsif TFINISHP='0' and index<8 then
                        TDATAO <= TDATAI;
                        TREADDP<='1';
                        index<= index+1;
                        
                    --Envoi adresse source en 6 parties
                    elsif TFINISHP='0' and index=8 then
                        TREADDP<='1';
                        TDATAO<= NOADDRI(47 downto 40);
                        index<=index+1;
                                                
                    elsif TFINISHP='0' and index=9 then
                        TREADDP<='1';
                        TDATAO<= NOADDRI(39 downto 32);
                        index<=index+1;
                        
                    elsif TFINISHP='0' and index=10 then
                         TREADDP<='1';
                         TDATAO<= NOADDRI(31 downto 24);
                         index<=index+1;
                         
                    elsif TFINISHP='0' and index=11 then
                         TREADDP<='1';
                         TDATAO<= NOADDRI(23 downto 16);
                         index<=index+1;   
                         
                     elsif TFINISHP='0' and index=12 then
                          TREADDP<='1';
                          TDATAO<= NOADDRI(15 downto 8);
                          index<=index+1;
                          
                      elsif TFINISHP='0' and index=13 then
                           TREADDP<='1';
                           TDATAO<= NOADDRI(7 downto 0);
                           index<=index+1;
                     
                                                                     
                    --Envoi Data   
                    elsif TFINISHP='0' and index=14 then
                        TDATAO <= TDATAI;
                        TREADDP<='1';
                        
                    --Fin de Transmission
                    elsif index=15 then
                        TDONEP<='1';
                        TDATAO<=X"00";
                        auxTR<='0';
                        index<=index+1;
                        
                    --Envoi EFD    
                    elsif TFINISHP='1' then
                        TDATAO<="10101011";
                        TREADDP<='1';
                        index<=index+1;         
                    end if;
                    
                       
    
                    temp2 := temp2+1;
                    
                -- 7 tics d'horloge d'attente
                else
                  temp2 := temp2+1;
                  TSTARTP<='0';
                  TREADDP<='0';
                  TDONEP <='0';
                                      
                  if temp2=9 then
                      temp2 := 1;
                  end if;     
                end if;
            elsif RESETN='0'then
                TREADDP <='0';
                TDONEP <='0';
                auxTR <='0'; 
                TSTARTP <='0';
                TDATAO<="00000000";           
            
            end if;
    end process;

    --Colision process
    process
        
    begin
        wait until CLK'event and CLK='1';
            if auxRC='1' and auxTR='1'then
                auxC <= '1';
            else
                auxC <= '0';
            end if;
    
    end process;
    
end Behavioral;
