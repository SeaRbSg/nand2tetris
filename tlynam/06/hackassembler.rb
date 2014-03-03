require './parser'

filename = "max/MaxL.asm"
output = "MaxL.hack"

parse = Parser.new

asm = File.read(filename)

command = ""

asm.each_line do |line|
  line.strip!
  command = parse.commandtype(line)
  case command
  when "A_COMMAND"
    word = parse.symbol(line).to_s(2)
    zeros = 16 - word.length
    zeros.times do
      File.open(output, "a") { |f| f.write "0"}
    end
    File.open(output, "a") { |f| f.write word}
    File.open(output, "a") { |f| f.write "\n"}
  when "C_COMMAND"
    File.open(output, "a") { |f| f.write "111"}
    comp_part = parse.comp(line)
    parse.write_comp(output,comp_part)

    dest_part = parse.dest(line)
    parse.write_dest(output,dest_part)

    jump_part = parse.jump(line)
    parse.write_jump(output,jump_part)
    File.open(output, "a") { |f| f.write "\n"}
  end
end
