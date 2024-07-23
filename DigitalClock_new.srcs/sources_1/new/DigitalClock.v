
module DigitalClock(CLK,ONOFF,CLOCKMODE,RESET,PRESET,STOPWATCH,PAUSESTOPWATCH,RESETSTOPWATCH,ALARM,ONOFFALARM,TIMER,SETTIMER,RESETTIMER,ONOFFTIMER,LEFT,RIGHT,UP,DOWN,Anode_Activate,LED_out,DP,beep,h1,h2,mode,AMPM);
input CLK,ONOFF;
input CLOCKMODE;
input RESET;
input PRESET;
input LEFT,RIGHT,UP,DOWN;
input STOPWATCH,PAUSESTOPWATCH,RESETSTOPWATCH;
input ALARM,ONOFFALARM;
input TIMER,SETTIMER,RESETTIMER,ONOFFTIMER;
output [3:0] Anode_Activate;
output [6:0] LED_out;
output DP;
output reg beep;
output reg [3:0] h1;
output reg [3:0] h2;
output reg [1:0] mode;
output reg AMPM;

reg [2:0] xpos=0;   
reg [25:0] count=0;
reg [25:0] count2=0;
reg [25:0] count3=0;
reg [10:0] timercount=0;
reg CLKOUT;
reg CLKOUT300MS;
reg CLKOUT10MS;
reg timerClock;
reg beep1=0,beep2=0;
reg [12:0] countTimerBeep=0;

always @(posedge CLK) 
begin
   
        if (count == 50000000) //1sec CLOCK
        begin 
            CLKOUT <= ~CLKOUT;
            count <= 0;
        end 
        else 
        begin
            if(!ONOFF)
            count <= count + 1;
        end
        
        if (count2 == 15000000) //0.3sec CLOCK
        begin // Adjust for 100 MHz input clock
            CLKOUT300MS <= ~CLKOUT300MS;
            count2 <= 0;
        end 
        else 
        begin
            if(!ONOFF)
            count2 <= count2 + 1;
        end
        
        if (count3 == 500000) //0.01sec CLOCK
        begin 
            CLKOUT10MS <= ~CLKOUT10MS;
            count3 <= 0;
        end 
        else 
        begin
            if(!ONOFF)
            count3 <= count3 + 1;
        end
end

always @(posedge CLKOUT10MS) 
begin
    if (timercount == 100) 
    begin 
        timerClock <= ~timerClock;
        timercount <= 0;
    end 
    else 
    begin
        timercount <= timercount + 1;
    end
end

reg [16:0] CountSec = 0;
reg [23:0] CountSec2 = 0;
reg [16:0] CountSec3 = 0;
reg [23:0] CountSec4 = 0;

reg [6:0] s;
reg [6:0] m;
reg [5:0] h;
reg [3:0] s1;
reg [3:0] s2;
reg [3:0] m1;
reg [3:0] m2;

always @(posedge CLKOUT300MS)
begin
    if(LEFT)
        if(xpos >=6)
            xpos<=0;
        else
            xpos <= xpos+1;
    else if(RIGHT)
        if(xpos<=0)
            xpos<=5;
        else     
            xpos <= xpos-1;
    else if(ONOFF)
        xpos<=0;
end

always@(posedge CLKOUT or posedge RESET)
begin
    if(RESET)
    begin
       CountSec<=0;
    end
    else
    begin
        if(PRESET && !STOPWATCH && !ALARM && !TIMER)
        begin
            if(UP)
                case(xpos)
                3'b000: CountSec <= CountSec + 1;
                3'b001: CountSec <= CountSec + 10;
                3'b010: CountSec <= CountSec + 60;
                3'b011: CountSec <= CountSec + 600;
                3'b100: CountSec <= CountSec + 3600;
                3'b101: CountSec <= CountSec + 36000;
            endcase
            else if(DOWN)
                case(xpos)
                3'b000: CountSec <= CountSec - 1;
                3'b001: CountSec <= CountSec - 10;
                3'b010: CountSec <= CountSec - 60;
                3'b011: CountSec <= CountSec - 600;
                3'b100: CountSec <= CountSec - 3600;
                3'b101: CountSec <= CountSec - 36000;
            endcase
        end
        else
        begin
           if(CountSec > (86400+36000))
                CountSec <= 0;
           else if(CountSec>=86400)
                CountSec<=0;
           else
                CountSec<=CountSec + 1; 
        end
    end
end

always @(posedge CLKOUT10MS or posedge RESETSTOPWATCH)
begin
    if(RESETSTOPWATCH)
    begin
       CountSec2<=0;
    end
    else
    begin
    if(PAUSESTOPWATCH && STOPWATCH==1)
        CountSec2 <= (CountSec2+1)%8640000;
    end
