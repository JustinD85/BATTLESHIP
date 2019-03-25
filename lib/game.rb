require './lib/ship'
require './lib/cell'
require './lib/board'

class Game

  def initialize
    @game_over = false
    @computer_board = Board.new
    @player_board = Board.new
  end

  def render_playspace
    system("clear")
    print "#{'=' * 10 } COMPUTER BOARD #{'=' * 10} \n"
    print @computer_board.render

    print "#{'=' * 10 } PLAYER BOARD #{'=' * 10} \n"
    print @player_board.render(true)
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
    system 'clear'
    p "I'm going to lay out my ships now"
    7.times do
      print '.'
      sleep 0.5
    end
    puts 'Done!'
    sleep 1
    p "You now need to lay out your ships"
    p "Remember: The Submarine is three units long and the Cruiser is two units long."
    sleep 3
    p "Here's what your board will look like:"
    print @player_board.render

    p "Enter the squares for your Submarine (3 spaces):"
    until @player_board.place(Ship.new("Cruiser", 3),convert_input_to_coords )
      p "Those are invalid coordinates. Please try again:"
      p "Enter the squares for the Cruiser (3 spaces):"
    end

    p "Enter the squares for your Cruiser (2 spaces):"
    until @player_board.place(Ship.new("Submarine",2), convert_input_to_coords)
      p "Those are invalid coordinates. Please try again:"
    end
    render_playspace
    p "Now that we've placed our ships, lets start the game!"
    sleep 5
  end

  def feedback(board, coord)
    if !board.cells[coord].empty?
      if board.cells[coord].ship.sunk?
        :sunk
      else
        :hit
      end
    else
      :missed
    end
  end

  def attempt_fire_on_player_ship
    valid_range = @player_board.cells.keys
    valid_range.shuffle!
    coord = valid_range.shift
    until !@player_board.cells[coord].fired_upon?
     coord = valid_range.shift
    end
    puts "Now it's my turn!"
    @player_board.cells[coord].fire_upon
    sleep 2
    render_playspace
    puts "I #{feedback(@player_board, coord).to_s} your ship"
    sleep(2)
    render_playspace
  end

  def attempt_fire_on_computer_ship
    is_valid_coordinate = false
    coord = ''
    until is_valid_coordinate
      coord = gets.chomp.upcase
      is_valid_coordinate = @computer_board.valid_coordinate?(coord) && !@computer_board.cells[coord].fired_upon?
      print "Please enter valid coordinates: " if !is_valid_coordinate
    end
    @computer_board.cells[coord].fire_upon
    render_playspace
    puts "You #{feedback(@computer_board, coord).to_s} my ship"
    sleep(2)

  end

  def take_turn
    print "Enter the coordinate for your shot: "

    attempt_fire_on_computer_ship
    render_playspace
    sleep 1
    attempt_fire_on_player_ship
  end

  def check_if_game_over
    computer_won = @player_board.cells.values.all? do |cell|
      cell.empty? || cell.ship.sunk?
    end

    player_won = @computer_board.cells.values.all? do |cell|
      cell.empty? || cell.ship.sunk?
    end

    @game_over = true if player_won || computer_won

    if player_won && computer_won
      p "It's tie"
    elsif player_won
      p "Player won"
    elsif computer_won
      p "Computer won"
    end

  end

  def play_game
    until @game_over
      render_playspace

      take_turn
      check_if_game_over
    end
    print "Game Over"
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
