import Foundation

var lines:[String] = []

if let text:String = try? String(contentsOf: URL(fileURLWithPath: "./test.txt")) {
  print(text)
  lines = text.split(separator: "\n")
}




// let time = text.split("\n")
// print(time)

// let times:[UInt16] = text.
// print(time.ranges(of:/[0-9]+/))

