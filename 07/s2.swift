import Foundation

let listOfHands = try String(contentsOf:
  URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("input.txt")
)

// Int here makes them comparible
enum HandType: Int {
  case FiveOfAKind = 7
  case FourOfAKind = 6
  case FullHouse = 5
  case ThreeOfAKind = 4
  case TwoPair = 3
  case OnePair = 2
  case HighCard = 1
}

// index is value
let CARD_VALUE = ["J", "2","3","4","5","6","7","8","9","T","Q","K","A"]

func cardValue(_ card:String.Element) -> Int {
  return CARD_VALUE.firstIndex(of:String(card)) ?? 0
}

struct Hand: Comparable {
  var cards: String = ""
  var bid: Int = 0
  var type: HandType = .HighCard

  init(cards: String, bid: Int) {
    self.cards = cards
    self.bid = bid
    self.type = self.calcType()
  }

  private func calcType() -> HandType {
    var counts: [String.SubSequence: Int] = [:]

    for card in cards.split(separator: "") {
      counts[card] = counts[card, default: 0] + 1
    }

    let numberOfJokers = counts["J"] ?? 0

    print(cards, numberOfJokers, counts)
    counts["J"] = 0

    if(counts.filter { $0.value >= 5 - numberOfJokers }.count >= 1){ return HandType.FiveOfAKind }
    if(counts.filter { $0.value >= 4 - numberOfJokers }.count >= 1) { return HandType.FourOfAKind }

    if(counts.filter { $0.value >= 3 - numberOfJokers }.count == 2) { return HandType.FullHouse }
    if counts.filter({ $0.value == 3 }).count == 1 &&
       counts.filter({ $0.value == 2 }).count > 0 {
        return HandType.FullHouse
    }


    if(counts.filter { $0.value >= 3 - numberOfJokers }.count >= 1) { return HandType.ThreeOfAKind }
    if(counts.filter { $0.value >= 2 - numberOfJokers }.count == 2) { return HandType.TwoPair }
    if(counts.filter { $0.value >= 2 - numberOfJokers }.count >= 1) { return HandType.OnePair }

    return .HighCard
  }

  // from the Comparable protocol
  static func <(lhs: Hand, rhs: Hand) -> Bool {
    if(lhs.type == rhs.type){
      // i dunno how else to get the index of each character, not throlled about this
      let lhsCards = Array(lhs.cards)
      let rhsCards = Array(rhs.cards)

      for cardNumber in 0...4 {
        if cardValue(lhsCards[cardNumber]) > cardValue(rhsCards[cardNumber]) { return true }
        if cardValue(lhsCards[cardNumber]) < cardValue(rhsCards[cardNumber]) { return false }
      }
    }

    return lhs.type.rawValue > rhs.type.rawValue
  }

}

var hands:[Hand] = []

for handRow in listOfHands.split(separator: "\n") {
  let handParts  = handRow.split(separator: " ")
  guard handParts.count == 2 else {
    print("formatting is wrong")
    exit(1)
  }
  let cards = handParts.first ?? ""
  let bid = Int(handParts.last!) ?? 0

  let hand = Hand(cards: String(cards), bid: bid)
  hands.append(hand)
}

var winnings = 0
for (index, hand) in hands.sorted().enumerated() {
  let rank = hands.count - index
  print ("\(rank) - \(hand.cards) - \(hand.type) - \(hand.bid) * \(rank) = \(hand.bid * rank)")
  winnings = winnings + (hand.bid * rank)
}

print("winnings: \(winnings)")
