require 'rainbow'

class Square
  attr_reader :color
  attr_accessor :designation, :piece
  def initialize(designation, color)
    @designation = designation
    @piece = nil
    @piece_display = "  "
    @color = color
  end

  def change_piece(piece)
    @piece = piece
    @piece_display = piece.to_s
    piece.location = @designation
  end

  def reset_square
    @piece = nil
    @piece_display = "  "
  end

  def to_s
    case color
      when 'white'
        Rainbow(@piece_display).bg(:white)
      when 'brown'
        Rainbow(@piece_display).bg(:chocolate)
    end
  end
end