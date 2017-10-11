require 'byebug'



module SteppingPiece

  def moves(start_position, move_types = @move_type)
    potential_moves = []
    if move_types.include?(:single)
      x_shift = (-1..1).to_a
      y_shift = (-1..1).to_a
      x_shift.each do |x|
        y_shift.each do |y|
          unless x == 0 && y == 0
            potential_moves << [start_position[0] + x, start_position[1] + y]
          end
        end
      end
    elsif move_types.include?(:hop)
      knight_moves = [
      [-2, -1],
      [-2,  1],
      [-1, -2],
      [-1,  2],
      [ 1, -2],
      [ 1,  2],
      [ 2, -1],
      [ 2,  1]
      ]
      knight_moves.each do |x|
        potential_moves << [start_position[0] + x[0], start_position[1] + x[1]]
      end
    end
    potential_moves.select! { |pos| pos.all? { |coord| coord >= 0 && coord < 8 } }
    potential_moves.reject { |pos| @board[pos].color == self.color }
  end

  private

  def move_diffs
  end

end

module SlidingPiece

  COLORS = [:b, :w]
  HORIZONTAL_SHIFTS = [[1, 0], [0, 1], [-1,0], [0, -1]]
  DIAGONAL_SHIFTS = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

  def moves(start_position, move_types = @move_type)
    potential_moves = []
    if move_types.include?(:horizontal)
      potential_moves += horizontal_dirs(start_position)
    end
    if move_types.include?(:diagonal)
      potential_moves += diagonal_dirs(start_position)
    end
    potential_moves
  end

  private

  def mov_dirs

  end

  def horizontal_dirs(start_pos)
    horizontal_moves = []
    HORIZONTAL_SHIFTS.each do |shift|
      horizontal_moves += grow_unblocked_moves_in_direction(start_pos, shift)
    end
    horizontal_moves
  end

  def diagonal_dirs(start_pos)
    diagonal_moves = []
    DIAGONAL_SHIFTS.each do |shift|
      diagonal_moves += grow_unblocked_moves_in_direction(start_pos, shift)
    end
    diagonal_moves
  end

  def grow_unblocked_moves_in_direction(start_pos, shift)
    valid_positions = []
    new_pos = [start_pos[0] + shift[0], start_pos[1] + shift[1]]
    if valid_move?(new_pos)
      valid_positions << new_pos
      if @board[new_pos].color == COLORS.reject { |el| el == self.color}[0]
        return valid_positions
      else
        valid_positions += grow_unblocked_moves_in_direction(new_pos, shift)
      end
    else
      return valid_positions
    end
  end

  def valid_move?(pos)
    return false if pos.any? { |coord| coord < 0 || coord > 7 }
    return false if @board[pos].color == self.color
    true
  end


end
