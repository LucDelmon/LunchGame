# frozen_string_literal: true

FactoryBot.define do
  factory :player, class: 'LunchGame::Player' do

    initialize_with { new(name) }

    name { 'bob' }
  end
end
