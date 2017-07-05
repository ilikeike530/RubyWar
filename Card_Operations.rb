

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

	include Enumerable

	attr_reader :cards

	def initialize
		@cards = [] 
		(2..14).each do |value|
			@cards.push Card.new("♠",value)
			@cards.push Card.new("♥",value)
			@cards.push Card.new("♦",value)
			@cards.push Card.new("♣",value)
		end
	end


	# def each
	# 	@cards.each { |card| yield card }
	# end

		
end


x = Deck.new()
x.cards.each {|card| puts card }







# def self.split_deck




# end


# def self.shuffle_deck # of any size
	
# end


	
