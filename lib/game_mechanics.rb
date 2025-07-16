require_relative 'game_elements/players'
require_relative 'game_elements/board'
require_relative 'game_elements/win_conditions'

class Game
  attr_accessor :white_player, :black_player
  include Win_Conditions

  def initialize
    @white_player = Player.new('white')
    @black_player = Player.new('black')
    @board = Board.new
  end
  
  def introduction
    puts 'Hello, this is a more fleshed out intermediate version. Please enjoy!'
    puts 'Type out the square like "a8" for instance. If you want to exit the game loop, Type q.'
    board_set_up
    play
  end

  def board_set_up
    black_set_up
    white_set_up
  end

  def white_move(input)
    puts @board
    finished_move = ''
    until (finished_move != nil && finished_move != '' ) || %w[q r d].include?(input)
      puts 'Now White, where are you moving FROM?'
      input = gets.chomp.downcase
      finished_move = @white_player.make_move(input, @board, @black_player) if input != 'q'
    end
    input
  end

  def black_move(input)
    puts @board.reversed
    finished_move = ''
    until (finished_move != nil && finished_move != '' ) ||  %w[q r d].include?(input)
        puts 'Now Black, where are you moving FROM?'
        input = gets.chomp.downcase
        p black_player.king.move_pos
        finished_move = @black_player.make_move(input, @board, @white_player) if input != 'q'
    end
    input
  end

  def play
    input = ''
    until %w[q r d].include?(input)
      define_legal_moves(@black_player, @white_player, input)
      if win_and_draw_checks(@white_player, @black_player) == true
        input = 'q'
      end
      return if %w[q r d].include?(input)
      @white_player.in_check?
      input = white_move(input)
      define_legal_moves(@white_player, @black_player, input)
      if win_and_draw_checks(@black_player, @white_player) == true
        input = 'q'
      end
      return if %w[q r d].include?(input)
      @black_player.in_check?
      input = black_move(input)
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

  def define_legal_moves(turn_ended, turn_started, input)
     turn_ended.prep_movement(@board, turn_started)
     turn_started.prep_movement(@board, turn_ended)
     turn_started.sim_move(@board, turn_ended)
  end

end