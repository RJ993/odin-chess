require_relative 'board_elements/pieces/king'
require_relative 'board_elements/squares'

class Player
  attr_accessor :pieces, :color

  def initialize
    @name = "Demo Dummy"
    @color = 'black'
    @pieces = [King.new(self)]
  end

  def move(input, board)
    @pieces[0].king_move(input, board)
  end
end