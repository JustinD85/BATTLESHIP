require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'

class CellTest < Minitest::Test
  attr_reader :cell,:cell_2, :cruiser
  def setup
    @cell = Cell.new('B4')
    @cell_2 = Cell.new('B3')
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

  def test_it_not_fired_upon_by_default
    cell.place_ship(cruiser)
    refute cell.fired_upon?
  end

  def test_it_can_be_fired_upon
    cell.place_ship(cruiser)
    cell.fire_upon
    assert cell.fired_upon?
  end
  
  def test_it_can_not_be_fired_upon_twice
    cell.place_ship(cruiser)
    cell.fire_upon
    cell.fire_upon
    assert 2, cruiser.health
  end

  def test_the_ship_inside_cell_lost_health_after_fired_upon
    cell.place_ship(cruiser)
    cell.fire_upon
    assert_equal 2, cell.ship.health
  end

  def test_it_should_return_decimal_by_default
    assert_equal ".", cell.render
  end

  def test_it_will_M_when_fired_upon_with_no_ship
    cell.fire_upon
    assert_equal "M", cell.render
  end

  def test_it_will_indicate_if_ship_is_being_shown
    cell_2.place_ship(cruiser)
    assert_equal "S", cell_2.render(true)
  end

  def test_it_should_render_H_if_fired_upon_and_has_ship
    cell_2.place_ship(cruiser)
    cell_2.fire_upon
    assert_equal "H", cell_2.render
  end

  def test_it_returns_X_if_ship_is_sunk
    cell_3 = Cell.new("B2")
    cell_3.place_ship(cruiser)
    cell_2.place_ship(cruiser)
    cell.place_ship(cruiser)

    cell.fire_upon
    cell_2.fire_upon
    cell_3.fire_upon

    assert_equal "X", cell.render
    assert_equal "X", cell_2.render
    assert_equal "X", cell_3.render
  end
end
