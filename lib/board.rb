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

  def valid_coordinate?(coord)
    @cells.any? { |key, value| key == coord }
  end

  def valid_placement?(ship, coord)
    #test comment for figuring out github branches
    valid = false
    #Rationale: If none of the horizontal || vertical rules apply, then not valid

    #rules to place horizontally: letter same, sequintial nums == ship length
    valid = true if coord.all? { |item| item[0] == coord.first[0] } &&
                     (coord.first[1]..coord.last[1]).to_a.length == ship.length

    #rules to place vertically: number same,  sequintial letters == ship.length
    valid = true if coord.all? { |item| item[1] == coord.first[1] } &&
                    (coord.first[0]..coord.last[0]).to_a.length == ship.length

    #all cells must be within the boards range
    valid = false if  coord.any? { |item| !valid_coordinate?(item) }

    valid
  end

end
