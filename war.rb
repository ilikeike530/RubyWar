
class Card
	attr_reader :suit, :value

	def initialize(suit,value)
		@suit = suit
		@value = value 
	end

	def to_s
		case value
			when 2..10 then "#{value}#{suit}"
				# other options for '10': ⑩ ⑽ ⒑ ⓾ X 🔟  or from http://www.fileformat.info/
			when 11 then "J#{suit}"
			when 12 then "Q#{suit}"
			when 13 then "K#{suit}"
			when 14 then "A#{suit}"	
		end
	end
end


class Deck

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
end


class Player
	
	attr_accessor :name, :draw_stack, :capture_stack, :stack_for_ties, :draw_card

	def initialize(name)
		@name = name
		@draw_stack = Deck.new
		@capture_stack = Deck.new
		@stack_for_ties = Deck.new
	end
end



def battle(p1, p2)
	p1.draw_card = p1.draw_stack.cards.shift; print "#{p1.name}'s card: #{p1.draw_card} \t|\t"
	p2.draw_card = p2.draw_stack.cards.shift; puts "#{p2.name}'s card: #{p2.draw_card}"
	if p1.draw_card.value > p2.draw_card.value
		p1.capture_stack.cards.push(p1.draw_card, p2.draw_card)
		p1.capture_stack.cards.concat(p1.stack_for_ties.cards, p2.stack_for_ties.cards)
		p1.stack_for_ties = []
		p2.stack_for_ties = []
		puts "Player 1 wins battle"
	elsif p2.draw_card.value > p1.draw_card.value
		p2.capture_stack.cards.push(p1.draw_card, p2.draw_card)
		p2.capture_stack.cards.concat(p1.stack_for_ties.cards, p2.stack_for_ties.cards)
		p1.stack_for_ties = []
		p2.stack_for_ties = []
		puts "Player 2 wins battle"
	elsif p1.draw_card.value == p2.draw_card.value
		p1.stack_for_ties.cards.push(p1.draw_card)
		p2.stack_for_ties.cards.push(p2.draw_card)
		break_tie(p1, p2)
	end
end


def break_tie(p1, p2)
	# add something about shuffling if under 4 cards here and having to shuffle
	3.times do 
		p1.stack_for_ties.cards.push(p1.draw_stack.cards.shift)
		print "#{p1.name}'s card: #{p1.stack_for_ties.cards.last} \t|\t"
		p2.stack_for_ties.cards.push(p2.draw_stack.cards.shift)
		puts "#{p2.name}'s card: #{p2.stack_for_ties.cards.last}"
	end
	battle(p1, p2)
end


def reshuffle(player)
	# if player.capture_stack.cards.length = 0  #finish this for how to perform the end-game
	shuffle player.capture_stack
	player.draw_stack = player.capture_stack
	player.capture_stack = []
end


# puts "Welcome to War! The Card Game."
# puts "(press 'Q' to Quit at any time)"
# print "Enter your name: "
# input = gets
# if input.length==0
# 	puts "Since you didn't enter a name, I'll call you 'Ape H.'"
# 	player1 = Player.new("Ape H.")
# elsif input == 'Q'
# 	exit
# else 
# 	player1 = Player.new(input)
# end
# print "Enter your opponents name (hit 'Enter' to default to 'Computer'): "
# input = gets
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

battle(player1, player2)
battle(player1, player2)


puts player1.draw_stack.cards.length
puts player2.draw_stack.cards.length
puts player1.capture_stack.cards.length
puts player2.capture_stack.cards.length







