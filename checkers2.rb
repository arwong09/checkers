require_relative 'board'

checkers = Board.new

10.times do
  puts checkers.render

  puts "move a piece, from_pos to_pos"
  from_pos, to_pos = gets.chomp.split(' ')
  checkers.move_piece(:black, from_pos.split(',').map{|n| Integer(n) }, to_pos.split(',').map{|n| Integer(n) })
  puts checkers.render
end