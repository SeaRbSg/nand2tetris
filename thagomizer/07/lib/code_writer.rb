class CodeWriter
  attr_accessor :asm

  def initialize
    @asm = []
  end

  def write_push_pop(cmd, segment, index)
    case cmd
    when :c_push
      write_push(segment, index)
    when :c_pop
      write_pop(segment, index)
    end
  end

  def write_push(segment, index)
    @asm << "// push #{segment} #{index}"

    if segment == "constant"
      @asm << "@#{index}"
      @asm << "D=A"
    else
      # Use the proper segment
    end
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_pop(segment, index)
    # Use segment properly

    @asm << "// pop #{segment} #{index}"
    @asm << "@#{index}"
    @asm << "D=A"
    @asm << "@LCL"  # TODO SEGMENT
    @asm << "D=A+D"
    @asm << "@R13"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@R13"
    @asm << "A=M"
    @asm << "M=D"
  end

  def write_arithmetic(cmd)
    case cmd
    when "add"
      write_add
    end
  end

  def write_add
    @asm << "// add"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
    @asm << "D=D+A"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write path
    File.open(path, "w") do |f|
      f.write @asm.join("\n")
    end
  end
end
