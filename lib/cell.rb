class Cell
  attr_reader :coordinate, :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fire_upon = false
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fire_upon
  end

  def fire_upon
    @ship.health -= 1 if @ship && !fired_upon?
    @fire_upon = true
  end

  def render(should_show = false)
    return "S" if should_show
    return "M" if fired_upon? && empty?
    return "X" if fired_upon? && @ship.sunk?
    return "H" if fired_upon? && !empty?
    return "." if !fired_upon?
  end
end
