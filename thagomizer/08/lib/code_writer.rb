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
      @asm += ["@R#{5+index}",
               "D=M",]
    when "pointer"
      @asm += ["@#{3+index}",
               "D=M",]
    when "constant"
      @asm += ["@#{index}",
               "D=A",]
    when "static"
      @asm += ["@#{self.file_name}.#{index}",
               "D=M"]
    when "local", "argument", "this", "that"
      @asm += ["@#{index}",
               "D=A",
               SEGMENTS[segment],
               "A=M+D",
               "D=M",]
    end
    push_d
  end

  def write_pop(segment, index)
    @asm << "// pop #{segment} #{index}"

    case segment
    when "temp"
      @asm += ["@SP",
               "AM=M-1",
               "D=M",
               "@R#{5+index}",]
    when "pointer"
      @asm += ["@SP",
               "AM=M-1",
               "D=M",
               "@#{3+index}",]
    when "static"
      @asm += ["@SP",
               "AM=M-1",
               "D=M",
               "@#{self.file_name}.#{index}",]
    else
      @asm += ["@#{index}",
               "D=A",
               SEGMENTS[segment],
               "D=M+D",
               "@R13",
               "M=D",
               "@SP",
               "AM=M-1",
               "D=M",
               "@R13",
               "A=M",]
    end

    @asm << "M=D"
  end

  def write_arithmetic(cmd)
    @asm << "// #{cmd}"

    send("write_#{cmd}")
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
    @asm += ["// label",
             "(#{label})",]
  end

  def write_goto(label)
    @asm += ["// goto",
             "@#{label}",
             "0;JMP",]
  end

  def write_if(label)
    @asm += ["// if-goto",
             "@SP",
             "AM=M-1",
             "D=M",
             "@#{label}",
             "D;JNE",]
  end

  def write_function(function_name, num_locals)
    @asm += ["// function #{function_name} #{num_locals}",
             "(#{function_name})",
             "@0",
             "D=A",]

    num_locals.times do
      push_d
    end

  end

  def write_call(function_name, num_args, include_comment = true)
    return_label = next_label("RET")

    @asm << "// call #{function_name} #{num_args}" if include_comment

    @asm += [
             "@#{return_label}",   # Push return-address
             "D=A",
             "@SP",
             "A=M",
             "M=D"]
    increment_sp

    push_var_onto_stack "LCL"
    push_var_onto_stack "ARG"
    push_var_onto_stack "THIS"
    push_var_onto_stack "THAT"

    @asm += [
             "@SP",                # ARG = SP-n-5
             "D=M",
             "@#{num_args + 5}",   # n+5
             "D=D-A",
             "@ARG",
             "M=D",
             "@SP",                # LCL = SP
             "D=M",
             "@LCL",
             "M=D",
             "@#{function_name}",  # goto f
             "0;JMP",
             "(#{return_label})",  # (return-address)
            ]
  end

  def push_var_onto_stack var
    @asm += ["@#{var}",
             "D=M",
             "@SP",
             "A=M",
             "M=D",]
    increment_sp
  end

  def write_return
    @asm += ["// return",
             "@LCL",        # FRAME = LCL
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

  def write_bootstrap
    @asm += ["// bootstrap",
             "@256",
             "D=A",
             "@SP",
             "M=D"]
    write_call("Sys.init", 0, false)
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

  def push_d
    @asm += ["@SP",
             "A=M",
             "M=D",]
    increment_sp
  end

  def increment_sp
    @asm += ["@SP",
             "M=M+1",]
  end

  def comparison(jump_to_use)
    label_true = next_label("TRUE")
    label_pushd = next_label("PUSHD")

    binary_operation {
      @asm += ["D=A-D",
               "@#{label_true}",
               "D;#{jump_to_use}",
               "D=0",
               "@#{label_pushd}",
               "0;JMP",
               "(#{label_true})",
               "D=-1",
               "(#{label_pushd})",]
    }
  end

  # The block must put the result in D
  def unary_operation
    @asm += ["@SP",
             "A=M-1",]
    yield
  end

  # The block must put the result in D
  def binary_operation
    load_top_two_stack_vars
    yield if block_given?
    push_d
  end

  def load_top_two_stack_vars
    @asm += ["@SP",
             "AM=M-1",
             "D=M",
             "@SP",
             "AM=M-1",
             "A=M",]
  end

end
