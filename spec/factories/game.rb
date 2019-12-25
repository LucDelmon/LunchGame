# frozen_string_literal: true

FactoryBot.define do
  factory :game, class: 'LunchGame::Game' do
    player { build(:player) }
    lock_size { 2 }

    initialize_with { new(player: player, lock_size: lock_size ) }
  end
end
