class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @ship.hit if @ship
    @fired_upon = true
  end

  def render(should_show = false)

    if fired_upon? && empty?
      "M"
    elsif fired_upon? && @ship.sunk?
      "X"
    elsif fired_upon? && !empty?
      "H"
    elsif should_show && @ship
      "S"
    else
      "."
    end
  end
end
