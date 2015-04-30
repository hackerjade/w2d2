require_relative 'keypress'

class Player
  attr_accessor :color
end

class HumanPlayer < Player
  def get_input
    show_single_key 
  end
end
