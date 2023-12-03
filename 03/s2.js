const fs = require('fs');

lines = fs.readFileSync('input.txt', 'utf8')
          .split('\n')
          .filter(line => !!line)

NUMBERS_PATTERN = /[0-9]+/g
SYMBOLS_PATTERN = /[^0-9.]/
GEAR_PATTERN = /\*/g

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

let foundGears = []
for(number of allLines.matchAll(GEAR_PATTERN)) {
  foundGears.push({
    value: number[0],
    start: number.index
  })
}

let gearParts = []

for(match of foundNumbers) {
  const {value, start} = match
  const end = start + value.length - 1;

  let gearLocation = -1;

  const leftEdgeDistance = start % lineLength
  const rightEdgeDistance = (end + 1) % lineLength

  const stringBefore = leftEdgeDistance > 0 ? allLines.at(start - 1) : ''
  if (stringBefore == '*') gearLocation = start - 1

  const stringAfter = rightEdgeDistance > 0 ? allLines.at(end + 1) : ''
  if (stringAfter == '*') gearLocation = end + 1

  const rowAboveOffset = start - lineLength
  const stringsAbove = allLines.substring(rowAboveOffset - Math.min(leftEdgeDistance, 1), rowAboveOffset + value.length + Math.min(rightEdgeDistance, 1))
  if (stringsAbove.indexOf('*') > -1) {
    gearLocation = stringsAbove.indexOf('*') + rowAboveOffset - Math.min(leftEdgeDistance, 1)
  }

  const rowBelowOffset = start + lineLength
  const stringsBelow = allLines.substring(rowBelowOffset -  Math.min(leftEdgeDistance, 1), rowBelowOffset + value.length + 1)

  if (stringsBelow.indexOf('*') > -1) {
    gearLocation = stringsBelow.indexOf('*') + rowBelowOffset - Math.min(leftEdgeDistance, 1)
  }

  const surroundingStrings = stringBefore + stringAfter + stringsAbove + stringsBelow;
  const isPartNumber = SYMBOLS_PATTERN.test(surroundingStrings)
  const isGear = surroundingStrings.indexOf('*') > -1

  if(isGear && isPartNumber){
    gearParts.push({
      gearLocation,
      value: parseInt(value)
    })
  }
}

let sum = 0;
for(const {start} of foundGears) {
  const parts = gearParts.filter(p => p.gearLocation == start)
  if(parts.length == 2) {
    console.log('using', parts[0].value, parts[1].value )
    sum += parts[0].value * parts[1].value
  } else {
    console.log('(skipping', parts, ')')
  }
}
console.log(sum)
