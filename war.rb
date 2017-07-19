# Functionality to add:
# 	allow user to repeat game with current names, and keep a running count of wins and losses and 
# 	total time played

require_relative 'calculate_time'

class Card
	attr_reader :suit, :value

	def initialize(suit,value)
		@suit = suit
		@value = value 
	end

	def to_s
		case value
			when 2..9 then " #{value}#{suit}"
			when 10 then "10#{suit}"
			when 11 then " J#{suit}"
			when 12 then " Q#{suit}"
			when 13 then " K#{suit}"
			when 14 then " A#{suit}"	
		end
	end
end


class Deck
	
	include Enumerable
	
	attr_accessor :cards

	def initialize
		@cards = []
	end

	def create_cards
		(2..14).each do |value|
			@cards.push Card.new(:♠,value)
			@cards.push Card.new(:♥,value)
			@cards.push Card.new(:♦,value)
			@cards.push Card.new(:♣,value)
		end
	end

	def shuffle
		temp_deck = []
		while @cards.length > 0 do
			temp_card = @cards.sample
			temp_deck.push(temp_card)
			@cards.delete(temp_card)
		end
		@cards = temp_deck
	end

	def deal (war)
		until @cards.length = 0 do
			war.player[0].draw_stack.push @cards.shift
			war.player[1].draw_stack.push @cards.shift
		end
	end

	def each
		@cards.each {|card| yield card}
	end

end


class Player
	
	attr_accessor :name, :name_spacer, :rounds_won, :rounds_lost,
								:draw_stack, :capture_stack, :stack_for_ties, :draw_card,
								:number_of_battles_won, :most_cards, :least_cards

	def initialize(name)
		@name = name
		@name_spacer = 10 - name.length
		@rounds_won = []
		@rounds_lost = []
	end

	def clean_slate_for_new_round
		@draw_stack = Deck.new
		@capture_stack = Deck.new
		@stack_for_ties = Deck.new
		@number_of_battles_won = 0
		@most_cards = 26
		@least_cards = 26
	end
end

class Round
	
	attr_accessor :number_of_battles, :number_of_cards_flipped, :number_of_unique_shuffles,
								:round_continues

	def initialize(name)
		@number_of_battles = 0
		@number_of_cards_flipped = 0
		@number_of_unique_shuffles = 0
		@round_continues = true
	end
end

class Game

	attr_accessor :player, :round, :total_time_saved

	def initialize(number_of_players, player_names)
		@player = []
		(0..(number_of_players-1)).each do |x|
			@player[x] = Player.new(player_names[x])
		end
		@total_time_saved = 0
	end
end

def game_intro
	system "clear" or system "cls"
	puts "╔═══════════════════════════════════════════════════════════════════════════╗"
	puts "║                       Welcome to War! The Card Game                       ║"
	puts "╚═══════════════════════════════════════════════════════════════════════════╝"
	
	player_names = []
	player_default_names = ["Ape H.", "Skynet"]
	(0..1).each do |x|
		loop do 
			print "Enter a name for player #{(x+1)} (or press 'Q' to quit at any time): "
			player_names[x] = gets.strip
			player_names[x].gsub!(/[^0-9.a-z ]/i, '')
			exit if player_names[x] == "Q" or player_names[x] == "q"
			break if player_names[x].length <= 10
			puts "That name is too long.  Name must be 10 characters or less."
		end
		if player_names[x].length == 0
			puts "Since you didn't enter a name, player #{(x+1)} will be known as '#{player_default_names[x]}'"
			player_names[x] = player_default_names[x]
		end
	end
	war = Game.new(2, player_names)
end

def play_round(war)
	full_deck = Deck.new
	full_deck.create_cards
	full_deck.shuffle
	war.round = Round.new
	war.player[0].clean_slate_for_new_round
	war.player[1].clean_slate_for_new_round
	full_deck.deal(war)
	loop do
		print "                       │ Press <Enter> to battle, or better yet press 'A' to Automate the game: "
		input = gets.strip
		input.gsub!(/[^0-9a-z ]/i, '')
		exit if input == "Q" or input == "q"
		battle(war) if input.length == 0
		if input == 'A' or input == 'a'
			loop do
				battle(war)
				sleep 0.05
			end
		end
	end
