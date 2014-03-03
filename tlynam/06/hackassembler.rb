require './parser'

filename = ARGV[0]
output = ARGV[0].gsub("asm","hack")

parse = Parser.new

rom_address = 0
asm = File.read(filename)
asm.each_line do |line|
  line.strip!
  if line[/[(]/] then
    label = line[/[A-Z_a-z.$0-9]+/]
    parse.symbol_table.store(label, rom_address)
  end
  if line[/^[@A-Za-z0-9]/] then
    rom_address += 1
  end
end

command = ""
label = ""
asm.each_line do |line|
  line.strip!
  command = parse.commandtype(line)
  case command
  when "A_COMMAND"
    word = parse.symbol(line)
    word = word.to_s(2)
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
  when "L_COMMAND"
    label = line[/[A-Z_a-z]+/]
    File.open(output, "a") { |f| f.write parse.symbol_table[:label]}
  end
end