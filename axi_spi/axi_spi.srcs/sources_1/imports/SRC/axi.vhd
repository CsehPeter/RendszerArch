library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axi is
  generic
  (
    DEVICES : integer := 1;
    PER_ADDR : std_logic_vector(7 downto 0) := X"FA"
  );
  port
  (
    --AXI
    -- Clock and Reset--
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      
      -- Write Address Channel--
      S_AXI_AWADDR : in std_logic_vector(31 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      
      -- Write Data Channel--
      S_AXI_WDATA : in std_logic_vector(31 downto 0);
      S_AXI_WSTRB : in std_logic_vector(3 downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      
      -- Read Address Channel--
      S_AXI_ARADDR : in std_logic_vector(31 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      
      -- Read Data Channel--
      S_AXI_RDATA : out std_logic_vector(31 downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      
      -- Write Response Channel--
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      
    --SPI
      spi_dev_sel : out std_logic_vector((DEVICES - 1) downto 0);
      spi_send_data : out std_logic_vector(23 downto 0);
      spi_rec_data : in std_logic_vector(23 downto 0);
      spi_busy : in std_logic;
      spi_valid : in std_logic;
      spi_en : out std_logic
  );
end axi;

architecture behavioral of axi is


signal read_en : std_logic := '0';  --jelzi, ha lehet olvasni: beérkezett az írási cím

--Belso WRITE jelek--
signal w_addr : std_logic_vector(31 downto 0) := (others => '0'); --írási cím tároló
signal w_addr_valid : std_logic := '0'; --Jelzi, ha van érvényes írási cím

signal w_data : std_logic_vector(31 downto 0) := (others => '0'); --írási adat tároló
signal w_data_valid : std_logic := '0'; --Jelzi, ha van érvényes olvasási cím

signal w_en : std_logic := '0'; --jelzi, ha lehet írni: beérkezett az írási cím és az adat 

--Belso READ jelek--
signal r_addr : std_logic_vector(31 downto 0) := (others => '0'); --olvasási cím tároló
signal r_addr_valid : std_logic := '0'; --Jelzi, ha van érvényes olvasási cím

signal r_data : std_logic_vector(31 downto 0) := (others => '0'); --olvasási adat tároló
signal r_data_valid : std_logic := '0'; --Jelzi, ha van érvényes olvasási adat 

signal r_en : std_logic := '0'; --jelzi, ha lehet olvasni: beérkezett az olvasási cím (az olvasási adatot ebbe nem kell belevenni, azt nem az AXI MASTER-tol kapjuk)

begin

----WRITE----

--Nem tudjuk, hogy sikeres-e az átvitel
S_AXI_BRESP <= "00";
S_AXI_BVALID <= '0';

--WRITE ADDR kezelo process--
proc_write_addr : process (S_AXI_ACLK)
begin
    if(rising_edge(S_AXI_ACLK)) then
        if(S_AXI_ARESETN = '1') then
            --w_addr <= (others => '0'); --Elég a vezérlo jelet resetelni
            w_addr_valid <= '0';
        else
            if(S_AXI_AWVALID = '1' and S_AXI_AWADDR(31 downto 24) = PER_ADDR) then --Ha van érvényes cím, akkor elveszem a címet és jelzem, hogy elvettem
                --Beolvasom a címet, van érvényes cím
                w_addr <= S_AXI_AWADDR;
                w_addr_valid <= '1';
                
                --Jelzek, hogy elvettem
                S_AXI_AWREADY <= '1';
            else
            
                S_AXI_AWREADY <= '0'; --Minden más esetben ez '0', csak akkor '1' ha elveszek egy címet
                
                --nullázni is kell valamikor a "w_addr_valid" jelet ( pl következo SPI kommunikációnál, amikor kiadjuk annak "en" jelét, ez után már nem igaz az, hogy érvényes a címünk)
                if(w_en = '1' and spi_busy = '0') then
                    w_addr_valid <= '0';
                end if;
                
            end if;
            
        end if;
    end if;
end process proc_write_addr;

--WRITE DATA kezelo process--
    --A "S_AXI_WSTRB" jel jelzi, hogy melyik bájtok érvényesek a bemeneten, ennek lekezelését nem írtam bele!!!
    --Szerintem valami ilyesmi lenne a feltétel: 
        --if(S_AXI_WVALID = '1' and (S_AXI_WSTRB = "0111" || S_AXI_WSTRB = "1111") then
    --Tehát ha van érvényes adat, és annak az alsó három bájtja érvényes, mert nekünk csak 24 bit kell (nyilván nem ez a legelegánsabb megoldás)
proc_write_data : process (S_AXI_ACLK)
begin
    if(rising_edge(S_AXI_ACLK)) then
        if(S_AXI_ARESETN = '1') then
            --w_data <= (others => '0'); --Elég a vezérlo jelet resetelni
            w_data_valid <= '0';
        else
            if(S_AXI_WVALID = '1') then --Ha van érvényes adat, akkor elveszem az adatot és jelzem, hogy elvettem
                --Beolvasom az adatot, van érvényes adat
                w_data <= S_AXI_WDATA;
                w_data_valid <= '1';
                
                --Jelzek, hogy elvettem az adatot
                S_AXI_WREADY <= '1';
            else
            
                S_AXI_WREADY <= '0'; --Minden más esetben ez '0', csak akkor '1' ha elveszek egy adatot
                
                --nullázni is kell valamikor a "w_data_valid" jelet ( pl következo SPI kommunikációnál, amikor kiadjuk annak "en" jelét, ez után már nem igaz az, hogy érvényes a címünk)                
                if(w_en = '1' and spi_busy = '0') then
                    w_data_valid <= '0';
                end if;
                
            end if;

        end if;
    end if;
end process proc_write_data;

--WRITE ENABLE--
    --Jelzi, ha van érvényes írási cím és írási adat tehát lehet írni
w_en <= w_addr_valid and w_data_valid;



----READ----

--Nem tudjuk, hogy sikeres-e az átvitel
S_AXI_RRESP <= "00";

--READ ADDR kezelo process--
proc_read_addr : process(S_AXI_ACLK)
begin
    if(rising_edge(S_AXI_ACLK)) then
        if(S_AXI_ARESETN = '1') then
            --r_addr <= (others => '0'); --Elég a vezérlo jelet resetelni
            r_addr_valid <= '0';
        else
            if(S_AXI_ARVALID = '1' and S_AXI_ARADDR(31 downto 24) = PER_ADDR) then --Ha van érvényes cím, akkor elveszem a címet és jelzem, hogy elvettem
                --Beolvasom a címet, és van érvényes cím
                r_addr <= S_AXI_ARADDR;
                r_addr_valid <= '1';
                
                --Jelzek, hogy elvettem a címet
                S_AXI_ARREADY <= '1';
            else
            
                S_AXI_ARREADY <= '0'; --Minden más esetben ez '0', csak akkor '1' ha elveszek egy címet
                
                --nullázni is kell valamikor a "r_addr_valid" jelet ( pl következo SPI kommunikációnál, amikor kiadjuk annak "en" jelét, ez után már nem igaz az, hogy érvényes a címünk)
                if(r_en = '1' and w_en = '0' and spi_busy = '0') then
                    r_addr_valid <= '0';
                end if;
            end if;
            
        end if;
    end if;
end process proc_read_addr;

--READ DATA kezelo process--
    --A "S_AXI_RRESP" jel jelzi, ha az átvitel sikerült-e. Ezt úgy kéne meghajtani, hogyha olvasás volt az elozo kommunikáció akkor sikeres, ha írás, akkor nem, hiszen ekkor is olvas az SPI csak nem arról a címrol amit a MASTER vár
proc_read_data : process(S_AXI_ACLK)
begin
   if(rising_edge(S_AXI_ACLK)) then
       if(S_AXI_ARESETN = '1') then
            --r_data <= (others => '0'); --Elég a vezérlo jelet resetelni
            r_data_valid <= '0';
       else
            --Adat beolvasás
            if(spi_valid = '1') then --Ha az SPI-nak van érvényes adata, akkor beolvasom azt, és eltárolom, hogy van érvényes adat 
                r_data <= x"00" & spi_rec_data; --konkatenálás: felso 8 bit '0', az alsó 24 bit az adat (itt lehet, hogy úgy kéne, hogy a felso 24 bit nulla és az alsó 8 az adat, mert úgyis csak ez az érvényes)
                r_data_valid <= '1';
            end if;
            
            --Adat kiadása MASTER-nek
            if(r_data_valid = '1') then --Itt igazából bele kéne venni, hogy ha az "spi_valid" '1' akkor is kiadjuk a valid jelet, csak akkor nem az "r_data" lenne az adat, hanem a "x"00" & spi_rec_data". Ez egy órajel késést jelent
               S_AXI_RDATA <= r_data; 
               S_AXI_RVALID <= '1';
            end if;
            
            --Visszaveszem az érvényes jelet
            if(S_AXI_RREADY = '1' and spi_valid = '0') then --Ha a MASTER elvette az adatot és az spi-on nem érkezett új adat, akkor már nem érvényes az "r_data". (Megj.: Az "spi_valid = '0'" nélkül szembehajtás lehetne a buszon)
                r_data_valid <= '0';
                S_AXI_RVALID <= '0';
            end if;
       end if;
   end if;
end process proc_read_data;

--READ ENABLE--
    --Ha van olvasási cím, akkor lehet olvasni
r_en <= r_addr_valid;

----SPI----

--SPI--VEZÉRLO
    --A címeket úgy kezelem hogy a felso 16 bitet használom a "spi_send_data"-ban mint címet, az alsó 16 az SPI eszközválasztónak használható(ez a bitszám változtatható a "DEVICES" által) 
proc_spi : process (S_AXI_ACLK)
    begin
   if(rising_edge(S_AXI_ACLK)) then
       if(S_AXI_ARESETN = '1') then
            spi_en <= '0';
       else
       
            --SPI engedélyezés--
            if((w_en = '1' or r_en = '1') and spi_busy = '0') then --ha lehet írni vagy olvasni és nem foglalt az SPI, akkor jelezzük az SPI-nak a kommunikációt, ez egy órajelig tartó pulzus
                spi_en <= '1';
            else
                spi_en <= '0';
            end if;
            
            --ÍRÁS--
                --(ha egyszerre van írás és olvasás akkor valamelyik a dominál, én az írást választottam; ezért nem jelenik meg a feltételben, hogy ne legyen írás)
            if(w_en = '1' and spi_busy = '0') then
                --SPI küldési adatvonal
                spi_send_data <= w_data(15 downto 8) & w_addr(31 downto 24) & w_data(7 downto 0);
					 --elso 8 bit: memória parancs -- második 8 bit: cím -- harmadik 8 bit: adat
                    --(Megj.: a "w_data(15 downto 8)" -nak tartalmaznia kell a megfelelo opcode-ot)
                    
                --SPI eszköz
                spi_dev_sel <=  w_addr((DEVICES - 1) downto 0);
            end if;
            
            --OLVASÁS--
                --(ha egyszerre van írás és olvasás, akkor az írás dominál; ezért jelenik meg a feltételben az, hogy ne legyen írás)
            if(r_en = '1' and w_en = '0' and spi_busy = '0') then
                 spi_send_data <= r_addr(31 downto 16) & x"00"; 
					  --elso 8 bit: memória parancs -- második 8 bit: cím -- harmadik 8 bit: data(ez itt nulla)
                    --(Megj.: a "r_addr(15 downto 8)" -nak tartalmaznia kell a megfelelo opcode-ot, ez elég ronda így :( )
                    
                --SPI eszköz
                spi_dev_sel <=  r_addr((DEVICES - 1) downto 0);
            end if;
            
       end if;
   end if;
end process proc_spi;

end behavioral;
