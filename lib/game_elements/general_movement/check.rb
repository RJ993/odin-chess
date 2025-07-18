require_relative '../board_elements/pieces/king'

module Check
  def prep_movement(board, opposing_player)
    pieces.each do |piece|
      piece.prep_move_pos(board, opposing_player)
    end
  end

  def in_check?
    if king.in_check == true
      puts "#{@name}, you are in check!!!"
    end
  end
  
  def out_of_check?(current_square, new_square, taken, taken_piece, opposing_player, board, moved_piece, useless_squares)
    check_status = king.in_check
    opposing_player.prep_movement(board, self)
    self.king.prep_move_pos(board, opposing_player)
    if king.in_check == true
      useless_squares.push(new_square.designation)
    end
    self.king.reset_movement(current_square, new_square, taken, taken_piece, opposing_player, moved_piece)
    opposing_player.prep_movement(board, self)
    self.king.prep_move_pos(board, opposing_player)
    king.in_check = check_status
  end

  def sim_move(board, opposing_player)
    self.pieces.each do |piece|
      useless_squares = []
      piece.move_pos.each do |move|
        piece.mock_move(board, move, self, opposing_player, useless_squares)
      end
      useless_squares.each do |pos|
        piece.move_pos.delete(pos) if useless_squares.include?(pos) if piece.class != King
        if piece.class == King
        piece.fail_safe.push(pos) if useless_squares.include?(pos)
        end
      end
    end
    self.king.fail_safe.each do |pos|
      self.king.move_pos.delete(pos) if self.king.fail_safe.include?(pos)
    end
    self.king.fail_safe = []
  end
end