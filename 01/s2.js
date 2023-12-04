const fs = require('fs');

const NUMBERS = {
  'one': 1, 'two': 2, 'three': 3, 'four': 4,
  'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9,
  '1': 1, '2': 2, '3': 3, '4': 4,
  '5': 5, '6': 6, '7': 7, '8': 8, '9': 9
}

const lines = fs.readFileSync('input.txt', 'utf8')
                .toLowerCase()
                // Hey let's replace all the possible collisions with non-colission words
                // and know that all of them still contain their base number to be slurped
                // up by the regex below.
                //    example: `twone` (two and one intersecting) becomes `ttwoone`
                //             (which still has two and one in it)
                .replaceAll('two', 'ttwoo')
                .replaceAll('three', 'tthree')
                .replaceAll('eight', 'eeight')
                .replaceAll('nine', 'nnine')
                .split('\n')
                .filter(line => !!line)

let total = 0;
for(let line of lines) {
  // split em by number or word number
  const numbers = line.match(RegExp(`(${Object.keys(NUMBERS).join('|')})`,'g'))
                      // map them into digits
                      .map(word => NUMBERS[word])
                      // make sure they are all strings
                      .map(word => `${word}`)

  console.log(line,'->', `${numbers.at(0)}${numbers.at(-1)}`)

  // string smash them together, then convert them to an integer
  const sum = parseInt(`${numbers.at(0)}${numbers.at(-1)}`)
  total += sum
}

console.log("total", total)
