

module Win_Conditions
  def in_checkmate?(turn_started, turn_ended)
    enemy_movements = []
    turn_started.pieces.each do |piece|
      enemy_movements += piece.move_pos
    end
    if enemy_movements == [] && turn_started.king.in_check == true
      puts "#{turn_ended.name} is the winner!!!"
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
      return true
    end
  end

  def resigns
    
  end

  def offers_draw
    
  end

  def insufficient_material(turn_started, turn_ended)
    if turn_started.pieces == [King] && turn_ended.pieces == [King]
      puts 'Draw by insufficient material'
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