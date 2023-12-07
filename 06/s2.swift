import Foundation

// Tests
// let durations: [UInt] = [71530]
// let records: [UInt] = [940200]

// Input for part 1
let durations: [UInt] = [63789468]
let records: [UInt] = [411127420471035]

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

let winningStrategies = findWinningStrategies(race: Race(
  duration: durations[0],
    record: records[0]
))

print("Sum of winning number of strategies \(winningStrategies.count)")

