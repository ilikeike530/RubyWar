

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
	attr_reader :cards, :player1_stack, :player2_stack

	def initialize
		@cards = []
		@player1_stack = []
		@player2_stack = []
		(2..14).each do |value|
			@cards.push Card.new(:♠,value)
			@cards.push Card.new(:♥,value)
			@cards.push Card.new(:♦,value)
			@cards.push Card.new(:♣,value)
		end
		# puts @cards.length
	end

	def shuffle
		temp_deck = []
		while @cards.length > 0 do
			temp_card = @cards.sample
			temp_deck.push temp_card
			@cards.delete(temp_card)
		end
		@cards = temp_deck
	end

	def deal
		while @cards.length > 0 do
			temp_card = @cards.shift
			if @player1_stack.length > @player2_stack.length
				@player2_stack.push temp_card
			else 
				@player1_stack.push temp_card
			end
		end
	end

	def play_war
		if @player1_stack.length == 0
			shuffle @player1_stack *********************
		
	end

	# def each
	# 	@cards.each { |card| yield card }
	# end
end


x = Deck.new()
x.shuffle
x.deal
# x.player1_stack.each {|card| puts card }
puts x.player2_stack.length




