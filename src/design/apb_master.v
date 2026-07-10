module apb_master #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32,
  parameter STRB_WIDTH = DATA_WIDTH/8
)(
  input                         clk,
  input                         rst_n,

  input                         transfer,
  input                         write_read,
  input      [ADDR_WIDTH-1:0]   addr_in,
  input      [DATA_WIDTH-1:0]   wdata_in,
  input      [STRB_WIDTH-1:0]   strb_in,

  output reg [DATA_WIDTH-1:0]   rdata_out,
  output reg                    transfer_done,
  output reg                    error,

  output reg [ADDR_WIDTH-1:0]   PADDR,
  output reg                    PSEL,
  output reg                    PENABLE,
  output reg                    PWRITE,
  output reg [DATA_WIDTH-1:0]   PWDATA,
  output reg [STRB_WIDTH-1:0]   PSTRB,

  input      [DATA_WIDTH-1:0]   PRDATA,
  input                         PREADY,
  input                         PSLVERR
);

  parameter IDLE   = 2'b00;
  parameter SETUP  = 2'b01;
  parameter ACCESS = 2'b10;

  reg [1:0] state, next_state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= IDLE;
    else
      state <= next_state;
  end

  always @(*) begin
    case (state)
      IDLE:    next_state = transfer ? SETUP : IDLE;
      SETUP:   next_state = ACCESS;
      ACCESS:  next_state = PREADY ? (transfer ? SETUP : IDLE) : ACCESS;
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      PADDR  <= {ADDR_WIDTH{1'b0}};
      PWRITE <= 1'b0;
      PWDATA <= {DATA_WIDTH{1'b0}};
      PSTRB  <= {STRB_WIDTH{1'b0}};
    end
    else if ((state == IDLE && transfer) ||
             (state == ACCESS && PREADY && transfer)) begin
      PADDR  <= addr_in;
      PWRITE <= write_read;
      PWDATA <= wdata_in;
      PSTRB  <= strb_in;
    end
  end

  always @(*) begin
    PSEL    = (state == SETUP) || (state == ACCESS);
    PENABLE = (state == ACCESS);
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rdata_out     <= {DATA_WIDTH{1'b0}};
      transfer_done <= 1'b0;
      error         <= 1'b0;
    end
    else begin
      transfer_done <= 1'b0;
      if (state == ACCESS && PREADY) begin
        rdata_out     <= PRDATA;
        transfer_done <= 1'b1;
        error         <= PSLVERR;
      end
    end
  end

endmodule
