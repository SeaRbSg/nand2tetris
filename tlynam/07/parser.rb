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

  end

  def sp
    return self.stack.length
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
    command = line[/^\w+/]
    case command
    when "add"
      return "C_ARITHMETIC"
    when "sub"
      return "C_ARITHMETIC"
    when "neg"
      return "C_ARITHMETIC"
    when "eq"
      return "C_ARITHMETIC"
    when "gt"
      return "C_ARITHMETIC"
    when "lt"
      return "C_ARITHMETIC"
    when "and"
      return "C_ARITHMETIC"
    when "or"
      return "C_ARITHMETIC"
    when "not"
      return "C_ARITHMETIC"
    when "push"
      return "C_PUSH"
    when "pop"
      return "C_POP"
    end
  end

=begin
Method: arg1
Args: -
Returns: string
Function: Returns the first argument of the current command.  C_ARITHMETIC the command itself (add, sub, etc) is returned.  Shouldn't be called for C_RETURN.
=end
  def arg1(line)
    return line[/^\w+/]
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
      file = ""
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      var1mem = 256 + (self.sp - 2)
      var2mem = 256 + (self.sp - 1)
      self.stack.delete_at(self.stack.length-1)
      self.stack.delete_at(self.stack.length-1)
      var3 = var1.to_i + var2.to_i
      self.stack.push(var3)
file = <<PARAGRAPH
@#{var2mem}
D=M

@#{var1mem}
M=D+M

@#{var2mem}
M=0

@#{var2mem}
D=A
@0
M=D+1
PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "sub"
      file = ""
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      sp1 = self.sp - 2
      sp2 = self.sp - 1
      var1mem = 256 + (sp1)
      var2mem = 256 + (sp2)
      stack1 = self.stack.length - 1
      self.stack.delete_at(stack1)
      stack2 = self.stack.length - 1
      self.stack.delete_at(stack2)
      temp = 0
      if var1 == nil then
        var1 = 0
      end
      if var2 == nil then
        var2 = 0
      end
      temp = var1.to_i - var2.to_i
      self.stack.push(temp)
file = <<PARAGRAPH
@#{var2mem}
D=M

@#{var1mem}
M=M-D

@#{var2mem}
M=0

@#{var2mem}
D=A
@0
M=D+1
PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "neg"
      file = ""
      var1 = self.stack.last

      var1mem = 256 + (self.sp - 1)
      self.stack.delete_at(self.stack.length-1)
      self.stack.push(var1 * -1)

file = <<PARAGRAPH
@#{var1mem}
M=-M

@#{var1mem}
D=A
@0
M=D+1
PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "eq"
      file = ""
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      var1mem = 256 + (self.sp - 2)
      var2mem = 256 + (self.sp - 1)
      self.stack.delete_at(self.stack.length-1)
      self.stack.delete_at(self.stack.length-1)
      if var1 == var2 then
        self.stack.push(-1)
      else
        self.stack.push(0)
      end
file = <<PARAGRAPH
@#{var2mem}
D=M

@#{var1mem}
D=D-M

@EQTRUE#{counter}
D;JEQ

@#{var1mem}
M=0

@#{var2mem}
M=0

@#{var2mem}
D=A

@0
M=D+1

@END#{counter}
0;JMP

(EQTRUE#{counter})

@#{var1mem}
M=-1

@#{var2mem}
M=0

@#{var2mem}
D=A

@0
M=D+1

(END#{counter})

PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "gt"
      file = ""
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      var1mem = 256 + (self.sp - 2)
      var2mem = 256 + (self.sp - 1)
      self.stack.delete_at(self.stack.length-1)
      self.stack.delete_at(self.stack.length-1)
      if var1 > var2 then
        self.stack.push(-1)
      else
        self.stack.push(0)
      end
file = <<PARAGRAPH
@#{var2mem}
D=M

@#{var1mem}
D=M-D

@GTTRUE#{counter}
D;JGT

@#{var1mem}
M=0

@#{var2mem}
M=0

@#{var2mem}
D=A

@0
M=D+1

@END#{counter}
0;JMP

(GTTRUE#{counter})

@#{var1mem}
M=-1

@#{var2mem}
M=0


@#{var2mem}
D=A
@0
M=D+1

(END#{counter})

PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "lt"
      file = ""
      var1 = self.stack.last(2)[0]
      var2 = self.stack.last(2)[1]
      var1mem = 256 + (self.sp - 2)
      var2mem = 256 + (self.sp - 1)
      self.stack.delete_at(self.stack.length-1)
      self.stack.delete_at(self.stack.length-1)
      if var1 < var2 then
        self.stack.push(-1)
      else
        self.stack.push(0)
      end
file = <<PARAGRAPH
@#{var2mem}
D=M

@#{var1mem}
D=M-D

@LTTRUE#{counter}
D;JLT

@#{var1mem}
M=0

@#{var2mem}
M=0

@#{var2mem}
D=A

@0
M=D+1

@END#{counter}
0;JMP

(LTTRUE#{counter})

@#{var1mem}
M=-1

@#{var2mem}
M=0


@#{var2mem}
D=A
@0
M=D+1

(END#{counter})

PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "and"
      file = ""
      var1 = self.stack.last(2)[0].to_i
      var2 = self.stack.last(2)[1].to_i
      var1mem = 256 + (self.sp - 2)
      var2mem = 256 + (self.sp - 1)
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
file = <<PARAGRAPH
@#{var2mem}
D=M

@#{var1mem}
M=M&D

@#{var2mem}
M=0

@#{var2mem}
D=A
@0
M=D+1
PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "or"
      file = ""
      var1 = self.stack.last(2)[0].to_i
      var2 = self.stack.last(2)[1].to_i
      var1mem = 256 + (self.sp - 2)
      var2mem = 256 + (self.sp - 1)
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
file = <<PARAGRAPH
@#{var2mem}
D=M

@#{var1mem}
M=D|M

@#{var2mem}
M=0

@#{var2mem}
D=A
@0
M=D+1
PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    when "not"
      file = ""
      var1 = self.stack.last
      var1mem = 256 + (self.sp - 1)
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

file = <<PARAGRAPH
@#{var1}
D=A
@#{var1mem}
M=!M

@#{var1mem}
D=A
@0
M=D+1
PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    end

  end

=begin
 Method: writepushpop
 Args: command (C_PUSH or C_POP), segment (string), index (int)
 Function: Writes the assembly code that is the translation of the given command, where command is either C_PUSH or C_POP.
=end
  def writepushpop(output,command,segment)
    case command
    when "C_POP"
      return self.stack.last
    when "C_PUSH"
      self.stack.push(segment)
      var1 = segment
      var1mem = 256 + (self.sp - 1)
file = <<PARAGRAPH
@#{var1}
D=A
@#{var1mem}
M=D
PARAGRAPH
      File.open(output, "a") { |f| f.write file }
    end
  end


end

