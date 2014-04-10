require_relative 'board'
require 'debugger'

class Piece
  attr_reader :color
  attr_accessor :board
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
        
    @board.add_piece(@pos, self)
  end
  
  def moves
    all_valid_moves = validate_moves(find_all_moves, find_all_jumps)
  end
  
  def find_all_moves
    row, col = @pos
    
    all_moves = move_deltas.map { |delta| [delta.first + row, delta.last + col] }
    moves_on_board = all_moves.select { |move| @board.valid_pos?(move) }
  end
  
  def find_all_jumps
    row, col = @pos
    
    all_jumps = jump_deltas.map { |delta| [delta.first + row, delta.last + col] }
    jumps_on_board = all_jumps.select { |jump| @board.valid_pos?(jump) }
  end
  
  def validate_moves(moves_on_board, jumps_on_board)
    valid_moves =  moves_on_board.select { |move| @board[move].nil? }
    
    valid_jumps = jumps_on_board.select do |jump|
      piece_between = @board[@board.pos_between(@pos, jump)]
      !piece_between.nil? && piece_between.color != @color 
    end
    
    p valid_moves + valid_jumps
    valid_moves + valid_jumps
  end
  
  def perform_slide!(to_pos)
    @board[@pos] = nil
    @board[to_pos] = self
    @pos = to_pos
  end
  
  def perform_jump!(to_pos)
    @board[@pos] = nil
    @board[to_pos] = self
    
    captured_piece = @board.pos_between(@pos, to_pos)
    @board.remove_piece!(captured_piece)
   
    @pos = to_pos
  end
  
  def move_deltas
    return [[-1, 1], [-1, -1], [1, -1], [1, 1]] if @king
    @color == :black ? [[-1, -1], [-1, 1]] : [[1, -1], [1, 1]]
  end
  
  def jump_deltas
    return [[-2, -2], [-2, 2], [2, -2], [2, 2]] if @king
    @color == :black ? [[-2, -2], [-2, 2]] : [[2, -2], [2, 2]]
  end
  
  def maybe_promote
    back_row = (@color == :red) ? 7 : 0
    @king = true if @pos[0] == back_row
  end
  
  def render
    @color == :black ? '●' : '○'
  end
end
