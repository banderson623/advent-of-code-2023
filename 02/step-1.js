const fs = require('fs');

lines = fs.readFileSync('input.txt', 'utf8')
          .split('\n')
          .filter(line => !!line)

const MAXES = {
  red: 12,
  green: 13,
  blue: 14
}

let sumOfGameIds = 0;

for(let game of lines){
  const maxDiscovered = {
    blue: 0,
    red: 0,
    green: 0,
  }
  const [label, findings] = game.split(':')
  const sets = findings.split(';')
  for(let grab of sets) {
    for(let colors of grab.split(', ').map(v => v.trim())){
      const [count, color] = colors.split(' ').map(v => v.trim())
      // console.log(color, count)
      maxDiscovered[color] = Math.max(maxDiscovered[color], count);
    }
  }

  if(maxDiscovered.green > MAXES.green ||
    maxDiscovered.blue > MAXES.blue ||
    maxDiscovered.red > MAXES.red) {
      console.log('impossible', label, maxDiscovered)
  } else {
    console.log('possible', label, maxDiscovered)
    const [,id] = label.split(' ')
    sumOfGameIds += parseInt(id)
  }
}
console.log(sumOfGameIds)
