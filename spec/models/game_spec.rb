# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::Game do
  subject(:game) { described_class.new(**attrs) }
  let(:player) { build(:player) }
  let(:lock_size) { 2 }

  let(:attrs) do
    {
      player: player,
      lock_size: lock_size
    }
  end


  describe '.new' do
    it 'initialize the player with the expected attributes' do
      aggregate_failures do
        expect(game.player).to eq player
        expect(game.game_ended).to eq false
        expect(game.lock_password_size).to eq lock_size
      end
    end
  end

  describe '#end_game' do
    let(:method_call) { game.end_game }
    it 'end_game' do
      expect { method_call }.to change(game, :game_ended).from(false).to(true)
    end
  end

  describe '#player_can_access_boss?' do
    let(:method_call) { game.player_can_access_boss? }
    context 'when the player does not know enough numbers from the lock combinaison' do
      it 'returns the correct value' do
        expect(method_call).to be false
      end
    end

    context 'when the player does know enough numbers from the lock combinaison' do
      before do
        allow(player).to receive(:known_lock_number).and_return(lock_size)
      end
      it 'returns the correct value' do
        expect(method_call).to be true
      end
    end
  end
end
