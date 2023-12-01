const fs = require('fs');

const NUMBER_WORDS = [
  'one', 'two', 'three', 'four',
  'five', 'six', 'seven', 'eight', 'nine'
]

// const lines = fs.readFileSync('02.txt','utf8')
const lines = fs.readFileSync('01-calibration.txt', 'utf8')
                // note lowercase
                .toLowerCase()
                .split('\n')
                .filter(line => !!line)

let total = 0;
for(let line of lines) {
  // split em by number or word number
  numbers = line.match(RegExp(`([0-9]|${NUMBER_WORDS.join('|')})`,'g'))
                // map them into digits
                .map(word => NUMBER_WORDS.indexOf(word) > -1 ? NUMBER_WORDS.indexOf(word) + 1 : word)
                // make sure they are all strings
                .map(word => `${word}`)

  console.log(line,'->', numbers.at(0) + numbers.at(-1))
  // string smash them together, then convert them to an integer
  const sum = parseInt(numbers.at(0) + numbers.at(-1))
  total += sum
}

console.log("total", total)

