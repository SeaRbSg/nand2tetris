class CodeWriter
  attr_accessor :file_name
  @@next_label = 0

  def translate(cmd)
    case cmd.type
    when :c_push
      push_cmd(*cmd.args)
    when :c_pop
      pop_cmd(*cmd.args)
    when :c_arithmetic
      arithmetic_cmd(cmd.command)
    when :c_label
      label_cmd(*cmd.args)
    when :c_goto
      goto_cmd(*cmd.args)
    when :c_if
      if_cmd(*cmd.args)
    else
      nil
    end
  end

  def push_cmd(segment, index)
    a = ''
    a = case segment
    when 'temp'
      <<-eoc
        @R#{index + 5}
        D=M
      eoc
    when 'pointer'
      <<-eoc
        @R#{index + 3}
        D=M
      eoc
    when 'constant'
      <<-eoc
        @#{index}
        D=A
      eoc
    when 'static'
      <<-eoc
        @#{file_name}.#{index}
        D=M
      eoc
    when 'local', 'argument', 'this', 'that'
      <<-eoc
        @#{index}
        D=A
        @#{label_for_type(segment)}
        A=M+D
        D=M
      eoc
    end
    "#{a}\n#{increment_and_push}"
  end

  def increment_and_push
    <<-eoc
      @SP
      A=M
      M=D
      @SP
      M=M+1
    eoc
  end

  def label_for_type(type)
    {
      'local' => 'LCL',
      'argument' => 'ARG',
      'this' => 'THIS',
      'that' => 'THAT'
    }[type]
  end

  def pop_cmd(segment, index)
    a = ''
    a = case segment
    when 'temp'
      <<-eoc
        #{decrement_and_pop}
        @#{index + 5}
        M=D
      eoc
    when 'pointer'
      <<-eoc
        #{decrement_and_pop}
        @#{index + 3}
        M=D
      eoc
    when 'static'
      <<-eoc
        #{decrement_and_pop}
        @#{file_name}.#{index}
        M=D
      eoc
    when 'local', 'argument', 'this', 'that'
      <<-eoc
        @#{index}
        D=A
        @#{label_for_type(segment)}
        D=M+D
        @R13
        M=D
        #{decrement_and_pop}
        @R13
        A=M
        M=D
      eoc
    end
  end

  def decrement_and_pop
    <<-eoc
      @SP
      AM=M-1
      D=M
    eoc
  end

  def next_label(note)
    @@next_label += 1
    "#{note}#{@@next_label}"
  end

  def arithmetic_cmd(cmd)
    case cmd

    when 'add'
      <<-eoc
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        A=M
        D=A+D
        #{increment_and_push}
      eoc
    when 'sub'
      <<-eoc
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        A=M
        D=A-D
        #{increment_and_push}
      eoc
    when 'eq'
      true_lbl = next_label('TRUE')
      end_lbl = next_label('END')
      <<-eoc
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        A=M
        D=A-D
        @#{true_lbl}
        D;JEQ
        D=0
        #{increment_and_push}
        @#{end_lbl}
        0;JMP
        (#{true_lbl})
        D=-1
        #{increment_and_push}
        (#{end_lbl})
      eoc
    when 'lt'
      true_lbl = next_label('TRUE')
      end_lbl = next_label('END')
      <<-eoc
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        A=M
        D=A-D
        @#{true_lbl}
        D;JLT
        D=0
        #{increment_and_push}
        @#{end_lbl}
        0;JMP
        (#{true_lbl})
        D=-1
        #{increment_and_push}
        (#{end_lbl})
      eoc
    when 'gt'
      true_lbl = next_label('TRUE')
      end_lbl = next_label('END')
      <<-eoc
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        A=M
        D=A-D
        @#{true_lbl}
        D;JGT
        D=0
        #{increment_and_push}
        @#{end_lbl}
        0;JMP
        (#{true_lbl})
        D=-1
        #{increment_and_push}
        (#{end_lbl})
      eoc
    when 'and'
      <<-eoc
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        A=M
        D=D&A
        #{increment_and_push}
      eoc
    when 'or'
      <<-eoc
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        A=M
        D=D|A
        #{increment_and_push}
      eoc
    when 'neg'
      <<-eoc
        @SP
        A=M-1
        M=-M
      eoc
    when 'not'
      <<-eoc
        @SP
        A=M-1
        M=!M
      eoc
    end    
  end
end