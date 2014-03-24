require './parser'

filename = ARGV[0]
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
    arg2 = parse.arg2(line)
    arg1 = parse.arg1(line)
    parse.writepushpop(command_type,output,arg1,arg2)
  when "C_POP"
    arg2 = parse.arg2(line)
    arg1 = parse.arg1(line) 
    parse.writepushpop(command_type,output,arg1,arg2)
  when "C_LABEL"
    arg1 = parse.arg1(line) 
    parse.writelabel(arg1,output)
  when "C_IF"
    arg1 = parse.arg1(line) 
    parse.writeif(arg1,output)
  when ""
  else
    raise "Unhandled Command Type #{command_type}" 
  end
end

file = File.read(output)
File.delete(output)
counter = 0
file.each_line do |line|
  if line[/^[\w@]/] then
    line = line.to_s.strip.ljust(30," ") + "// #{counter.to_s}\n"
    File.open(output, "a") { |f| f.write line }
    counter += 1
  else
    File.open(output, "a") { |f| f.write "\n" + line + "\n" }
  end
end