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
    if @health > 0
      @health -= 1
    end
  end
end
