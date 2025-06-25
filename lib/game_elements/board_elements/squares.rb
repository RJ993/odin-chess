require 'rainbow'

class Square
  attr_reader :color
  def initialize(designation, color)
    @designation = designation
    @piece = "  "
    @color = color
  end

  def change_piece(piece)
    @piece = piece
  end

  def to_s
    case color
      when 'white'
        Rainbow(@piece).bg(:white)
      when 'red'
        Rainbow(@piece).bg(:crimson)
    end
  end
end