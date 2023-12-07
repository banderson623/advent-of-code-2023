# Advent of Code Journal


I was thinking about doing these in different languages, but we'll see....


## Day 1
`nvm use; node 01-calibration.js`

First one was pretty simple, extract the digits into an array. Then from there snag the first and last via `.a()` with 0 and -1. Smoosh them together as strings, then convert them into an integer and sum all the ones in the line.

On to number 2...

Okay so the overlapping numbers are really tricky, i'd love to solve this in regex but unknown if I can...
Here is a good example of the regex problem https://rubular.com/r/u7gmmN6nQqTp83 thanks to Travis' help constructing `ninezjtxp7bpzdgtoneeightoneighth`, this is nasty.

A quick google and a bunch of stack overflows that all look kinda like [this one](https://stackoverflow.com/a/44642092/5419). Fine so lets walk the string and snag the matches without regexp. _... meh, less fun with this strategy_

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

I remembered nice things about ruby:
* Hash can have a default value `Hash.new(1)` this was nice!
* Ranges, just a pleasure in general. But also a range of `(1..0).each do` won't ever execute and I used this as a shortcut.


# Day 5

Wow this is a lot of instructions.

Step 1: Once you read through it all, and get it. There are a few things to do:
1. parse the file into maps
2. determine the applicable ranges (thanks ruby for Range)
3. calculate the offsets and go
Not bad, and I got it on my first try!

Step 2: okay welp, my solution is so ineqadequate for step 2. I banged my head against a few performance improvements, but never got there.

So I am now going to try and run the whole thing in reverse (thankful Casey reminded me that locations pass through, so there are more than what is listed...)

okay so I could NOT solve it with the reverse strategy, it kinda sucked. I worked on it for a while but it never revealed the error. [I gave reddit a glance](https://www.reddit.com/r/adventofcode/comments/18buwiz/2023_day_5_part_2_can_someone_explain_a_more/) (gosh I hate reddit's interface). But anyway, they talked a lot about collapsing maps (which sounds like what Travis was working on).

I am going to check that out now... I made `05/2.2.rb` to try this solution

it worked ⭐ ! And "collapsing maps" isn't the right name. Instead it's about treating your ranges as the input (not walking the values in those ranges). The basic strategy would be to:

1. Take the whole array of seed ranges as input. So if my seed range arrays looked like `[(1..300), (400..600)]` I could say I have two buckets of 500 total seeds. _(remember the real input data for seeds is NN billion of them)_
2. Send these two buckets of seeds into the first map: `seed-to-soil` and apply the transforms to the ranges. So if `seed-to-soil` had say two different transforms like `1000 100 300` and `4000 400 200`, then those transforms applied to each bucket and the outgoing "seed ranges" (which were now soil ranges) would be offset by 900 and 3600 respectively. And they would be `[(900..1200), (4000..4200)]`
3. Continue this again for `soil-to-fertilizer`...


This was a good strategy, admittedly one I would not have gotten to on my own. There are really two tricks here to be mindful of:

1. I need to fill the gaps in any transform/maps (like `soil-to-fertilizer`). And most maps have one gap in them (just to get you). Gaps can be "filled" by passing the range through without an offset. So this means that with the sample data in `water-to-light` there is a hole at 0-18, so it's like I needed to add a new line to that map, that read `0 0 18`, which means for values between 0 and 18, apply no offset let them "pass through"

2. Not all incoming ranges are going to map perfectly to the transforms specified in the maps. So now you have a couple of options when the transform doesn't cover an incoming range (remember it's an array of ranges being offset/mapped by an array of transforms).
   - The range is beyond/larger-than the defined transforms completely in which case it's a pass through with zero offset/transform.
   - The range saddles two transforms, and therefor the range needs to be split. That strategy is about finding the slice point and cutting it, then applying the correct transforms to your two halves (they won't have the same offset).
   - Be mindful of more than one split required (I am not sure if that exists, but my code allows for it). This was about taking care of the remaind er after a split and running it back through the loop.


```
Map: seed-to-soil, buckets going in 10, buckets coming out 12
Map: soil-to-fertilizer, buckets going in 12, buckets coming out 12
Map: fertilizer-to-water, buckets going in 12, buckets coming out 17
Map: water-to-light, buckets going in 17, buckets coming out 19
Map: light-to-temperature, buckets going in 19, buckets coming out 24
Map: temperature-to-humidity, buckets going in 24, buckets coming out 28
Map: humidity-to-location, buckets going in 28, buckets coming out 31
```

# Day 6 here we go.

Let's use Swift!

Okay installed the [swift language server in VScode](https://marketplace.visualstudio.com/items?itemName=sswg.swift-lang).

I can run it with `swift s1.swift`

And better I can use [nodemon](https://www.npmjs.com/package/nodemon) to run swift! `nodemon --exec "swift" s1.swift`

Swift file and string parsing is absolutely terrible, relative to javascript and ruby. I gave up parsing the string or file... and just hard coded the values in a reasonable structure.

Anyway the first part was pretty straightforward and 😴 a nice warm up with swift.