import Foundation



if let text:String = try? String(contentsOf: URL(fileURLWithPath: "./test.txt")) {
  print(text)
  let lines = text.split(separator: "\n")
  print(lines)
}




// let time = text.split("\n")
// print(time)

// let times:[UInt16] = text.
// print(time.ranges(of:/[0-9]+/))

