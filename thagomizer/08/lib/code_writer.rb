class CodeWriter
  SEGMENTS = {"local"    => "@LCL",
              "argument" => "@ARG",
              "this"     => "@THIS",
              "that"     => "@THAT",
             }

  attr_accessor :asm, :file_name

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

  def write_push(segment, index, include_comment = true)
    @asm << "// push #{segment} #{index}" if include_comment

    case segment
    when "temp"
      @asm << "@R#{5+index}"
      @asm << "D=M"
    when "pointer"
      @asm << "@#{3+index}"
      @asm << "D=M"
    when "constant"
      @asm << "@#{index}"
      @asm << "D=A"
    when "static"
      @asm << "@#{self.file_name}.#{index}"
      @asm << "D=M"
    when "local", "argument", "this", "that"
      @asm << "@#{index}"
      @asm << "D=A"
      @asm << SEGMENTS[segment]
      @asm << "A=M+D"
      @asm << "D=M"
    end
    pushd
  end

  def write_pop(segment, index)
    @asm << "// pop #{segment} #{index}"

    case segment
    when "temp"
      @asm << "@SP"
      @asm << "AM=M-1"
      @asm << "D=M"
      @asm << "@R#{5+index}"
    when "pointer"
      @asm << "@SP"
      @asm << "AM=M-1"
      @asm << "D=M"
      @asm << "@#{3+index}"
    when "static"
      @asm << "@SP"
      @asm << "AM=M-1"
      @asm << "D=M"
      @asm << "@#{self.file_name}.#{index}"
    else
      @asm << "@#{index}"
      @asm << "D=A"
      @asm << SEGMENTS[segment]
      @asm << "D=M+D"
      @asm << "@R13"
      @asm << "M=D"
      @asm << "@SP"
      @asm << "AM=M-1"
      @asm << "D=M"
      @asm << "@R13"
      @asm << "A=M"
    end

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
      @asm << "M=-M"
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
      @asm << "M=!M"
    }
  end

  def write_label(label)
    @asm << "// label"
    @asm << "(#{label})"
  end

  def write_goto(label)
    @asm << "// goto"
    @asm << "@#{label}"
    @asm << "0;JMP"
  end

  def write_if(label)
    @asm << "// if-goto"
    @asm << "@SP"
    @asm << "AM=M-1"
    @asm << "D=M"
    @asm << "@#{label}"
    @asm << "D;JNE"
  end

  def write_function(function_name, num_locals)
    loop_label = next_label("LOOP")

    @asm << "// function #{function_name} #{num_locals}"
    @asm << "(#{function_name})"
    @asm << "@#{num_locals}"
    @asm << "D=A"
    @asm << "@R13"
    @asm << "M=D"
    @asm << "(#{loop_label})"

    write_push("constant", 0, false)

    @asm << "@R13"
    @asm << "MD=M-1"
    @asm << "@#{loop_label}"
    @asm << "D;JGT"
  end

  def write_return
    # TODO Reduce code duplication

    @asm += ["// return",
             "@LCL",        # FRAME = LCL
              "D=M",
              "@LCL",
              "D=M",
              "@R14",
              "M=D",
              "@5",         # RET = *(FRAME - 5)
              "AD=D-A",
              "D=M",
              "@R15",
              "M=D",
              "@SP",        # *ARG = pop()
              "AM=M-1",
              "D=M",
              "@ARG",
              "A=M",
              "M=D",
              "@ARG",       # SP = ARG + 1
              "D=M+1",
              "@SP",
              "M=D"]

    restore_frame_var("THAT")  # THAT = *(FRAME-1)
    restore_frame_var("THIS")  # THIS = *(FRAME-2)
    restore_frame_var("ARG")   # ARG = *(FRAME-3)
    restore_frame_var("LCL")   # LCL = *(FRAME-4)

    @asm += ["@R15",       # goto RET
              "A=M",
              "0;JMP"]
  end

  def restore_frame_var(var)
    @asm += ["@R14",
             "AMD=M-1",
             "D=M",
             "@#{var}",
              "M=D"]
  end

  def write path
    i = 0

    File.open(path, "w") do |f|
      @asm.each do |line|
        if line =~ /\/\// or line =~ /\(/
          f.puts line
        else
          f.puts line + "\t\t // #{i}"
          i += 1
        end
      end
#      f.write @asm.join("\n")
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
    label_pushd = next_label("PUSHD")

    binary_operation {
      @asm << "D=A-D"
      @asm << "@#{label_true}"
      @asm << "D;#{jump_to_use}"

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
    @asm << "A=M-1"
    yield
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
