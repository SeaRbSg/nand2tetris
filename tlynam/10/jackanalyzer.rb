require './tokenizer'
require './compilationengine'

inputfiles = []
ary = []
filefolder = ARGV[0]

if filefolder.nil?
  puts "Please pass file or folder name"
elsif !filefolder.nil?
  if Dir.exist?(filefolder)
    Dir.entries(filefolder).each {|file|
      inputfiles << filefolder + "/" + file[/^\w*.jack/] unless file[/^\w*.jack/].nil?
    }
  elsif File.exist?(filefolder)
    inputfiles << filefolder
  end
end

inputfiles.each { |inputfile|
  outputfile = inputfile.gsub(".jack","_tokens.xml")
  File.open(outputfile, "a") { |f| f.write "<tokens>\n" }
  #puts inputfile + " " + outputfile
  File.open(inputfile, "r") { |file|
    #How ignore comments
    cleanfile = ""
    file.each_line { |line|
      line = line[/^[^*\/]*/].strip
      line << " "
      cleanfile << line
    }
    #How use \W instead of [\];\.{},+\-*&|<>=~()"]
    parts = cleanfile.scan(/([\];\.{},+\-*&|<>=~()"]|[\w]+)/)
    tokenfile = Tokenizer.new
    parts.each {|part|
      #puts part[0]
      tokentype = tokenfile.tokentype(part[0])
      tokenfile.tokenwrite(outputfile,tokentype,part[0])
    }
  }
  File.open(outputfile, "a") { |f| f.write "</tokens>\n" }
}

