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
    @ship.hit if @ship && !fired_upon?
    @fire_upon = true
  end

  def render(should_show = false)
    case
    when should_show && @ship
      "S"
    when fired_upon? && empty?
      "M"
    when fired_upon? && @ship.sunk?
      "X"
    when fired_upon? && !empty?
      "H"
    else
      "."
    end

    # Unsure which is clearer
    # return "S" if should_show && @ship
    # return "M" if fired_upon? && empty?
    # return "X" if fired_upon? && @ship.sunk?
    # return "H" if fired_upon? && !empty?
    # return "." if !fired_upon?
  end
end
