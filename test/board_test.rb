require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'

class BoardTest < Minitest::Test
  attr_reader :board, :submarine, :cruiser

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @board = Board.new
  end

  def test_it_exists
    assert_instance_of Board, board
  end

  def test_it_can_create_board_full_of_cells
    ranges = "A1".."D4"
    expected = ranges.select do |coord|
      coord if coord < "#{coord[0]}5" && coord > "#{coord[0]}0"
    end
    assert_equal expected, board.cells.keys
    board.cells.values.each do |cell|
      assert_instance_of Cell, cell
    end
  end

  def test_it_can_determine_valid_coordinates
    assert board.valid_coordinate?("A1")
    assert board.valid_coordinate?("D4")

    refute board.valid_coordinate?("A5")
    refute board.valid_coordinate?("A0")
  end

  def test_it_validates_coordinate_length_matches_ship_length
    refute board.valid_placement?(cruiser, ["A1","A2"])

    refute board.valid_placement?(submarine, ["A1", "A2", "A3"])
  end

  def test_it_validates_coordinates_are_consective_when_placing_ship
    refute board.valid_placement?(cruiser, ["A1", "B2", "A3"])
    refute board.valid_placement?(submarine, ["A1", "C1"])
    refute board.valid_placement?(cruiser, ["A3", "A2", "A1"])
    refute board.valid_placement?(submarine, ["C1", "B1"])
  end

  def test_it_validates_coordinates_are_not_diagonal
    refute board.valid_placement?(cruiser, ["A1", "B2", "C3"])
    refute board.valid_placement?(submarine, ["C2", "D3"])
  end

  def test_it_validates_coornates_are_good
    assert board.valid_placement?(cruiser, ["B1", "C1", "D1"])
    assert board.valid_placement?(submarine, ["A1", "A2"])
  end

  def test_it_can_place_a_ship_on_valid_coordinates
    board.place(cruiser, ["B1", "C1", "D1"])

    assert_instance_of Ship, board.cells["B1"].ship
    assert_instance_of Ship, board.cells["C1"].ship
    assert_instance_of Ship, board.cells["D1"].ship

    assert_equal board.cells["D1"].ship, board.cells["C1"].ship
    assert_equal board.cells["B1"].ship, board.cells["D1"].ship
    assert_nil board.cells["A1"].ship
  end

  def test_it_can_not_place_ship_on_top_of_ship
    board.place(cruiser, ["B1", "C1", "D1"])
    refute board.valid_placement?(submarine, ["D1", "D2"])
    assert board.valid_placement?(submarine, ["A1", "A2"])
  end

  def test_it_can_render_correctly
    board.place(cruiser, ["B1", "C1", "D1"])
    expected = " 1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
    actual = board.render
    assert_equal expected, actual
  end

  def test_it_can_render_correctly_with_ships_shown
    board.place(cruiser, ["A1", "A2", "A3"])
    expected = " 1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n"
    actual = board.render(true)
    assert_equal expected, actual
  end

  def test_it_can_render_correctly_with_missed_shots
    board.place(cruiser, ["B1", "C1", "D1"])
    board.cells['B3'].fire_upon
    expected = " 1 2 3 4 \nA . . . . \nB . . M . \nC . . . . \nD . . . . \n"
    actual = board.render
    assert_equal expected, actual
  end

  def test_it_can_render_correctly_with_hit_shots
    board.place(cruiser, ["B1", "C1", "D1"])
    board.cells['B1'].fire_upon
    expected = " 1 2 3 4 \nA . . . . \nB H . . . \nC . . . . \nD . . . . \n"
    actual = board.render
    assert_equal expected, actual
  end

  def test_it_can_render_correctly_with_a_sunken_ship
    board.place(cruiser, ["B1", "C1", "D1"])
    board.cells['B1'].fire_upon
    board.cells['C1'].fire_upon
    board.cells['D1'].fire_upon
    expected = " 1 2 3 4 \nA . . . . \nB X . . . \nC X . . . \nD X . . . \n"
    actual = board.render
    assert_equal expected, actual
  end
end
