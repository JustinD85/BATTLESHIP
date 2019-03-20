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
    refute board.valid_placement?(cruiser, ["A1", "A2", "A4"])
    refute board.valid_placement?(submarine, ["A1", "C1"])
    refute board.valid_placement?(cruiser, ["A3", "A2", "A1"])
    refute board.valid_placement?(submarine, ["C1", "B1"])
  end
end
