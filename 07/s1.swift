import Foundation

let listOfHands = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""

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


struct Hand {
  var cards: String = ""
  var bid: Int = 0

  init(cards: String, bid: Int) {
    self.cards = cards
    self.bid = bid
  }

  func type() -> HandType {
    let sortedCards = self.cards.sorted().map{ String($0) }.joined()
    print(sortedCards)

    let treeOfAKind = /(\S)\\1\\1\\1/

    if (sortedCards.contains(try! Regex("(\\S)\\1\\1\\1\\1\\1"))) { return .FiveOfAKind}
    // if (sortedCards.contains(try! Regex(#"(\S)\1\1\1\1"#))) { return .FourOfAKind}
    // if (sortedCards.contains(try! Regex(#"(\S)\1\1\1|(\S)\2\2/)"#))) { return .FullHouse}
    // if (sortedCards.contains(try! Regex("(\\S)\\1\\1\\1"))) { return .ThreeOfAKind}
    if (sortedCards.contains(treeOfAKind)) { return .ThreeOfAKind}
    // if (sortedCards.contains(try! Regex(#"(\S)\1\1|(\S)\2\2/)"#))) { return .TwoPair}
    // if (sortedCards.contains(try! Regex(#"(\S)\1\1"#))) { return .OnePair}

    return .HighCard
  }

}

for handRow in listOfHands.split(separator: "\n") {
  let handParts  = handRow.split(separator: " ")
  guard handParts.count == 2 else {
    print("formatting is wrong")
    exit(1)
  }
  let cards = handParts.first ?? ""
  let bid = Int(handParts.last!) ?? 0

  let hand = Hand(cards: String(cards), bid: bid)
  print(hand, hand.type())
}
