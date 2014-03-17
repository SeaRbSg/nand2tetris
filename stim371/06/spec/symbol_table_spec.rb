require_relative '../n2t_symbol_table.rb'

describe Assembler::SymbolTable do
  before(:each) do
    @table = Assembler::SymbolTable.new
  end

  describe 'predefined symbols' do
    it 'should initialize the predefined symbols' do
      @table.table.size.should eq 23
    end
  end

  describe '#add_entry' do
    it 'should store the symbol and its address' do
      @table.add_entry('LOOP', 12)
      @table.contains?('LOOP').should be_true
    end
  end

  describe '#contains?' do
    before(:each) do
      @table.add_entry('LOOP', 5)
    end

    it 'should return true if the table contains the symbol' do
      @table.contains?('LOOP').should be_true
    end

    it 'should return false if the table does not contain the symbol' do
      @table.contains?('LINE').should be_false
    end
  end

  describe '#address_for' do
    it 'should return the correct memory address for the given symbol' do
      @table.add_entry('LOOP', 5)
      @table.address_for('LOOP').should eq 5
    end
  end
end