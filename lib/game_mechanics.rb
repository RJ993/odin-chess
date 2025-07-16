require_relative 'game_elements/players'
require_relative 'game_elements/board'
require_relative 'game_elements/win_conditions'

class Game
  attr_accessor :white_player, :black_player
  include Win_Conditions

  def initialize
    puts 'Who will be white?'
    @white_player = Player.new('white', gets.chomp)
    puts 'Who will be black?'
    @black_player = Player.new('black', gets.chomp)
    @board = Board.new
  end
  
  def introduction
    puts 'Welcome players! Good luck!'
    board_set_up
    play
  end

  def board_set_up
    black_set_up
    white_set_up
  end

  def init_move(player)
    finished_move = ''
    until (finished_move != nil && finished_move != '' )
      puts "Now #{player.name}, where are you moving FROM?"
      input = gets.chomp.downcase
      finished_move = player.make_move(input, @board, @black_player)
    end
  end

  def play
    until @white_player.winner == true || @black_player.winner == true || (@white_player.draw == true && @black_player.draw == true)
      draw_called = false
      draw_called = player_action(@white_player, @black_player)
      return if @white_player.winner == true || @black_player.winner == true || (@white_player.draw == true && @black_player.draw == true)
      player_action(@black_player, @white_player) if draw_called == false
    end
  end

  def white_set_up
    index = 48
    number = 8
    8.times do
      @board.layout[index].change_piece(@white_player.pieces[number])
      index += 1
      number += 1
    end
    index = 56
    number = 0
    8.times do
      @board.layout[index].change_piece(@white_player.pieces[number])
      index += 1
      number += 1
    end
  end

  def black_set_up
    index = 0
    number = 0
    16.times do 
      @board.layout[index].change_piece(@black_player.pieces[number])
      index += 1
      number += 1
    end
  end

  def define_legal_moves(turn_ended, turn_started)
     turn_ended.prep_movement(@board, turn_started)
     turn_started.prep_movement(@board, turn_ended)
     turn_started.sim_move(@board, turn_ended)
  end

  def player_action(player, opposing_player)
    puts @board if player.color == 'white'
    puts @board.reversed if player.color == 'black'
    drawn = false
    define_legal_moves(opposing_player, player)
    opposing_player.winner = true if win_and_draw_checks(player, opposing_player) == true
    return if opposing_player.winner == true || player.winner == true
    puts 'What will your action be? ("i" for instructions, "p" to play on, "r" for resignation, and "d" to offer a draw.)'
    input = gets.chomp.downcase
    case input
    when 'r'
      resigns(opposing_player)
    when 'd'
      drawn = offers_draw(player, opposing_player)
    when 'i'
      drawn = instructions
    else
      init_move(player)
    end
    drawn
  end

  def instructions
    puts 'Pawns can move one space, or two spaces if it is their first move. They take diagonally.'
    puts 'Special Move: En Passant --> If an opposing Pawn moves to the 5th rank (white), or 4th rank (black), they can take
the adjacent pawn and move diagonally.'
    puts 'Knights move in an "L" shape.'
    puts 'Kings can move in any direction at a fixed distance of one square. Look out for your king\'s safety as if your king is in checkmate,
you lose.'
    puts 'Special Move: Castling --> If your king and rook has not moved, has no pieces between them, and is not in check, You can castle by
selecting the square your king is on and input either "o-o" or "o-o-o" depending on which side you want to castle.'
    puts 'Bishops move diagonally regardless of distance'
    puts 'Rooks move vertically or horizontally regardless of distance'
    puts 'Queens have both the movement of a Rook and a Bishop'
    puts 'When you are in check, your king is attacked but can move a piece to get out while in checkmate, you have no more legal moves'
    puts 'A stalemate is when you have no more legal moves but you are NOT attacked by any piece.'
    return true
  end

end