# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::Player do
  subject(:player) { described_class.new(name) }
  let(:name) { 'bob' }

  describe '.new' do
    it 'initialize the player with the expected attributes' do
      aggregate_failures do
        expect(player.name).to eq name
        expect(player.known_lock_number).to eq 0
      end
    end
  end

  describe '#increase_known_lock_number' do
    let(:method_call) { player.increase_known_lock_number }
    it 'increases known_lock_number' do
      expect { method_call }.to change(player, :known_lock_number).by(1)
    end
  end
end
