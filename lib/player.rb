 require './lib/board'

class Player
  attr_reader :board

  def initialize(board_size = "D04")
    @board =  Board.new("A01"..board_size)
    @guesses = []
    @enemy = ""
    @last_coord_fired_on = ""
  end

  def acquire_enemy(enemy)
    @enemy = enemy
  end

  def show_board(show_ship = false)
    @board.render(show_ship)
  end

  def place_ship?(ship, coords)
    @board.place(ship, coords)
  end

  def fire_upon?(coord)
    good_coord =  @enemy.board.valid_coordinate?(coord) &&
                  !@enemy.board.cells[coord].fired_upon?

    @enemy.receive_fire(coord) if good_coord
    @last_coord_fired_on = coord if good_coord
    good_coord
  end

  def receive_fire(coord)
    @board.cells[coord].fire_upon
  end

  def ship_name(coord)
    @board.cells[coord].ship.name
  end

  def survey_battlefield
    "Your shot on " +  @last_coord_fired_on + " was a " +
      @enemy.status_of_cell(@last_coord_fired_on)
  end

  def status_of_cell(coord)
    cell = @board.cells[coord]

    if !cell.empty? && cell.ship.sunk?
      "sunk"
    elsif !cell.empty?
      "hit"
    else
      "miss"
    end

  end

  def all_ships_sunk?
    @board.cells.values.all?{ |cell| cell.empty? || cell.ship.sunk? }
  end

  def already_shot_at_location?(coord)
    @board.valid_coordinate?(coord) && @board.cells[coord].fired_upon?
  end

  def report_sunken_vessel
    @enemy.board.cells[@last_coord_fired_on].ship.name
  end

end
