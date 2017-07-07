
class Card
	attr_reader :suit, :value

	def initialize(suit,value)
		@suit = suit
		@value = value 
	end

	def to_s
		case value
			when 2..10 then "#{value}#{suit}"
			when 11 then "J#{suit}"
			when 12 then "Q#{suit}"
			when 13 then "K#{suit}"
			when 14 then "A#{suit}"	
		end
	end
end


class Deck
	# include Enumerable

	attr_reader :cards

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

	# def each
	# 	@cards.each {|turtles_are_fun| yield turtles_are_fun}
	# end
end


def battle(p1_draw_stack, p1_capture_stack, p2_draw_stack, p2_capture_stack)
	player1_card = p1_draw_stack.cards.shift
	player2_card = p2_draw_stack.cards.shift
	if player1_card.value > player2_card.value
		p1_capture_stack.cards.push(player1_card, player2_card)
	elsif player2_card.value > player1_card.value
		p2_capture_stack.cards.push(player1_card, player2_card)
	elsif player1_card.value == player2_card.value
		breaktie(player1_card,p1_draw_stack, p1_capture_stack,
							player2_card,p2_draw_stack, p2_capture_stack)
	end
end

def breaktie(player1_card,p1_draw_stack, p1_capture_stack,
							player2_card,p2_draw_stack, p2_capture_stack)
	player1_facedown_stack = Deck.new
	player2_facedown_stack = Deck.new
	# add something about shuffling if under 4 cards here
	3.times { player1_facedown_stack.cards.push(p1_draw_stack.cards.shift) }

end


	# if @player1_stack.length == 0
	# 	shuffle @player1_stack *********************
	

# def each
# 	@cards.each { |card| yield card }
# end


# puts "Welcome to War! The Card Game."
# puts "(press Q' to Quit at any time)"
# print "Enter your name: "
# player1_name = gets
# if player1_name.length==0
# 	puts "Since you didn't enter a name, I'll call you 'Ape H.'"
# 	player1_name = "Ape H."
# end
# print "Enter your opponents name (hit 'Enter' to default to 'Computer'): "
# player2_name = gets
# if player2_name.length==0
# 	player2_name = "Skynet"
# end

full_deck = Deck.new
player1_draw_stack = Deck.new
player2_draw_stack = Deck.new
player1_capture_stack = Deck.new
player2_capture_stack = Deck.new
full_deck.create_cards
full_deck.shuffle
full_deck.deal(player1_draw_stack, player2_draw_stack)
battle(player1_draw_stack, player1_capture_stack, 
				player2_draw_stack, player2_capture_stack)


# puts player2_draw_stack.cards.length
# puts player1_capture_stack.cards.length
# puts player2_capture_stack.cards.length



# full_deck.player1_stack.each {|card| puts card }




