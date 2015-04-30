require_relative 'piece'
require_relative 'board'
require_relative 'player'
require 'io/console'
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
    @current_player = @player1
  end

  def play
    until @board.checkmate?(@player1.color) || @board.checkmate?(@player2.color)
      # display
      # puts @board.render(@current_player.color)
      # action
      action(@current_player)
      # switch
      @current_player = @current_player == @player1 ? @player2 : @player1

    end
    puts @board.render(player.color)
  end

  def action(player)

    # until pick_up && drop_off, get the input
    # begin
    begin
    start_pos, end_pos = nil, nil
    until start_pos && end_pos
    # when pick_up, store cursor if valid, else raise error
      puts @board.render(player.color)
      input = player.get_input
      case input
      when :pick_up
        start_pos = @board.cursor if is_valid?(@board.cursor)
    # when drop_off, store cursor
      when :drop_off
        end_pos = @board.cursor
      else
        # byebug
        @board.move_cursor(input)
      end
      # return
      system "clear"
      # return
    end
    @board.move(start_pos, end_pos)
    rescue RuntimeError => e
      retry
    end
    return
    # call move(pick_up, drop_off)
  end

  # def new_position(pos)
  #   [@board.cursor[0] + pos[0], @board.cursor[1] + pos[1]]
  # end

  def is_valid?(pos)
    if @board[pos].is_a?(Piece)
      if @board[pos].color == @current_player.color
        return true
      end
    end

    return false
  end

end




# var = "\u2654"
# puts var.encode('utf-8')

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  # byebug
  game.play
  # board1 = game.board
  # board2 = board1.deep_dup
  # # board1.move([0,1], [2,2])
  # board1.move([0,2], [4,6])
  # board1.move([0,4],[1,3])
  # board1.move([0,0],[6,0])
  # p board1.checkmate?(:black)
  #
  # # p board1[[0,4]].moves
  # puts board1.render

end
