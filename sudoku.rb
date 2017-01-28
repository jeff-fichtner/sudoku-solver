require_relative 'reset_screen'

def solve(board_string)
	game = string_to_hash(board_string)
	return hash_to_array(brute_force_iterative_solve(game))
end

def brute_force_iterative_solve(game)
	cursor = 0

	until cursor == 81

		if game[cursor][:fixed]
			cursor += 1
		else
			if verify?(game) && game[cursor][:value] > 0 && game[cursor][:value] <= 9
				cursor += 1
			elsif game[cursor][:value] < 9
				game[cursor][:value] += 1
			elsif game[cursor][:value] >= 9
				game[cursor][:value] = 0
				cursor = prev_guess(game, cursor)
				game[cursor][:value] += 1
			end
		end

		display_current(game)
	end

	return game
end


# brute_force_iterative_solve methods

def verify?(game_hash)
	flat_board = hash_to_flat(game_hash)
	return row_checker(flat_board) && column_checker(flat_board) && square_checker(flat_board)
end

def display_current(game)
	reset_screen
	puts pretty_board(hash_to_array(game))
	sleep(0.001)
end

def prev_guess(game_hash, cursor)
	cursor -= 1
	until !game_hash[cursor][:fixed]
		cursor -= 1
	end
	return cursor
end

def solved?(board_array)
  return valid?(board_array) && valid?(transpose_arrays(board_array)) && valid?(create_3x3(board_array))
end

def valid?(board_array)
  board_array.each { |row| return false if row.length != row.uniq.length }
  return true
end

def transpose_arrays(board_array)
  board_array.transpose
end

# coordinates for 3x3:
  # 1 4 7
  # 2 5 8
  # 3 6 9
def create_3x3(board_array)
	three_by_three = []
  board_array.each { |array| three_by_three << array.each_slice(3).to_a }

  first_array, second_array, third_array = [], [], []
  9.times do |row|
    3.times do |column|
      current_array = three_by_three[row][column]
      case column
      when 0
        first_array << current_array
      when 1
        second_array << current_array
      when 2
        third_array << current_array
      end
    end
  end
  three_by_three = []
  three_by_three << first_array.join.chars.each_slice(9).to_a
  three_by_three << second_array.join.chars.each_slice(9).to_a
  three_by_three << third_array.join.chars.each_slice(9).to_a
  final_array = []
  (0..2).each do |index|
    (0..2).each do |array|
      final_array << three_by_three[index][array]
    end
  end

  final_array
end

# -----------------------------------
# VERIFICATIONS


def row_checker(flat_board_array)
    first_row_indexes = [0,1,2,3,4,5,6,7,8]
    current_row = 0
    until current_row >= 9
        indexes = first_row_indexes.map { |index| index + current_row * 9}
        hash_of_vals = {}
        indexes.each do |index|
            if hash_of_vals[flat_board_array[index]] && flat_board_array[index] != 0
                return false
            else 
                hash_of_vals[flat_board_array[index]] = 1
            end
        end
        current_row += 1
    end
    true
end

def column_checker(flat_board_array)
    first_column_indexes = [0,9,18,27,36,45,54,63,72]
    current_column = 0
    until current_column >= 9
        indexes = first_column_indexes.map { |index| index + current_column }
        hash_of_vals = { }
        indexes.each do |index|
            if hash_of_vals[flat_board_array[index]] && flat_board_array[index] != 0
                return false
            else 
                hash_of_vals[flat_board_array[index]] = 1
            end
        end
        current_column += 1
    end
    true
end

def square_checker(flat_board_array)
    first_square_indexes = [0,1,2,9,10,11,18,19,20]
    current_square = 0
    until current_square >= 3
        indexes = first_square_indexes.map { |index| index + (current_square * 3)}
        hash_of_vals = { }
        indexes.each do |index|
            if hash_of_vals[flat_board_array[index]] && flat_board_array[index] != 0
                return false
            else 
                hash_of_vals[flat_board_array[index]] = 1
            end
        end
        current_square += 1
    end
    first_square_indexes.map! { |index| index + 27 }
    current_square = 0
    until current_square >= 3
        indexes = first_square_indexes.map { |index| index + (current_square * 3)}
        hash_of_vals = { }
        indexes.each do |index|
            if hash_of_vals[flat_board_array[index]] && flat_board_array[index] != 0
                return false
            else 
                hash_of_vals[flat_board_array[index]] = 1
            end
        end
        current_square += 1
    end
    first_square_indexes.map! { |index| index + 27 }
    current_square = 0
    until current_square >= 3
        indexes = first_square_indexes.map { |index| index + (current_square * 3)}
        hash_of_vals = { }
        indexes.each do |index|
            if hash_of_vals[flat_board_array[index]] && flat_board_array[index] != 0
                return false
            else 
                hash_of_vals[flat_board_array[index]] = 1
            end
        end
        current_square += 1
    end
    true
end

# FORMATS

# Board string => game hash
def string_to_hash(board_string)
	game = {}

	81.times do |i|
		game[i] = {}
		if board_string[i] == "-"
			game[i][:value] = 0
			game[i][:fixed] = false
		else
			game[i][:value] = board_string[i].to_i
			game[i][:fixed] = true
		end
	end

	game
end

def hash_to_array(game_hash)
	flat_array = hash_to_flat(game_hash)
	board_array = Array.new
	flat_array.each_slice(9) { |row| board_array << row }
	return board_array
end


# Game hash => board array
 def hash_to_flat(game_hash)
  flat_array = Array.new

  game_hash.values.each do |hash|
  	hash.each { |key, value| flat_array << value if key == :value }
  end

  flat_array
end

# Board array => print string
def pretty_board(board_array)
	output = "\n"

	board_array.each do |row|
		row.each do |box|
			output << "  #{box}"
		end
		output << "\n"
	end

	output << "\n"
end


# # verification methods for individual squares
# def verify_row(board_array, guess, x, y)
#   return !board_array[y].include?(guess)
# end

# def verify_column(board_array, guess, x, y)
#   columns = transpose_arrays(board_array)
#   return column[x].include?(guess)
# end

# def verify_grid(board_array, guess, x, y)
#   grids = create_3x3(board_array)
#   if y <= 2
#     if x <= 2
#       grid = 1
#     elsif x <= 5
#       grid = 4
#     else
#       grid = 7
#     end
#   elsif y <= 5
#     if x <= 2
#       grid = 2
#     elsif x <= 5
#       grid = 5
#     else
#       grid = 8
#     end
#   else
#     if x <= 2
#       grid = 3
#     elsif x <= 5
#       grid = 6
#     else
#       grid = 9
#     end
#   end

#   return !grids[grid].include?(guess)
# end
