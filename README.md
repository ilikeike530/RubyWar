War! The Card Game
-------------------------

Overview

This game will simulate the game of war - the card game where each player filps 
the top card and the player with the highest card wins and takes the opponents
card(s).  If the cards are tied, 3 cards a placed face down, and a 4th face up. The
player with the highest card wins the tie.  If a tie continues, 3 + 1 more cards are
put in play.  While a game of war might not seem like an exciting computer game,
playing the actual game with physical cards is much more mind-numbing.  

Game Requirements
1) Recreate the card game War! with a single deck of cards and 2 players
2) Use a standard deck with 4 suits (C,D,H,S) and 2,3,4,5,6,7,8,9,10,J,Q,K,A 
3) Allow for ties and resulting 3 cards down, 1 up scenario (and multiples thereof)
4) Require each player's deck to be shuffled when they run out of cards 
5) Allow an Automated mode, where the game is played without requireing any further,
		input from the user, and shows the results of each battle.  
6) Allow player to enter their name and the name of their computer opponent
7) Allow multiple games to be played with the same players, and keep statistics for
		each round and the game overall.  

Technical Requirements
1) Create an appropriate class for each data type - cards, stacks, players, etc.
2) Determine how to pass necessary data to each method
3) Create a functional and pleasant UI, and use Unicode characters as necessary
4) Determine how to handle edge cases, for example:
		+ When a player doesn't have enough cards left to break a tie
		+ When a player ties a battle with their last card(s)
5) Capture statistics for each round and the game overall
