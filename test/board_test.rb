require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'

class BoardTest < Minitest::Test
  attr_reader :board
  def setup
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
end
