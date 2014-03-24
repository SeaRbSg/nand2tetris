class Parser

=begin
  Method: Constructor/initializer
  Args: Input file/stream
  Returns: nil
  Function: Opens the input file/stream and gets ready to self it.
=end
  attr_accessor :stack
  def initialize 
    @stack = []
    @static = []
  end

=begin
Method: commandType
Args: -
Returns:
C_ARITHMETIC
C_PUSH
C_POP
C_LABEL
C_GOTO
C_IF
C_FUNCTION
C_RETURN
C_CALL
Function: Returns the type of the current VM command.  C_ARITHMETIC is return for all the arithmetic commands.
=end
  def commandtype(line)
    command = line[/^[\w-]+/]
    case command
    when nil
      # do nothing
    when "add", "sub", "neg", "eq", "gt", "lt", "and", "or", "not"
      return "C_ARITHMETIC"
    when "push"
      return "C_PUSH"
    when "pop"
      return "C_POP"
    when "label"
      return "C_LABEL"
    when "if-goto"
      return "C_IF"
    else
      raise "Unhandled #{command.inspect} in commandtype"
    end
  end

=begin
Method: arg1
Args: -
Returns: string
Function: Returns the first argument of the current command.  C_ARITHMETIC the command itself (add, sub, etc) is returned.  Shouldn't be called for C_RETURN.
=end
  def arg1(line)
    case line[/^[\w-]*/]
    when "add", "sub", "neg", "eq", "gt", "lt", "and", "or", "not"
      return line
    else
      line.gsub!(/^[\w-]*/,"")
      return line[/^*[\w_]+/]
    end
  end

=begin
Method: arg2
Args: -
Returns: int
Function: Returns the second argument of the current command.  Should be called only if the current command is C_PUSH, C_POP, C_FUNCTION, or C_CALL.
=end
  def arg2(line)
    return line[/^*\d+/]
  end

=begin
 Method: writearithmetic
 Args: command (string)
 Function: Writes the assembly code that is the translation of the given arithmetic command.
=end
  def writearithmetic(command,output,counter)
    case command
    when "add"
      file = add_sub_thing command
      File.open(output, "a") { |f| f.write file }
    when "sub"
      file = add_sub_thing command
      File.open(output, "a") { |f| f.write file }
    when "eq"
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      if var1 == var2 then
        self.stack.push(-1)
      else
        self.stack.push(0)
      end
      file = equality command, counter
      File.open(output, "a") { |f| f.write file }
    when "gt"
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      if var1 > var2 then
        self.stack.push(-1)
      else
        self.stack.push(0)
      end
      file = equality command, counter
      File.open(output, "a") { |f| f.write file }
    when "lt"
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      if var1 < var2 then
        self.stack.push(-1)
      else
        self.stack.push(0)
      end
      file = equality command, counter
      File.open(output, "a") { |f| f.write file }
    when "and"
      var1 = self.stack.last(2)[0].to_i
      var2 = self.stack.last(2)[1].to_i
      self.stack.delete_at(self.stack.length-1)
      self.stack.delete_at(self.stack.length-1)
      var1bit = var1.to_s(2).rjust(16,"0")
      var2bit = var2.to_s(2).rjust(16,"0")
      bit = true
      16.times do |x|
        if var1bit[x] != var2bit[x]
          bit = false
        end
      end
      if bit == false then
        self.stack.push(0)
      else
        self.stack.push(-1)
      end
      file = andor command
      File.open(output, "a") { |f| f.write file }
    when "or"
      var1 = self.stack.last(2)[0].to_i
      var2 = self.stack.last(2)[1].to_i
      self.stack.delete_at(self.stack.length-1)
      self.stack.delete_at(self.stack.length-1)  
      var1bit = var1.to_s(2).rjust(16,"0")
      var2bit = var2.to_s(2).rjust(16,"0")
      bit = true
      16.times do |x|
        if var1bit[x] != 1 && var2bit[x] != 1
          bit = false
        end
      end
      if bit == false then
        self.stack.push(0)
      else
        self.stack.push(-1)
      end
      file = andor command
      File.open(output, "a") { |f| f.write file }
    when "not"
      var1 = self.stack.last
      self.stack.delete_at(self.stack.length-1)
      var1bit = var1.to_s(2).rjust(16,"0")
      var2bit = ""

      16.times do |x|
        if var1bit[x].to_i == 1 then
          var2bit << "0"
        else
          var2bit << "1"
        end
      end

      self.stack.push(var2bit.to_i(2))

      file = negnot command
      File.open(output, "a") { |f| f.write file }
    when "neg"
      var1 = self.stack.last
      self.stack.delete_at(self.stack.length-1)
      self.stack.push(var1 * -1)
      file = negnot command
      File.open(output, "a") { |f| f.write file }
    else
      raise "Unhandled #{command} in writearithmetic"
    end

  end

=begin
 Method: writepushpop
 Args: command (C_PUSH or C_POP), segment (string), index (int)
 Function: Writes the assembly code that is the translation of the given command, where command is either C_PUSH or C_POP.
 pg 142 table of ram mapping names
