# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe LunchGame::RoomInitializerService do
  subject(:service) { described_class.new(game) }
  let(:game) { build(:game) }

  describe '#call' do
    let(:service_call) { service.call }

    it 'returns an array of room starting with a departure room' do
      aggregate_failures do
        expect(service_call).to be_an(Array)
        service_call.each do |room|
          expect(room).to be_an_kind_of(LunchGame::Rooms::BaseRoom)
        end
      end
    end

    it 'puts a departure room in first position and link a final room north of it' do
      expect(service_call.first).to be_an_kind_of(LunchGame::Rooms::DepartureRoom)
      expect(service_call.first.north_room).to be_an_kind_of(LunchGame::Rooms::FinalRoom)
    end
  end
end