end


# def battle(p1, p2)
def battle(war)
	# check_and_reshuffle(p1, p2)
	# check_and_reshuffle(war.player[0],war.player[1])
	check_and_reshuffle(war)
	(0..(war.player.length-1)).each do |x|
		war.player[x].draw_card = war.player[x].draw_stack.cards.shift
		war.player[x].number_of_cards_flipped += 1
		print "│ " if x == 1
		print "#{war.player[x].name}'s card: #{" " * war.player[x].name_spacer}#{war.player[x].draw_card} "
		puts if x == 1
	end

	if war.player[0].draw_card.value > war.player[1].draw_card.value  # IM RIGHT HERE
		w = 0; l = 1
		war.player[w].capture_stack.cards.push(war.player[w].draw_card, war.player[l].draw_card)
		war.player[w].capture_stack.cards.concat(war.player[w].stack_for_ties.cards)
		war.player[w].capture_stack.cards.concat(war.player[1].stack_for_ties.cards)
		war.player[w].stack_for_ties.cards = []
		war.player[l].stack_for_ties.cards = []
		war.player[w].number_of_battles += 1
		war.player[l].number_of_battles += 1
		war.player[w].number_of_battles_won += 1
		war.player[w].most_cards = [war.player[w].draw_stack.cards.length + war.player[w].capture_stack.cards.length, war.player[w].most_cards].max
		war.player[l].least_cards = [war.player[l].draw_stack.cards.length + war.player[l].capture_stack.cards.length, war.player[l].least_cards].min
		print "  --Battle Winner--    │" 
		# print	"                          P1 range: #{war.player[0].least_cards} to #{war.player[0].most_cards}"  	# for debugging
		# print	"    P2 range: #{p2.least_cards} to #{p2.most_cards}"  												# for debugging
		puts
		status(p1,p2)  # open to update
	elsif war.player[1].draw_card.value > war.player[0].draw_card.value
		war.player[1].capture_stack.cards.push(war.player[0].draw_card, war.player[1].draw_card)
		war.player[1].capture_stack.cards.concat(war.player[0].stack_for_ties.cards)
		war.player[1].capture_stack.cards.concat(war.player[1].stack_for_ties.cards)
		war.player[0].stack_for_ties.cards = []
		war.player[1].stack_for_ties.cards = []
		war.player[0].number_of_battles += 1
		war.player[1].number_of_battles += 1
		war.player[1].number_of_battles_won += 1
		war.player[1].most_cards = [war.player[1].draw_stack.cards.length + war.player[1].capture_stack.cards.length, war.player[1].most_cards].max
		war.player[0].least_cards = [war.player[0].draw_stack.cards.length + war.player[0].capture_stack.cards.length, war.player[0].least_cards].min
		print "                       │   --Battle Winner--"   
		# print "      P1 range: #{p1.least_cards} to #{p1.most_cards}" 												# for debugging
		# print "    P2 range: #{p2.least_cards} to #{p2.most_cards}"  													# for debugging
		puts
		status(p1,p2)
	elsif p1.draw_card.value == p2.draw_card.value
		p1.stack_for_ties.cards.push(p1.draw_card)
		p2.stack_for_ties.cards.push(p2.draw_card)
		break_tie(p1, p2)
	end
end

def break_tie(p1, p2)  
	number_of_facedown_flips = [p1.draw_stack.cards.length + p1.capture_stack.cards.length, 
															p2.draw_stack.cards.length + p2.capture_stack.cards.length].min - 1 
	[3, number_of_facedown_flips].min.times do 
		check_and_reshuffle(p1, p2)
		p1.stack_for_ties.cards.push(p1.draw_stack.cards.shift)
		p1.number_of_cards_flipped += 1
		print "+#{p1.name}'s card:#{" " * p1.name_spacer}#{p1.stack_for_ties.cards.last} " 
		p2.stack_for_ties.cards.push(p2.draw_stack.cards.shift)
		p2.number_of_cards_flipped += 1
		puts "│ +#{p2.name}'s card:#{" " * p2.name_spacer}#{p2.stack_for_ties.cards.last}"
	end
	battle(p1, p2)
end