=end
  def writepushpop(command_type,output,arg1,arg2)
    case command_type
    when "C_POP"
      case arg1
      when "local"
        file = pop_thing "@LCL", arg2
        File.open(output, "a") { |f| f.write file }
      when "argument"
        file = pop_thing "@ARG", arg2
        File.open(output, "a") { |f| f.write file }
      when "this"
        file = pop_thing "@THIS", arg2
        File.open(output, "a") { |f| f.write file }
      when "that"
        file = pop_thing "@THAT", arg2
        File.open(output, "a") { |f| f.write file }
      when "temp"
        file = pop_thing "@R5", arg2, false
        File.open(output, "a") { |f| f.write file }
      when "pointer"
        file = pop_thing "@THIS", arg2, false
        File.open(output, "a") { |f| f.write file }
      when "static"
        file = pop_thing "@16", arg2, false
        File.open(output, "a") { |f| f.write file }
      else
        raise "Umnhandled #{arg1} in #{command_type}"
      end
    when "C_PUSH"
      case arg1
      when "local"
        self.stack.push(arg2)
        file = push_thing "@LCL", arg2
        File.open(output, "a") { |f| f.write file }
      when "this"
        self.stack.push(arg2)
        file = push_thing "@THIS", arg2
        File.open(output, "a") { |f| f.write file }
      when "that"
        self.stack.push(arg2)
        file = push_thing "@THAT", arg2
        File.open(output, "a") { |f| f.write file }
      when "argument"
        self.stack.push(arg2)
        file = push_thing "@ARG", arg2
        File.open(output, "a") { |f| f.write file }
      when "temp"
        self.stack.push(arg2)
        file = push_thing "@R5", arg2, false
        File.open(output, "a") { |f| f.write file }
      when "pointer"
        self.stack.push(arg2)
        file = push_thing "@THIS", arg2, false
        File.open(output, "a") { |f| f.write file }
      when "static"
        self.stack.push(arg2)
        file = push_thing "@16", arg2, false
        File.open(output, "a") { |f| f.write file }
      when "constant"
        self.stack.push(arg2)
file = <<PARAGRAPH
// Push Constant #{arg2}
@#{arg2}
D=A

@SP
A=M

M=D

@SP
M=M+1
PARAGRAPH
        File.open(output, "a") { |f| f.write file }
      else
         raise "Unhandled #{arg1} in #{command_type}"
      end
    else
        raise "Unhandled command #{command_type}"
    end
  end

  def push_thing loc, arg2, deref=true
<<PARAGRAPH
// Push #{loc} #{arg2}
#{loc}
D=#{deref ? "M" : "A"}

@#{arg2}
A=D+A

D=M

@SP
A=M

M=D

@SP
M=M+1

PARAGRAPH
  end

  def pop_thing loc, arg2, deref=true
<<PARAGRAPH
// Pop #{loc} #{arg2}
@SP
AM=M-1

D=M

@R13
M=D

#{loc}
D=#{deref ? "M" : "A"}

@#{arg2}
D=D+A

@R14
M=D

@R13
D=M

@R14
A=M

M=D

PARAGRAPH
  end

  def add_sub_thing command
    file = ""
    var1 = self.stack.last(2)[0]
    var2 = self.stack.last(2)[1]
    self.stack.delete_at(self.stack.length-1)
    self.stack.delete_at(self.stack.length-1)
    if command == "add"
      sym = "+"
      var3 = var1.to_i + var2.to_i
    elsif command == "sub"
      sym = "-"
      var3 = var1.to_i - var2.to_i
    else
      "Unhandled command #{command}"
    end
    self.stack.push(var3)
<<PARAGRAPH
// #{command}
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D#{sym}M

@SP
A=M

M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

M=0

PARAGRAPH
  end

  def equality command, counter
    self.stack.delete_at(self.stack.length-1)
    self.stack.delete_at(self.stack.length-1)
    case command
    when "eq"
      sym = "EQTRUE"
      jmp = "JEQ"
    when "gt"
      sym = "GTTRUE"
      jmp = "JGT"
    when "lt"
      sym = "LTTRUE"
      jmp = "JLT"
    else
      "Unhandled command #{command}"
    end
<<PARAGRAPH
// #{command}
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D-M

@#{sym}#{counter}
D;#{jmp}

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=0

@SP
M=M+1

@SP
A=M

M=0

@END#{counter}
0;JMP

#{"(" + sym + counter.to_s + ")"}

@SP
A=M

M=0

@R14
M=0

@R13
M=0

@SP
A=M

M=-1

@SP
M=M+1

@SP
A=M

M=0

(END#{counter})
PARAGRAPH
  end

  def andor command
    case command
    when "and"
      sym = "&"
    when "or"
      sym = "|"
    else
      raise "Unhandled command #{command}"
    end

<<PARAGRAPH
// #{command}
@SP
M=M-1

@SP
A=M

D=M

@R13
M=D

@SP
M=M-1

@SP
A=M

D=M

@R14
M=D

@R14
D=M

@R13
D=D#{sym}M

@SP
A=M

M=D

@R14
M=0

@R13
M=0

@SP
M=M+1

@SP
A=M

M=0

PARAGRAPH
  end

  def negnot command
    case command
    when "not"
      sym = "!"
    when "neg"
      sym = "-"
    else
      raise "Unhandled command #{command}"
    end
<<PARAGRAPH
// #{command}
@SP
M=M-1

@SP
A=M

M=#{sym}D

@SP
M=M+1

@SP
A=M

M=0
PARAGRAPH
  end


end