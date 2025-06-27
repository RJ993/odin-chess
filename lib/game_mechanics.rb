require_relative 'game_elements/players'
require_relative 'game_elements/board'
require_relative 'game_elements/board_elements/pieces/pawn'

class Game
  def initialize
    @player = Player.new
    @board = Board.new
  end
  def demonstration
    puts 'Hello, this is a demonstration of what this could become. Please enjoy!'
    puts  'Type out the square you want to move to. For instance "a8". If you want to exit the game loop, Type q.'
    board_set_up
    play
  end

  def board_set_up
    @board.layout[27].change_piece(@player.pieces[0])
    index = 8
    8.times do
      @board.layout[index].change_piece(Pawn.new)
      index += 1
    end
    index = 48
    8.times do
      @board.layout[index].change_piece(Pawn.new)
      index += 1
    end
    puts @board
  end

  def play
    input = ''
    until input == 'q'
      puts 'Now please put in your square!'
      input = gets.chomp.downcase
      if input != 'q'
        @player.move(input, @board)
        puts @board
      end
    end
  end
end