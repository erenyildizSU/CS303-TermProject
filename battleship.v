// DO NOT MODIFY THE MODULE NAMES, SIGNAL NAMES, SIGNAL PROPERTIES

module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

/* Your design goes here. */
reg [3:0] current_state;
reg [3:0] next_state;
reg [15:0] mapA ;
reg [15:0] mapB ;
reg [2:0] scoreA ;
reg[2:0]  scoreB;
reg [31:0] timer_count;
reg [1:0] input_count ;
reg Z;
reg errFlag;

parameter timer_limit = 50;
parameter [3:0] IDLE = 4'b0000;
parameter [3:0] SHOW_A = 4'b0001;
parameter [3:0] A_IN = 4'b0010;
parameter [3:0] ERROR_A = 4'b0011;

parameter [3:0] SHOW_B = 4'b0100;
parameter [3:0] B_IN = 4'b0101;
parameter [3:0] ERROR_B = 4'b0110;

parameter [3:0] SHOW_SCORE = 4'b0111;

parameter [3:0] A_SHOOT = 4'b1000;
parameter [3:0] A_SINK = 4'b1001;

parameter [3:0] B_SHOOT = 4'b1011;
parameter [3:0] B_SINK = 4'b1100;



parameter [3:0] A_WIN = 4'b1010;
parameter [3:0] B_WIN = 4'b1101;


parameter [7:0] ZERO =     8'b00111111 ;
parameter [7:0] ONE =      8'b00000110 ;
parameter [7:0] TWO =      8'b01011011 ;
parameter [7:0] THREE =    8'b01001111 ;
parameter [7:0] FOUR =     8'b01100110 ;
parameter [7:0] FIVE =     8'b01101101 ;
parameter [7:0] SIX  =     8'b01111101 ;
parameter [7:0] SEVEN =    8'b00000111 ;
parameter [7:0] A_string = 8'b01110111 ;
parameter [7:0] B_string = 8'b01111100 ;

parameter [7:0] I_string = 8'b00000110 ;
parameter [7:0] D_string = 8'b01011110 ;
parameter [7:0] L_string = 8'b00111000 ;
parameter [7:0] E_string = 8'b01111001 ;
parameter [7:0] DASH_string = 8'b01000000 ;
parameter [7:0] r_string = 8'b01010000 ;
parameter [7:0] o_string = 8'b01011100 ;

reg [3:0] index;




always @(posedge clk)
begin
  if ( rst)
  begin
    current_state <= IDLE;
    
    
  end
  else
  begin
      
    current_state <= next_state;
  end
end







always@(*)
begin
  next_state = current_state;
  case (current_state)
    IDLE:
    begin
      if (start) begin
        next_state = SHOW_A;
      end
      else begin
        next_state = IDLE;
      end
      
    end
    



    SHOW_A:
    begin
      if (timer_count != (timer_limit - 1))
      begin
        next_state = SHOW_A;
      end
      else
      begin
        next_state = A_IN;
      end
    end



    A_IN:
    begin
      if (pAb) begin
        if (mapA[index]) begin
          next_state = ERROR_A;
        end
        else begin
          if (input_count > 2) begin
            next_state = SHOW_B;
          end
          else begin
            next_state = A_IN;
          end
        end
      end
      else begin
        next_state = A_IN;
      end
    end



    ERROR_A:
    begin
      if (timer_count != (timer_limit - 1))
      begin
        next_state = ERROR_A;
      end
      else
      begin
        next_state = A_IN;
      end
    end




    SHOW_B:
    begin
      if (timer_count != (timer_limit - 1))
      begin
        next_state = SHOW_B;
      end
      else
      begin
        next_state = B_IN;
      end
    end



    B_IN:
    begin
      if (pBb) begin
        if (mapB[index]) begin
          next_state = ERROR_B;
        end
        else begin
          if (input_count > 2) begin
            next_state = SHOW_SCORE;
          end
          else begin
            next_state = B_IN;
          end
        end
      end
      else begin
        next_state = B_IN;
      end
    end



    ERROR_B:
    begin
      if (timer_count != (timer_limit - 1))
      begin
        next_state = ERROR_B;
      end
      else
      begin
        next_state = B_IN;
      end
    end



    SHOW_SCORE:
    begin // BURADAN DEVAM ETCEK.
      if (timer_count != (timer_limit - 1))
      begin
        next_state = SHOW_SCORE;
      end
      else
      begin
        next_state = A_SHOOT;
      end
    end


    A_SHOOT:
    begin
      if (pAb)
      begin
        next_state = A_SINK;
      end
      else begin
        next_state = A_SHOOT ;
      end
    end


    A_SINK:
    begin
      if (timer_count != (timer_limit - 1))
      begin
        next_state =A_SINK;
      end
      else begin
        if(scoreA > 3)
        begin
          next_state = A_WIN;
        end
      else
        begin
          next_state = B_SHOOT;
        end
      end
      end
    

    A_WIN:
    begin
      next_state = A_WIN;
    end


    B_SHOOT:
    begin
      if (pBb)
      begin
        next_state = B_SINK;
      end
      else begin
        next_state = B_SHOOT;
      end 
    end

    B_SINK:
    begin
      if (timer_count != (timer_limit - 1))
      begin
        next_state =B_SINK;
      end
      else begin
        if(scoreB > 3)
        begin
          next_state = B_WIN;
        end
      else
        begin
          next_state = A_SHOOT;
        end
      end
      end


    B_WIN:
    begin
      next_state = B_WIN;
    end

    default : begin
      next_state = IDLE;
    end
  endcase
