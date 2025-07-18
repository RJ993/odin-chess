require 'rspec'
require_relative '../../lib/game_elements/players'
require_relative '../../lib/game_mechanics'
require_relative '../../lib/game_elements/win_conditions'

describe Win_Conditions do
  describe '#win_and_draw_checks' do
  subject(:game) {Game.new}
    context 'when it is white\'s turn, not in check, and in scenario 1' do

      before do
        game.load_game('./spec/test_scenarios/scenario_one.yml')
      end

      it 'return false on the checks' do
        expect(game.win_and_draw_checks(game.white_player, game.black_player)).to be false
      end

      it 'returns true a couple of moves later' do
        qsquare = game.board.layout.find {|square| square.designation == 'd1'}
        queen = qsquare.piece
        queen.move(game.white_player, game.black_player, game.board, 'f3')
        game.define_legal_moves(game.white_player, game.black_player)
        queen.move(game.white_player, game.black_player, game.board, 'f7')
        game.define_legal_moves(game.white_player, game.black_player)
        expect(game.win_and_draw_checks(game.black_player, game.white_player)).to be true
      end

    end

    context 'when it is white\'s turn, not in check, and in scenario 3' do

      before do
        game.load_game('./spec/test_scenarios/scenario_three.yml')
      end

      it 'return true due to stalemate a move later' do
        qsquare = game.board.layout.find {|square| square.designation == 'e3'}
        queen = qsquare.piece
        queen.move(game.white_player, game.black_player, game.board, 'g3')
        game.define_legal_moves(game.white_player, game.black_player)
        expect(game.win_and_draw_checks(game.black_player, game.white_player)).to be true
      end

      it 'returns true due to insufficient material 2 moves later' do
        qsquare = game.board.layout.find {|square| square.designation == 'e3'}
        ksquare = game.board.layout.find {|square| square.designation == 'h1'}
        queen = qsquare.piece
        king = ksquare.piece
        queen.move(game.white_player, game.black_player, game.board, 'g1')
        game.define_legal_moves(game.white_player, game.black_player)
        king.move(game.black_player, game.white_player, game.board, 'g1')
        game.define_legal_moves(game.black_player, game.white_player)
        expect(game.win_and_draw_checks(game.white_player, game.black_player)).to be true
      end

    end
  end
end