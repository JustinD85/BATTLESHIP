require './lib/cell'
class Board
  attr_reader :cells

  def initialize(range = "A1".."D4")
    @cells = populate_with_cells(range)
    @max_board_size = 4
  end

  def populate_with_cells(range)
    @max_board_size = range.max_by { |coords| coords }[1].to_i

    valid_range = range.select do |coords|
       coords[1].to_i <= @max_board_size  && !coords.include?("0")
    end

    board_hash = {}
    valid_range.each { |coords| board_hash[coords] = Cell.new(coords) }
    board_hash
  end

  def valid_coordinate?(coords)
    @cells.any? { |key, value| key == coords }
  end

  def valid_horizontal_placement?(coords, ship)
    coords.all? { |coord| coord[0] == coords.first[0] } &&
      (coords.first..coords.last).to_a == coords &&
      coords.length == ship.length
  end

  def valid_vertical_placement?(coords,ship)
    letters_in_coords = coords.map { |coord| coord[0] }
    letters_in_coords_using_range = (coords.first[0]..coords.last[0]).to_a

    coords.all? { |coord| coord[1] == coords.first[1] } &&
     letters_in_coords == letters_in_coords_using_range
  end

  def out_of_bounds_or_has_ship_already?(coords)
    coords.any? { |coord| !valid_coordinate?(coord) } ||
      coords.any? { |coord| !@cells[coord].empty?}
  end
  

  def valid_placement?(ship, coords)
    valid = false

    valid = true if valid_horizontal_placement?(coords, ship)

    valid = true if valid_vertical_placement?(coords,ship)

    valid = false if out_of_bounds_or_has_ship_already?(coords)

    valid
 
  end

  def place(ship, coords)
    is_valid = valid_placement?(ship, coords)

    coords.each { |coord| cells[coord].place_ship(ship) } if is_valid
 
    is_valid
  end

  def render(show_ship = false)
    board = " "
    letter_arr = ("A".."Z").to_a.slice(0,@max_board_size)

    @max_board_size.times { |num| board += " #{num + 1}" }

    @cells.values.each_with_index do |cell, i|

      board << " \n" << letter_arr.shift if i % @max_board_size  == 0
      board << " "
      board << cell.render(show_ship)
    end
    board << " \n"
  end

end
