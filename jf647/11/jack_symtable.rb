require 'singleton'

module Jack

    class SymTable

        include Singleton

        def initialize
            @table = { :class => Hash.new }
            @i = Hash.new
        end

        def newsub
            @table[:sub] = Hash.new
            %i(arg var).each do |kind|
                @i.delete(kind)
            end
        end

        def add(name, type, kind)
            case kind
            when :static, :field
                @table[:class][name] = { :kind => kind, :type => type, :index => nexti(kind) }
            when :arg, :var
                @table[:sub][name] = { :kind => kind, :type => type, :index => nexti(kind) }
            else
                raise "invalid symbol kind '#{kind}"
            end
        end

        %w(kind type index).each do |attr|
            define_method(attr) do |name|
                lookup(name, attr.to_sym)
            end
        end

        private

        def nexti(kind)
            if @i.key?(kind)
                @i[kind] += 1
            else
                @i[kind] = 0
            end
            return @i[kind]
        end

        def lookup(name, attr)
            %i(sub class).each do |scope|
                if @table[scope].key?(name)
                    return @table[scope][name][attr]
                end
            end
            return :none
        end

    end

end
