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
    puts  'Type out the square like "a8" for instance. If you want to exit the game loop, Type q.'
    board_set_up
    play
  end

  def board_set_up
    index = 0
    number = 0
    16.times do 
      @board.layout[index].change_piece(@black_player.pieces[number])
      index += 1
      number += 1
    end
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
    puts @board
  end

  def play
    input = ''
    until input == 'q'
      puts 'Now White, where are you moving FROM?'
      input = gets.chomp.downcase
      if input != 'q'
        @white_player.make_move(input, @board, self)
        puts @board.reversed
      end
      return if input == 'q'
      puts 'Now Black, where are you moving FROM?'
      input = gets.chomp.downcase
      if input != 'q'
        @black_player.make_move(input, @board, self)
        puts @board
      end
    end
  end
end