require 'minitest/autorun'
require 'minitest/pride'
require './lib/player'
require './lib/ship'

class PlayerTest < MiniTest::Test
  attr_reader :player, :computer, :ship

  def setup
    @player = Player.new
    @computer = Player.new
    @player.acquire_enemy(@computer)
    @computer.acquire_enemy(@player)
    @ship = Ship.new("Cruiser", 1)
  end

  def test_it_should_exist
    assert_instance_of Player, player
  end

  def test_it_should_be_able_to_setup_its_board
    player.place_ship?(ship, ["A1"])
    assert player.board.cells.values.any? { |cell| !cell.empty?  }
  end

  def test_it_should_be_able_to_fire_upon_ship
    player.place_ship?(ship, ["A1"])
    assert computer.fire_upon?("A1")
  end

  def test_it_should_be_able_to_return_ship_name
    player.place_ship?(ship, ["A1"])
    assert "Cruiser", player.ship_name("A1")
  end

end
