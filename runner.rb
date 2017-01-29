require_relative 'sudoku'

# The sudoku puzzles can be found in the sudoku_puzzles.txt file.

# Currently, Line 10 defines the variable board_string to equal 
# the first puzzle (i.e., the first line in the .txt file).
# Edit the number after the filename, 0-14, to change the puzzle 
# it solves.

board_string = File.readlines('sudoku_puzzles.txt')[0].chomp

solved_board = solve(board_string)
if solved?(solved_board)
  puts "The board was solved!"
  puts pretty_board(solved_board)
else
  puts "The board wasn't solved :("
end
