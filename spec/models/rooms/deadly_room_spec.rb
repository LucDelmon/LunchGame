# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe LunchGame::Rooms::DeadlyRoom do
  subject(:room) { described_class.new(game) }
  let(:game) { build(:game) }

  describe '#full_options_list' do
    subject { room.full_options_list }
    let(:available_directions) { %i[forward backward] }
    before do
      allow(room).to receive(:available_directions).and_return(available_directions)
    end

    it { is_expected.to eq [:exit] }
  end
end
