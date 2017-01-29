require_relative 'reset_screen'

def solve(board_string)
	game = string_to_hash(board_string)
	return hash_to_array(brute_force_iterative_solve(game))
end

# Brute force iterative solution:
# Starts cursor at zero - runs until end of board
	# if fixed:
		# increments cursor
	# if not fixed:
		# if there's a valid guess in place:
			# increments cursor
		# if value not valid and less than 9:
			# increments guess
		# if no more valid guesses
			# reset current space to 0
			# set cursor back to closest non-fixed position
			# increment guess at that position

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

# returns true/false if a board is valid, not solved
def verify?(game_hash)
	flat_board = hash_to_flat(game_hash)
	return row_checker(flat_board) && column_checker(flat_board) && square_checker(flat_board)
end

# renders the board, pauses
def display_current(game_hash)
	reset_screen
	puts pretty_board(hash_to_array(game_hash))
	sleep(0.001)
end

# recursive method to find previous unfixed guess and reset cursor
def prev_guess(game_hash, cursor)
	cursor -= 1
	return cursor unless game_hash[cursor][:fixed]
	return prev_guess(game_hash, cursor)
end

# returns true/false if entire board is solved correctly and valid
def solved?(board_array)
  return valid?(board_array) && valid?(transpose_arrays(board_array)) && valid?(create_grid(board_array))
end

# method checking all rows for uniqueness
def valid?(board_array)
  board_array.each { |row| return false if row.length != row.uniq.length }
  return true
end

# ------------------------------
# TRANSPOSITIONS

def transpose_arrays(board_array)
  return board_array.transpose
end

# coordinates for 3x3:
  # 1 4 7
  # 2 5 8
  # 3 6 9

def create_grid(board_array)
	# split into triplets
	triplets_array = []
  board_array.each { |array| triplets_array << array.each_slice(3).to_a }

  # shuffle the triplets
  shuffle_container = [[], [], []]
  9.times do |row|
    3.times do |column|
      current_array = triplets_array[row][column]
      shuffle_container[column] << current_array
    end
  end

  # flatten and re-split
  final_array = []
  shuffle_container.flatten.each_slice(9) { |array| final_array << array  }

  return final_array
end

# -----------------------------------
# VERIFICATIONS - thanks Will for the borrowed code


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
  
  return true
end

def column_checker(flat_board_array)
  first_column_indexes = [0,9,18,27,36,45,54,63,72]
  current_column = 0
  until current_column >= 9
    indexes = first_column_indexes.map { |index| index + current_column }
    hash_of_vals = {}
    indexes.each do |index|
      if hash_of_vals[flat_board_array[index]] && flat_board_array[index] != 0
        return false
      else 
        hash_of_vals[flat_board_array[index]] = 1
      end
    end
    current_column += 1
  end
  
  return true
end

def square_checker(flat_board_array)
  first_square_indexes = [0,1,2,9,10,11,18,19,20]
  current_square = 0
  until current_square >= 3
    indexes = first_square_indexes.map { |index| index + (current_square * 3)}
    hash_of_vals = {}
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
    hash_of_vals = {}
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
    hash_of_vals = {}
    indexes.each do |index|
      if hash_of_vals[flat_board_array[index]] && flat_board_array[index] != 0
        return false
      else 
        hash_of_vals[flat_board_array[index]] = 1
      end
    end
    current_square += 1
  end
  
  return true
end

# ----------------------------------
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
	board_array = []
	flat_array.each_slice(9) { |row| board_array << row }
	return board_array
end


# Game hash => board array
 def hash_to_flat(game_hash)
  flat_array = []

  game_hash.values.each do |hash|
  	hash.each { |key, value| flat_array << value if key == :value }
  end

  return flat_array
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

	return output
end
