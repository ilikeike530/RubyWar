# Functionality to add:
# 	Add an end game statement, including
# 					Statement of who the winner was
#           counter " This game took 40 turns.  At 2 seconds per turn, it would have taken
# 							20 minutes to play thisgame
				#   List most and least cards each player had during the game
# 	Add an automated mode "A" to Automate, "Q" to quit
# 	



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

	def deal (deck1, deck2)
		while @cards.length > 0 do
			temp_card = @cards.shift
			if deck1.cards.length > deck2.cards.length
				deck2.cards.push temp_card
			else 
				deck1.cards.push temp_card
			end
		end
	end

	def each
		@cards.each {|card| yield card}
	end

end


class Player
	
	attr_accessor :name, :name_spacer, :draw_stack, :capture_stack, :stack_for_ties, :draw_card

	def initialize(name)
		@name = name
		@name_spacer = 10 - name.length
		@draw_stack = Deck.new
		@capture_stack = Deck.new
		@stack_for_ties = Deck.new
	end
end



def battle(p1, p2)
	check_and_reshuffle(p1, p2)
	p1.draw_card = p1.draw_stack.cards.shift; 
	print "#{p1.name}'s card: " + " " * p1.name_spacer + "#{p1.draw_card} "
	p2.draw_card = p2.draw_stack.cards.shift; 
	puts "│ #{p2.name}'s card: " + " " * p2.name_spacer + "#{p2.draw_card}"
	if p1.draw_card.value > p2.draw_card.value
		p1.capture_stack.cards.push(p1.draw_card, p2.draw_card)
		p1.capture_stack.cards.concat(p1.stack_for_ties.cards)
		p1.capture_stack.cards.concat(p2.stack_for_ties.cards)
		p1.stack_for_ties.cards = []
		p2.stack_for_ties.cards = []
		puts "  --Battle Winner--    │"
		status(p1,p2)
	elsif p2.draw_card.value > p1.draw_card.value
		p2.capture_stack.cards.push(p1.draw_card, p2.draw_card)
		p2.capture_stack.cards.concat(p1.stack_for_ties.cards)
		p2.capture_stack.cards.concat(p2.stack_for_ties.cards)
		p1.stack_for_ties.cards = []
		p2.stack_for_ties.cards = []
		puts "                       │   --Battle Winner--"
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
		print "+#{p1.name}'s card:"	+ " " * p1.name_spacer + "#{p1.stack_for_ties.cards.last} " 
		p2.stack_for_ties.cards.push(p2.draw_stack.cards.shift)
		puts "│ +#{p2.name}'s card:"	+ " " * p2.name_spacer + "#{p2.stack_for_ties.cards.last}"
	end
	battle(p1, p2)
end


def check_and_reshuffle(*player)
  (0..(player.length-1)).each do |x|							# If either player has no cards left, end game
		if player[x].draw_stack.cards.length == 0 and
		player[x].capture_stack.cards.length == 0 and
		player[x].stack_for_ties.cards.length == 0
			game_conclusion(player[0], player[1])
		end
	end

  (0..(player.length-1)).each do |x|							# If either player ends a battle with a tie and 
		if player[x].draw_stack.cards.length == 0 and 		# has no draw or capture cards left, shuffle
		player[x].capture_stack.cards.length == 0					# all 3 stacks to draw stack
			(0..(player.length-1)).each do |x|
				player[x].draw_stack.cards.concat(player[x].stack_for_ties.cards)
				player[x].stack_for_ties.cards = []
				player[x].draw_stack.cards.concat(player[x].capture_stack.cards)
				player[x].capture_stack.cards = []
				player[x].draw_stack.shuffle
			end
			puts "--Performed Reshuffle--│--Performed Reshuffle--"
		end
	end
	
  (0..(player.length-1)).each do |x|							# Standard shuffle - move cards to draw stack from 
		if player[x].draw_stack.cards.length == 0					# capture stack if no cards left in draw stack
			player[x].capture_stack.shuffle
			player[x].draw_stack = player[x].capture_stack.dup  # An alternative to concat
			player[x].capture_stack.cards = []
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
	puts "░" * (p2.draw_stack.cards.length + p2.capture_stack.cards.length)
	puts "───────────────────────┼────────────────────────"
end

def game_conclusion(*player)
	(0..(player.length-1)).each do |x|
		if player[x].draw_stack.cards.length + 
		player[x].capture_stack.cards.length +
		player[x].stack_for_ties.cards.length == 52
			puts "#{player[x].name} Wins!!"
		end
	end
	# add all the stuff about game end counts (# of turns) and statistics here
	exit
end


# puts "Welcome to War! The Card Game."
# puts "(press 'Q' to Quit at any time)"
# print "Enter your name: "
# input = gets
# if input.length > 10
# 	puts "That name is too long.  Next time enter a name 10 characters or less."
# 	exit
# elsif input.length==0
# 	puts "Since you didn't enter a name, I'll call you 'Ape H.'"
# 	player1 = Player.new("Ape")
# elsif input == 'Q'
# 	exit
# else 
# 	player1 = Player.new(input)
# end
# print "Enter your opponents name (hit 'Enter' to default to 'Computer'): "
# input = gets
# if input.length > 10
# 	puts "That name is too long.  Next time enter a name 10 characters or less."
# 	exit
# if input.length==0
# 	player2 = Player.new("Skynet")
# elsif input == 'Q'
# 	exit
# else 
# 	player2 = Player.new(input)

player1 = Player.new("Ape H.")
player2 = Player.new("Skynet")

full_deck = Deck.new
full_deck.create_cards
full_deck.shuffle
full_deck.deal(player1.draw_stack, player2.draw_stack)

2000.times do
	battle(player1, player2)
	sleep 0.05
end

puts player1.draw_stack.cards.length
puts player2.draw_stack.cards.length
puts player1.capture_stack.cards.length
puts player2.capture_stack.cards.length

# player1.draw_stack.each { |x| puts x }





