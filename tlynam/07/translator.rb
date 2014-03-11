require './parser'

#filename = ARGV[0]
filename = "stackarithmetic/stacktest/stacktest.vm"
output = filename.gsub("vm","asm")

parse = Parser.new

vm = File.read(filename)
counter = 0
vm.each_line do |line|
  line.strip!
  command_type = parse.commandtype(line)
  case command_type
  when "C_ARITHMETIC"
    counter += 1
    arthmetic = parse.arg1(line)
    parse.writearithmetic(arthmetic,output,counter)
  when "C_PUSH"
    constant = parse.arg2(line)
    #parse.stack.push(constant)
    parse.writepushpop(output,command_type, constant)
  when "C_POP"
    constant = parse.arg2(line)
  end
end