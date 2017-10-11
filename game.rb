require_relative 'display.rb'
require_relative 'players.rb'
require 'byebug'
require_relative 'piece.rb'

class Game

  def initialize(player1, player2)
    @board = Board.new
    @display = Display.new(@board)
    @player1 = Player.new(player1, :w)
    @player2 = Player.new(player2, :b)
    @active_player = @player1
    @check = false
  end

  def play
    loop do #until @board.checkmate?
      system("clear")
      puts "CHECK!" if @check
      move = get_move_from_player
      if @board[move[0]].moves(move[0]).include?(move[1]) #&& !move_into_check?(move[0], move[1])
        @board.move_piece(move[0], move[1])
        @board[move[0]] = NullPiece.instance
        switch_player
        if @board.in_check?(@active_player.color)
          @check = true
        else
          @check = false
        end
        #byebug
      end
    end
  end

  def switch_player
    @active_player == @player1 ? @active_player = @player2 : @active_player = @player1
  end

  def get_move_from_player
    start_pos = nil
    end_pos = nil
    loop do
      puts "#{@active_player.name}: pick piece to move"
      @display.render
      pos = @display.cursor.get_input
      if pos && @board[pos].color == @active_player.color
        #byebug
        start_pos = pos.dup
        system("clear")
        break
      end
      system("clear")
    end
    #byebug
    loop do
      puts "#{@active_player.name}: pick location to move to"
      @display.render
      pos = @display.cursor.get_input
      if pos
        #byebug
        end_pos = pos.dup
        system("clear")
        break
      end
      system("clear")
    end
    #byebug
    [start_pos, end_pos]
  end

  def move_into_check?(start, endpoint)
    #copy_board = @board.deep_dup
    copy_board.move_piece(start, endpoint)
    copy_board[start] = NullPiece.instance
    check_color = nil
    if @active_player.color == :w
      check_color = :b
    else
      check_color = :w
    end
    if @board.in_check?(check_color)
      return true
    end
    false
  end

end

game = Game.new('maliha', 'miles')
game.play
