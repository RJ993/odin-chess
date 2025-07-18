require 'rspec'
require_relative '../../../lib/game_elements/players'
require_relative '../../../lib/game_mechanics'
require_relative '../../../lib/game_elements/special_movements/castling'

describe Castling do
  subject(:game) {Game.new}
  describe '#castling?' do
    context 'when it is white\'s turn to move, not in check, and in test scenario 1' do
      before do
        game.load_game('./spec/test_scenarios/scenario_one.yml')
      end

      it 'does not castle when a piece is in the way' do
        expect(game.white_player.king.castling?('o-o', game.board)).to eql(nil)
      end

      it 'does not castle when opposing piece blocks the way' do
        square_one = game.board.layout.find {|square| square.designation == 'g1'}
        square_two = game.board.layout.find {|square| square.designation == 'd4'}
        knight_one = square_one.piece
        knight_two = square_two.piece
        knight_one.move(game.white_player, game.black_player, game.board, 'f3')
        knight_two.move(game.black_player, game.white_player, game.board, 'e2')
        game.define_legal_moves(game.black_player, game.white_player)
        expect(game.white_player.king.castling?('o-o', game.board)).to eql(nil)
      end

      it 'does not castle when in check' do
        square_one = game.board.layout.find {|square| square.designation == 'g1'}
        square_two = game.board.layout.find {|square| square.designation == 'd4'}
        knight_one = square_one.piece
        knight_two = square_two.piece
        knight_one.move(game.white_player, game.black_player, game.board, 'f3')
        knight_two.move(game.black_player, game.white_player, game.board, 'f3')
        game.define_legal_moves(game.black_player, game.white_player)
        expect(game.white_player.king.castling?('o-o', game.board)).to eql(nil)
      end

      it 'does have ability to castle' do
        square_one = game.board.layout.find {|square| square.designation == 'g1'}
        knight_one = square_one.piece
        knight_one.move(game.white_player, game.black_player, game.board, 'f3')
        expect(game.white_player.king.castling?('o-o', game.board)).to eql('CASTLED')
      end
    end
  end
end