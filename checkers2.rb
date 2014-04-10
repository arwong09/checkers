require 'debugger'
class Board
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_pieces
  end
  
  def [](pos)
    row, col = pos
    @grid[row][col]
  end
  
  def all_pieces
    @grid.flatten.compact
  end
  
  def add_piece(pos, piece)
    self[pos] = piece
  end
  
  def render
    @grid.map do |row|
      row.map do |piece|
        
       piece.nil? ? "." : piece.render
     end.join(' ')
   end
  end
  
  protected
  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece    
  end
  
  def place_pieces
    8.times do |row|
      8.times do |col|
        
        pos = [row, col]
        if row <= 2
          self[pos] = Piece.new(:red, self, [row, col]) if (row + col).even?
        elsif row >= 5
          self[pos] = Piece.new(:black, self, [row, col]) if (row + col).even?
        end
        
      end
    end
  end
end

##########################################

class Piece
  attr_reader :pos, :board
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
        
    @board.add_piece(@pos, self)
  end
  
  def perform_slide!(pos)
    
  end
  
  def perform_jump!(pos)
    
  end
  
  def maybe_promote
    back_row = (@color == :red) ? 7 : 0
    @king = true if @pos[0] == back_row
  end
  
  def render
    "\u26C2"
  end
  
  protected
 
end

##########################################

checkers = Board.new
puts checkers.render