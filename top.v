// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE

module top (
  input        clk    , 
  input  [3:0] sw     , 
  input  [3:0] btn    ,
  output [7:0] led    , 
  output [7:0] seven  , 
  output [3:0] segment 
);

  
  // Clock Divider 
  wire clk_div;
  wire [7:0] disp0, disp1, disp2, disp3;
  wire [7:0] led_out;
  wire rst_Cln, startCln, pAb_Cln, pBb_Cln;


  clk_divider clk_div_inst (
    .clk_in     (clk),
    .divided_clk(clk_div)
  );
  

  // Debouncers for Buttons
  // (btn[3]: pAb, btn[2]: rst, btn[1]: start, btn[0]: pBb)
 
  debouncer db_pAb (
    .clk       (clk_div),
    .rst       (1'b0),
    .noisy_in  (btn[3]),
    .clean_out (pAb_Cln)
  );

  debouncer db_pBb (
    .clk       (clk_div),
    .rst       (1'b0),
    .noisy_in  (btn[0]),
    .clean_out (pBb_Cln)
  );

  debouncer db_START (
    .clk       (clk_div),
    .rst       (1'b0),
    .noisy_in  (btn[1]),
    .clean_out (startCln)
  );

  debouncer db_RST (
    .clk       (clk_div),
    .rst       (1'b0),
    .noisy_in  (btn[2]),
    .clean_out (rst_Cln)
  );

  
  // 3) Battleship (FSM) Module

  battleship game (
    .clk   (clk_div),
    .rst   (rst_Cln),
    .start (startCln),
    .X     (sw[3:2]),
    .Y     (sw[1:0]),
    .pAb   (pAb_Cln),
    .pBb   (pBb_Cln),
    .disp0 (disp0),
    .disp1 (disp1),
    .disp2 (disp2),
    .disp3 (disp3),
    .led   (led_out)
  );

  
  // SSD Driver
  ssd display  (
    .clk     (clk),       /
    .disp0   (disp0),
    .disp1   (disp1),
    .disp2   (disp2),
    .disp3   (disp3),
    .seven   (seven),
    .segment (segment)
  );

  
  // LED out
  
  assign led = led_out;

endmodule