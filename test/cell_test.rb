require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'

class CellTest < Minitest::Test
  attr_reader :cell, :cruiser
  def setup
    @cell = Cell.new('B4')
    @cruiser = Ship.new('Cruiser', 3)
  end

  def test_it_exists
    assert_instance_of Cell, cell
  end

  def test_for_coordinate
    assert_equal 'B4', cell.coordinate
  end

  def test_it_doesnt_have_ship
    assert_nil cell.ship
  end

  def test_it_should_be_empty
    assert cell.empty?
  end

  def test_it_hold_ship
    cell.place_ship(cruiser)
    assert_equal cruiser, cell.ship
  end

  def test_it_should_not_be_empty
    cell.place_ship(cruiser)
    refute cell.empty?
  end
end
