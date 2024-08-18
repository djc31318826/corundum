/**
    Designed by djc001 @ 2021-10-30


**/
`timescale 1ps/1ps
module pfifo_a
#(
    parameter WIDTH             = 18     ,
    parameter SOP               = WIDTH-1,
    parameter EOP               = WIDTH-2,
    parameter FIFO_AFULL_LEVEL  = 500    ,
    parameter FIFO_AEMPTY_LEVEL = 10     ,
    parameter ADDR_WIDTH        = 10     
) 
(
    input                   clk_wr          ,//
    input                   clk_rd          ,//
    input                   rst_wr          ,//
    input                   rst_rd          ,//
    input                   fifo_wr_en      ,//
    input   [WIDTH-1:0]     fifo_data_in    ,//
    input                   pkt_err         ,//
    input                   fifo_clr        ,//
    input                   fifo_rd_en      ,//
    output [WIDTH-1:0]      fifo_rd_data    ,//
    output                  afull           ,//
    output                  aempty          ,//
    output                  full            ,//
    output                  empty            //

);

wire    sig_sop                 ;
wire    sig_eop                 ;
wire    sig_err                 ;
wire    sig_eop_rd              ;

reg [ADDR_WIDTH-1:0]    wr_addr      =0 ;

reg [ADDR_WIDTH-1:0]    wr_addr_lock  ;
reg [ADDR_WIDTH-1:0]    rd_addr      =0 ;
reg [ADDR_WIDTH-1:0]    rd_addr_pre   ;
reg                     fifo_wr_en_d1 ;
wire                    fifo_wr_en_neg;
wire                    reset_inner   ;
wire                    reset_inner_wr;
wire                    reset_inner_rd;
reg  [WIDTH-1:0]        fifo_data_in_d1;

wire [ADDR_WIDTH-1:0]   addr_gap_wr   ;
wire [ADDR_WIDTH-1:0]   addr_gap_rd   ;
wire [ADDR_WIDTH-1:0]   wr_addr_clk_rd;
wire [ADDR_WIDTH-1:0]   rd_addr_clk_wr;

reg[1:0]     fifo_clr_shift_wr;
reg[1:0]     fifo_clr_shift_rd;

reg          empty_rd;
reg          empty_d1;
reg          empty_d2;


wire         fifo_clr_wr;
wire         fifo_clr_rd;
reg [ADDR_WIDTH-1:0]    pkt_count_wr  ;
reg  [ADDR_WIDTH-1:0] pkt_count_rd       ;
wire [ADDR_WIDTH-1:0] pkt_count_wr_clk_rd;


reg [7:0]   reset_inner_shift_wr;
reg         reset_inner_shift_wr_ext;

reg         reset_inner_rd_d1;
reg         reset_inner_rd_d2;

reg         reset_inner_wr_d1;
reg         reset_inner_wr_d2;
reg         pkt_err_d1       ;

assign  sig_sop   =fifo_data_in[SOP]&fifo_wr_en         ;
assign  sig_eop   =fifo_data_in[EOP]&fifo_wr_en         ;
assign  sig_err   =fifo_data_in[EOP]&pkt_err&fifo_wr_en ;
assign  sig_eop_rd=fifo_rd_data[EOP]&fifo_rd_en         ;

always @(posedge clk_wr or posedge rst_wr)
begin
    if(rst_wr==1'b1)
        pkt_err_d1<=1'd0;
    else
        pkt_err_d1<=pkt_err;
end

always @(posedge clk_wr or posedge rst_wr)
begin
    if(rst_wr==1'b1)
        fifo_clr_shift_wr<=2'd0;
    else
        fifo_clr_shift_wr<={fifo_clr_shift_wr[0],fifo_clr_shift_rd[1]};
end

always @(posedge clk_rd or posedge rst_rd)
begin
    if(rst_rd==1'b1)
        fifo_clr_shift_rd<=2'd0;
    else
        fifo_clr_shift_rd<={fifo_clr_shift_rd[0],fifo_clr}; //fifo_clr的宽度足够不需要展宽
end


assign fifo_clr_wr=fifo_clr_shift_wr[1];
assign fifo_clr_rd=fifo_clr_shift_rd[1];

//如果有超长包进来，又没有EOP的化，会导致fifo的empty=0，afull=1，此时FIFO肯定不在读的状态，需要做复位。
assign  reset_inner=(afull==1'b1&&empty_d2==1'b1&&fifo_wr_en_neg==1'b1);

always @(posedge clk_wr or posedge rst_wr)
begin
    if(rst_wr==1'b1)
        reset_inner_shift_wr<=8'b0;
    else
        reset_inner_shift_wr<={reset_inner_shift_wr[6:0],reset_inner};
end

always @(posedge clk_wr or posedge rst_wr)
begin
    if(rst_wr==1'b1)
        reset_inner_shift_wr_ext<=1'b0;
    else
        reset_inner_shift_wr_ext<=|reset_inner_shift_wr;
end

always @(posedge clk_rd or posedge rst_rd)
begin
    if(rst_rd==1'b1)
    begin
        reset_inner_rd_d1<=1'b0;
        reset_inner_rd_d2<=1'b0;
    end
    else
    begin
        reset_inner_rd_d1<=reset_inner_shift_wr_ext;
        reset_inner_rd_d2<=reset_inner_rd_d1;
    end
end

always @(posedge clk_wr or posedge rst_wr)
begin
    if(rst_wr==1'b1)
    begin
        reset_inner_wr_d1<=1'b0;
        reset_inner_wr_d2<=1'b0;
    end
    else
    begin
        reset_inner_wr_d1<=reset_inner_rd_d2;
        reset_inner_wr_d2<=reset_inner_wr_d1;
    end
end

assign  reset_inner_wr=reset_inner_wr_d2;
assign  reset_inner_rd=reset_inner_rd_d2;

always @(posedge clk_wr or posedge rst_wr)
begin
    if(rst_wr==1'b1)
        fifo_wr_en_d1<=1'b0;
    else
        fifo_wr_en_d1<=fifo_wr_en;
end

assign fifo_wr_en_neg=(~fifo_wr_en)&fifo_wr_en_d1;
/*
always @(posedge clk_wr or posedge rst_wr) 
begin
    if(rst_wr==1'b1)
        wr_addr<={ADDR_WIDTH{1'b0}} ;
    else if(fifo_clr_wr==1'b1||reset_inner_wr==1'b1)
        wr_addr<={ADDR_WIDTH{1'b0}} ;
    //else if(sig_err==1'b1)
    //    wr_addr<=wr_addr_lock;   
    else if(sig_sop==1'b1&&full==1'b0)
        wr_addr<=wr_addr_lock+1'b1;   
    else if(fifo_wr_en==1'b1&&full==1'b0)       //需要加入full=0的判断，防止写溢出
        wr_addr<=wr_addr+1'b1;
end
*/
always @(posedge clk_wr or posedge rst_wr) 
begin
    if(rst_wr==1'b1)
        wr_addr<={ADDR_WIDTH{1'b0}} ;
    else if(fifo_clr_wr==1'b1||reset_inner_wr==1'b1)
        wr_addr<={ADDR_WIDTH{1'b0}} ;
    else if(sig_sop==1'b1)
        wr_addr<=wr_addr_lock;
    else if(fifo_wr_en_d1==1'b1&&full==1'b0)
        wr_addr<=wr_addr+1'b1;
end


always @(posedge clk_wr or posedge rst_wr) 
begin
    if(rst_wr==1'b1)
        fifo_data_in_d1<={WIDTH{1'b0}} ;
    else
        fifo_data_in_d1<=fifo_data_in;
end

always @(posedge clk_wr or posedge rst_wr) 
begin
    if(rst_wr==1'b1)
        wr_addr_lock<={ADDR_WIDTH{1'b0}} ;
    else if(fifo_clr_wr==1'b1||reset_inner_wr==1'b1)
        wr_addr_lock<={ADDR_WIDTH{1'b0}} ;
    else if(fifo_wr_en_d1==1'b1&&fifo_data_in_d1[EOP]==1'b1&&pkt_err_d1==1'b0)//if(sig_eop==1'b1&&sig_err==1'b0)
        wr_addr_lock<=wr_addr+1'b1;
end

always @(posedge clk_rd or posedge rst_rd) 
begin
    if(rst_rd==1'b1)
        rd_addr<={ADDR_WIDTH{1'b0}} ;
    else if(fifo_clr_wr==1'b1||reset_inner_rd==1'b1)
        rd_addr<={ADDR_WIDTH{1'b0}} ;
    else if(fifo_rd_en==1'b1&&empty==1'b0)
        rd_addr<=rd_addr+1'b1;
end

always@ *
begin
    if(fifo_rd_en==1'b1)
        rd_addr_pre=rd_addr+1'b1;
    else
        rd_addr_pre=rd_addr;
end

//产生fifo的full指示信号
//assign addr_gap = wr_addr - rd_addr;
assign full     = (addr_gap_wr>={{(ADDR_WIDTH-3){1'b1}},3'b0});
assign afull    = (addr_gap_wr>=FIFO_AFULL_LEVEL)  ;  
assign aempty   = (addr_gap_rd<FIFO_AEMPTY_LEVEL)  ;
/*empty 产生*/
always @(posedge clk_wr or posedge rst_wr) 
begin
    if(rst_wr==1'b1)
        pkt_count_wr<={ADDR_WIDTH{1'b0}} ;
    else if(fifo_clr_wr==1'b1||reset_inner_wr==1'b1)
        pkt_count_wr<={ADDR_WIDTH{1'b0}} ;
    else if(sig_eop==1'b1&&pkt_err==1'b0)
        pkt_count_wr<=pkt_count_wr+1'b1;
end

gray_trans
#(
    .WIDTH  (ADDR_WIDTH)     
) 
u0_gray_trans
(
    .data_in    ( pkt_count_wr  ),//input   [WIDTH-1:0]     
    .clk_in     ( clk_wr   ),//input                   
    .rst_in     ( rst_wr  ),//input                   
    .clk_out    ( clk_rd  ),//input                   
    .rst_out    ( rst_rd  ),//input                   
    .data_out   ( pkt_count_wr_clk_rd  ) //output  [WIDTH-1:0]  
);

gray_trans
#(
    .WIDTH  (ADDR_WIDTH)     
) 
u1_gray_trans
(
    .data_in    ( wr_addr       ),//input   [WIDTH-1:0]     
    .clk_in     ( clk_wr        ),//input                   
    .rst_in     ( rst_wr        ),//input                   
    .clk_out    ( clk_rd        ),//input                   
    .rst_out    ( rst_rd        ),//input                   
    .data_out   ( wr_addr_clk_rd) //output  [WIDTH-1:0]  
);

assign addr_gap_rd=wr_addr_clk_rd-rd_addr;

gray_trans
#(
    .WIDTH  (ADDR_WIDTH)     
) 
u2_gray_trans
(
    .data_in    ( rd_addr       ),//input   [WIDTH-1:0]     
    .clk_in     ( clk_rd        ),//input                   
    .rst_in     ( rst_rd        ),//input                   
    .clk_out    ( clk_wr        ),//input                   
    .rst_out    ( rst_wr        ),//input                   
    .data_out   ( rd_addr_clk_wr) //output  [WIDTH-1:0]  
);
assign addr_gap_wr=(fifo_clr_wr==1'b1)?1'b0:wr_addr-rd_addr_clk_wr;

always @(posedge clk_rd or posedge rst_rd) 
begin
    if(rst_rd==1'b1)
        pkt_count_rd<={ADDR_WIDTH{1'b0}} ;
    else    if (fifo_clr_rd==1'b1)     
        pkt_count_rd<={ADDR_WIDTH{1'b0}} ;
    else    if(sig_eop_rd==1'b1)
        pkt_count_rd<=pkt_count_rd+1'b1;
end

assign empty=(pkt_count_rd==pkt_count_wr_clk_rd);


always @(posedge clk_rd or posedge rst_rd) 
begin
    if(rst_rd==1'b1)
        empty_rd<=1'b1 ;
    else   
        empty_rd<=empty;
end

always @(posedge clk_wr or posedge rst_wr) 
begin
    if(rst_wr==1'b1)
    begin
        empty_d1<=1'b1;
        empty_d2<=1'b1;
    end
    else 
    begin
        empty_d1<=empty_rd;
        empty_d2<=empty_d1;
    end
end

//例化RAM
// xpm_memory_sdpram: Simple Dual Port RAM
// Xilinx Parameterized Macro, version 2021.1
xpm_memory_sdpram #(
 .ADDR_WIDTH_A              (ADDR_WIDTH     ), // DECIMAL
 .ADDR_WIDTH_B              (ADDR_WIDTH     ), // DECIMAL
 .AUTO_SLEEP_TIME           (0              ), // DECIMAL
 .BYTE_WRITE_WIDTH_A        (WIDTH          ), // DECIMAL *****
 .CASCADE_HEIGHT            (0              ), // DECIMAL
 .CLOCKING_MODE             ("independent_clock" ), // String
 .ECC_MODE                  ("no_ecc"       ), // String
 .MEMORY_INIT_FILE          ("none"         ), // String
 .MEMORY_INIT_PARAM         ("0"            ), // String
 .MEMORY_OPTIMIZATION       ("true"         ), // String
 .MEMORY_PRIMITIVE          ("auto"         ), // String
 .MEMORY_SIZE               (2**ADDR_WIDTH*WIDTH  ), // DECIMAL
 .MESSAGE_CONTROL           (0              ), // DECIMAL
 .READ_DATA_WIDTH_B         (WIDTH          ), // DECIMAL
 .READ_LATENCY_B            (1              ), // DECIMAL
 .READ_RESET_VALUE_B        ("0"            ), // String
 .RST_MODE_A                ("SYNC"         ), // String
 .RST_MODE_B                ("SYNC"         ), // String
 .SIM_ASSERT_CHK            (0              ), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
 .USE_EMBEDDED_CONSTRAINT   (0              ), // DECIMAL
 .USE_MEM_INIT              (1              ), // DECIMAL
 .WAKEUP_TIME               ("disable_sleep"), // String
 .WRITE_DATA_WIDTH_A        (WIDTH          ), // DECIMAL
 .WRITE_MODE_B              ("no_change"    ) // String
)
xpm_memory_sdpram_inst (
 .dbiterrb      (            ), // 1-bit output: Status signal to indicate double bit error occurrence
                            // on the data output of port B.
 .doutb         (fifo_rd_data), // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
 .sbiterrb      (            ), // 1-bit output: Status signal to indicate single bit error occurrence
 // on the data output of port B.
 .addra         (wr_addr     ), // ADDR_WIDTH_A-bit input: Address for port A write operations.
 .addrb         (rd_addr_pre ), // ADDR_WIDTH_B-bit input: Address for port B read operations.
 .clka          (clk_wr      ), // 1-bit input: Clock signal for port A. Also clocks port B when
 // parameter CLOCKING_MODE is "common_clock".
 .clkb          (clk_rd     ), // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
 // "independent_clock". Unused when parameter CLOCKING_MODE is
 // "common_clock".
 .dina          (fifo_data_in_d1), // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
 .ena           (fifo_wr_en_d1  ), // 1-bit input: Memory enable signal for port A. Must be high on clock
 // cycles when write operations are initiated. Pipelined internally.
 .enb           (1'b1        ), // 1-bit input: Memory enable signal for port B. Must be high on clock
 // cycles when read operations are initiated. Pipelined internally.
 .injectdbiterra(1'b0       ), // 1-bit input: Controls double bit error injection on input data when
 // ECC enabled (Error injection capability is not available in
 // "decode_only" mode).
 .injectsbiterra(1'b0       ), // 1-bit input: Controls single bit error injection on input data when
 // ECC enabled (Error injection capability is not available in
 // "decode_only" mode).
 .regceb        (1'b1       ), // 1-bit input: Clock Enable for the last register stage on the output
 // data path.
 .rstb          (rst_rd      ), // 1-bit input: Reset signal for the final port B output register stage.
 // Synchronously resets output port doutb to the value specified by
 // parameter READ_RESET_VALUE_B.
 .sleep         (1'b0       ), // 1-bit input: sleep signal to enable the dynamic power saving feature.
 .wea           (fifo_wr_en_d1) // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
 // for port A input data port dina. 1 bit wide when word-wide writes are
 // used. In byte-wide write configurations, each bit controls the
 // writing one byte of dina to address addra. For example, to
 // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
 // is 32, wea would be 4'b0010.
);
// End of xpm_memory_sdpram_inst instantiation
/*
BRAM_SDP_MACRO #(
 .BRAM_SIZE("18Kb"), // Target BRAM, "18Kb" or "36Kb"
 .DEVICE("7SERIES"), // Target device: "7SERIES"
 .WRITE_WIDTH(WIDTH), // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
 .READ_WIDTH (WIDTH), // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
 .DO_REG(0), // Optional output register (0 or 1)
 .INIT_FILE ("NONE"),
 .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
 // "GENERATE_X_ONLY" or "NONE"
 .SRVAL(72'h000000000000000000), // Set/Reset value for port output
 .INIT(72'h000000000000000000), // Initial values on output port
 .WRITE_MODE("READ_FIRST"), // Specify "READ_FIRST" for same clock or synchronous clocks
 // Specify "WRITE_FIRST for asynchronous clocks on ports
 .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 // The next set of INIT_xx are valid when configured as 36Kb
 .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
 // The next set of INITP_xx are for the parity bits
 .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
 // The next set of INITP_xx are valid when configured as 36Kb
 .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
 .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000)
) 
BRAM_SDP_MACRO_inst
(
    .DO        (fifo_rd_data     ), // Output read data port, width defined by READ_WIDTH parameter
    .DI        (fifo_data_in     ), // Input write data port, width defined by WRITE_WIDTH parameter
    .RDADDR    (rd_addr_pre      ), // Input read address, width defined by read port depth
    .RDCLK     (clk_sys          ), // 1-bit input read clock
    .RDEN      (fifo_rd_en       ), // 1-bit input read port enable
    .REGCE     (1'b1             ), // 1-bit input read output register enable
    .RST       (reset            ), // 1-bit input reset
    .WE        (32'hffff_ffff    ), // Input write enable, width defined by write port depth
    .WRADDR    (wr_addr          ), // Input write address, width defined by write port depth
    .WRCLK     (clk_sys          ), // 1-bit input write clock
    .WREN      (fifo_wr_en       ) // 1-bit input write port enable
)

*/

endmodule
