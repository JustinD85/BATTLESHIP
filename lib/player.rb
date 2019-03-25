require './lib/board'

class Player
  attr_reader :name, :board

  def initialize
    @board =  Board.new
    @guesses = []
  end

  def show_board(show_ship = false)
    @board.render(show_ship)
  end

  def place_ship?(ship, coords)
    @board.place(ship, coords)
  end

  def fire_upon?(player, coord)
    good_coord = !@board.cells[coord].fired_upon? &&
                 @board.valid_coordinate?(coord)

    player.receive_fire(coord) if good_coord

    good_coord
  end

  def receive_fire(coord)
    @board.cells[coord].fire_upon
  end

  def ship_name(coord)
    @board.cells[coord].ship.name
  end
end
