class CodeWriter
  attr_accessor :file_name

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
        @#{index + 3}
        M=D
      eoc
    when 'pointer'
      <<-eoc
        #{decrement_and_pop}
        @#{index + 5}
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
    # when 

    end
      
      
      
  end
end