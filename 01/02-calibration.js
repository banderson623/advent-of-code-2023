const fs = require('fs');

// const NUMBER_WORDS = [
//   'one', 'two', 'three', 'four',
//   'five', 'six', 'seven', 'eight', 'nine'
// ]

const NUMBERS = {
  'one': 1, 'two': 2, 'three': 3, 'four': 4,
  'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9,
  '1': 1, '2': 2, '3': 3, '4': 4,
  '5': 5, '6': 6, '7': 7, '8': 8, '9': 9
}

// Walks each letter in the line, and identifies if this is a number or not
// I stated with regex, but it did not allow for overlapping numbers like: "oneight"
function extractNumbers(word) {
  const numbers = [];

  for (let i = 0; i < word.length; i++) {
    for (let numberToFind in NUMBERS) {
      if (word.startsWith(numberToFind, i)) {
        numbers.push(NUMBERS[numberToFind])
      }
    }
  }
  return numbers;
}

// const lines = fs.readFileSync('02.txt','utf8')
const lines = fs.readFileSync('01-calibration.txt', 'utf8')
                .toLowerCase()
                .split('\n')
                .filter(line => !!line)

let total = 0;
for(let line of lines) {
  // split em by number or word number
  // NOTE THIS IS CLOSE BUT DOESN'T ALLOW FOR OVERLAPPING NUMBERS ("oneight")
  // numbers = line.match(RegExp(`([0-9]|${NUMBER_WORDS.join('|')})`,'g'))
  //               // map them into digits
  //               .map(word => NUMBER_WORDS.indexOf(word) > -1 ? NUMBER_WORDS.indexOf(word) + 1 : word)
  //               // make sure they are all strings
  //               .map(word => `${word}`)

  const numbers = extractNumbers(line)
  console.log(line,'->', `${numbers.at(0)}${numbers.at(-1)}`)

  // string smash them together, then convert them to an integer
  const sum = parseInt(`${numbers.at(0)}${numbers.at(-1)}`)
  total += sum
}

console.log("total", total)