end

always @(posedge CLKOUT) begin
    if (ALARM) begin
    CountSec3 = CountSec3 %86400;
        if (UP) begin
            case (xpos)
                3'b000: CountSec3 <= CountSec3 + 1;
                3'b001: CountSec3 <= CountSec3 + 10;
                3'b010: CountSec3 <= CountSec3 + 60;
                3'b011: CountSec3 <= CountSec3 + 600;
                3'b100: CountSec3 <= CountSec3 + 3600;
                3'b101: CountSec3 <= CountSec3 + 36000;
            endcase
        end else if (DOWN) begin
            case (xpos)
                3'b000: CountSec3 <= CountSec3 - 1;
                3'b001: CountSec3 <= CountSec3 - 10;
                3'b010: CountSec3 <= CountSec3 - 60;
                3'b011: CountSec3 <= CountSec3 - 600;
                3'b100: CountSec3 <= CountSec3 - 3600;
                3'b101: CountSec3 <= CountSec3 - 36000;
            endcase
        end
    end
    
    if (ONOFFALARM && CLKOUT && (CountSec > CountSec3) && (CountSec < (CountSec3 + 60))) begin
        beep1 <= 1;
    end else begin
        beep1 <= 0;
    end
end


always @(posedge CLKOUT10MS or posedge RESETTIMER) begin
    if(RESETTIMER)
    begin
        CountSec4<=0;
        beep2<=0;    
        countTimerBeep<=0;
    end
    else
    begin
        if (TIMER && SETTIMER && timerClock ) begin
            CountSec4 = CountSec4 %8640000;
            if (UP) begin
                case (xpos)
                    3'b000: CountSec4 <= CountSec4 + 100;
                    3'b001: CountSec4 <= CountSec4 + 1000;
                    3'b010: CountSec4 <= CountSec4 + 6000;
                    3'b011: CountSec4 <= CountSec4 + 60000;
                    3'b100: CountSec4 <= CountSec4 + 360000;
                    3'b101: CountSec4 <= CountSec4 + 3600000;
                endcase
            end else if (DOWN) begin
                case (xpos)
                    3'b000: CountSec4 <= CountSec4 - 100;
                    3'b001: CountSec4 <= CountSec4 - 1000;
                    3'b010: CountSec4 <= CountSec4 - 6000;
                    3'b011: CountSec4 <= CountSec4 - 60000;
                    3'b100: CountSec4 <= CountSec4 - 360000;
                    3'b101: CountSec4 <= CountSec4 - 3600000;
                endcase
            end
        end
        if(ONOFFTIMER)
        begin
            if(CountSec4>0)
            CountSec4<=(CountSec4-1)%8640000;
            else if (CLKOUT && CountSec4==0 && countTimerBeep<1500 ) begin
                beep2 <= 1;
                countTimerBeep<=countTimerBeep+1;
            end else begin
                beep2 <= 0;
            end
        end
    end
end

always @(CLKOUT or CLKOUT10MS or STOPWATCH or ALARM or TIMER or SETTIMER or CountSec or CountSec2 or CountSec3 or CountSec4 or ONOFF)
begin
    if(!ONOFF)
    begin
    if(STOPWATCH)
    begin
    mode<=2'b01;
        if(CountSec2 <6000)
        begin
            s <= CountSec2% 100;
            m <= ((CountSec2 % 6000) / 100);
            h <= CountSec2 / 6000; 
        end else begin
            if(CLOCKMODE && CountSec2 >=4320000)
            begin
                s <= ((CountSec2%4320000)/100 )% 60;
                m <= ((((CountSec2%4320000)/100) % 3600) / 60);
                h <= ((CountSec2%4320000)/100 )/ 3600; 
                AMPM<= 1;
            end else begin
                s <= (CountSec2/100 )% 60;
                m <= (((CountSec2/100) % 3600) / 60);
                h <= (CountSec2/100 )/ 3600; 
                AMPM<=0;
            end
        end
    end
    else if(ALARM)
    begin
    mode<=2'b10;
    if(CLOCKMODE && CountSec3 >=43200)
    begin
        s <= (CountSec3%43200) % 60;
        m <= (((CountSec3%43200) % 3600) / 60);
        h <= (CountSec3%43200) / 3600; 
        AMPM<=1;
    end else begin
        s <= CountSec3 % 60;
        m <= ((CountSec3 % 3600) / 60);
        h <= CountSec3 / 3600;
        AMPM<=0; 
        end
    end
    else if(TIMER)
    begin
    mode<=2'b11;
        if(CountSec4 <6000 && (!SETTIMER || ONOFFTIMER))
        begin
            s <= CountSec4% 100;
            m <= ((CountSec4 % 6000) / 100);
            h <= CountSec4 / 6000; 
        end else begin
            if(CLOCKMODE && CountSec4 >=4320000)
            begin
            s <= ((CountSec4%4320000)/100 )% 60;
            m <= ((((CountSec4%4320000)/100) % 3600) / 60);
            h <= ((CountSec4%4320000)/100 )/ 3600; 
            AMPM<=1;
            end else begin
            s <= (CountSec4/100 )% 60;
            m <= (((CountSec4/100) % 3600) / 60);
            h <= (CountSec4/100 )/ 3600; 
            AMPM<=0;
            end
        end
    end
    else
    begin
        mode<=2'b00;
        if(CLOCKMODE && CountSec >=43200)
        begin
            s <= (CountSec%43200) % 60;
            m <= (((CountSec%43200) % 3600) / 60);
            h <= (CountSec%43200) / 3600;
            AMPM<=1;
        end
        else begin
            s <= CountSec % 60;
            m <= ((CountSec % 3600) / 60);
            h <= CountSec / 3600;
            AMPM<=0;
        end 
    end
    
