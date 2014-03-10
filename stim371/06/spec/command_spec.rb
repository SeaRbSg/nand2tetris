require_relative '../n2t_command.rb'

describe Assembler::Parser::Command do
  describe '#command_type' do
    it 'should return the correct type' do
      commands = {
        '@200' => 'A_COMMAND',
        '@LOOP' => 'A_COMMAND',
        'A=M' => 'C_COMMAND',
        'D=M;JMP' => 'C_COMMAND',
        '0;JMP' => 'C_COMMAND',
        '(LOOP)' => 'L_COMMAND'
      }
      commands.each do |command,type|
        ct = Assembler::Parser::Command.new(command).command_type
        ct.should eq type
      end
    end

    it 'should ignore spaces and comments' do
        {
          '// testing comment' => nil,
          '// A=M' => nil,
          '' => nil
        }.each do |command,type|
        ct = Assembler::Parser::Command.new(command).command_type
        ct.should eq type
      end
    end
  end

  context 'fields' do
    #[dest, comp, jump]
    def commands
      @commands ||= {
        'A=M' => {dest: 'A', comp: 'M', jump: nil},
        'MD=A' => {dest: 'MD', comp: 'A', jump: nil},
        'D=M;JMP' => {dest: 'D', comp: 'M', jump: 'JMP'},
        '0;JMP' => {dest: nil, comp: '0', jump: 'JMP'}
      }
    end

    def test_matching_command_for_field(commands, field_name)
      commands.each do |command, fields|
        field = Assembler::Parser::Command.new(command).public_send(field_name)
        field.should eq fields[field_name]
      end
    end

    describe '#symbol' do
      it 'should return the correct mnemonic' do
        label_cmds = {
          '@LOOP' => {symbol: 'LOOP'},
          '(END)' => {symbol: 'END'}
        }
        test_matching_command_for_field(label_cmds, :symbol)
      end
    end

    describe '#dest' do
      it 'should return the correct mnemonic' do
        test_matching_command_for_field(commands, :dest)
      end
    end

    describe '#comp' do
      it 'should return the correct mnemonic' do
        test_matching_command_for_field(commands, :comp)
      end
    end

    describe '#jump' do
      it 'should return the correct mnemonic' do
        test_matching_command_for_field(commands, :jump)
      end
    end
  end
end