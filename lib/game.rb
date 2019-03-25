require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/player'
require './lib/ai'

class Game

  def initialize
    @game_over = false
    @player = Player.new
    @computer = AI.new
  end

  def render_playspace
    system("clear")
    print "#{'=' * 10 } COMPUTER BOARD #{'=' * 10} \n"
    print @computer.show_board

    print "#{'=' * 10 } PLAYER BOARD #{'=' * 10} \n"
    print @player.show_board(true)
  end


  def computer_placement
    ships = [Ship.new("Cruiser", 2), Ship.new("Submarine", 3)]
    @computer.theorize_and_place_ships(ships)
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
    print @player.show_board

    p "Enter the squares for your Submarine (3 spaces):"
    until @player.place_ship?(Ship.new("Cruiser", 3), convert_input_to_coords )
      p "Those are invalid coordinates. Please try again:"
      p "Enter the squares for the Cruiser (3 spaces):"
    end

    p "Enter the squares for your Cruiser (2 spaces):"
    until @player.place_ship?(Ship.new("Submarine",2), convert_input_to_coords)
      p "Those are invalid coordinates. Please try again:"
    end
    render_playspace
    p "Now that we've placed our ships, lets start the game!"
    sleep 5
  end

  def attempt_fire_on_player_ship

    puts "Now it's my turn!"
    @computer.fire_on_enemy_ship
    sleep 2

    render_playspace
    case @computer.survey_battlefield
    when :hit
      p "I hit one of your ships!"
    when :missed
      p "I Missed!"
    when :sunk
      p "I Sunk your #{@computer.report_sunken_vessel}!"
    end
    sleep(2)
    render_playspace
  end

  def attempt_fire_on_computer_ship
    coord = gets.chomp.upcase

    until @player.fire_upon?(@computer, coord)
      coord = gets.chomp.upcase
      print "Please enter valid coordinates: "
    end
    render_playspace

    case @computer.status_of_cell(coord)
    when :hit
      p "You Hit one of my ships!"
    when :missed
      p "You Missed!"
    when :sunk
      p "You Sunk my #{@computer.ship_name(coord)}!"
    end
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
    computer_won = @player.all_ships_sunk?
    player_won = @computer.all_ships_sunk?

    @game_over = (player_won || computer_won)

    if player_won
      p "Player won"
    elsif computer_won
      p "Computer won"
    end

  end

  def play_game
    computer_placement
    player_placement
    @computer.acquire_enemy(@player)
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
        play_game
      end
  end
end
