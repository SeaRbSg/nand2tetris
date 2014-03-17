require_relative '../n2t_parser.rb'
require 'tempfile'

describe Assembler::Parser do
  before(:each) do
    @file = Tempfile.new('test')
    @file.write("@200\nM=A\n0;JMP\n")
    @file.close
  end

  describe '#initialize' do
    it 'should take file parameter' do
      path = @file.path
      expect { Assembler::Parser.new(path) }.to_not raise_error
    end

    it 'should load data' do
      path = @file.path

      parser = Assembler::Parser.new(path)
      parser.lines.should_not be_nil
    end
  end

  describe '#more_commands?' do
    it 'should return true if more commands' do
      parser = Assembler::Parser.new(@file.path)
      parser.more_commands?.should be_true
    end

    it 'should return false if at end of file' do
      file = Tempfile.new('test')
      file.close

      parser = Assembler::Parser.new(file.path)
      parser.more_commands?.should be_false
    end
  end

  describe '#advance' do
    it 'should read in the next line' do
      parser = Assembler::Parser.new(@file.path)
      
      parser.advance
      parser.command.should_not be_nil
    end
  end

  describe '#generate_symbol_table' do
    it 'should add entries for each symbol' do
      @file = Tempfile.new('test')
      @file.write("(LOOP)\nM=A\n0;JMP\n")
      @file.close

      parser = Assembler::Parser.new(@file.path)

      parser.symbol_table.table.should have_key('LOOP')
    end
  end
end
