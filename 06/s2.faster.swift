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

func countWinningStrategies(race: Race) -> UInt {
  var firstWin: UInt = 0
  var lastWin: UInt = 0


  for holdTime in stride(from: 1, to: race.duration, by: 1) {
    let velocity = holdTime
    let timeRemaining = race.duration - holdTime
    let distanceTraveled = timeRemaining * velocity

    let didWin = distanceTraveled > race.record

    if(didWin) {
      firstWin = holdTime
      break
    }
  }

  for holdTime in stride(from: race.duration, to: 1, by: -1) {
    let velocity = holdTime
    let timeRemaining = race.duration - holdTime
    let distanceTraveled = timeRemaining * velocity

    let didWin = distanceTraveled > race.record

    if(didWin) {
      lastWin = holdTime
      break
    }
  }


  print("First Win: \(firstWin) last win \(lastWin)")
  return lastWin - firstWin + 1
}

let winningCount = countWinningStrategies(race: Race(
  duration: durations[0],
    record: records[0]
))

print("Number of winning strategies \(winningCount)")
