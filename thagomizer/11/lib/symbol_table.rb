class SymbolTable
  CLASS_KINDS      = [:field, :static]
  SUBROUTINE_KINDS = [:arg, :var]

  def initialize()
    @class_vars      = {}
    @subroutine_vars = {}
    @counts          = Hash.new(0)
  end

  def start_subroutine
    @subroutine_vars = {}
    @counts[:var] = 0
    @counts[:arg] = 0
  end

  def define(name, type, kind)
    e = Entry.new(name, type, kind, @counts[kind])

    @counts[kind] += 1            # Increment iff the entry was created

    if CLASS_KINDS.include?(kind)
      @class_vars[name]      = e
    elsif SUBROUTINE_KINDS.include?(kind)
      @subroutine_vars[name] = e
    end
  end

  def var_count(kind)
    @counts[kind]
  end

  def kind_of(name)
    field_for_symbol(name, :kind)
  end

  def type_of(name)
    field_for_symbol(name, :type)
  end

  def index_of(name)
    field_for_symbol(name, :index)
  end

  def field_for_symbol(name, field)
    entry = self[name]
    entry.send(field) if entry
  end

  def [](name)
    @subroutine_vars[name] || @class_vars[name]
  end
end


class Entry
  VALID_KINDS = [:static, :field, :arg, :var]

  attr_accessor :name, :type, :kind, :index

  def initialize(name, type, kind, index)
    raise ArgumentError.new("Invalid kind #{kind}") unless valid_kind?(kind)

    @name = name
    @type = type
    @kind = kind
    @index = index
  end

  def valid_kind?(kind)
    VALID_KINDS.include?(kind)
  end
end
