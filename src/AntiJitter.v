module AntiJitter #(parameter Peroids = 8)(
    input clk,
    input SIGNAL,
    output AntiJitter_SIGNAL
  );
  reg [7:0]cnt = 0;

  always @(posedge clk)
  begin
    cnt<={cnt[6:0],SIGNAL};
  end
  assign AntiJitter_SIGNAL=&cnt;
endmodule
