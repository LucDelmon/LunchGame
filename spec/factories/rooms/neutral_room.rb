# frozen_string_literal: true

FactoryBot.define do
  factory :neutral_room, class: 'LunchGame::Rooms::NeutralRoom' do
    game { build(:game) }

    initialize_with { new(game ) }
  end
end
