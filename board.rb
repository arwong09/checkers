require_relative 'piece'
require 'debugger'

class Board
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_pieces
    # Piece.new(:red, self, [5,5])
    # Piece.new(:black, self, [2,2])
  end
  
  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end
  
  def move_piece(color, move_sequence)
    from_pos, to_pos = move_sequence.first, move_sequence.last
    
    piece = self[from_pos]
    raise "No piece there." if self[from_pos].nil?
    raise "Move your own piece!" if piece.color != color
    raise "Can't move there." if !piece.moves.include?(to_pos)
    
    piece.perform_moves!(move_sequence)

    piece.maybe_promote
  end
  
  def remove_piece!(pos)
    self[pos].board = nil
    self[pos] = nil
  end
  
  def pos_between(from_pos, to_pos)
    [(from_pos.first + to_pos.first) / 2, (from_pos.last + to_pos.last) / 2]
  end
  
  def all_pieces
    @grid.flatten.compact
  end
  
  def add_piece(pos, piece)
    self[pos] = piece
  end
  
  def render
    rendered_board = @grid.map do |row|
      row.map do |piece|
       piece.nil? ? "." : piece.render
     end.join(' ')
    end
    
    rendered_board.each_with_index { |row,index| row.prepend(index.to_s + ' ') }
    rendered_board.unshift('  0 1 2 3 4 5 6 7 ')
  end
  
  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece    
  end
  
  def [](pos)
    row, col = pos
    @grid[row][col]
  end
  
  protected  
  # def num_between(num1, num2)
 #    bigger = (num1 < num2) ? num2 : num1
 #    bigger - 1
 #  end
  
  def place_pieces
    8.times do |row|
      8.times do |col|
        
        pos = [row, col]
        if row <= 2
          Piece.new(:red, self, [row, col]) if (row + col).even?
        elsif row >= 5
          Piece.new(:black, self, [row, col]) if (row + col).even?
        end
        
      end
    end
  end
end