# Advent of Code Journal


I was thinking about doing these in different languages, but we'll see....


## Day 1
`nvm use; node 01-calibration.js`

First one was pretty simple, extract the digits into an array. Then from there snag the first and last via `.a()` with 0 and -1. Smoosh them together as strings, then convert them into an integer and sum all the ones in the line.

On to number 2...

Okay so the overlapping numbers are really tricky, i'd love to solve this in regex but unknown if I can...
Here is a good example of the regex problem https://rubular.com/r/u7gmmN6nQqTp83 thanks to Travis' help constructing `ninezjtxp7bpzdgtoneeightoneighth`, this is nasty.

A quck google and a bunch of stack overflows that all look kinda like [this one](https://stackoverflow.com/a/44642092/5419). Fine so lets walk the string and snag the matches without regexp...
