require_relative 'game_elements/players'
require_relative 'game_elements/board'
require_relative 'game_elements/win_conditions'
require_relative '../serialize'

class Game
  attr_accessor :white_player, :black_player, :board

  include Win_Conditions
  include Serialize

  def initialize
    @white_player = nil
    @black_player = nil
    @board = Board.new
    @turn = nil
    @turn_iterations = 1
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

  def init_move(player, opposing_player)
    finished_move = ''
    until !finished_move.nil? && finished_move != ''
      puts "Now #{player.name}, where are you moving FROM?"
      input = gets.chomp.downcase
      finished_move = player.make_move(input, @board, opposing_player)
    end
  end

  def play
    draw_called = false
    until @white_player.winner == true || @black_player.winner == true || (@white_player.draw == true && @black_player.draw == true)
      @turn = 'white' if draw_called == false && @turn_iterations.odd?
      draw_called = player_action(@white_player, @black_player) if @turn == 'white'
      @turn_iterations += 1
      if @white_player.winner == true || @black_player.winner == true || (@white_player.draw == true && @black_player.draw == true)
        return
      end

      @turn = 'black' if draw_called == false && @turn_iterations.even?
      draw_called = player_action(@black_player, @white_player) if @turn == 'black'
      @turn_iterations += 1
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
    maintain_board
  end

  def player_action(player, opposing_player)
    puts @board if player.color == 'white'
    puts @board.reversed if player.color == 'black'
    drawn = false
    define_legal_moves(opposing_player, player)
    return if win_and_draw_checks(player, opposing_player) == true

    player.in_check?
    puts 'What will your action be? ("i" for instructions, "s" to save AND quit, "p" to play on, "r" for resignation, and "d" to offer a draw.)'
    input = gets.chomp.downcase
    case input
    when 'r'
      resigns(opposing_player)
    when 'd'
      drawn = offers_draw(player, opposing_player)
    when 'i'
      drawn = instructions
    when 's'
      to_yaml('only_save_file/current_game.yml')
      @white_player.draw = true
      @black_player.draw = true
    else
      init_move(player, opposing_player)
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
    true
  end

  def maintain_board
    white_player.check_squares(board)
    black_player.check_squares(board)
  end
end
