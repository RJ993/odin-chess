require_relative 'board_elements/squares'

class Board
  attr_reader :alphabet_designation, :board

  def initialize
    @board = board_creator
  end

  def board_creator
    board_array = []
    number = 9
    4.times do
    number -= 1
    alpha_number = 0
      4.times do
        alpha_number += 1
        alpha = number_to_alpha(alpha_number)
        board_array.push(Square.new("#{alpha.to_s + number.to_s}", 'white'))
        alpha_number += 1
        alpha = number_to_alpha(alpha_number)
        board_array.push(Square.new("#{alpha.to_s + number.to_s}", 'red'))
      end
      number -= 1
      alpha_number = 0
      4.times do
        alpha_number += 1
        alpha = number_to_alpha(alpha_number)
        board_array.push(Square.new("#{alpha.to_s + number.to_s}", 'red'))
        alpha_number += 1
        alpha = number_to_alpha(alpha_number)
        board_array.push(Square.new("#{alpha.to_s + number.to_s}", 'white'))
      end
    end
    board_array
  end

  def number_to_alpha(number)
    return {
      'a' => 1,
      'b' => 2,
      'c' => 3,
      'd' => 4,
      'e' => 5,
      'f' => 6,
      'g' => 7,
      'h' => 8
    }.key(number)
  end

  def to_s
  board_string = ''
  number = 8
    board.each_with_index do |square, index|
      if (index + 1) % 8 == 0
        board_string += "#{square.to_s}\n"
      elsif (index + 1) % 8 == 1
        board_string += "#{number} #{square.to_s}"
        number -= 1
      elsif (index + 1) % 8 != 0
        board_string += "#{square.to_s}"
      end
    end
  board_string += '  a b c d e f g h'
  board_string
  end

  def reverse_board
  board_string = ''
  number = 1
    board.reverse.each_with_index do |square, index|
      if (index + 1) % 8 == 0
        board_string += "#{square.to_s}\n"
      elsif (index + 1) % 8 == 1
        board_string += "#{number} #{square.to_s}"
        number += 1
      elsif (index + 1) % 8 != 0
        board_string += "#{square.to_s}"
      end
    end
  board_string += '  h g f e d c b a'
  board_string
  end
end