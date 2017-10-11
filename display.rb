require_relative 'board.rb'
require_relative 'cursor.rb'
require 'colorize'

class Display

  attr_reader :cursor

  def initialize (board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    str = "  ------------------------- \n"
    display_i = 8
    row_i = 0
    while display_i > 0
      str << "#{display_i} |"
      display_i -= 1
      8.times do |column_i|
        if [row_i, column_i] == @cursor.cursor_pos
          if @board[[row_i, column_i]].nil?
            str << "_ ".colorize(:blue) + "|"
          else
            str << "#{@board[[row_i, column_i]]} ".colorize(:blue) + "|"
          end
        elsif @board[[row_i, column_i]].nil?
          str << "_ |" #@board[row_idx, column_idx]
        else
          str << "#{@board[[row_i, column_i]]} |" #@board[row_idx, column_idx]
        end
      end
      str << "\n"
      row_i += 1
    end
    str << "  ------------------------- \n"
    str << '   A  B  C  D  E  F  G  H '
    puts str
  end



end

# x = Board.new
# d = Display.new(x)
# d.looper
