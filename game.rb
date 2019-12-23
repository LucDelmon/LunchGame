# frozen_string_literal: true

require_relative 'lib/lunch_game'

game_service = LunchGame::GameService.new
begin
  game_service.call
rescue LunchGame::Errors::ExitCommandReceived
  puts('goodbye and thanks for playing')
end
