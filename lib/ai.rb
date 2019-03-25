require './lib/player'

class AI < Player

  def initialize
    super
    @enemy = ""
    @last_coord_fired_on = ""
  end

  def acquire_enemy(enemy)
    @enemy = enemy
  end

  def fire_on_enemy_ship
    valid_range = @enemy.board.cells.keys.shuffle
    coord = valid_range.shift

    until fire_upon?(@enemy, coord)
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

  def theorize_and_place_ships(ships)
    ships.each do |ship|
      until place_ship?(ship, coordinate_randomizer(ship))
      end
    end
  end

  def survey_battlefield
    @enemy.status_of_cell(@last_coord_fired_on)
  end

  def report_sunken_vessel
    @enemy.board.cells[@last_coord_fired_on].ship.name
  end

end
