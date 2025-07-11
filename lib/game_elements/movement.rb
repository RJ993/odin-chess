require_relative 'players'
require_relative 'board'
require_relative 'board_elements/squares'
require_relative '../game_mechanics'

module Movement
  
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
    self.restrict_movement(opposing_player) if self.class == King
    self.pawn_options(board, cords) if self.class == Pawn
  end

  def static_movement(board, new_cords)
    self.move_pos = []
    self.moves = self.generate_movement(board) if self.class == Pawn
      @moves.each do |possibility|
        new_let = board.number_to_alpha(possibility[0] + new_cords[0])
        new_num = possibility[1] + new_cords[1]
        if %w[a b c d e f g h].include?(new_let) && [1, 2, 3, 4, 5, 6, 7, 8].include?(new_num)
        new_cord = new_let + new_num.to_s
        self.move_pos.push(new_cord)
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
            blocked = true if pos.piece != nil
            self.move_pos.push(new_cord)
            end
          end
        end
      direction_multiplier = 1
      blocked = false
      end
  end

  def move(player, opposing_player, board, input)
    new_square = self.castling?(input, board) if (input == 'o-o' || input == 'o-o-o') && self.class == King
    return new_square if new_square == 'CASTLED'
    taken_piece = []
    self.moved == true if self.class == King || self.class == Rook
    current_square = board.layout.find{|square| square.designation == @location}
    current_square_index = board.layout.index{|square| square.designation == @location}
    new_square = board.layout.find{|square| square.designation == input} if self.move_pos.include?(input)
      if new_square != nil && new_square.piece == nil
        new_square.change_piece(self)
        current_square.reset_square
        pawn_methods(player, opposing_player, board, new_square, current_square_index)
        new_square = player.out_of_check?(current_square, new_square, false, taken_piece, opposing_player, board, self) if player.king.in_check == true
      elsif new_square != nil && new_square.piece.color != player.color
        pawn_methods(player, opposing_player, board, new_square, current_square_index)
        takes(player, opposing_player, current_square, new_square, taken_piece)
        new_square = player.out_of_check?(current_square, new_square, true, taken_piece, opposing_player, board, self) if player.king.in_check == true
      else
        puts 'Invalid square. Please try another square!'
      end
      new_square
  end
  
  def takes(taking_player, opposing_player, current_square, new_square, taken_piece)
    taken_piece.push(new_square.piece)
    opposing_player.pieces.delete(new_square.piece)
    new_square.change_piece(self)
    current_square.reset_square
  end

  def reset_movement(current_square, new_square, taken, taken_piece, opposing_player, moved_piece)
    if taken == true
      opposing_player.pieces.push(taken_piece[0])
      new_square.change_piece(taken_piece[0])
    else
      new_square.reset_square
    end
    current_square.change_piece(moved_piece)
    square = nil
    return square
  end

  def pawn_methods(player, opposing_player, board, new_square, current_square_index)
    return if self.class != Pawn
    self.en_passant_met?(player, opposing_player, board, new_square, current_square_index) if new_square.piece == nil
    self.promote(player, new_square) if (player.color == 'white' && input[1] == '8') || (player.color == 'black' && input[1] == '1')
    self.pawn_conditions(player)
  end
end