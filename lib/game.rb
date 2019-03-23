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
    coords = gets.chomp.split
    coords.each { |coord| coord.upcase! }
    coords
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

  def start
    system("clear")
    p "Welcome to BattleShip"
    until @game_over
      p "Enter p to play. Enter q to quit."
      
      case gets.chomp
      when "q"
        @game_over = true
      when "p"
        p "You are playing the game!"
        computer_placement
        player_placement
      end
    end

  end
end
