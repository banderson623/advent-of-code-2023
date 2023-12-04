# Ruby, you are a darling for letting me specify a default value
multipliers = Hash.new(1)

card_number = 1
File.foreach("input.txt") do |card|

  _,label, winning, scratched = /(.*):(.*)\|(.*)/.match(card).to_a

  matches_found = 0
  winning.split(' ').map{|v| " #{v} "}.each do |value|
    scratched+=" "
    if scratched.include? value
      matches_found += 1
    end
  end

  # one is a trick here since #each won't execute with a
  #     range ending below the starrting, like (1..0)
  (1..matches_found).each do |number|
    multipliers[card_number + number] += multipliers[card_number]
  end

  # puts "#{label} -> #{matches_found} (#{multipliers})"
  card_number += 1
end

number_of_cards = (1...card_number).inject{|sum, card| sum += multipliers[card]}
puts "Total number of cards: #{number_of_cards}"