h2 = h / 10;  
h1 = h % 10;

s1 = s%10;
s2 = s/10;
m1 = m%10;
m2 = m/10;
end else
begin
    s1 = 4'b1110;
    s2 = 4'b1111;
    m1 = 4'b1111;
    m2 = 4'b0000;
    h1=0;
    h2=0;
end
end

always @(*)
begin
    beep <= ( ( beep1 || beep2 )&& CLKOUT);
end

sseg(CLK,s1,s2,m1,m2,xpos,Anode_Activate,LED_out,DP);

endmodule





module sseg(
   input clk_100MHz,     
   input [3:0] ones,  
	input [3:0] tens,  
	input [3:0] hundreds,
	input [3:0] thousands ,
	input [2:0] xpos,
    output reg [3:0] AN,
    output reg [6:0] SEG,
    output reg DP       
    );
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    parameter CHARA = 7'b000_1000; // A
    parameter CHARB = 7'b000_0000; // B
    parameter CHARC = 7'b011_0001; // C
    parameter CHARD = 7'b000_0001; // D
    parameter CHARE = 7'b111_1111; // 
    parameter CHARF = 7'b011_1000; // F

    reg [1:0] anode_select;        
    reg [16:0] anode_timer;   
              
    always @(posedge clk_100MHz) begin  // 1ms x 4 displays = 4ms refresh period
        if(anode_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
            anode_timer <= 0;                   // 10ns x 100,000 = 1ms
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
    end
    
    always @(anode_select) begin
        case(anode_select) 
            2'b00 : AN = 4'b1110;   // Turn on ones digit
            2'b01 : AN = 4'b1101;   // Turn on tens digit
            2'b10 : AN = 4'b1011;   // Turn on hundreds digit
            2'b11 : AN = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    always @(*) begin
        case(anode_select)
            2'b00 : begin 				
								case(ones)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1010 : SEG = CHARA;
                            4'b1011 : SEG = CHARB;
                            4'b1100 : SEG = CHARC;
                            4'b1101 : SEG = CHARD;
                            4'b1110 : SEG = CHARE;
                            4'b1111 : SEG = CHARF;
                        endcase
                    end
                        
            2'b01 : begin 
								case(tens)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1010 : SEG = CHARA;
                            4'b1011 : SEG = CHARB;
                            4'b1100 : SEG = CHARC;
                            4'b1101 : SEG = CHARD;
                            4'b1110 : SEG = CHARE;
                            4'b1111 : SEG = CHARF;
                        endcase
                    end
				
                    
            2'b10 : begin       
                        case(hundreds)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1010 : SEG = CHARA;
                            4'b1011 : SEG = CHARB;
                            4'b1100 : SEG = CHARC;
                            4'b1101 : SEG = CHARD;
                            4'b1110 : SEG = CHARE;
                            4'b1111 : SEG = CHARF;
                        endcase
                    end
                    
            2'b11 : begin      
                        case(thousands)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1010 : SEG = CHARA;
                            4'b1011 : SEG = CHARB;
                            4'b1100 : SEG = CHARC;
                            4'b1101 : SEG = CHARD;
                            4'b1110 : SEG = CHARE;
                            4'b1111 : SEG = CHARF;
                        endcase
                    end
        endcase
   end
   
    always @(*)
    begin
        if(xpos!=anode_select)
        begin
            DP=1;
        end
    end
    
endmodule