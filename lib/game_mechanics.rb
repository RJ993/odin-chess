require_relative 'game_elements/players'
require_relative 'game_elements/board'
require_relative 'game_elements/board_elements/pieces/pawn'

class Game
  attr_accessor :white_player, :black_player

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
    until (finished_move != nil && finished_move != '' ) || input == 'q'
      puts 'Now White, where are you moving FROM?'
      input = gets.chomp.downcase
      finished_move = @white_player.make_move(input, @board, @black_player) if input != 'q'
    end
    input
  end

  def black_move(input)
    puts @board.reversed
    finished_move = ''
    until (finished_move != nil && finished_move != '' ) || input == 'q'
        puts 'Now Black, where are you moving FROM?'
        input = gets.chomp.downcase
        finished_move = @black_player.make_move(input, @board, @white_player) if input != 'q'
    end
    input
  end

  def play
    input = ''
    until input == 'q'
      define_legal_moves(@black_player, @white_player)
      input = white_move(input)
      return if input == 'q'
      define_legal_moves(@white_player, @black_player)
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

  def define_legal_moves(turn_ended, turn_started)
     turn_ended.prep_movement(@board, turn_started)
     turn_started.prep_movement(@board, turn_ended)
     turn_started.in_check?
  end

end