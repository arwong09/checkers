require_relative 'piece'
require 'debugger'

class Board
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_pieces
  end
  
  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end
  
  def move_piece(color, from_pos, to_pos)
    piece = self[from_pos]
    raise "Move your own piece!" if piece.color != color
    #raise "Can't move there." unless piece.moves.include?(to_pos)
    delta = (from_pos.first - to_pos.first).abs
    
    delta == 1 ? perform_slide!(from_pos, to_pos) : perform_jump!(from_pos, to_pos)
  end
  
  def perform_slide!(from_pos, to_pos)
    piece = self[from_pos]
    
    self[from_pos] = nil
    self[to_pos] = piece
  end
  
  def perform_jump!(from_pos, to_pos)
    piece = self[from_pos]
    captured_piece = self[pos_between(from_pos, to_pos)]
    self[from_pos], captured_piece = nil
    self[to_pos] = piece
  end
  
  def pos_between(from_pos, to_pos)
    [(from_pos.first - to_pos.first).abs, (from_pos.first - to_pos.first).abs]
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