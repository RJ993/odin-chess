

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
  
  def out_of_check?(current_square, new_square, taken, taken_piece, opposing_player, board, moved_piece)
    square = new_square
    opposing_player.prep_movement(board, self)
    prep_movement(board, opposing_player)
    if king.in_check == true
      square = king.reset_movement(current_square, new_square, taken, taken_piece, opposing_player, moved_piece)
      puts 'Invalid, please try again!'
    end
    square
  end
end