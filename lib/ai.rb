require './lib/player'

class AI < Player

  def initialize(board_size = "S19")
    super(board_size)
  end


  def fire_on_enemy_ship
    valid_range = @enemy.board.cells.keys.shuffle
    coord = valid_range.shift

    until fire_upon?(coord)
      coord = valid_range.shift
    end
    @last_coord_fired_on = coord

  end

  def coordinate_randomizer(ship)
    cells = @board.cells.keys
    new_coords = []
    ship.length.times do |x|
      new_coords << cells.shuffle.shift
    end
    new_coords
  end

  def theorize_and_place_ship(ship)
    place_ship?(ship, coordinate_randomizer(ship))
  end

  def survey_battlefield
    "My shot on " + @last_coord_fired_on + " was a " +
      @enemy.status_of_cell(@last_coord_fired_on)
  end

end
