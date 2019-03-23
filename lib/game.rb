require './lib/ship'
require './lib/cell'
require './lib/board'

class Game

  def initialize
    @game_over = false
    @computer_board = Board.new
    @player_board = Board.new
  end

  def coordinate_randomizer(ship)
    cells = @computer_board.cells.keys
    new_coords = []
    ship.length.times do |x|
      new_coords << cells.shuffle.shift
    end
    new_coords
  end

  def computer_placement
    [Ship.new("Cruiser", 2), Ship.new("Submarine", 3)].each do |ship| 
      until @computer_board.place(ship, coordinate_randomizer(ship))
      end
    end
  end

  def convert_input_to_coords()
    valid_coord = false

    until valid_coord
      coords = gets.chomp.split
      
      if (coords.all? { |coord| coord.split("").length == 2 })
        return coords.map { |coord| coord.upcase}
      else
        print "Please enter valid coordinates! \n"
      end
    end

  end

  def player_placement
    p "I have laid out my ships on the grid"
    p "You now need to lay out your ships"
    p "The Cruiser is two units long and the Submarine is three units long."
    print @player_board.render

    p "Enter the squares for the Cruiser (3 spaces):"
    until @player_board.place(Ship.new("Cruiser", 3),convert_input_to_coords )
      p "Those are invalid coordinates. Please try again:"
      p "Enter the squares for the Cruiser (3 spaces):"
    end
    print @player_board.render(true)

    p "Enter the squares for the Submarine (2 spaces):"
    until @player_board.place(Ship.new("Submarine",2), convert_input_to_coords)
      p "Those are invalid coordinates. Please try again:"
    end
    print @player_board.render(true)
  end

  def attempt_fire_on_computer_ship
    is_valid_coordinate = false
    coord = ''
    until is_valid_coordinate
      coord = gets.chomp.upcase!
      is_valid_coordinate = @computer_board.valid_coordinate?(coord)
      print "Please enter valid coordinates"
    end
    @computer_board.cells[coord].fire_upon
  end
  def play_game
    until @game_over
      system("clear")
      print "#{'=' * 10 } COMPUTER BOARD #{'=' * 10} \n"
      print @computer_board.render

      print "#{'=' * 10 } PLAYER BOARD #{'=' * 10} \n"
      print @player_board.render(true)

      print "Enter the coordinate for your shot:"

      attempt_fire_on_computer_ship
    end
  end

  def start
    system("clear")
    p "Welcome to BattleShip"
      p "Enter p to play. Enter q to quit."
      case gets.chomp
      when "q"
        @game_over = true
      when "p"
        computer_placement
        player_placement
        play_game
      end
  end
end
