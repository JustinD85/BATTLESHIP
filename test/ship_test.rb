require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'

class ShipTest < Minitest::Test
  attr_reader :ship

  def setup
    @ship = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Ship, ship
  end

end
