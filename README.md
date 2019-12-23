# LunchGame

Lunchgame is a little role-player game to pass the time at lunch, working using ruby 2.6.3.

## Installation

After cloning or unzipping the repository just run bundle install to install the gems.

## Goal
To enter the final room you must find numbers to open the last room (which is directly forward at the beginning)

## How to play
Just enter `ruby game.rb` to start the game.

The game works in turns. You will receives informations about the events happening and the console will ask you for a command while providing you a list of availables commands.

Enter the command you wanna execute and press enter. The game will process the command. Explain you what's happening and ask for your reaction and so on until you win or loose the game.

At any point you can stop the game by writing `exit`

## How to test 

type `rspec` to launch the tests

## How to cheat

At the start of the game you have an option cheat_and_go_to_boss to enter directly into the boss room

To defeat the boss choose `turn_around_arch` then `aim_for_the_tail`

if you want to open the door normaly you need to go to the interesting room and use all the options there.

The map is always the same. To go to interesting room from departure go:
- East then north ( right and left at the beginning when you face the door)
- East then north then west ( right, left and left at the beginning when you face the door)
- West, West then north ( left, forward and right at the beginning when you face the door)

You will probably have to draw it for the relative direction when coming back

