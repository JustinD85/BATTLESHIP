require './lib/cell'
require 'pry'

class Board
  attr_reader :cells

  def initialize(range)
    @max_board_size = 0
    @cells = populate_with_cells(range)
  end

  def populate_with_cells(range)
    @max_board_size = range.last.scan(/\d+/).join.to_i
    
    valid_range = range.select do |coords|
      coord_num = coords.scan(/\d+/).join.to_i
       coord_num <= @max_board_size  && coord_num != 0
    end
    formatted_range = valid_range.map do |coord|
     coord.chr + coord.scan(/\d+/).join.to_i.to_s
    end
    board_hash = {}
    formatted_range.each { |coords| board_hash[coords] = Cell.new(coords) }
    board_hash
  end

  def valid_coordinate?(coord)
    @cells.any? { |key, value| key == coord }
  end

  def valid_horizontal_placement?(coords)
    coords.all? { |coord| coord.chr == coords.first.chr } &&
      (coords.first..coords.last).to_a == coords
  end

  def valid_vertical_placement?(coords)
    letters_in_coords = coords.map { |coord| coord.chr }
    letters_in_coords_using_range = (coords.first.chr..coords.last.chr).to_a

    coords.all? { |coord| coord[1] == coords.first[1] } &&
     letters_in_coords == letters_in_coords_using_range
  end

  def out_of_bounds_or_has_ship_already?(coords)
    coords.any? { |coord| !valid_coordinate?(coord) } ||
      coords.any? { |coord| !@cells[coord].empty?}
  end

  def valid_placement?(ship, coords)
    valid = false

    valid = true if valid_horizontal_placement?(coords)

    valid = true if valid_vertical_placement?(coords)

    valid = false if out_of_bounds_or_has_ship_already?(coords)

    valid = false if coords.length != ship.length

    valid

  end

  def place(ship, coords)
    is_valid = valid_placement?(ship, coords)

    coords.each { |coord| cells[coord].place_ship(ship) } if is_valid

    is_valid
  end

  def render(show_ship = false)
    board = " "
    letter_arr = ("A".."Z").to_a.slice(0, @max_board_size)

    @max_board_size.times do |num|
      board += "  #{num + 1}" if num < 10
      board += " #{num + 1}" if num >= 10
    end
 
    @cells.values.each_with_index do |cell, i|

      board << " \n" << letter_arr.shift if i % @max_board_size  == 0
      board << "  "
      board << cell.render(show_ship)
    end
    board << " \n"
  end

end
