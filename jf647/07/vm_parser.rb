require 'rltk'

module VM
    
    class Parser < RLTK::Parser
    
        p(:vmline) do
            c('op')                         { |o| o }
            c('COMMENT')                    { |_| Comment.new }
            c('')                           { Blank.new }
        end
    
        p(:op) do
            c('PUSH segname NUMBER')        { |_,seg,val| PushCommand.new(seg, val) }
            c('POP segname NUMBER')         { |_,seg,val| PopCommand.new(seg, val) }
            c('ADD')                        { |_| AddCommand.new }
            c('SUB')                        { |_| SubCommand.new }
            c('EQ')                         { |_| EqualsCommand.new }
            c('LT')                         { |_| LessThanCommand.new }
            c('GT')                         { |_| GreaterThanCommand.new }
            c('NEG')                        { |_| NegateCommand.new }
            c('AND')                        { |_| AndCommand.new }
            c('OR')                         { |_| OrCommand.new }
            c('NOT')                        { |_| NotCommand.new }
        end
        
        p(:segname) do
            c('SEG_ARGUMENT')               { |_| :argument }
            c('SEG_LOCAL')                  { |_| :local }
            c('SEG_STATIC')                 { |_| :static }
            c('SEG_CONSTANT')               { |_| :constant }
            c('SEG_LOCAL')                  { |_| :local }
            c('SEG_THIS')                   { |_| :this }
            c('SEG_THAT')                   { |_| :that }
            c('SEG_POINTER')                { |_| :pointer }
            c('SEG_TEMP')                   { |_| :temp }
        end
    
        finalize :explain => ENV.key?('DUMP_PARSER')
        
    end

end
