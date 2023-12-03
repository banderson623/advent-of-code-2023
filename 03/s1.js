const fs = require('fs');

lines = fs.readFileSync('input.txt', 'utf8')
          .split('\n')
          .filter(line => !!line)

NUMBERS_PATTERN = /[0-9]+/g
SYMBOLS_PATTERN = /[^0-9.]/

let lineLength = lines[0].length;
allLines = lines.join('')

// gotta find numbers before smashing them together, since numbers appear to wrap then
// :/
let foundNumbers = []
lines.forEach((line, rowNumber) => {
  for(number of line.matchAll(NUMBERS_PATTERN)) {
    foundNumbers.push({
      value: number[0],
      start: number.index + (rowNumber * lineLength)
    })
  }
})

let sum = 0;

for(match of foundNumbers) {
  const {value, start} = match
  const end = start + value.length - 1;

  const leftEdgeDistance = start % lineLength
  const rightEdgeDistance = (end + 1) % lineLength

  const stringBefore = leftEdgeDistance > 0 ? allLines.at(start - 1) : ''
  const stringAfter = rightEdgeDistance > 0 ? allLines.at(end + 1) : ''

  const rowAboveOffset = start - lineLength
  const stringsAbove = allLines.substring(rowAboveOffset - Math.min(leftEdgeDistance, 1), rowAboveOffset + value.length + Math.min(rightEdgeDistance, 1))

  const rowBelowOffset = start + lineLength
  const stringsBelow = allLines.substring(rowBelowOffset -  Math.min(leftEdgeDistance, 1), rowBelowOffset + value.length + 1)

  const surroundingStrings = stringBefore + stringAfter + stringsAbove + stringsBelow;
  const isPartNumber = SYMBOLS_PATTERN.test(surroundingStrings)

  // if(isPartNumber){
    // console.log(value, surroundingStrings, isPartNumber, surroundingStrings.match(SYMBOLS_PATTERN)?.[0])
  // }

  // console.log(stringsAbove)
  // console.log(stringBefore + value + stringAfter, isPartNumber)
  // console.log(stringsBelow)


  // console.log(parseInt(value), value, value == parseInt(value))

  if(isPartNumber) {
    sum += parseInt(value)
  }
}

console.log(sum)