end


always @(posedge clk) begin
  if (rst) begin
    timer_count <= 0;
  end
  else begin
    case (current_state)
      ERROR_A, ERROR_B, A_SINK, B_SINK, A_WIN, B_WIN, SHOW_A, SHOW_B, SHOW_SCORE: begin
        if (timer_count != (timer_limit - 1))
          timer_count <= timer_count + 1;
        else
          timer_count <= 0; // 1 saniye dolunca tekrar sıfırla
      end

      default: begin
        // Bekleme gerekmeyen durumlarda timer_count=0
        timer_count <= 0;
      end
    endcase
  end
end




always@(posedge clk)
begin
if (rst)
  begin
    
   mapA <= 16'b0000000000000000; mapB <= 16'b0000000000000000; scoreA <= 0 ; scoreB <= 0 ; Z<=0 ; input_count<= 0 ; errFlag         <= 1'b0;

  disp3 <=  I_string;
  disp2 <=  D_string;
  disp1 <=  L_string;
  disp0 <=  E_string; 
  led<= 8'b00000000;
  index <= 4'b0 ;

  end

  else begin
    index = (Y * 4) + X;

  case (current_state)

  //BAK
   
    IDLE: begin
    disp3 <=  I_string;
    disp2 <=  D_string;
    disp1 <=  L_string;
    disp0 <=  E_string;
    led <= 8'b10011001;
    errFlag     <= 1'b0;

    end

    SHOW_A:
    begin
      disp3 <= A_string;
      disp2 <= 8'b00000000 ;
      disp1 <= 8'b00000000 ;
      disp0 <= 8'b00000000 ;
      led <=   8'b10011001 ; // unutulmus

    end

    A_IN:
    begin
      disp3 <= 8'b00000000;
      disp2 <= 8'b00000000;



      if (pAb)
      begin
        

        if (mapA[index] == 0)
        begin
          if (input_count>2)
          begin
            mapA[index] <= 1 ;
            input_count <= 0 ;
            errFlag <= 0 ;
          end
          else
          begin
            mapA[index] <= 1 ;
            input_count <= input_count + 1 ;
            errFlag <= 0 ;
          end
        end
        else begin
          errFlag <= 1 ;
          
        end
      end
      else begin
        errFlag <= 0 ;
      end


      case (input_count)
        2'b00:
        begin

          led <= 8'b10000000 ;
        end

        2'b01:
        begin

          led <= 8'b10010000 ;
        end

        2'b10:
        begin

          led <= 8'b10100000 ;
        end

        2'b11:
        begin

          led <= 8'b10110000 ;
        end

        endcase



      case (Y)
        2'b00:
        begin
          disp0 <= ZERO ;
        end

        2'b01:
        begin
          disp0 <= ONE ;

        end

        2'b10:
        begin
          disp0 <= TWO ;

        end

        2'b11:
        begin
          disp0 <= THREE ;
        end
      endcase

      case (X)
        2'b00:
        begin
          disp1 <= ZERO ;
        end

        2'b01:
        begin
          disp1 <= ONE ;

        end

        2'b10:
        begin
          disp1 <= TWO ;

        end

        2'b11:
        begin
          disp1 <= THREE ;
        end
      endcase
    end

    ERROR_A:
    begin

      disp3 <= E_string;
      disp2 <= r_string;
      disp1 <= r_string;
      disp0 <= o_string;
      led <= 8'b10011001;

    end

    SHOW_B:
    begin

      disp3 <= B_string;

      disp2 <= 8'b00000000;
      disp1 <= 8'b00000000;
      disp0 <= 8'b00000000;
      led <=   8'b10011001;

    end

    B_IN:
    begin

      disp3 <= 8'b00000000;
      disp2 <= 8'b00000000;



      if (pBb)
      begin

        if (mapB[index] == 0)
        begin
          if (input_count>2)
          begin
            mapB[index] <= 1 ;
            input_count <= 0 ;
            errFlag <= 0 ;
          end
          else
          begin
            mapB[index] <= 1 ;
            input_count <= input_count + 1 ;
            errFlag <= 0 ;
          end
        end
        else begin
          errFlag <= 1 ;
          
        end
      end
      else begin
        errFlag <= 0 ;
      end

      case (input_count)
        2'b00:
        begin

          led <= 8'b00000001 ;
        end

        2'b01:
        begin

          led <= 8'b00000101 ;
        end
        2'b10:
        begin

          led <= 8'b00001001 ;
        end
        2'b11:
        begin
          led <= 8'b00001101 ;
        end

        endcase



      case (Y)
        2'b00:
        begin
          disp0 <= ZERO ;
        end

        2'b01:
        begin
          disp0 <= ONE ;

        end

        2'b10:
        begin
          disp0 <= TWO ;

        end

        2'b11:
        begin
          disp0 <= THREE ;
        end
      endcase

      case (X)
        2'b00:
        begin
          disp1 <= ZERO ;
        end

        2'b01:
        begin
          disp1 <= ONE ;

        end

        2'b10:
        begin
          disp1 <= TWO ;

        end

        2'b11:
        begin
          disp1 <= THREE ;
        end
      endcase
    end


    // DEVAM

    ERROR_B: begin
      disp3 <= E_string;
      disp2 <= r_string;
      disp1 <= r_string;
      disp0 <= o_string;
      led <= 8'b10011001;
    end


    A_SHOOT:begin
      disp3 <= 8'b00000000;
      disp2 <= 8'b00000000;

      if (pAb)
      begin

        if (mapB[index]) begin
          scoreA <= scoreA + 1;
          Z <= 1'b1;
          mapB[index] <= 1'b0;
        end
        
        else
        begin
          Z <= 1'b0;
        end
      end
      else begin
        scoreA <= scoreA ;
      end
      case (X)
          2'b00: begin
            disp1 <= ZERO;
          end 
          2'b01: begin 
            disp1 <= ONE;
          end  
          2'b10: begin
            disp1 <= TWO;
          end  
          2'b11:begin
            disp1 <= THREE;
          end

      endcase

      case (Y)
          2'b00:begin
            disp0 <= ZERO;
          end 
          2'b01:begin
            disp0 <= ONE;
          end 
          2'b10:begin
            disp0 <= TWO;
          end 
          2'b11:begin
            disp0 <= THREE;
          end 


      endcase

      led <= (scoreA[1:0] << 4) | (scoreB[1:0] << 2) | 8'b10000000;

    end


    B_SHOOT: begin
      disp3 <= 8'b00000000;
      disp2 <= 8'b00000000;

      if (pBb) begin

        if (mapA[index])
        begin
          scoreB <= scoreB + 1;
          Z <= 1'b1;
          mapA[index] <= 1'b0;
        end
        else
        begin
          Z <= 1'b0;
        end
      end
      else begin
        scoreB <= scoreB;
      end
      case (X)
          2'b00: begin
            disp1 <= ZERO;
          end 
          2'b01: begin 
            disp1 <= ONE;
          end  
          2'b10: begin
            disp1 <= TWO;
          end  
          2'b11:begin
            disp1 <= THREE;
          end

      endcase

      case (Y)
          2'b00:begin
            disp0 <= ZERO;
          end 
          2'b01:begin
            disp0 <= ONE;
          end 
          2'b10:begin
            disp0 <= TWO;
          end 
          2'b11:begin
            disp0 <= THREE;
          end 
      endcase
      
      led <= (scoreA[1:0] << 4) | (scoreB[1:0] << 2) | 2'b01;
    end


    SHOW_SCORE: begin
      
      disp3 <= 8'b00000000;
      
      case(scoreA)
        3'b000:begin
          disp2 <= ZERO;
        end 
        3'b001:begin
          disp2 <= ONE;
        end 
        3'b010:begin
          disp2 <= TWO;
        end 
        3'b011:begin
          disp2 <= THREE;
        end 
        3'b100:begin
          disp2 <= FOUR;
        end
        default: begin
          disp2 <= FIVE;
        end

      endcase
      
      disp1 <= DASH_string;
      
      case(scoreB)
        3'b000:begin
          disp0 <= ZERO;
        end 
        3'b001:begin
          disp0 <= ONE;
        end 
        3'b010:begin
          disp0 <= TWO;
        end 
        3'b011:begin
          disp0 <= THREE;
        end 
        3'b100:begin
          disp0 <= FOUR;
        end
        default: begin
          disp0 <= FIVE;
        end

      endcase
      
      led <= 8'b10011001;
    end


    A_SINK: begin
      
      disp3 <= 8'b00000000;

      case(scoreA)
      3'b000:begin
        disp2 <= ZERO;
      end 
      3'b001:begin
        disp2 <= ONE;
      end 
      3'b010:begin
        disp2 <= TWO;
      end 
      3'b011:begin
        disp2 <= THREE;
      end 
      3'b100:begin
        disp2 <= FOUR;
      end
      default: begin
        disp2 <= FIVE;
      end
      endcase

      disp1 <= DASH_string;

      case(scoreB)
      3'b000:begin
        disp0 <= ZERO;
      end 
      3'b001:begin
        disp0 <= ONE;
      end 
      3'b010:begin
        disp0 <= TWO;
      end 
      3'b011:begin
        disp0 <= THREE;
      end 
      3'b100:begin
        disp0 <= FOUR;
      end
      default: begin
        disp0 <= FIVE;
      end
      endcase

      if (Z) begin
        led <= 8'b11111111;
      end 
      else begin
        led <= 8'b00000000;
      end
    end



    B_SINK: begin
      
      disp3 <= 8'b00000000;
      
      case(scoreA)
      3'b000:begin
        disp2 <= ZERO;
      end 
      3'b001:begin
        disp2 <= ONE;
      end 
      3'b010:begin
        disp2 <= TWO;
      end 
      3'b011:begin
        disp2 <= THREE;
      end 
      3'b100:begin
        disp2 <= FOUR;
      end
      default: begin
        disp2 <= FIVE;
      end
      endcase

      disp1 <= DASH_string;

      case(scoreB)
      3'b000:begin
        disp0 <= ZERO;
      end 
      3'b001:begin
        disp0 <= ONE;
      end 
      3'b010:begin
        disp0 <= TWO;
      end 
      3'b011:begin
        disp0 <= THREE;
      end 
      3'b100:begin
        disp0 <= FOUR;
      end
      default: begin
        disp0 <= FIVE;
      end
      endcase        
      
      if (Z) begin
        led <= 8'b11111111;
      end 
      else begin
        led <= 8'b00000000;
      end
    end


    A_WIN: begin
      disp3 <= A_string;

      case(scoreA)
      3'b000:begin
        disp2 <= ZERO;
      end 
      3'b001:begin
        disp2 <= ONE;
      end 
      3'b010:begin
        disp2 <= TWO;
      end 
      3'b011:begin
        disp2 <= THREE;
      end 
      3'b100:begin
        disp2 <= FOUR;
      end
      default: begin
        disp2 <= FIVE;
      end
      endcase
      
      disp1 <= DASH_string;
      
      case(scoreB)
      3'b000:begin
        disp0 <= ZERO;
      end 
      3'b001:begin
        disp0 <= ONE;
      end 
      3'b010:begin
        disp0 <= TWO;
      end 
      3'b011:begin
        disp0 <= THREE;
      end 
      3'b100:begin
        disp0 <= FOUR;
      end
      default: begin
        disp0 <= FIVE;
      end
      endcase        
      
      case(timer_count[3:1])
        3'b000: led <= 8'b10000001;
        3'b001: led <= 8'b01000010;
        3'b010: led <= 8'b00100100;
        3'b011: led <= 8'b00011000;
        3'b100: led <= 8'b00011000;
        3'b101: led <= 8'b00100100;
        3'b110: led <= 8'b01000010;
        3'b111: led <= 8'b10000001;
    endcase
    end

    B_WIN: begin
      disp3 <= B_string;


      case(scoreA)
      3'b000:begin
        disp2 <= ZERO;
      end 
      3'b001:begin
        disp2 <= ONE;
      end 
      3'b010:begin
        disp2 <= TWO;
      end 
      3'b011:begin
        disp2 <= THREE;
      end 
      3'b100:begin
        disp2 <= FOUR;
      end
      default: begin
        disp2 <= FIVE;
      end
      endcase

      disp1 <= DASH_string;

      case(scoreB)
      3'b000:begin
        disp0 <= ZERO;
      end 
      3'b001:begin
        disp0 <= ONE;
      end 
      3'b010:begin
        disp0 <= TWO;
      end 
      3'b011:begin
        disp0 <= THREE;
      end 
      3'b100:begin
        disp0 <= FOUR;
      end
      default: begin
        disp0 <= FIVE;
      end
      endcase 
      
      
      case(timer_count[3:1])
        3'b000: led <= 8'b10000001;
        3'b001: led <= 8'b01000010;
        3'b010: led <= 8'b00100100;
        3'b011: led <= 8'b00011000;
        3'b100: led <= 8'b00011000;
        3'b101: led <= 8'b00100100;
        3'b110: led <= 8'b01000010;
        3'b111: led <= 8'b10000001;
      

    endcase

    end
  default:  begin
      
  
  led <= led ;
  disp0 <= disp0;
  disp1 <= disp1;
  disp2 <= disp2;
  disp3 <= disp3;  
  end
  endcase
end
end



endmodule