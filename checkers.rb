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
    row, col = target
    
    if @board.grid[row][col].class != WhiteSquare
      raise "can't slide there!"
      return false
    end
    
    @board.grid[@pos[0]][@pos[1]] = WhiteSquare.new
    @board.grid[row][col] = self
    @pos = target
    true
  end
  
  def perform_jump(target)
    @pos = target
  end
  
  def maybe_promote
    
  end
end

class BlackSquare
  def to_s
    "\u25A0"
  end
end

class WhiteSquare
  def to_s
    "\u25A1"
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
          @grid[row][col] = BlackSquare.new 
        else
          if row == 3 || row == 4
            @grid[row][col] = WhiteSquare.new
          else 
            @grid[row][col] = Piece.new(row, col, self)
          end
        end
      end
    end
  end
  
  def print_board
    system('clear')
    puts "   0 1 2 3 4 5 6 7  "
    8.times do |row|
      row_visual = "#{row}  "
      
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
sleep(1)
checkers.grid[2][7].perform_slide([3,6])
checkers.print_board
