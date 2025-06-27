require_relative '../../players'
require_relative '../squares'
require_relative '../../board'

class King
  attr_accessor :location, :board

  def initialize(player)
    @color = player.color
    @display = make_display
    @movement = [[1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]]
    @location = nil
  end

  def make_display
    possible_displays = {'white' => "\u2654 ", 'black' => "\u265A "}
    possible_displays[@color]
  end

  def to_s
    @display
  end

  def king_move(input, board)
    current_square = board.layout.find{|square| square.designation == @location}
    current_square_location = current_square.designation
    cords = current_square_location.split('')
    alpha_number = board.alpha_to_number(cords[0])
    new_cords = [alpha_number, cords[1].to_i]
    new_square = nil
    @movement.each do |possibility|
      new_let = board.number_to_alpha(possibility[0] + new_cords[0])
      new_num = possibility[1] + new_cords[1]
      if %w[a b c d e f g h].include?(new_let) && [1, 2, 3, 4, 5, 6, 7, 8].include?(new_num)
      new_cord = new_let + new_num.to_s
      new_square = board.layout.find {|square| square.designation == new_cord} if new_cord == input
      end
    end
    if new_square != nil && new_square.piece == nil
      new_square.change_piece(self)
      current_square.reset_square
    else
      puts 'Invalid square. Please try another square!'
    end
  end
end