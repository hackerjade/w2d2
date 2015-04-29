require_relative 'piece'
require_relative 'board'
require_relative 'player'
require 'byebug'
require 'colorize'

class Game
  attr_reader :board, :player1, :player2

  def initialize(player1 = HumanPlayer.new, player2 = HumanPlayer.new)
    @player1 = player1
    @player2 = player2
    @board = Board.new
    @player1.color = :black
    @player2.color = :white
  end
end




# var = "\u2654"
# puts var.encode('utf-8')

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  board1 = game.board
  board2 = board1.deep_dup
  board1.move([0,1], [2,2])
  # p board1[[0,4]].moves
  puts board1.render

end
