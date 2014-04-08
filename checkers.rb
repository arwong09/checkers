class Piece
	def initialize(row, col, board)
		@king = false
		@pos = [row, col]
		@board = board
    #@color = color
	end
  
  def to_s
    return "\u25CB"
  end
  
  def perform_slide(target)
    @pos = target
  end
  
  def perform_jump(target)
    @pos = target
    
  end
  
  def promote?
    
  end
end

class WhiteSquare
  def to_s
    return "\u25A0"
  end
end

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8) { |row| Array.new(8) { |col| } }
  end
  
  def place_pieces
    8.times do |row|
      8.times do |col|
        if (row + col).even?
          @grid[row][col] = WhiteSquare.new 
        else
          @grid[row][col] = Piece.new(row, col, self) unless row == 3 || row == 4
        end
      end
    end
  end
  
  def print_board
    8.times do |row|
      row_visual = ""
      
      8.times do |col|
        row_visual << @grid[row][col].to_s << " "
        row_visual << " " if @grid[row][col].nil?
      end
      
      puts row_visual
    end
  end
end

checkers = Board.new
checkers.place_pieces
checkers.print_board