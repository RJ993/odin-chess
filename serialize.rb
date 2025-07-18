require 'yaml'

module Serialize
    def load_game(file)
    data = YAML.safe_load(File.read(file), permitted_classes: [Symbol, Player, Board, 
    King, Queen, Rook, Pawn, Knight, Bishop, Square], aliases: true)
    @white_player = data[:white_player]
    @black_player = data[:black_player]
    @board = data[:board]
    @turn = data[:turn]
    @turn_iterations = data[:turn_iterations]
    end

  def to_yaml(file)
    File.open(file, 'w') do |save_file|
      YAML.dump({
                  white_player: @white_player,
                  black_player: @black_player,
                  board: @board,
                  turn: @turn,
                  turn_iterations: @turn_iterations
                }, save_file)
    end
    puts 'The game is saved.'
  end
end