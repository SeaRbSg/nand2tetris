require 'stringio'

class VmWriter
  attr_accessor :output

  def initialize(output = StringIO.new)
    @output = output
  end

  def write_push(segment, index)
    write_push_pop(:push, segment, index)
  end

  def write_pop(segment, index)
    write_push_pop(:pop, segment, index)
  end

  def write_push_pop(cmd, segment, index)
    segment_name = case segment
                   when :const
                     :constant
                   when :arg
                     :argument
                   when :local, :static, :this, :that, :pointer, :temp
                     segment
                   else
                     raise "Unknown segment"
                   end

    @output.puts "#{cmd} #{segment_name} #{index}"
  end

  def write_arithmetic(cmd)
    case cmd
    when :add, :sub, :neg, :eq, :gt, :lt, :and, :or, :not
        @output.puts cmd
    else
      raise "Unknown Operation"
    end
  end

  def write_label(label)
    @output.puts "label #{label}"
  end

  def write_goto(label)
    @output.puts "goto #{label}"
  end

  def write_if(label)
    @output.puts "if-goto #{label}"
  end

  def write_call(name, num_args)
    @output.puts "call #{name} #{num_args}"
  end

  def write_function(name, num_locals)
    @output.puts "function #{name} #{num_locals}"
  end

  def write_return
    @output.puts "return"
  end

  def write_comment(comment)
    @output.puts "// #{comment}"
  end
end
