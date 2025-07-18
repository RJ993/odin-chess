require 'rspec'
require_relative '../../lib/game_elements/players'
require_relative '../../lib/game_mechanics'

describe Player do
  subject(:game) { Game.new }
  describe '#make_move' do
    context 'when it is white\'s turn, not in check, and in scenario 1 ands plans to move to an empty square' do
      before do
        game.load_game('./spec/test_scenarios/scenario_one.yml')
        allow(game.white_player).to receive(:gets).and_return('f3')
      end

      it 'moves a piece to an empty square' do
        square = game.board.layout.find { |square| square.designation == 'd1' }
        queen = square.piece
        expect { game.white_player.make_move('d1', game.board, game.black_player) }.to change {
          queen.location
        }.to('f3')
      end
    end

    context 'when it is white\'s turn, not in check, and in scenario 1 ands plans to take' do
      before do
        game.load_game('./spec/test_scenarios/scenario_one.yml')
        allow(game.white_player).to receive(:gets).and_return('f7')
      end

      it 'deletes f7 pawn' do
        expect { game.white_player.make_move('c4', game.board, game.black_player) }.to change {
          game.black_player.pieces.length
        }.to(15)
      end
    end
  end
end
