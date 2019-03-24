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
    valid = false
    #Rationale: If none of the horizontal || vertical rules apply, then not valid

    #rules to place horizontally: letter same, sequintial nums == ship length
    valid = true if coord.all? { |item| item[0] == coord.first[0] } &&
                     (coord.first[1]..coord.last[1]).to_a.length == ship.length

    #rules to place vertically: number same,  sequintial letters == ship.length
    valid = true if coord.all? { |item| item[1] == coord.first[1] } &&
                    (coord.first[0]..coord.last[0]).to_a.length == ship.length

    #all cells must be within the boards range and not contain ship
    valid = false if coord.any? { |item| !valid_coordinate?(item) } ||
                     coord.any? { |item| !@cells[item].empty?}

                     #check for odd middle coordinate
    if coord.length == 3
      valid = false if coord[0] > coord[1] || coord[0] == coord[1] || coord[1] == coord[2] || coord[2] < coord[1]
    end
    valid
    #sal - break this into methods
  end

  def place(ship, coord)
    is_valid = valid_placement?(ship, coord)

    if is_valid
      coord.each do |item|
        cells[item].place_ship(ship)
      end
    end
    is_valid
  end

  def render(show_ship = false)
    board = "  1 2 3 4"
    letter_arr = ['A', 'B', 'C', 'D']
    @cells.each_with_index do |(coord, cell), i|
      if i % 4  == 0
        board << " \n"
        board << letter_arr[0]
        letter_arr.shift
      end

      if (i % 4) + 1 != 0
        board << " "
      end
      board << cell.render(show_ship)
    end
    board << " \n"
  end
end
