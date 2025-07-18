require_relative 'lib/game_mechanics'
require_relative 'serialize'

input = ''
puts 'Welcome to Chess!!! (Press "n" for new game, Press "l" to load a game)'
input = gets.chomp.downcase until %w[n l].include?(input)
if input == 'n'
  game = Game.new
  puts 'Who will be white?'
  game.white_player = Player.new('white', gets.chomp)
  puts 'Who will be black?'
  game.black_player = Player.new('black', gets.chomp)
  game.introduction
elsif (input == 'l') && (File.zero?('only_save_file/current_game.yml') == false)
  game = Game.new
  game.load_game('./only_save_file/current_game.yml')
  game.play
elsif (input == 'l') && File.zero?('only_save_file/current_game.yml') == true
  puts "You haven't played a game yet. Please try opening the game again and play a new game."
end
