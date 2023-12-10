`timescale 1 ns / 1 ns 

module char_rom (
  input [7:0] ascii_hex,
  input [2:0] rowNum,
  input [2:0] colNum,
  output reg[2:0] pixel
);
reg[9:0] rom[949:0];
reg [10:0] line;
//reg[15:0] rom[2**10-1:0];
initial $readmemb("characters.rom",rom);
always @(*) begin
  line = ((ascii_hex - 8'h20) * 10) + (rowNum + 1);
  pixel = rom[line][colNum - 1] === 1 ? 3'b111 : 3'b000;
end

endmodule 