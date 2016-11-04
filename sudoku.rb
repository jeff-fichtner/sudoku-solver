# Takes a board as a string in the format
# you see in the puzzle file. Returns
# something representing a board after
# your solver has tried to solve it.
# How you represent your board is up to you!
def solve(board_string)
	string_to_board(board_string)
end

# Returns a boolean indicating whether
# or not the provided board is solved.
# The input board will be in whatever
# form `solve` returns.
def solved?(board)
end






# -----------------------------------
# DISPLAY

# Takes in solved board array
# Returns string to print
def pretty_board(board)
	output = "\n"

	board.each do |row|
		row.each do |box|
			output << "  " + box
		end
		output << "\n"
	end

	output << "\n"
end

# Takes the original board string
# Converts to board array
# Returns board
def string_to_board(board_string)
	board = []
	board_string.chars.each_slice(9) { |row| board << row }
	board
end
