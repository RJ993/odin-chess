

module Win_Conditions
  def in_checkmate?(turn_started, turn_ended)
    enemy_movements = []
    turn_started.pieces.each do |piece|
      enemy_movements += piece.move_pos
    end
    if enemy_movements == [] && turn_started.king.in_check == true
      puts "#{turn_ended.name} wins by checkmate!!!"
      turn_ended.winner = true
      return true
    end
  end

  def in_stalemate?(turn_started, turn_ended)
    enemy_movements = []
    turn_started.pieces.each do |piece|
      enemy_movements += piece.move_pos
    end
    if enemy_movements == [] && turn_started.king.in_check == false
      puts "Draw by stalemate!"
      turn_ended.draw = true
      turn_started.draw = true
      return true
    end
  end

  def resigns(opposing_player)
    opposing_player.winner = true
    puts "#{opposing_player.name} wins due to opponent's resignation!"
  end

  def offers_draw(player, opposing_player)
    player.draw = true
    puts "#{opposing_player.name}, do you want to draw? (y or n)"
    input = gets.chomp.downcase
    if input == 'y'
      opposing_player.draw = true
      puts 'Draw by agreement!'
    else
      puts "Sorry, #{player.name}, but #{opposing_player.name} does not accept."
    end
    return true
  end

  def insufficient_material(turn_started, turn_ended)
    if turn_started.pieces == [King] && turn_ended.pieces == [King]
      puts 'Draw by insufficient material'
      turn_started.draw = true
      turn_ended.draw = true
      return true
    end
  end

  def win_and_draw_checks(turn_started, turn_ended)
    sustained = false
    sustained = in_checkmate?(turn_started, turn_ended) if sustained == false
    sustained = in_stalemate?(turn_started, turn_ended) if sustained == false
    sustained = insufficient_material(turn_started, turn_ended) if sustained == false
    return sustained
  end
end