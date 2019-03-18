class Ship
  attr_reader :name, :length
  attr_accessor :health

  def initialize(name, health)
    @name = name
    @health = health
    @length = health
  end
end
