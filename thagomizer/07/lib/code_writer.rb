class CodeWriter
  attr_accessor :asm

  def initialize
    @asm = []
    @label_uniquifier = "0000"
  end

  def next_label(prefix)
    @label_uniquifier = @label_uniquifier.succ
    "#{prefix}#{@label_uniquifier}"
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
    when "sub"
      write_sub
    when "neg"
      write_neg
    when "eq"
      write_eq
    when "gt"
      write_gt
    when "lt"
      write_lt
    when "and"
      write_and
    when "or"
      write_or
    when "not"
      write_not
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
    @asm << "D=A+D"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_sub
    @asm << "// sub"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
    @asm << "D=A-D"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_neg
    @asm << "// neg"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "MD=-D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_eq
    label_true = next_label("TRUE")
    label_false = next_label("FALSE")
    label_pushd = next_label("PUSHD")

    @asm << "// eq"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
    @asm << "D=A-D"
    @asm << "@#{label_true}"
    @asm << "D;JEQ"

    @asm << "(#{label_false})"
    @asm << "D=0"
    @asm << "@#{label_pushd}"
    @asm << "0;JMP"

    @asm << "(#{label_true})"
    @asm << "D=-1"

    @asm << "(#{label_pushd})"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_gt
    label_true = next_label("TRUE")
    label_false = next_label("FALSE")
    label_pushd = next_label("PUSHD")

    @asm << "// gt"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
    @asm << "D=A-D"
    @asm << "@#{label_true}"
    @asm << "D;JGT"

    @asm << "(#{label_false})"
    @asm << "D=0"
    @asm << "@#{label_pushd}"
    @asm << "0;JMP"

    @asm << "(#{label_true})"
    @asm << "D=-1"

    @asm << "(#{label_pushd})"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_lt
    label_true = next_label("TRUE")
    label_false = next_label("FALSE")
    label_pushd = next_label("PUSHD")

    @asm << "// lt"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
    @asm << "D=A-D"
    @asm << "@#{label_true}"
    @asm << "D;JLT"

    @asm << "(#{label_false})"
    @asm << "D=0"
    @asm << "@#{label_pushd}"
    @asm << "0;JMP"

    @asm << "(#{label_true})"
    @asm << "D=-1"

    @asm << "(#{label_pushd})"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_and
    @asm << "// and"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
    @asm << "D=D&A"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_or
    @asm << "// or"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
    @asm << "D=D|A"
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write_not
    @asm << "// not"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "MD=!D"
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def write path
    File.open(path, "w") do |f|
      f.write @asm.join("\n")
    end
  end
end
