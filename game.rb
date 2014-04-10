require_relative 'piece'
require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @turn = :black
  end
  
  def run
    until game_over?
      puts @board.render
      
      begin
        get_input
      rescue => e
        puts e.message
        retry
      end
      
      change_turns
    end
    
    puts @board.render    
    winner = (@turn == :black) ? "Red" : "Black"
    puts "#{winner} wins!"
  end
  
  def get_input
    puts "#{@turn.capitalize}'s turn.  Move a piece: ex. 4,4 5,5"
    
    #find move sequence
    move_sequence = gets.chomp.split(' ')
    move_sequence = move_sequence.map do |coords|
      coords.split(',').map{ |n| Integer(n) }
    end
    
    @board.move_piece(@turn, move_sequence)
  end
  
  def change_turns
    @turn = (@turn == :black) ? :red : :black
  end
  
  def game_over?
    #@board.all_pieces.none? { |piece| piece.color == :black } || @board.all_pieces.none? { |piece| piece.color == :red }
    [:black, :red].any? do |color|
      @board.all_pieces.none? { |piece| piece.color == color }
    end
  end
end

checkers = Game.new
checkers.run