import Foundation

// Tests
// let durations: [UInt] = [7, 15, 30]
// let records: [UInt] = [9, 40, 200]

// Input for part 1
let durations: [UInt] = [63, 78, 94, 68]
let records: [UInt] = [411, 1274, 2047, 1035]

struct Race {
  var duration: UInt
  var record: UInt
}

func findWinningStrategies(race: Race) -> [UInt] {
  var winningStrategies: [UInt] = []

  for holdTime in 1...race.duration-1 {
    let velocity = holdTime
    let timeRemaining = race.duration - holdTime
    let distanceTraveled = timeRemaining * velocity
    let didWin = distanceTraveled > race.record

    if(didWin) {
      winningStrategies.append(holdTime)
    }
  }

  return winningStrategies
}

var sum: Int = 1;
for (raceNumber, duration) in durations.enumerated() {
  let race = Race(duration: duration, record: records[raceNumber])
  let winningStrats = findWinningStrategies(race: race)
  print("Race #\(race) - \(winningStrats)")
  sum *= winningStrats.count
}

print("Sum of winning number of strategies \(sum)")

