require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require 'pry'

class ShipTest < Minitest::Test
  attr_reader :ship

  def setup
    @ship = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Ship, ship
  end

  def test_it_has_attributes
    assert_equal 'Cruiser', ship.name
    assert_equal 3, ship.length
    assert_equal 3, ship.health
  end

  def test_it_is_not_sunk
    refute ship.sunk?
  end

  def test_it_can_get_hit
    ship.hit
    assert_equal 2, ship.health
    refute ship.sunk?
  end

  def test_it_can_be_hit_twice
    ship.hit
    assert_equal 2, ship.health
    refute ship.sunk?

    ship.hit
    assert_equal 1, ship.health
    refute ship.sunk?
  end

  def test_it_can_be_sunk
    ship.hit
    ship.hit
    ship.hit
    assert_equal 0, ship.health
    assert ship.sunk?
  end
end
