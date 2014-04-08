require 'tokenizer'

class Compiler
  def self.compile text
    Tokenizer.tokenize(text)
  end
end


if $0 == __FILE__
  input = ARGV.first

  unless input && File.exists?(input)
    abort "Usage: #{$0} input"
  end

  puts input
end
