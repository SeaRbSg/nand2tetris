require_relative 'assembler'

raw_lines = File.readlines(ARGV[0])

clean_lines = raw_lines.map {|line| line.strip}
              .select {|line| !line.start_with?("//") && !line.empty?}
              .map {|line| line.split("//")[0].strip}

machine_code = Assembler.assemble clean_lines

File.open(ARGV[0].gsub("asm", "hack"), 'w') do |file| 
  machine_code.each {|line| file.write(line + "\n")}
end
