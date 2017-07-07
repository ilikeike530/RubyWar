
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

	attr_accessor :cards, :owner

	def initialize (owner="")
		@cards = []
		@owner = owner
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
	player1_card = p1_draw_stack.cards.shift; print "#{p1_draw_stack.owner}'s card: #{player1_card} | "
	player2_card = p2_draw_stack.cards.shift; puts "#{p2_draw_stack.owner}'s card: #{player2_card}"
	if player1_card.value > player2_card.value
		p1_capture_stack.cards.push(player1_card, player2_card)
		return "Player 1 Wins battle"
	elsif player2_card.value > player1_card.value
		p2_capture_stack.cards.push(player1_card, player2_card)
		return "Player 2 wins battle"
	elsif player1_card.value == player2_card.value
		deal3(player1_card,p1_draw_stack, p1_capture_stack,
							player2_card,p2_draw_stack, p2_capture_stack)
	end
end

def deal3(player1_card,p1_draw_stack, p1_capture_stack,
							player2_card,p2_draw_stack, p2_capture_stack)
	player1_facedown_stack = Deck.new
	player2_facedown_stack = Deck.new
	# add something about shuffling if under 4 cards here
	3.times { player1_facedown_stack.cards.push(p1_draw_stack.cards.shift) }
	3.times { player2_facedown_stack.cards.push(p2_draw_stack.cards.shift) }
	winner_from_4th_card = battle(p1_draw_stack,p1_capture_stack, p1_draw_stack,p1_capture_stack) 
	if winner_from_4th_card == "Player 1 Wins battle"
		p1_capture_stack.cards += player1_facedown_stack.cards + player2_facedown_stack.cards
	elsif winner_from_4th_card == "Player 2 Wins battle"
		p2_capture_stack.cards += player1_facedown_stack.cards + player2_facedown_stack.cards
	end


	puts player1_card
	player1_facedown_stack.cards.each {|card| puts card }
	puts player2_card
	player2_facedown_stack.cards.each {|card| puts card }


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
player1_draw_stack = Deck.new("Ape H.")
player2_draw_stack = Deck.new("Skynet")
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



# full_deck.cards.each {|card| puts card }