def check_and_reshuffle(war)
  (0..(war.player.length-1)).each do |x|								# If either player has no cards left, end game
		if war.player[x].draw_stack.cards.length == 0 and
			war.player[x].capture_stack.cards.length == 0 and
			war.player[x].stack_for_ties.cards.length == 0
			round_conclusion(war)
		end
	end

  (0..(war.player.length-1)).each do |x|									# If either player ends a battle with a tie and 
		if war.player[x].draw_stack.cards.length == 0 and 		# has no draw or capture cards left, shuffle
			war.player[x].capture_stack.cards.length == 0				# all 3 stacks to draw stack
			(0..(war.player.length-1)).each do |x|
				war.player[x].draw_stack.cards.concat(war.player[x].stack_for_ties.cards)
				war.player[x].stack_for_ties.cards = []
				war.player[x].draw_stack.cards.concat(war.player[x].capture_stack.cards)
				war.player[x].capture_stack.cards = []
				war.player[x].draw_stack.shuffle
			end
			war.round.number_of_unique_shuffles += 1
			puts "--Performed Reshuffle--│--Performed Reshuffle--"
		end
	end
	
  (0..(war.player.length-1)).each do |x|									# Standard shuffle - move cards to draw stack from 
		if war.player[x].draw_stack.cards.length == 0					# capture stack if no cards left in draw stack
			war.player[x].capture_stack.shuffle
			war.player[x].draw_stack = war.player[x].capture_stack.dup  # An alternative to concat
			war.player[x].capture_stack.cards = []
			war.round.number_of_unique_shuffles += 1
		end
	end
end

def status (p1, p2)
	print "#{p1.name} has #{p1.draw_stack.cards.length + p1.capture_stack.cards.length} cards" 
	print " " if (p1.draw_stack.cards.length + p1.capture_stack.cards.length) < 10
	print " " * p1.name_spacer

	print "│ #{p2.name} has #{p2.draw_stack.cards.length + p2.capture_stack.cards.length} cards " 
	print " " if (p2.draw_stack.cards.length + p2.capture_stack.cards.length) < 10
	print " " * p2.name_spacer

	print "░" * (p1.draw_stack.cards.length + p1.capture_stack.cards.length)
	print " █ "
	puts "░" * (p2.draw_stack.cards.length + p2.capture_stack.cards.length) + "│"
	puts "───────────────────────┼────────────────────────────────────────────────────────────────────────────────┘"
end

def round_conclusion(war)  
	puts "───────────────────────┴────────────────────────────────────────────────────────────────────────────────"
	(0..(war.player.length-1)).each do |x|
		if war.player[x].draw_stack.cards.length + 
			war.player[x].capture_stack.cards.length +
			war.player[x].stack_for_ties.cards.length == 52
			1.times {puts ("   #{war.player[x].name} Wins the Round!!" + " " * war.player[x].name_spacer) * 4}
		end
	end
	puts "────────────────────────────────────────────────────────────────────────────────────────────────────────"
	puts "ROUND STATISTICS:"
	puts "────────────────"
	puts "    + A total of #{war.round.number_of_battles} battles were waged"
	puts
	puts "    + Each player flipped a total of #{war.round.number_of_cards_flipped} cards"
	puts 
	(0..(war.player.length-1)).each do |x|
		print "    + #{war.player[x].name} won #{war.player[x].number_of_battles_won} battles and had "
		puts "between #{war.player[x].least_cards} and #{player[x].most_cards} cards during the game."
		puts
	end
	temp_round_time = war.round.number_of_cards_flipped * 3 + war.round.number_of_unique_shuffles * 10
	war.total_time_saved += temp_round_time
		# note the line above now has a single amount for unique shuffles - it used to add unique
		# shufles from both players as follows:
		# player[0].number_of_unique_shuffles * 10 + player[1].number_of_unique_shuffles * 10
	print "    + If you had used a real deck of cards, it would have taken you "
	puts TimeCalculation.seconds_to_words(temp_round_time)
	puts "       to play this game (assuming 3 seconds per battle and 10 seconds for each shuffle)"
	puts
	war.round.round_continues = false
end

def game_conclusion
	
end



#============================================================================================
#============================================================================================

game_intro
loop {play_round war}
