require_relative 'board'

class Piece
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
        
    @board.add_piece(@pos, self)
  end
  
  def maybe_promote
    back_row = (@color == :red) ? 7 : 0
    @king = true if @pos[0] == back_row
  end
  
  def render
    "\u26C2"
  end
end
