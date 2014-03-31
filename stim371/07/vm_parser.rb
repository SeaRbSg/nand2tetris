class Parser
  attr_reader :lines

  def initialize(file)
    @lines = File.readlines(file).map {|l| l.strip.gsub(/\s*\/\/.*/,'') }
    p lines
  end

  def parse
    lines.each do |line|
      yield Command.new(line)
    end
  end
end

class Command
  attr_accessor :command, :type, :arg1, :arg2
  def initialize(line)
    line_bits = line.split(' ')
    @command = line_bits[0]
    @type = Type.identify(command)
    @arg1 = line_bits[1]
    @arg2 = line_bits[2].to_i
  end

  def args
    [arg1, arg2]
  end

  def nil?
    type.nil?
  end

  module Type
    def self.identify(cmd)
      case cmd
      when "", nil
        nil
      when 'add', 'sub', 'neg', 'eq', 'gt', 'lt', 'and', 'or', 'not'
        :c_arithmetic
      when 'push'
        :c_push
      when 'pop'
        :c_pop
      when 'label'
        :c_label
      when 'goto'
        :c_goto
      when 'if-goto'
        :c_if
      else
        raise "unknown command: #{cmd}"
      end
    end
  end
end
