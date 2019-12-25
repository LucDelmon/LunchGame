# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::LockNumberFoundService do
  subject(:service) { described_class.new(game) }
  let(:game) { build(:game, lock_size: lock_size) }

  describe '#call' do
    let(:method_call) { service.call }
    let(:known_lock_number) { 1 }
    let(:lock_size) { 2 }

    before do
      allow(game.player).to receive(:increase_known_lock_number).and_return(known_lock_number)
    end

    it 'increases the player known_lock_number' do
      method_call
      expect(game.player).to have_received(:increase_known_lock_number)
    end

    it 'output a message about the remaining number to find' do
      expect { method_call }.to output(
        "still #{lock_size - known_lock_number} number(s) to find\n"
      ).to_stdout
    end

    context 'when knowing enough number' do
      it 'You found all the number of the lock, time to go back to the entrance' do
        expect { method_call }.to output(
          "still #{lock_size - known_lock_number} number(s) to find\n"
        ).to_stdout
      end
    end
  end
end
