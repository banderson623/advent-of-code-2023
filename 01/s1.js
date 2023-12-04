const fs = require('fs');

lines = fs.readFileSync('input.txt', 'utf8')
          .split('\n')
          .filter(line => !!line)

let total = 0;
for(let line of lines) {
  const numbers = line.match(/([0-9])/g)
  const sum = parseInt(numbers.at(0) + numbers.at(-1))
  total += sum
}

console.log("total", total)

