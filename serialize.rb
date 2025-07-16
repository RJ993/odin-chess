require 'yaml'

module Serialize
    def load_game
    data = YAML.safe_load(File.read('./only_save_file/current_game.yml'), permitted_classes: [Symbol, Player, Board, 
    King, Queen, Rook, Pawn, Knight, Bishop, Square], aliases: true)
    @white_player = data[:white_player]
    @black_player = data[:black_player]
    @board = data[:board]
    end

  def to_yaml
    File.open('only_save_file/current_game.yml', 'w') do |save_file|
      YAML.dump({
                  white_player: @white_player,
                  black_player: @black_player,
                  board: @board
                }, save_file)
    end
    puts 'The game is saved.'
  end
end