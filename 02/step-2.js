const fs = require('fs');

lines = fs.readFileSync('input.txt', 'utf8')
          .split('\n')
          .filter(line => !!line)


let sumOfGamePower = 0;

for(let game of lines){
  const maxes = {
    blue: 0,
    red: 0,
    green: 0,
  }
  const [label, findings] = game.split(':')
  const sets = findings.split(';')
  for(let grab of sets) {
    for(let colors of grab.split(', ').map(v => v.trim())){
      const [count, color] = colors.split(' ').map(v => v.trim())
      maxes[color] = Math.max(maxes[color], parseInt(count));
    }
  }
  const power = maxes.blue * maxes.green * maxes.red
  sumOfGamePower += power
  console.log(label, power, maxes)

}
console.log(sumOfGamePower)
