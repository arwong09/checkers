require_relative 'board'

class Piece
  attr_reader :color
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
        
    @board.add_piece(@pos, self)
  end
  
  def moves
    moves_on_board = move_deltas.select { |move| @board.valid_pos?(move) }
    jumps_on_board = + jump_deltas.select { |jump| @board.valid_pos?(jump) }
    
    valid_moves =  moves_on_board.select { |move| @board[move].nil? }
    valid_jumps = jumps_on_board.select do |jump| 
      piece_between = @board[@board.pos_between(@pos, jump)]
      return !piece_between.nil? && piece_between.color != @color 
    end
    
    p valid_moves + valid_jumps
    valid_moves + valid_jumps
  end
  
  def move_deltas
    return [[-1, 1], [-1, -1], [1, -1], [1, 1]] if @king
    @color == :black ? [[-1, 1], [-1, 1]] : [[1, -1], [1, 1]]
  end
  
  def jump_deltas
    return [[-2, -2], [-2, 2], [2, -2], [2, 2]] if @king
    @color == :black ? [[-2, -2], [-2, 2]] : [[2, -2], [2, 2]]
  end
  
  # def perform_moves!(positions)
 #    
 #  end
  
  def maybe_promote
    back_row = (@color == :red) ? 7 : 0
    @king = true if @pos[0] == back_row
  end
  
  def render
    @color == :black ? '●' : '○'
  end
end
