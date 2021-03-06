require_relative 'board'

class Piece
  attr_reader :color, :pos, :king
  attr_accessor :board
  
  def initialize(color, board, pos, king = false)
    @color, @board, @pos = color, board, pos
    @king = king
        
    @board.add_piece(@pos, self)
  end
  
  def moves #returns array of all valid moves
    validate_moves(find_all_moves, find_all_jumps)
  end
  
  def find_all_moves #returns all moves within the board bounds
    row, col = @pos
    
    all_moves = move_deltas.map { |delta| [delta.first + row, delta.last + col] }
    all_moves.select { |move| @board.valid_pos?(move) }
  end
  
  def find_all_jumps #returns all jumps within the board bounds
    row, col = @pos
    
    all_jumps = jump_deltas.map { |delta| [delta.first + row, delta.last + col] }
    all_jumps.select { |jump| @board.valid_pos?(jump) }
  end
  
  def validate_moves(moves_on_board, jumps_on_board) #returns valid moves and jumps on board
    valid_moves =  moves_on_board.select { |move| @board[move].nil? }
    
    valid_jumps = jumps_on_board.select do |jump|
      piece_between = @board[@board.pos_between(@pos, jump)]
      !piece_between.nil? && piece_between.color != @color 
    end
    
    valid_moves + valid_jumps
  end
  
  def perform_moves!(move_sequence)
    if move_sequence.count == 2  
      from_pos, to_pos = move_sequence
      delta = (from_pos.first - to_pos.first).abs
      delta == 1 ? perform_slide!(to_pos) : perform_jump!(to_pos)
    else
      
      if valid_move_sequence?(move_sequence.dup, @board)
        move_sequence.shift #discard from_pos position
        perform_jump!(move_sequence.shift) until move_sequence.empty?
      end
    end
  end
 
  
  def valid_move_sequence?(move_sequence, board)
    return true if move_sequence.count == 1
    curr_pos = move_sequence.shift #discard current position
    test_board = board.dup
    duped_piece = test_board[curr_pos]
    next_move = move_sequence[0]
    
    #debugger
    raise "Illegal Move Sequence!" if !duped_piece.moves.include?(next_move)
    duped_piece.perform_jump!(next_move)
    valid_move_sequence?(move_sequence, test_board)
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
    if @king
      @color == :black  ? "♚" : "♔"
    else
      @color == :black ? '●' : '○'
    end
  end
end
