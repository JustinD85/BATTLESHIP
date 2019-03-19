require './lib/cell'
class Board
  attr_reader :cells
  def initialize
    @cells = create_cells
  end

  def create_cells
    range = "A1".."D4"
    valid_range = range.select do |coord|
      coord if coord < "#{coord[0]}5" && coord > "#{coord[0]}0"
    end

    board_hash = {}
    valid_range.each do |coord|
      board_hash[coord] = Cell.new(coord)
    end
    board_hash
  end
end
