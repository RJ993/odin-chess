require_relative '../players'
require_relative '../board'
require_relative '../board_elements/squares'
require_relative '../../game_mechanics'
require_relative '../movement'


module Restrict
  def prep_move_pos(board, opposing_player)
      current_square = board.layout.find{|square| square.designation == self.location}
      current_square_location = current_square.designation
      cords = current_square_location.split('')
      alpha_number = board.alpha_to_number(cords[0])
      new_cords = [alpha_number, cords[1].to_i]
      calculate_pos(board, new_cords, cords, opposing_player)
  end

  def calculate_pos(board, new_cords, cords, opposing_player)
    static_movement(board, new_cords) if self.class == King || self.class == Pawn || self.class == Knight
    dynamic_movement(board, new_cords) if self.class == Queen || self.class == Rook || self.class == Bishop
    self.pawn_options(board, cords) if self.class == Pawn
    if self.class == King
      self.restrict_movement(opposing_player)
    end
  end

  def static_movement(board, new_cords)
    self.move_pos = []
    self.moves = self.generate_movement(board) if self.class == Pawn
      @moves.each do |possibility|
        new_let = board.number_to_alpha(possibility[0] + new_cords[0])
        new_num = possibility[1] + new_cords[1]
        if %w[a b c d e f g h].include?(new_let) && [1, 2, 3, 4, 5, 6, 7, 8].include?(new_num)
        new_cord = new_let + new_num.to_s
        pos = board.layout.find {|square| square.designation == new_cord}
        if pos.piece != nil
        self.move_pos.push(new_cord) if pos.piece.color != self.color
        else
        self.move_pos.push(new_cord)
        end
        end
      end
  end

  def dynamic_movement(board, new_cords)
      self.move_pos = []
      direction_multiplier = 1
      blocked = false
      @moves.each do |possibility|
        7.times do
          if blocked == false
            new_let = board.number_to_alpha((possibility[0]*direction_multiplier) + new_cords[0])
            new_num = (possibility[1]*direction_multiplier) + new_cords[1]
            if %w[a b c d e f g h].include?(new_let) && [1, 2, 3, 4, 5, 6, 7, 8].include?(new_num)
            new_cord = new_let + new_num.to_s
            direction_multiplier += 1
            pos = board.layout.find {|square| square.designation == new_cord}
            if pos.piece != nil
              blocked = true
              self.move_pos.push(new_cord) if pos.piece.color != self.color
            else
              self.move_pos.push(new_cord)
            end
            end
          end
        end
      direction_multiplier = 1
      blocked = false
      end
  end

  def restrict_movement(opposing_player)
    enemy_squares = []
    opposing_player.pieces.each do |piece|
      enemy_squares.push(piece.move_pos)
    end
    forbidden_squares = enemy_squares.flatten.uniq
    @blocked_squares = forbidden_squares
    move_pos.each do |possibility|
      move_pos.delete(possibility) if forbidden_squares.include?(possibility)
      forbidden_squares.include?(@location) ? @in_check = true : @in_check = false
    end
  end

  def mock_move(board, input, player, opposing_player, useless_squares)
    taken_piece = []
    current_square = board.layout.find{|square| square.designation == @location}
    current_square_index = board.layout.index{|square| square.designation == @location}
    new_square = board.layout.find{|square| square.designation == input} if self.move_pos.include?(input)
      if new_square != nil && new_square.piece == nil
        new_square.change_piece(self)
        current_square.reset_square
        en_passant_met?(player, opposing_player, board, new_square, current_square_index, taken_piece) if self.class == Pawn
        player.out_of_check?(current_square, new_square, false, taken_piece, opposing_player, board, self, useless_squares)
      elsif new_square != nil && new_square.piece.color != player.color
        takes(player, opposing_player, current_square, new_square, taken_piece)
        player.out_of_check?(current_square, new_square, true, taken_piece, opposing_player, board, self, useless_squares)
      end
  end
end