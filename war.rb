# Functionality to add:
# 	Add an end game statement, including
# 					Statement of who the winner was
#           counter " This game took 40 turns.  At 2 seconds per turn, it would have taken
# 							20 minutes to play thisgame
				#   List most and least cards each player had during the game
# 	Add a graphical indicator after each turn to show how many cards are left over for each team, i.e:
#							----------------|---------------------------
# 	Add an automated mode "A" to Automate, "Q" to quit
# 	Add something to make sure the lines line up based on the length of a user's name
# 	Add a delay so the game looks cool and the line moves back and forth
# 	



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
	
	attr_accessor :name, :draw_stack, :capture_stack, :stack_for_ties, :draw_card

	def initialize(name)
		@name = name
		@draw_stack = Deck.new
		@capture_stack = Deck.new
		@stack_for_ties = Deck.new
	end
end



def battle(p1, p2)
	check_and_reshuffle(p1, p2)
	p1.draw_card = p1.draw_stack.cards.shift; print "#{p1.name}'s card: #{p1.draw_card} \t│\t"
	p2.draw_card = p2.draw_stack.cards.shift; puts "#{p2.name}'s card: #{p2.draw_card}"
	if p1.draw_card.value > p2.draw_card.value
		p1.capture_stack.cards.push(p1.draw_card, p2.draw_card)
		p1.capture_stack.cards.concat(p1.stack_for_ties.cards)
		p1.capture_stack.cards.concat(p2.stack_for_ties.cards)
		p1.stack_for_ties.cards = []
		p2.stack_for_ties.cards = []
		puts " --Battle Winner--  │"
		status(p1,p2)
	elsif p2.draw_card.value > p1.draw_card.value
		p2.capture_stack.cards.push(p1.draw_card, p2.draw_card)
		p2.capture_stack.cards.concat(p1.stack_for_ties.cards)
		p2.capture_stack.cards.concat(p2.stack_for_ties.cards)
		p1.stack_for_ties.cards = []
		p2.stack_for_ties.cards = []
		puts "                    │ --Battle Winner--"
		status(p1,p2)
	elsif p1.draw_card.value == p2.draw_card.value
		p1.stack_for_ties.cards.push(p1.draw_card)
		p2.stack_for_ties.cards.push(p2.draw_card)
		break_tie(p1, p2)
	end
end


def break_tie(p1, p2)  # I'm not 100% sure how this would work if one player ran out of cards on the 1st of 2nd flip during a 3x battle
	number_of_facedown_flips = [p1.draw_stack.cards.length + p1.capture_stack.cards.length, 
															p2.draw_stack.cards.length + p2.capture_stack.cards.length].min - 1 

	[3, number_of_facedown_flips].min.times do 
		check_and_reshuffle(p1, p2)
		p1.stack_for_ties.cards.push(p1.draw_stack.cards.shift)
		print "#{p1.name}'s card: #{p1.stack_for_ties.cards.last} \t│\t"
		p2.stack_for_ties.cards.push(p2.draw_stack.cards.shift)
		puts "#{p2.name}'s card: #{p2.stack_for_ties.cards.last}"
	end
	battle(p1, p2)
end


def check_and_reshuffle(*player)
	puts "IM INSIDE THE CHECK AND RESHUFFLE FUNCTION" # for debugging
	# (0..(player.length-1)).each do |x|	
	# 	return if player[x].final_card_status == true
	# end

  (0..(player.length-1)).each do |x|							# If either player has no cards left, end game
		if player[x].draw_stack.cards.length == 0 and
		player[x].capture_stack.cards.length == 0 and
		player[x].stack_for_ties.cards.length == 0
			game_conclusion(player[0], player[1])
		end
	end
	# 				# open to completely update method below - it's just a shell
 #  (0..(player.length-1)).each do |x|							# If either player runs out of cards during a tie
	# 	if player[x].draw_stack.cards.length == 1 and 		# break, cut battle short and flip last card
	# 	player[x].capture_stack.cards.length == 0	and  		# BUT WHAT IF THAT LAST CARD RESULTS IN A TIE??
	# 	player[x].stack_for_ties.cards.length > 0
	# 		return
	# 		end
	# 	end
	# end

  (0..(player.length-1)).each do |x|							# If either player ends a battle with a tie and 
		if player[x].draw_stack.cards.length == 0 and 		# has no draw or capture cards left
		player[x].capture_stack.cards.length == 0
			(0..(player.length-1)).each do |x|
				player[x].stack_for_ties.shuffle
				player[x].draw_stack.cards.concat(player[x].stack_for_ties.cards)
				player[x].stack_for_ties.cards = []
			end
		end
	end
	
  (0..(player.length-1)).each do |x|
		if player[x].draw_stack.cards.length == 0
			puts "IM INSIDE THE IF STATEMENT*****************************" # for debugging
			# player[x].capture_stack.cards.each { |card| puts "#{card} prior to shuffle" }  # for debugging
			player[x].capture_stack.shuffle
			player[x].draw_stack.cards.each { |card| puts "#{card} draw stack pre transfer" }  # for debugging
			puts player[x].draw_stack.object_id				# for debugging
			puts player[x].capture_stack.object_id		# for debugging
			player[x].draw_stack = player[x].capture_stack.dup  # could I have just used concat
			puts player[x].draw_stack.object_id				# for debugging
			puts player[x].capture_stack.object_id		# for debugging
			puts player[x].draw_stack.cards.length; puts "HERE" # for debugging
			player[x].draw_stack.cards.each { |card| puts "#{card} draw stack PSOT transfer" }  # for debugging
			player[x].capture_stack.cards = []
			player[x].capture_stack.cards.each { |card| puts "#{card} this line won't get printed" }  # for debugging
			player[x].draw_stack.cards.each { |card| puts "#{card} draw stack POST POST POST transfer" }  # for debugging
			puts player[x].draw_stack.cards.length; puts "HERE again" # for debugging
		end
	end
end

def status (p1, p2)
	print "#{p1.name} has #{p1.draw_stack.cards.length} #{p1.capture_stack.cards.length} #{p1.stack_for_ties.cards.length} cards │\t"
	puts "#{p2.name} has #{p2.draw_stack.cards.length} #{p2.capture_stack.cards.length} #{p2.stack_for_ties.cards.length} cards"
	puts "────────────────────┼─────────────────────"
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

200.times{ battle(player1, player2) }

puts player1.draw_stack.cards.length
puts player2.draw_stack.cards.length
puts player1.capture_stack.cards.length
puts player2.capture_stack.cards.length

# player1.draw_stack.each { |x| puts x }





