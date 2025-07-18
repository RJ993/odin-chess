require 'rspec'
require_relative '../lib/game_mechanics'

describe Game do
  subject(:game) { described_class.new }
  describe '#define_legal_moves' do
    context 'when it is white\'s turn to move, not in check, and in test scenario 1' do
      before do
        game.load_game('./spec/test_scenarios/scenario_one.yml')
      end

      it 'properly restricts king movement' do
        expect(game.white_player.king.move_pos).not_to include('e2')
        game.define_legal_moves(game.black_player, game.white_player)
      end

      it 'restricts queen movement to be on the light diagonal and d2' do
        square = game.board.layout.find { |square| square.designation == 'd1' }
        queen = square.piece
        expect(queen.move_pos).to include('d2', 'e2', 'f3', 'g4', 'h5')
        game.define_legal_moves(game.black_player, game.white_player)
      end

      it 'restricts e4 pawn\'s movement as to not take straightforward' do
        square = game.board.layout.find { |square| square.designation == 'e4' }
        pawn = square.piece
        expect(pawn.move_pos).not_to include('e5')
        game.define_legal_moves(game.black_player, game.white_player)
      end

      it 'doesn\'t include the b2 square for c1 bishop' do
        square = game.board.layout.find { |square| square.designation == 'c1' }
        bishop = square.piece
        expect(bishop.move_pos).not_to include('b2')
        game.define_legal_moves(game.black_player, game.white_player)
      end
    end
    context 'when it is black\'s turn to move, in check, and in test scenario 2' do
      before do
        game.load_game('./spec/test_scenarios/scenario_two.yml')
      end

      it 'properly restricts king movement' do
        expect(game.black_player.king.move_pos).not_to include('f7')
        game.define_legal_moves(game.white_player, game.black_player)
      end

      it 'restricts queen to have no movement' do
        square = game.board.layout.find { |square| square.designation == 'd8' }
        queen = square.piece
        expect(queen.move_pos).to eql([])
        game.define_legal_moves(game.white_player, game.black_player)
      end

      it 'give g7 pawn the ability to block' do
        square = game.board.layout.find { |square| square.designation == 'g7' }
        pawn = square.piece
        expect(pawn.move_pos).to eql(['g6'])
        game.define_legal_moves(game.white_player, game.black_player)
      end
    end
  end

  describe '#player_action' do
    context 'when player wants to offer draw' do
      before do
        game.load_game('./spec/test_scenarios/scenario_one.yml')
        allow(game).to receive(:gets).and_return('d', 'y')
      end

      it 'method returns true' do
        expect(game.player_action(game.white_player, game.black_player)).to eql(true)
      end
    end
  end
end
