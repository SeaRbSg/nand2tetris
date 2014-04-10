class Token
  attr_accessor :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end
end
