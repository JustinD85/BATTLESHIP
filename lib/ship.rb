class Ship
  attr_reader :name, :length, :health

  def initialize(name, health)
    @name = name
    @health = health
    @length = health
  end

  def sunk?
    @health < 1
  end

  def hit
    @health -= 1
  end
end
