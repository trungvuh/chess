require_relative 'piece.rb'
require 'byebug'

class Board

  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    make_starting_grid
    @king_locations = { w: [7, 4], b: [0, 4] }
  end

  def make_starting_grid
    [[0, 0], [7, 7], [0, 7], [7, 0]].each do |pos|
      self[pos] = Rook.new(pos, self) #rooks
    end
    [[0, 1], [0, 6], [7, 1], [7, 6]].each do |pos|
      self[pos] = Knight.new(pos, self) #knights
    end
    [[0, 2], [0, 5], [7, 2], [7, 5]].each do |pos|
      self[pos] = Bishop.new(pos, self) #bishops
    end
    [[0, 3], [7, 3]].each do |pos| #[7, 3]
      self[pos] = Queen.new(pos, self) #queens
    end
    [[0, 4], [7, 4]].each do |pos|
      self[pos] = King.new(pos, self) #kings
    end
    i = 0
    while i < 8
      self[[1, i]] = Pawn.new([1, i], self) #pawns
      self[[6, i]] = Pawn.new([6, i], self) #pawns
      i2 = 2
      while i2 < 6
        self[[i2, i]] = NullPiece.instance #nullpieces
        i2 += 1
      end
      i += 1
    end
    [0, 1, 6, 7].each do |row|
      if row < 3
        @grid[row].each { |piece| piece.set_black }
      else
        @grid[row].each { |piece| piece.set_white }
      end
    end
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def move_piece(start_pos, end_pos)
    raise "Error: no piece located at #{start_pos}." if self[start_pos].nil?
    raise "Error: invalid destination for piece." unless valid_pos?(end_pos)
    piece = self[start_pos]
    piece.moved_before = true if piece.is_a?(Pawn)
    self[start_pos] = nil
    self[end_pos] = piece
    self[end_pos].set_position(end_pos)
    @king_locations[piece.color] = end_pos if piece.is_a?(King)
  end

  def valid_pos?(pos)
    return false if pos.length > 2
    return false if pos.any? { |el| el > 7 || el < 0 }
    true
  end

  def in_check?(color)
    king_pos = @king_locations[color]
    @grid.each_with_index do |row,idx|
      row.each_with_index do |piece, idx2|
        if !piece.is_a?(NullPiece) && piece.color != color
          if piece.moves([idx, idx2]).include?(king_pos)
            return true
          end
        end
      end
    end
    false
  end

  # def deep_dup
  #   new_board = []
  #   array.each do |el|
  #     if el.is_a?(Array)
  #       new_board << el.dup
  #     else
  #       new_board << el
  #     end
  #   end
  #   new_board
  # end

end
