# Advent of Code Journal


I was thinking about doing these in different languages, but we'll see....


## Day 1
`nvm use; node 01-calibration.js`

First one was pretty simple, extract the digits into an array. Then from there snag the first and last via `.a()` with 0 and -1. Smoosh them together as strings, then convert them into an integer and sum all the ones in the line.

On to number 2...

Okay so the overlapping numbers are really tricky, i'd love to solve this in regex but unknown if I can...
Here is a good example of the regex problem https://rubular.com/r/u7gmmN6nQqTp83 thanks to Travis' help constructing `ninezjtxp7bpzdgtoneeightoneighth`, this is nasty.

A quck google and a bunch of stack overflows that all look kinda like [this one](https://stackoverflow.com/a/44642092/5419). Fine so lets walk the string and snag the matches without regexp...

## Day 2

Part 1:
I sure would love to use soemthigng other than javascript... hmm.. maybe not this one though?
Okay i stuck with javascript.
Huh, so much string splitting, mixed with a bit of Math.max

Oh well on to Part 2.

So the work from part 1 to part 2 was much easier than yesterday's. Interesting. Anyway same strategy, but instead of an `if` check, just multiply the max discovered.

I was expecting a tricky _something_ but that didn't happen.


## Day 3

Part 1:
So I was trying to have some fun without walking a 2d grid with 2 for loops. It was _medium_ successful. I got stuck when one line ended with a number and the next line started with a number. (Since I was using regex to identify numbers). Once I got that solved, it was smooth sailing.


Part 2:
So the strategy is to find all the gears first. Then I can locate the part numbers like before. And if the surrounding symbol is a gear, record that location. Then later walk through all the gears and map together the surrounding parts.

Honestly not thrilled with my code here.

## Day 4

Let's do some ruby.

Okay that took too long to get rbenv, and then vs code working with it all. Meh.

Step 1: Anyway this was straightforward once I remembered the string splitting and regex commands in ruby. I did get bit by fractional matches for a second.


Step 2: I'd like to handle this by adding a card multiplier, such that every match founds increments the multiplier for that card.... oops, so I was not trying to get the sum of winnings, rather the total count of cards.

Anyway same strategy, use a multiplier to serve as the number of times a card should be counted.

(it was fun to use ruby, it took me about 4x as long to go from solution to syntax, but that is to be expected.)
