module eeprom_top_tb;

  reg clk;
  reg rst;
  reg newd;
  reg ack;
  reg wr;
  wire scl;
  wire sda;
  reg [7:0] wdata;
  reg [6:0] addr;
  wire [7:0] rdata;
  wire done;

  // Instantiate the eeprom_top module
  eeprom_top uut (
    .clk(clk),
    .rst(rst),
    .newd(newd),
    .ack(ack),
    .wr(wr),
    .scl(scl),
    .sda(sda),
    .wdata(wdata),
    .addr(addr),
    .rdata(rdata),
    .done(done)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Stimulus process
  initial begin
    // Initialize inputs
    rst = 1;
    newd = 0;
    ack = 0;
    wr = 0;
    wdata = 8'h00;
    addr = 7'h00;

    // Reset the design
    #10 rst = 0;

    // Write operation
    @(negedge clk);
    newd = 1;
    wr = 1;
    wdata = 8'hAA;
    addr = 7'h55;
    @(negedge clk);
    newd = 0;
    ack = 1;

    // Wait for write to complete
    wait(done);
    @(negedge clk);
    ack = 0;

    // Read operation
    @(negedge clk);
    newd = 1;
    wr = 0;
    addr = 7'h55;
    @(negedge clk);
    newd = 0;
    ack = 1;

    // Wait for read to complete
    wait(done);
    @(negedge clk);
    ack = 0;

    // Finish simulation
    #100;
    $stop;
  end

endmodule
