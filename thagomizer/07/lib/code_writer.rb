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
    pushd
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
    @asm << "// #{cmd}"

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
    binary_operation {
      @asm << "D=A+D"
    }
  end

  def write_sub
    binary_operation {
      @asm << "D=A-D"
    }
  end

  def write_neg
    unary_operation {
      @asm << "MD=-D"
    }
  end

  def write_eq
    comparison("JEQ")
  end

  def write_gt
    comparison("JGT")
  end

  def write_lt
    comparison("JLT")
  end

  def write_and
    binary_operation {
      @asm << "D=D&A"
    }
  end

  def write_or
    binary_operation {
      @asm << "D=D|A"
    }
  end

  def write_not
    unary_operation {
      @asm << "MD=!D"
    }
  end

  def write path
    File.open(path, "w") do |f|
      f.write @asm.join("\n")
    end
  end

  def pushd
    @asm << "@SP"
    @asm << "A=M"
    @asm << "M=D"
    increment_sp
  end

  def increment_sp
    @asm << "@SP"
    @asm << "M=M+1"
  end

  def comparison(jump_to_use)
    label_true = next_label("TRUE")
    label_false = next_label("FALSE")
    label_pushd = next_label("PUSHD")

    binary_operation {
      @asm << "D=A-D"
      @asm << "@#{label_true}"
      @asm << "D;#{jump_to_use}"

      @asm << "(#{label_false})"
      @asm << "D=0"
      @asm << "@#{label_pushd}"
      @asm << "0;JMP"

      @asm << "(#{label_true})"
      @asm << "D=-1"

      @asm << "(#{label_pushd})"
    }
  end

  # The block must put the result in D
  def unary_operation
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    yield if block_given?
    increment_sp
  end

  # The block must put the result in D
  def binary_operation
    load_top_two_stack_vars
    yield if block_given?
    pushd
  end

  def load_top_two_stack_vars
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "A=M"
  end

end
